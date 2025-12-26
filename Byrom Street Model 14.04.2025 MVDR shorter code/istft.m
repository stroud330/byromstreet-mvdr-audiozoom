function separated_signal = istft(S, window, noverlap, nfft, ~)
    % ISTFT - Inverse Short-Time Fourier Transform
    %
    % S: Spectrogram (complex matrix)
    % window: Length of the window
    % noverlap: Number of overlapping samples
    % nfft: Number of FFT points

    % Inverse STFT parameters
    hop_size = window - noverlap;
    [~, num_frames] = size(S);
    len_audio = (num_frames - 1) * hop_size + window;
    separated_signal = zeros(len_audio, 1); % Ensure column vector

    % Inverse STFT
    for i = 1:num_frames
        frame = ifft(S(:, i), nfft, 'symmetric');
        audio_start = (i-1) * hop_size + 1;
        audio_end = audio_start + window - 1;
        separated_signal(audio_start:audio_end) = separated_signal(audio_start:audio_end) + frame(1:window);
    end

    % Normalize the audio to avoid clipping
    separated_signal = separated_signal / max(abs(separated_signal));
end