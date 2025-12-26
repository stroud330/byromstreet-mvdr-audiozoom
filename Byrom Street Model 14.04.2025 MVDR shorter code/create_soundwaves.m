function[start_point, end_point, dimensions, soundwave_group, soundProfile, red_line_start, red_line_end, collision_array, reflection_group, collision_coords, collision_group, collision_array2, collision_coords2, collision_array3, collision_coords3, collision_array4, collision_coords4, reflection_data] = create_soundwaves(dimensions, speaker_coordinates, soundwave_choice, custom_soundProfile, world_objects, surfaces)
  
    % Constants and Initializations
    P_thresh = 20e-6;  % 20 µPa, threshold of hearing
    num_speakers = size(speaker_coordinates, 1);
    
    % Check for soundwave choice
    if strcmp(soundwave_choice, '1')
        % Use default soundProfile settings
        soundProfile(1).SPL = 80; soundProfile(1).Azimuth = 210; soundProfile(1).Elevation = 10;  soundProfile(1).HBW = 10; soundProfile(1).VBW = 10;
        soundProfile(2).SPL = 80; soundProfile(2).Azimuth = 180; soundProfile(2).Elevation = 10;  soundProfile(2).HBW = 10; soundProfile(2).VBW = 10;
        soundProfile(3).SPL = 80; soundProfile(3).Azimuth = 150; soundProfile(3).Elevation = 10;  soundProfile(3).HBW = 10; soundProfile(3).VBW = 10;
        soundProfile(4).SPL = 80; soundProfile(4).Azimuth = 270; soundProfile(4).Elevation = 10;  soundProfile(4).HBW = 10; soundProfile(4).VBW = 10;
        soundProfile(5).SPL = 0; soundProfile(5).Azimuth = 90; soundProfile(5).Elevation = 10;  soundProfile(5).HBW = 10; soundProfile(5).VBW = 10;
        soundProfile(6).SPL = 80; soundProfile(6).Azimuth = 45; soundProfile(6).Elevation = 10;  soundProfile(6).HBW = 10; soundProfile(6).VBW = 10;
        soundProfile(7).SPL = 80; soundProfile(7).Azimuth = 330;  soundProfile(7).Elevation = 10;  soundProfile(7).HBW = 10; soundProfile(7).VBW = 10;
        soundProfile(8).SPL = 80; soundProfile(8).Azimuth = 0;  soundProfile(8).Elevation = 10;  soundProfile(8).HBW = 10; soundProfile(8).VBW = 10;
        soundProfile(9).SPL = 80; soundProfile(9).Azimuth = 30; soundProfile(9).Elevation = 10; soundProfile(9).HBW = 10; soundProfile(9).VBW = 10;
    elseif strcmp(soundwave_choice, '2')
        soundProfile = custom_soundProfile;  
    end
   
    % Speaker Coordinate Adjustment
    adjustment = [0.250, 0.250, 1.5];
    adjusted_coordinates = speaker_coordinates + adjustment;
    % Initialize arrays to store line start and end points
    red_line_start = [];
    red_line_end = [];
% Visualization
figure(2);
soundwave_group = hggroup;
reflection_group = hggroup;
collision_group = hggroup;
hold on;
% Initialize arrays to store x1, y1, z1
original_end_coords = cell(num_speakers, 1);
% Loop through the speakers
for i = 1:num_speakers
    if soundProfile(i).SPL <= 0
        continue;
    end
    P_0 = P_thresh * 10^(soundProfile(i).SPL / 20);
    max_distance = sqrt(P_0 / P_thresh);
    %max_distance_array(i) = max_distance; % Initialize max_distance_array
    
    x0 = adjusted_coordinates(i, 1);
    y0 = adjusted_coordinates(i, 2);
    z0 = adjusted_coordinates(i, 3);
    % Limited number of azimuth angles
    theta_values = [soundProfile(i).Azimuth - soundProfile(i).HBW/2, ...
                    soundProfile(i).Azimuth, ...
                    soundProfile(i).Azimuth + soundProfile(i).HBW/2];
    
    % Limited number of elevation angles
    phi_values = [90 - (soundProfile(i).Elevation + soundProfile(i).VBW/2), ...
                  90 - soundProfile(i).Elevation, ...
                  90 - (soundProfile(i).Elevation - soundProfile(i).VBW/2)];
    for theta = theta_values
        theta_modified = theta + 90;  % Azimuth orientation adjustment
        for phi = phi_values
            x1 = x0 + max_distance * sind(phi) * cosd(theta_modified);
            y1 = y0 + max_distance * sind(phi) * sind(theta_modified);
            z1 = z0 + max_distance * cosd(phi);
            original_end_coords{i} = [original_end_coords{i}; x1, y1, z1];
                       
           % Save this line's start and end coordinates
            red_line_start = [red_line_start; x0, y0, z0];
            red_line_end = [red_line_end; x1, y1, z1];
            % BLUE TEST LINE
            %line([x0, x1], [y0, y1], [z0, z1], 'Parent', soundwave_group,'Color', 'b', 'LineWidth', 0.5);
        end
    end
                    
