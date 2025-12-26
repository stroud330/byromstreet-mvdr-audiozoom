function noise_estimation = estimate_noise(audio)
    % Simple estimation of noise using non-speech segments (placeholder)
    noise_estimation = mean(real(audio(audio < 0.05))); % Threshold-based noise estimation on real part
end
