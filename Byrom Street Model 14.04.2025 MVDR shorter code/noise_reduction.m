function enhanced_audio = noise_reduction(beamformed_audio, beamform_grid_choice, fs)
    %% Spectral Subtraction for Noise Reduction
    % Parameters
    window_length = 2048;
    overlap_length = 1024;
    nfft = 2048;

    % Estimate noise spectrum from a portion of the audio with minimal signal (non-speech segment)
    noise_estimation_segment = beamformed_audio(beamformed_audio < 0.05);
    if isempty(noise_estimation_segment)
        noise_estimation_segment = beamformed_audio(1:window_length); % Fallback if no silence is detected
    end
    noise_spectrum = mean(abs(spectrogram(noise_estimation_segment, window_length, overlap_length, nfft, fs)), 2);

    % Spectrogram of beamformed audio
    [S, F, T] = spectrogram(beamformed_audio, window_length, overlap_length, nfft, fs);
    magnitude_S = abs(S);
    phase_S = angle(S);

    % Apply Spectral Subtraction
    enhanced_magnitude = magnitude_S - repmat(noise_spectrum, 1, length(T));
    enhanced_magnitude = max(enhanced_magnitude, 0); % Prevent negative magnitudes

    % Reconstruct the enhanced signal
    enhanced_S = enhanced_magnitude .* exp(1j * phase_S);
    enhanced_audio = istft(enhanced_S, fs, 'Window', hann(window_length), 'OverlapLength', overlap_length, 'FFTLength', nfft);

    % Normalize the enhanced audio to avoid clipping
    enhanced_audio = enhanced_audio / max(abs(enhanced_audio));
end