%% Call check_collision to obtain initial collision_coords
[collision_array, collision_coords, calculated_normal, no_collision_idx] = check_collision(red_line_start, red_line_end, world_objects, soundProfile, collision_group, surfaces, dimensions);
%% Loop through all the speakers
% Initialize a counter for the first line index for each speaker
line_counter = 1;
% Loop through all the speakers
for idx = 1:num_speakers
    if soundProfile(idx).SPL <= 0
        continue;
    end
    
    % Update speaker's initial coordinates for this iteration
    x0 = adjusted_coordinates(idx, 1);
    y0 = adjusted_coordinates(idx, 2);
    z0 = adjusted_coordinates(idx, 3);
    
    % Calculate the index range for this speaker's lines dynamically
    start_idx = line_counter;
    end_idx = start_idx + 8;  % Each speaker has 9 lines
    
    % Make sure we don't exceed the bounds of collision_coords
    if end_idx > size(collision_coords, 1)
        end_idx = size(collision_coords, 1);
    end
    
    % Extract this speaker's collision coordinates
    speaker_collision_coords = collision_coords(start_idx:end_idx, :);
    
    % Find the rows where there are actual collisions (non-NaN)
    collision_indices = find(~isnan(speaker_collision_coords(:, 1)));
    
    % Extract the red_line_end coordinates for this speaker
    speaker_red_line_end = red_line_end(start_idx:end_idx, :);
    
    % Remove collided lines to get non-collided lines for this speaker
    non_collided_lines = speaker_red_line_end;
    non_collided_lines(collision_indices, :) = [];
    
    % Increment the line counter for the next iteration
    line_counter = end_idx + 1;
    
    % Plot red lines for collisions
    for k = 1:size(speaker_collision_coords, 1)
        if ~isnan(speaker_collision_coords(k, 1))
            x1 = speaker_collision_coords(k, 1);
            y1 = speaker_collision_coords(k, 2);
            z1 = speaker_collision_coords(k, 3);
            line([x0, x1], [y0, y1], [z0, z1], 'Parent', soundwave_group, 'Color', 'r', 'LineWidth', 0.5);
        end
    end
    % Plot blue lines for non-collisions
    for k = 1:size(non_collided_lines, 1)
        x2 = non_collided_lines(k, 1);
        y2 = non_collided_lines(k, 2);
        z2 = non_collided_lines(k, 3);
        line([x0, x2], [y0, y2], [z0, z2], 'Parent', soundwave_group, 'Color', 'r', 'LineWidth', 0.5);
    end
end
%% Draw reflections
reflection_start_points = NaN(size(collision_coords));
reflection_end_points = NaN(size(collision_coords));
figure(2);
%hold on;
% Preallocate normals_array with NaN
normals_array = NaN(length(collision_array), 3);
% Collect the normals from the struct
for i = 1:length(collision_array)
    if ~isempty(collision_array(i).Normal)
        normals_array(i, :) = collision_array(i).Normal;
    end
end
% Loop through all collision points to draw the reflections
for idx = 1:size(collision_coords, 1)
    % Coordinates where the sound collides with a surface
    x02 = collision_coords(idx, 1);
    y02 = collision_coords(idx, 2);
    z02 = collision_coords(idx, 3);
    % Update the speaker's initial coordinates for this collision point
    x0 = red_line_start(idx, 1);
    y0 = red_line_start(idx, 2);
    z0 = red_line_start(idx, 3);
    
    % Normal at collision
    normal_vector = normals_array(idx, :) / norm(normals_array(idx, :));
    
    % Incident Direction
    startPoint = [x0, y0, z0];  % The original sound source coordinates
    endPoint = [x02, y02, z02];  % The collision point
    incident_vector = (endPoint - startPoint) / norm(endPoint - startPoint);
    
    % Reflection Angle using Snell's Law
    reflection_vector = incident_vector - 2 * (dot(incident_vector, normal_vector)) * normal_vector;
    
    % Adjusting the reflection based on Sabine Coefficient and initial power
    sabine_coefficient = collision_array(idx).Sabine_Coefficient;
    P_reflected = P_0 * sabine_coefficient;
    
    % Update maximum distance the reflected sound can travel
    max_reflected_distance = sqrt(P_reflected / P_thresh);
    
    % Create your reflected vectors
    x_reflection = x02 + reflection_vector(1) * max_reflected_distance;
    y_reflection = y02 + reflection_vector(2) * max_reflected_distance;
    z_reflection = z02 + reflection_vector(3) * max_reflected_distance;
     % Append these to your new arrays
