function [collision_array4, collision_coords4, calculated_normal4, no_collision_idx4] = check_collision4(start_point, end_point, world_objects, soundProfile, collision_group, surfaces, dimensions, reflection_group)
% Initialize outputs
    total_reflected_lines = size(start_point, 1);
    isIntersect2 = false(1, total_reflected_lines);
    closest_collision_distance2 = Inf(1, total_reflected_lines);
    % Preallocate collision_coords with NaN
    collision_coords4 = NaN(total_reflected_lines, 3);  
    % Initialize a vector to keep track of lines with no collisions
    no_collision_idx4 = [];
    % Initialize collision_array
    collision_array4 = repmat(struct('SoundSource', '', 'SoundProfile', '', 'Component', '', 'Material', '', 'Sabine_Coefficient', '', 'Collision_Coordinates', [], 'Normal', []), total_reflected_lines, 1);
    % Initialize the counter for total_red_lines
    counter = 1;
    % Loop through soundProfile to populate SoundSource and SoundProfile arrays
    for i = 1:length(soundProfile)
        if soundProfile(i).SPL > 0  % Check if the speaker is active
            for j = 1:9  % Assuming each active speaker has 9 associated red lines
                SoundSource{counter} = sprintf('Speaker %d', i);
                SoundProfile{counter} = sprintf('SoundProfile %d', i);
                counter = counter + 1;
            end
        end
    end
    % Populate initial SoundSource and SoundProfile
    for i = 1:length(collision_array4)
        collision_array4(i).SoundSource = SoundSource{i};
        collision_array4(i).SoundProfile = SoundProfile{i};
    end

tolerance_for_start_point = 1e-6;  % You can adjust this as needed
% Initialize counters before the loop
array_counter = 0;
% Check for collisions
for line_idx2 = 1:total_reflected_lines
    closest_collision_distance2(line_idx2) = Inf;  % Reset for each line
    current_start_point = start_point(line_idx2, :);  % Select the start point of the current line
    current_end_point = end_point(line_idx2, :);     % Select the end point of the current line
    for building_idx2 = 1:length(world_objects)
        for component_idx = 1:length(world_objects(building_idx2).components)
            this_component2 = world_objects(building_idx2).components(component_idx);
            vertices2 = this_component2.vertices;
            faces2 = this_component2.faces;
            
           if isempty(vertices2) || isempty(faces2)
                continue;
            end

            for f = 1:size(faces2, 1)
                face2 = faces2(f, :);
                face2 = face2(~isnan(face2));  % Remove NaNs to handle both triangular and quadrilateral faces
                % Identify ceiling by the face index
                isCeiling = (f == 6);  % 6th row is always the ceiling 
                % Collision logic
            v1 = vertices2(face2(1), :);
            v2 = vertices2(face2(2), :);
            v3 = vertices2(face2(3), :);
            calculated_normal4 = cross(v2 - v1, v3 - v1);

            t = dot(calculated_normal4, (v1 - current_start_point)) / dot(calculated_normal4, (current_end_point - current_start_point));
                isIntersect2 = false;
                point2 = [];
                
                if t >= 0  && t <= 1 
                    point2 = current_start_point + t * (current_end_point - current_start_point);
                    isIntersect2 = true;
                end
                if ~isempty(point2)

tolerance = 0.01;
% Check if point or its adjusted version (considering tolerance) is within the polygon
adjustedPoints2 = [point2(1) + tolerance, point2(2);
                  point2(1) - tolerance, point2(2);
                  point2(1), point2(2) + tolerance;
                  point2(1), point2(2) - tolerance];

isWithinBoundsXY2 = any(arrayfun(@(idx) pointInPolygon(adjustedPoints2(idx, 1), adjustedPoints2(idx, 2), vertices2), 1:size(adjustedPoints2, 1)));

% Adjust the Z dimension bounds with tolerance
isWithinBoundsZ2 = (point2(3) >= min(vertices2(:, 3)) - tolerance & point2(3) <= max(vertices2(:, 3)) + tolerance);

isWithinBounds2 = isWithinBoundsXY2 && isWithinBoundsZ2;


                end
                    if isIntersect2 && isWithinBounds2
                        distance_to_collision = norm(point2 - current_start_point);
                        if distance_to_collision < closest_collision_distance2(line_idx2) && distance_to_collision > tolerance_for_start_point
        closest_collision_distance2(line_idx2) = distance_to_collision;
                            collision_array4(line_idx2).Component = this_component2.name;
                            collision_array4(line_idx2).Material = this_component2.material;
                            collision_array4(line_idx2).Sabine_Coefficient = this_component2.sabine_coefficient;
                            collision_array4(line_idx2).Collision_Coordinates = point2;
                            collision_array4(line_idx2).Normal = calculated_normal4;
                          if isCeiling
                                collision_array4(line_idx2).Component = strcat(this_component2.name, '_ceiling');
                          end
                            array_counter = array_counter + 1;
                        end
                    end
                end
            end
            % If no collision for this line
            if closest_collision_distance2(line_idx2) == Inf
                no_collision_idx4 = [no_collision_idx4, line_idx2];
            end
    
    
 %% Ground Collision Checks
    for surface_idx = 1:length(surfaces)
        x = surfaces(surface_idx).position.x;
        y = surfaces(surface_idx).position.y;
        z = surfaces(surface_idx).position.z; 

        v1 = [x(1), y(1), z(1)];
        v2 = [x(2), y(2), z(2)];
        v3 = [x(3), y(3), z(3)];
        calculated_normal4 = cross(v2 - v1, v3 - v1);
        t = dot(calculated_normal4, (v1 - current_start_point)) / dot(calculated_normal4, (current_end_point - current_start_point));

        point2 = [];
        if t >= 0 && t <= 1
            point2 = current_start_point + t * (current_end_point - current_start_point);
            isIntersect2 = true;
        end

        if ~isempty(point2) && inpolygon(point2(1), point2(2), x, y)
            distance_to_collision = norm(point2 - current_start_point);
            if distance_to_collision < closest_collision_distance2(line_idx2) && distance_to_collision > tolerance_for_start_point
        closest_collision_distance2(line_idx2) = distance_to_collision;
                collision_array4(line_idx2).Component = surfaces(surface_idx).name; % Assuming surfaces struct has a name field
                collision_array4(line_idx2).Material = surfaces(surface_idx).material;
                collision_array4(line_idx2).Sabine_Coefficient = surfaces(surface_idx).sabine_coefficient;
                collision_array4(line_idx2).Collision_Coordinates = point2;
                collision_array4(line_idx2).Normal = calculated_normal4;
            end
        end
    end

    % Check if no collision for this line
    if closest_collision_distance2(line_idx2) == Inf
        no_collision_idx4 = [no_collision_idx4, line_idx2];
    
    end
    end
    end

%% Preallocate collision_coords with NaN
collision_coords4 = NaN(length(collision_array4), 3);

% Collect the coordinates from the struct
for i = 1:length(collision_array4)
    if ~isempty(collision_array4(i).Collision_Coordinates)
        collision_coords4(i, :) = collision_array4(i).Collision_Coordinates;
    end
end

% Plot the collision coordinates
if ~all(isnan(collision_coords4), 'all')
    valid_coords2 = collision_coords4(~isnan(collision_coords4(:, 1)), :);
    scatter3(valid_coords2(:, 1), valid_coords2(:, 2), valid_coords2(:, 3), 'Parent', collision_group, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'y');
end

