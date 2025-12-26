function beam_pattern = compute_beam_pattern(beamformer, azimuth_range, elevation_range)
    num_azimuth = length(azimuth_range);
    num_elevation = length(elevation_range);
    beam_pattern = zeros(num_elevation, num_azimuth);
    speed_of_sound = 34300;%beamformer.PropagationSpeed;
    Fs = beamformer.SampleRate;
    array = beamformer.SensorArray;
    num_elements = array.NumElements;
    element_spacing = array.ElementSpacing;

    for azi_idx = 1:num_azimuth
        for ele_idx = 1:num_elevation
            direction = [azimuth_range(azi_idx); elevation_range(ele_idx)];
           

            R = array.getElementPosition;
            steering_vector = exp(-1i * 2 * pi / (speed_of_sound / Fs) * ...
                (R(1, :) * sin(deg2rad(elevation_range(ele_idx))) * cos(deg2rad(azimuth_range(azi_idx))) + ...
                 R(2, :) * sin(deg2rad(elevation_range(ele_idx))) * sin(deg2rad(azimuth_range(azi_idx))) + ...
                 R(3, :) * cos(deg2rad(elevation_range(ele_idx)))));

            % Compute time delay beamforming weights
            time_delays = (0:(num_elements - 1)) * element_spacing * cos(deg2rad(direction(2))) * cos(deg2rad(direction(1))) / speed_of_sound;
            weights = exp(-1i * 2 * pi * time_delays * Fs);

            beam_pattern(ele_idx, azi_idx) = abs(weights * steering_vector(:));
        end
    end

    beam_pattern = 20 * log10(beam_pattern);
end