if ~isempty(x_reflection) && ~isempty(y_reflection) && ~isempty(z_reflection)
    reflection_end_points(idx, :) = [x_reflection, y_reflection, z_reflection];
else
    % If any of these are empty, keep them as NaN
    reflection_end_points(idx, :) = [NaN, NaN, NaN];
end
if ~isempty(x02) && ~isempty(y02) && ~isempty(z02)
    reflection_start_points(idx, :) = [x02, y02, z02];
else
    % If any of these are empty, keep them as NaN
    reflection_start_points(idx, :) = [NaN, NaN, NaN];
end
    
    % Draw the reflection line
   %line([x02, x_reflection], [y02, y_reflection], [z02, z_reflection], 'Parent', reflection_group, 'Color', 'g', 'LineWidth', 0.5);
  end
end
% Call check_collision2 to see if the reflection line collides
    start_point = reflection_start_points;
    end_point = reflection_end_points;
 [collision_array2, collision_coords2, calculated_normal2, no_collision_idx2] = check_collision2(start_point, end_point, world_objects, soundProfile, collision_group, surfaces, dimensions, reflection_group);
%% Loop through all the speakers
% Plotting collided lines in green
for i = 1:size(collision_coords, 1)
    start_points = collision_coords(i, :);
    end_points = collision_coords2(i, :);
    
    % Check for NaN values before plotting
    if ~any(isnan(start_points)) && ~any(isnan(end_points))
        line([start_points(1), end_points(1)], ...
             [start_points(2), end_points(2)], ...
             [start_points(3), end_points(3)], 'Parent', reflection_group, 'Color', [1 0.5 0.5]);
    end
end

% Identify non-collided lines by finding NaNs in collision_coords
non_collision_indices = find(isnan(collision_coords2(:, 1)));

% Plotting non-collided lines in blue
for i = 1:size(non_collision_indices, 1)
    idx = non_collision_indices(i);
    start_point = collision_coords(idx, :);
    end_points = end_point(idx, :);
    
    % Check for NaN values before plotting
    if ~any(isnan(end_points))
        line([start_point(1), end_points(1)], ...
             [start_point(2), end_points(2)], ...
             [start_point(3), end_points(3)], 'Parent', reflection_group, 'Color', [1 0.5 0.5]);
    end
end

%% 2ND REFLECTIONS!!
% Draw reflections
reflection_start_points2 = NaN(size(collision_coords2));
reflection_end_points2 = NaN(size(collision_coords2));
figure(2);
%hold on;
% Preallocate normals_array with NaN
normals_array2 = NaN(length(collision_array), 3);
% Collect the normals from the struct
for i = 1:length(collision_array2)
    if ~isempty(collision_array2(i).Normal)
        normals_array2(i, :) = collision_array2(i).Normal;
    end
end
% Loop through all collision points to draw the reflections
for idx = 1:size(collision_coords2, 1)
    % Coordinates where the sound collides with a surface
    x02 = collision_coords2(idx, 1);
    y02 = collision_coords2(idx, 2);
    z02 = collision_coords2(idx, 3);
    % Update the speaker's initial coordinates for this collision point
    x0 = collision_coords(idx, 1);
    y0 = collision_coords(idx, 2);
    z0 = collision_coords(idx, 3);
    
    % Normal at collision
    normal_vector2 = normals_array2(idx, :) / norm(normals_array2(idx, :));
    
    % Incident Direction
    startPoint = [x0, y0, z0];  % The original sound source coordinates
    endPoint = [x02, y02, z02];  % The collision point
    incident_vector2 = (endPoint - startPoint) / norm(endPoint - startPoint);
    
    % Reflection Angle using Snell's Law
    reflection_vector2 = incident_vector2 - 2 * (dot(incident_vector2, normal_vector2)) * normal_vector2;
    
    % Adjusting the reflection based on Sabine Coefficient and initial power
    sabine_coefficient2 = collision_array2(idx).Sabine_Coefficient;
    P_reflected2 = P_reflected * sabine_coefficient2; % P_0
    
    % Update maximum distance the reflected sound can travel
    max_reflected_distance2 = sqrt(P_reflected2 / P_thresh);
    
    % Create your reflected vectors
    x_reflection = x02 + reflection_vector2(1) * max_reflected_distance2;
    y_reflection = y02 + reflection_vector2(2) * max_reflected_distance2;
    z_reflection = z02 + reflection_vector2(3) * max_reflected_distance2;
     % Append these to your new arrays
