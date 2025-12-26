function [final_filtered_signal, beamformed_audio, beamformer, azimuth_grids] = beamformer_MVDR(fs, dimensions, beamform_grid_choice, mic_coordinates, speaker_coordinates, ALLSPKMics)
    %% Enhanced Beamformer with MVDR and ICA for Noise Reduction
    user_input_numeric = str2double(beamform_grid_choice);
    
    % Compute the azimuth and elevation angles for each microphone
    ref_azimuth = atan2(mic_coordinates(3, 2) - dimensions.centreY, mic_coordinates(3, 1) - dimensions.centreX) * 180/pi;
    azimuth_mics = zeros(size(mic_coordinates, 1), 1);
    elevations_mics = zeros(size(mic_coordinates, 1), 1);
    for i = 1:size(mic_coordinates, 1)
        x = mic_coordinates(i, 1) - dimensions.centreX;
        y = mic_coordinates(i, 2) - dimensions.centreY;
        z = mic_coordinates(i, 3);
        azimuth_mics(i) = wrapTo180(atan2(y, x) * 180/pi - ref_azimuth);
        elevations_mics(i) = wrapTo180(atan2(z, sqrt(x^2 + y^2 + z^2)) * 180/pi);
    end
    %% MVDR Beamformer - Azimuth Grid Setup
       azimuth_grids = zeros(size(speaker_coordinates, 1), 1);
    for i = 1:size(speaker_coordinates, 1)
        x = speaker_coordinates(i, 1) - dimensions.centreX;
        y = speaker_coordinates(i, 2) - dimensions.centreY;
        azimuth_grids(i) = wrapTo180(atan2(y, x) * 180/pi -90);
    end
    azimuth_grids = wrapTo180(azimuth_grids); % Ensure values are within -180 to 180 degrees % Ensure all values are >= -180
    azimuth_grids = azimuth_grids';
    %azimuth_grids = [45, 0, -45, 90, 0, -90, 122.5, 180, -122.5]';
    elevation_grids = zeros(size(speaker_coordinates, 1), 1);
    for i = 1:size(speaker_coordinates, 1)
        [~, elevation_grids(i)] = cart2sph(speaker_coordinates(i,1) - dimensions.centreX, speaker_coordinates(i,2) - dimensions.centreY, dimensions.centreZ);
        elevation_grids(i) = wrapTo180(elevation_grids(i) * 180/pi);
    end
    %% MVDR Beamformer Implementation
    % Explicitly define the microphone array using the provided mic positions
    mic_positions = mic_coordinates'; % Transpose to match the required format (3 x N)
    mic_array = phased.ConformalArray('ElementPosition', mic_positions);
    beamformer = phased.MVDRBeamformer('SensorArray', mic_array, 'PropagationSpeed', 343, 'Direction', [azimuth_grids(user_input_numeric); elevation_grids(user_input_numeric)], 'WeightsOutputPort', true, 'DiagonalLoadingFactor', 0.02);
    
    %% Apply MVDR Beamformer to Audio Data
    audio_data_matrix = cell2mat(ALLSPKMics)'; % Convert cell array to matrix
    [beamformed_audio, weights] = beamformer(audio_data_matrix);
    %% Pre Beamformed audio
    Array_Audio_Pre_Beamform = sum(audio_data_matrix, 2);
    Array_Audio_Pre_Beamform = Array_Audio_Pre_Beamform / max(abs(Array_Audio_Pre_Beamform));
    %% Normalize Beamformed Audio
    %beamformed_audio = beamformed_audio / max(abs(beamformed_audio));
     beamformed_audio = (beamformed_audio / max(abs(beamformed_audio))) * 0.3;

    %% Save Pre Beamformed Audio
    filename_Pre_beamformed = 'Pre_Beamformed_Audio.wav';
    audiowrite(filename_Pre_beamformed, real(Array_Audio_Pre_Beamform), fs);
    
    %% Polar Plot Beamforming Pattern 
    % Compute MVDR beam pattern based on beamformer properties
    azimuth_range = -180:1:180;
    elevation_range = 0; % Set to 0 for a 2D plot
    beam_pattern_dB = compute_mvdr_beam_pattern(beamformer, azimuth_range, elevation_range, audio_data_matrix);
    
    % Apply scaling to emphasize the directivity
    beam_pattern_dB = 20 * log10(abs(beam_pattern_dB) + eps); % Convert to dB scale
    beam_pattern_dB = beam_pattern_dB - max(beam_pattern_dB); % Normalize to 0 dB max
    beam_pattern_dB = max(beam_pattern_dB, -40); % Limit to -40 dB to retain directivity
    
    figure(5);
    azimuth_offset = mod(azimuth_grids(user_input_numeric) - 90 + 180, 360); % Adjust azimuth offset to align correctly, with an additional -90 degree offset
    %azimuth_rotation = 0; % Set the rotation to shift zero from the right to the top
    titleString = ['Beam Pattern Steered to Grid ', num2str(beamform_grid_choice)];
    polarpattern(mod(azimuth_range + azimuth_offset, 360), beam_pattern_dB, 'MagnitudeLim', [-250e-3, 0], 'AngleAtTop', 0, 'TitleTopTextInterpreter', 'tex', 'TitleTop', titleString);
 %% Plot Beam Pattern for the Selected Array Shape
