function final_separated_signal2 = Separation2(final_separated_signal, beamform_grid_choice, fs)
    % Ensure the audio is mono
    if size(final_separated_signal, 2) > 1
        final_separated_signal = mean(final_separated_signal, 2); % Convert to mono by averaging channels
    end

    % Ensure final_separated_signal is a column vector
    if isrow(final_separated_signal)
        final_separated_signal = final_separated_signal';
    end

    original_length = length(final_separated_signal); % Store original length

    % Define parameters for spectrogram
    window = 4096; % Larger window for better frequency resolution
    noverlap = 3584; % Increased overlap to reduce choppiness (overlap of 12/13, which is ~92%)
    nfft = 4096;

    % Adjust the window size if it is larger than the signal length
    if original_length < window
        window = max(original_length, 2); % Ensure window is at least 2 samples
    end
    if original_length < noverlap
        noverlap = max(floor(window * 0.75), 1); % Ensure noverlap is at least 1 sample
    end

    % Compute the spectrogram with higher resolution and increased overlap
    [S, ~, ~] = spectrogram(final_separated_signal, window, noverlap, nfft, fs);
    magnitude = abs(S);
    phase = angle(S);

    % Apply NMF to the magnitude spectrogram
    num_components = 4; % Increase the number of sources to separate
    [W, H] = nnmf(magnitude, num_components, 'algorithm', 'mult', 'replicates', 10, 'options', statset('MaxIter', 500));

    % Reconstruct the separated components
    separated_signals = cell(num_components + 1, 1); % Extra component for residual
    separated_magnitude_sum = zeros(size(magnitude));
    for i = 1:num_components
        separated_magnitude = W(:, i) * H(i, :);
        separated_magnitude_sum = separated_magnitude_sum + separated_magnitude;
        separated_spectrogram = separated_magnitude .* exp(1j * phase);
        separated_signal = istft(separated_spectrogram, window, noverlap, nfft, fs);
        
        % Ensure the same length as original
        if length(separated_signal) < original_length
            separated_signal = [separated_signal; zeros(original_length - length(separated_signal), 1)];
        else
            separated_signal = separated_signal(1:original_length);
        end

        separated_signals{i} = separated_signal;
    end

    % Compute the residual
    residual_magnitude = max(magnitude - separated_magnitude_sum, 0); % Ensure non-negative values
    residual_spectrogram = residual_magnitude .* exp(1j * phase);
    separated_signal = istft(residual_spectrogram, window, noverlap, nfft, fs);

    % Ensure the same length as original
    if length(separated_signal) < original_length
        separated_signal = [separated_signal; zeros(original_length - length(separated_signal), 1)];
    else
        separated_signal = separated_signal(1:original_length);
    end

    separated_signals{num_components + 1} = separated_signal;

    % Save the separated audio files
    for i = 1:num_components + 1
        filename = sprintf('Separated_Audio_Grid_%s_Source_%db.wav', num2str(beamform_grid_choice), i);
        audiowrite(filename, separated_signals{i}, fs);
        fprintf('Saved %s\n', filename);
    end

    % Save the last separated signal as a variable
    final_separated_signal2 = separated_signals{num_components + 1};

    % Plot the separated audio signals in time and frequency domains
    figure(11);
    t = (0:length(separated_signals{1})-1)/fs;
    for i = 1:num_components + 1
        subplot(2, num_components + 1, i);
        plot(t, separated_signals{i});
        title(sprintf('Separated Source %db', i));
        xlabel('Time (s)');
        ylabel('Amplitude');
        axis([0 5 -1 1]);

        subplot(2, num_components + 1, i + num_components + 1);
        spectrogram(separated_signals{i}, window, noverlap, nfft, fs, 'yaxis');
        xlabel('Time (s)');
        ylabel('kHz');
        axis([0 5 0 6]);
        colormap('jet');
        title(sprintf('Spectrogram of Separated Source %d', i));
        colorbar off;
    end

    sgtitle(sprintf('Separated Audio Sources for Grid %s', num2str(beamform_grid_choice))); % Note: sgtitle requires R2018b or later
end