if ~isempty(x_reflection) && ~isempty(y_reflection) && ~isempty(z_reflection)
    reflection_end_points2(idx, :) = [x_reflection, y_reflection, z_reflection];
else
    % If any of these are empty, keep them as NaN
    reflection_end_points2(idx, :) = [NaN, NaN, NaN];
end
if ~isempty(x02) && ~isempty(y02) && ~isempty(z02)
    reflection_start_points2(idx, :) = [x02, y02, z02];
else
    % If any of these are empty, keep them as NaN
    reflection_start_points2(idx, :) = [NaN, NaN, NaN];
end
    
    % Draw the reflection line
   %line([x02, x_reflection], [y02, y_reflection], [z02, z_reflection], 'Parent', reflection_group, 'Color', 'g', 'LineWidth', 0.5);
  end

%% Call check_collision3 to see if the 2nd reflection line collides
    start_point = reflection_start_points2;
    end_point = reflection_end_points2;
 [collision_array3, collision_coords3, calculated_normal3, no_collision_idx3] = check_collision3(start_point, end_point, world_objects, soundProfile, collision_group, surfaces, dimensions, reflection_group);
% Initialize outputs
%% Loop through all the speakers
% Plotting collided lines in green
for i = 1:size(collision_coords3, 1)
    start_points = collision_coords2(i, :);
    end_points = collision_coords3(i, :);
    
    % Check for NaN values before plotting
    if ~any(isnan(start_points)) && ~any(isnan(end_points))
        line([start_points(1), end_points(1)], ...
             [start_points(2), end_points(2)], ...
             [start_points(3), end_points(3)], 'Parent', reflection_group, 'Color', [1 0.5 0.5]);
    end
end

% Identify non-collided lines by finding NaNs in collision_coords
non_collision_indices = find(isnan(collision_coords3(:, 1)));

% Plotting non-collided lines in blue
for i = 1:size(non_collision_indices, 1)
    idx = non_collision_indices(i);
    start_point = collision_coords2(idx, :);
    end_points = end_point(idx, :);
    
    % Check for NaN values before plotting
    if ~any(isnan(end_points))
        line([start_point(1), end_points(1)], ...
             [start_point(2), end_points(2)], ...
             [start_point(3), end_points(3)], 'Parent', reflection_group, 'Color', [1 0.5 0.5]);
    end
end

%% THIRD REFLECTIONS!!

% Draw reflections
reflection_start_points3 = NaN(size(collision_coords3));
reflection_end_points3 = NaN(size(collision_coords3));
figure(2);
%hold on;
% Preallocate normals_array with NaN
normals_array3 = NaN(length(collision_array), 3);
% Collect the normals from the struct
for i = 1:length(collision_array3)
    if ~isempty(collision_array3(i).Normal)
        normals_array2(i, :) = collision_array3(i).Normal;
    end
end
% Loop through all collision points to draw the reflections
for idx = 1:size(collision_coords3, 1)
    % Coordinates where the sound collides with a surface
    x02 = collision_coords3(idx, 1);
    y02 = collision_coords3(idx, 2);
    z02 = collision_coords3(idx, 3);
    % Update the speaker's initial coordinates for this collision point
    x0 = collision_coords2(idx, 1);
    y0 = collision_coords2(idx, 2);
    z0 = collision_coords2(idx, 3);
    
    % Normal at collision
    normal_vector3 = normals_array3(idx, :) / norm(normals_array3(idx, :));
    
    % Incident Direction
    startPoint = [x0, y0, z0];  % The original sound source coordinates
    endPoint = [x02, y02, z02];  % The collision point
    incident_vector3 = (endPoint - startPoint) / norm(endPoint - startPoint);
    
    % Reflection Angle using Snell's Law
    reflection_vector3 = incident_vector3 - 2 * (dot(incident_vector3, normal_vector3)) * normal_vector3;
    
    % Adjusting the reflection based on Sabine Coefficient and initial power
    sabine_coefficient3 = collision_array3(idx).Sabine_Coefficient;
    P_reflected3 = P_reflected2 * sabine_coefficient2; % P_0
    
    % Update maximum distance the reflected sound can travel
    max_reflected_distance3 = sqrt(P_reflected3 / P_thresh);
    
    % Create your reflected vectors
    x_reflection = x02 + reflection_vector2(1) * max_reflected_distance3;
    y_reflection = y02 + reflection_vector2(2) * max_reflected_distance3;
    z_reflection = z02 + reflection_vector2(3) * max_reflected_distance3;
     % Append these to your new arrays
