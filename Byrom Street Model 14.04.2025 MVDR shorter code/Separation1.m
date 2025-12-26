function final_separated_signal = Separation1(beamformed_audio, beamform_grid_choice, fs)
    % Load the original voice file to be used as a reference
    [original_voice, fs_voice] = audioread('Audio\Speech5secs.wav');
    
    % Ensure the sample rates match
    if fs_voice ~= fs
        original_voice = resample(original_voice, fs, fs_voice);
    end

    % Convert both signals to mono if needed
    if size(beamformed_audio, 2) > 1
        beamformed_audio = mean(beamformed_audio, 2); % Convert to mono by averaging channels
    end
    if size(original_voice, 2) > 1
        original_voice = mean(original_voice, 2); % Convert to mono by averaging channels
    end

    % Ensure both signals are the same length by truncating or zero-padding
    len_beamformed = length(beamformed_audio);
    len_original = length(original_voice);
    if len_beamformed > len_original
        original_voice = [original_voice; zeros(len_beamformed - len_original, 1)];
    elseif len_original > len_beamformed
        beamformed_audio = [beamformed_audio; zeros(len_original - len_beamformed, 1)];
    end

    % Compute the STFT of both signals
    window = 1024; % Smaller window to provide better temporal resolution
    noverlap = 512;
    nfft = 1024;
    [S_mixture, f, t] = spectrogram(beamformed_audio, window, noverlap, nfft, fs);
    [S_voice, f_voice, t_voice] = spectrogram(original_voice, window, noverlap, nfft, fs);

    % Align the spectrograms using interp2
    % Interpolate magnitude_voice to match the size of magnitude_mixture
    magnitude_mixture = abs(S_mixture);
    magnitude_voice = abs(S_voice);
    
    [F_orig, T_orig] = meshgrid(f_voice, t_voice);
    [F_new, T_new] = meshgrid(f, t);
    magnitude_voice_resized = interp2(F_orig, T_orig, magnitude_voice', F_new, T_new, 'linear', 0)';

    % Create an adaptive mask based on the power spectral density of the voice
    % and mixture signals
    power_mixture = magnitude_mixture.^2;
    power_voice = magnitude_voice_resized.^2;

    % Calculate the Wiener filter mask
    spectral_mask = power_voice ./ (power_mixture + power_voice + eps); % Wiener filter mask

    % Smooth the spectral mask to reduce artifacts
    spectral_mask = imgaussfilt(spectral_mask, 1); % Apply Gaussian smoothing

    % Apply a softening operation to make the mask less aggressive
    alpha = 0.8; % Softening factor (0 < alpha < 1)
    spectral_mask = spectral_mask.^alpha;

    % Apply the Wiener mask to the mixture magnitude to get the separated speech component
    magnitude_separated = spectral_mask .* magnitude_mixture;

    % Reconstruct the spectrogram with the phase from the mixture
    separated_spectrogram = magnitude_separated .* exp(1j * angle(S_mixture));

    % Use Griffin-Lim to refine the phase and reduce robotic artifacts
    max_iterations = 50; % Increase iterations for better phase accuracy
    reconstructed_signal = griffin_lim(separated_spectrogram, window, noverlap, nfft, fs, max_iterations);

    % Ensure the same length as original
    original_length = length(beamformed_audio);
    if length(reconstructed_signal) < original_length
        reconstructed_signal = [reconstructed_signal; zeros(original_length - length(reconstructed_signal), 1)];
    else
        reconstructed_signal = reconstructed_signal(1:original_length);
    end

    % Save the final separated signal as the output
    final_separated_signal = reconstructed_signal;

    % Save the separated audio file
    filename_final = sprintf('Final_Spectral_Mask_Wiener_EnhancedV3_Speech_Grid_%s.wav', num2str(beamform_grid_choice));
    audiowrite(filename_final, final_separated_signal, fs);
    fprintf('Saved %s\n', filename_final);

    % Plot the separated audio signal in time domain
    figure(9);
    t = (0:length(final_separated_signal) - 1) / fs;
    plot(t, final_separated_signal);
    title('Final Separated Speech Signal (Enhanced Wiener Filtering with Mask Refinement)');
    xlabel('Time (s)');
    ylabel('Amplitude');
end

% Griffin-Lim algorithm for iterative phase reconstruction
function reconstructed_signal = griffin_lim(magnitude_spectrogram, window, noverlap, nfft, fs, max_iterations)
    % Initialize phase with random values
    [num_f_bins, num_t_bins] = size(magnitude_spectrogram);
    phase = 2 * pi * (rand(num_f_bins, num_t_bins) - 0.5);
    
    for i = 1:max_iterations
        % Construct the complex spectrogram with current phase estimate
        reconstructed_spectrogram = magnitude_spectrogram .* exp(1j * phase);
        
        % Compute the time-domain signal via ISTFT
        reconstructed_signal = istft(reconstructed_spectrogram, window, noverlap, nfft, fs);
        
        % Recalculate the spectrogram of the reconstructed signal
        [S_reconstructed, ~, ~] = spectrogram(reconstructed_signal, window, noverlap, nfft, fs);
        
        % Ensure phase has the same size as original magnitude_spectrogram
        if size(S_reconstructed, 1) ~= num_f_bins || size(S_reconstructed, 2) ~= num_t_bins
            S_reconstructed = interp2(linspace(0, 1, size(S_reconstructed, 2)), linspace(0, 1, size(S_reconstructed, 1)), abs(S_reconstructed), ...
                                      linspace(0, 1, num_t_bins), linspace(0, 1, num_f_bins)', 'linear', 0);
        end
        
        % Update phase estimate
        phase = angle(S_reconstructed);
    end
end
