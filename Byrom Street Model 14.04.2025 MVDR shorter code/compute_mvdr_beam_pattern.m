function beam_pattern = compute_mvdr_beam_pattern(beamformer, azimuth_range, elevation_range, audio_data_matrix)
    % Compute the MVDR beam pattern based on the steering direction and beamformer properties
    num_azimuth = length(azimuth_range);
    num_elevation = length(elevation_range);
    beam_pattern = zeros(num_elevation, num_azimuth);
    array = beamformer.SensorArray;
    steering_vector = phased.SteeringVector('SensorArray', array, 'PropagationSpeed', 343);
    frequency = 1e3; % Set frequency for steering vector computation
    for azi_idx = 1:num_azimuth
        for ele_idx = 1:num_elevation
            direction = [azimuth_range(azi_idx); elevation_range(ele_idx)];
            sv = steering_vector(frequency, direction); % Compute the steering vector for the direction
            % Ensure correct dimension alignment for multiplication
            if size(audio_data_matrix, 2) == length(sv)
                output = abs(audio_data_matrix * sv); % Calculate response with correct dimensions
                beam_pattern(ele_idx, azi_idx) = mean(output); % Averaging over all samples for stability
            else
                output = abs(audio_data_matrix' * sv); % Fallback if dimensions require transposition
                beam_pattern(ele_idx, azi_idx) = mean(output); % Averaging over all samples for stability
            end
        end
    end
    beam_pattern = 20 * log10(beam_pattern);
end