% Compute the directivity pattern for the entire microphone array
% Use -180 to 180 for azimuth, as it represents the entire range
azimuth_range = -180:180;
elevation_range = 0;
% Recompute the beam pattern for the entire array response without beamforming to a specific direction
beam_pattern_dB = pattern(mic_array, fs, azimuth_range, elevation_range, 'PropagationSpeed', 343);
% Convert azimuth_range from -180:180 to 0:360 for visualization purposes
azimuth_range_shifted = mod(azimuth_range + 180, 360);
% Use polarpattern for consistent plotting style with Figure 6
figure(6)
titleString = 'Beam Pattern for Chosen Array';
polarpattern(azimuth_range_shifted, beam_pattern_dB, 'MagnitudeLim', [-40, 0], 'AngleAtTop', 0, 'TitleTopTextInterpreter', 'tex', 'TitleTop', titleString);

%% Filtering

[final_filtered_signal] = Filter(beamformed_audio, beamform_grid_choice, fs);

    % Normalize reconstructed audio
    final_filtered_signal = final_filtered_signal / max(abs(final_filtered_signal))*0.3;

%% Plot Beamformer Output after Filtering
N = length(final_filtered_signal);
t = (0:N-1)/fs; % Time vector for plotting
figure(7);

% First subplot (Time Domain Signals)
subplot(1,2,1);

% Plot all signals with specific handles
h(1) = plot(t, real(Array_Audio_Pre_Beamform(1:N)), 'DisplayName', 'Pre Beamformed Audio', 'LineWidth', 0.5);
hold on;
h(2) = plot(t, real(beamformed_audio(1:N)), 'DisplayName', 'Beamformed Audio', 'LineWidth', 0.5);
h(3) = plot(t, real(final_filtered_signal), 'DisplayName', 'Filtered Audio', 'LineWidth', 0.5);
hold off;

% Create an interactive legend for the first subplot with individual items
lgd1 = legend([h(1), h(2), h(3)], 'Pre Beamformed Audio', 'Beamformed Audio', 'Filtered Audio');
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title(['Beamformer with Filtering Grid ' num2str(beamform_grid_choice)]);
axis([0 5 -1 1]);

% Set up legend to be interactive for each waveform
set(lgd1, 'ItemHitFcn', @(~, event) toggleVisibility(event, h));

% Second subplot (Spectrogram) - Initialize with the final filtered signal
subplot(1,2,2);
spectrogram(real(final_filtered_signal), 2048, 1024, 2048, fs, 'yaxis');
xlabel('Time (s)');
ylabel('kHz');
axis([0 5 0 20]);
colormap('jet');
title('Spectrogram of Filtered Audio');
colorbar off;

% Callback function to toggle visibility of a plot line
function toggleVisibility(event, h)
    % Find the index of the clicked item in the legend
    index = find(strcmp({h.DisplayName}, event.Peer.DisplayName));
    
    % Toggle visibility of the clicked line
    if strcmp(h(index).Visible, 'on')
        h(index).Visible = 'off';
    else
        h(index).Visible = 'on';
    end

    % Determine which waveforms are currently visible
    visible_lines = find(arrayfun(@(x) strcmp(x.Visible, 'on'), h));

    % If at least one waveform is visible, update the spectrogram to reflect the last visible waveform
    if ~isempty(visible_lines)
        % Update the spectrogram with the last visible signal
        subplot(1,2,2);
        cla; % Clear the current spectrogram plot
        spectrogram(real(h(visible_lines(end)).YData), 2048, 1024, 2048, fs, 'yaxis');
        xlabel('Time (s)');
        ylabel('kHz');
        axis([0 5 0 20]);
        colormap('jet');
        title(['Spectrogram of ' h(visible_lines(end)).DisplayName]);
        colorbar off;
    else
        % Clear the spectrogram if no signals are visible
        subplot(1,2,2);
        cla;
        title('No Signal Selected');
    end
end

    %% Save Beamformed Audio
    filename_beamformed = ['Beamformed_Audio_Grid_' num2str(beamform_grid_choice) '.wav'];
    audiowrite(filename_beamformed, real(beamformed_audio), fs);
end  