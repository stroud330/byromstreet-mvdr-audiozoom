function [ALLSPKMics, fs, speedOfSound, drone_noise] = import_audio_signals(distanceSpkMics, mic_coordinates, speaker_coordinates, micsOn, soundProfile, reflection_data)
   
    % Parameters
    N = 240000;
    fs = 48000;
    speedOfSound = 343;
    t = (0:N-1)/fs;

    % Load audio files
    [music_sound, fs] = audioread('Audio/Music5secs.wav');
    [speech_sound, ~] = audioread('Audio/Speech5secs.wav');
    [drone_noise, ~] = audioread('Audio/Dronenoise5secs.wav');

    % Initialize ALLSPKMics
    ALLSPKMics = cell(1, size(mic_coordinates, 1));
    mic_signals = zeros(size(mic_coordinates, 1), N);

    % Process Speaker Signals
    for spk = 1:size(speaker_coordinates, 1)
        if soundProfile(spk).SPL ~= 0  % Check if the speaker is on
            % Select the appropriate signal for each speaker
            if spk == 3  % Human voice for speaker 3
                spk_signal = speech_sound';
            else  % Music for all other speakers
                spk_signal = music_sound';
            end

            for mic = 1:size(mic_coordinates, 1)
                if micsOn(mic) == 1
                    % Distance-based attenuation and delay
                    distance = distanceSpkMics(spk, mic);
                    delay_samples = round((distance / speedOfSound) * fs);
                    attenuation_factor = 1 / (distance^2);  % Inverse square law

                    % SPL adjustment (SPL at 1 meter)
                    SPL_adjustment = db2mag(soundProfile(spk).SPL - 94);  % Convert dB SPL to linear scale
                    if delay_samples < length(spk_signal)
                        attenuated_signal = [zeros(1, delay_samples), spk_signal(1:end - delay_samples)] * attenuation_factor * SPL_adjustment;
                    else
                        attenuated_signal = zeros(1, length(spk_signal)); % If delay exceeds signal length
                    end

                    % Combine signals for each microphone
                    mic_signals(mic, :) = mic_signals(mic, :) + attenuated_signal;
                end
            end
        end
    end

    % Add drone noise to each microphone signal, adjusted for level
    drone_noise_level = 0.001; % Adjust this value based on your requirements
    drone_noise_adjusted = drone_noise * drone_noise_level;
    if length(drone_noise_adjusted) < N
        drone_noise_adjusted = [drone_noise_adjusted; zeros(N - length(drone_noise_adjusted), 1)];
    else
        drone_noise_adjusted = drone_noise_adjusted(1:N);
    end

    for mic = 1:size(mic_coordinates, 1)
        mic_signals(mic, :) = mic_signals(mic, :) + drone_noise_adjusted';
    end

    % Normalize only if max(abs(mic_signals(:))) is not zero
    if max(abs(mic_signals(:))) ~= 0
        mic_signals = mic_signals / max(abs(mic_signals(:)));
    end

    % Save microphone 1 signal for testing as a WAV file
    mic1_signal = mic_signals(1, :);
    mic1_signal = mic1_signal / max(abs(mic1_signal)); % Normalize to avoid clipping
    audiowrite('mic1_signal_pre_beamforming.wav', mic1_signal, fs);

    % Assign to ALLSPKMics
    for mic = 1:size(mic_coordinates, 1)
        ALLSPKMics{mic} = mic_signals(mic, :);
    end
    ALLSPKMics = ALLSPKMics';

    % Plotting the signals
    figure(4);
    for mic = 1:size(mic_coordinates, 1)
        subplot(4, 4, mic);
        plot(t, ALLSPKMics{mic});
        title(sprintf('Mic %d', mic));
        xlabel('Time (s)');
        ylabel('Amplitude');
        axis([0 max(t) -1 1]); % Adjust axis as needed
    end
end