if ~isempty(x_reflection) && ~isempty(y_reflection) && ~isempty(z_reflection)
    reflection_end_points3(idx, :) = [x_reflection, y_reflection, z_reflection];
else
    % If any of these are empty, keep them as NaN
    reflection_end_points3(idx, :) = [NaN, NaN, NaN];
end
if ~isempty(x02) && ~isempty(y02) && ~isempty(z02)
    reflection_start_points3(idx, :) = [x02, y02, z02];
else
    % If any of these are empty, keep them as NaN
    reflection_start_points3(idx, :) = [NaN, NaN, NaN];
end
    
    % Draw the reflection line
   %line([x02, x_reflection], [y02, y_reflection], [z02, z_reflection], 'Parent', reflection_group, 'Color', 'g', 'LineWidth', 0.5);
  end

%% Call check_collision3 to see if the 3rd reflection line collides
    start_point = reflection_start_points3;
    end_point = reflection_end_points3;
 [collision_array4, collision_coords4, calculated_normal4, no_collision_idx4] = check_collision4(start_point, end_point, world_objects, soundProfile, collision_group, surfaces, dimensions, reflection_group);
% Initialize outputs
%% Loop through all the speakers
% Plotting collided lines in green
for i = 1:size(collision_coords3, 1)
    start_points = collision_coords3(i, :);
    end_points = collision_coords4(i, :);
    
    % Check for NaN values before plotting
    if ~any(isnan(start_points)) && ~any(isnan(end_points))
        line([start_points(1), end_points(1)], ...
             [start_points(2), end_points(2)], ...
             [start_points(3), end_points(3)], 'Parent', reflection_group, 'Color', [1 0.5 0.5]);
    end
end

% Identify non-collided lines by finding NaNs in collision_coords
non_collision_indices = find(isnan(collision_coords4(:, 1)));

% Plotting non-collided lines in blue
for i = 1:size(non_collision_indices, 1)
    idx = non_collision_indices(i);
    start_point = collision_coords3(idx, :);
    end_points = end_point(idx, :);
    
    % Check for NaN values before plotting
    if ~any(isnan(end_points))
        line([start_point(1), end_points(1)], ...
             [start_point(2), end_points(2)], ...
             [start_point(3), end_points(3)], 'Parent', reflection_group, 'Color', [1 0.5 0.5]);
    end
end
%% Initialize reflection data structure
reflection_data = struct(...
    'reflectionPoints1', arrayfun(@(x) x.Collision_Coordinates, collision_array, 'UniformOutput', false), ...
    'reflectionNormals1', arrayfun(@(x) x.Normal, collision_array, 'UniformOutput', false), ...
    'sabineCoefficients1', arrayfun(@(x) x.Sabine_Coefficient, collision_array, 'UniformOutput', false), ...
    'reflectionPoints2', arrayfun(@(x) x.Collision_Coordinates, collision_array2, 'UniformOutput', false), ...
    'reflectionNormals2', arrayfun(@(x) x.Normal, collision_array2, 'UniformOutput', false), ...
    'sabineCoefficients2', arrayfun(@(x) x.Sabine_Coefficient, collision_array2, 'UniformOutput', false), ...
    'reflectionPoints3', arrayfun(@(x) x.Collision_Coordinates, collision_array3, 'UniformOutput', false), ...
    'reflectionNormals3', arrayfun(@(x) x.Normal, collision_array3, 'UniformOutput', false), ...
    'sabineCoefficients3', arrayfun(@(x) x.Sabine_Coefficient, collision_array3, 'UniformOutput', false), ...
    'reflectionPoints4', arrayfun(@(x) x.Collision_Coordinates, collision_array4, 'UniformOutput', false), ...
    'reflectionNormals4', arrayfun(@(x) x.Normal, collision_array4, 'UniformOutput', false), ...
    'sabineCoefficients4', arrayfun(@(x) x.Sabine_Coefficient, collision_array4, 'UniformOutput', false) ...
);


