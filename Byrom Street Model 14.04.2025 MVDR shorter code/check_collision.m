function [collision_array, collision_coords, calculated_normal, no_collision_idx] = check_collision(red_line_start, red_line_end, world_objects, soundProfile, collision_group, surfaces, dimensions)
    % Initialize outputs
    total_red_lines = size(red_line_start, 1);
    isIntersect = false(1, total_red_lines);
    closest_collision_distance = Inf(1, total_red_lines);
    % Preallocate collision_coords with NaN
    collision_coords = NaN(total_red_lines, 3); 
    % Initialize a vector to keep track of lines with no collisions
    no_collision_idx = [];
    % Initialize collision_array
    collision_array = repmat(struct('SoundSource', '', 'SoundProfile', '', 'Component', '', 'Material', '', 'Sabine_Coefficient', '', 'Collision_Coordinates', [], 'Normal', []), total_red_lines, 1);
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
    for i = 1:length(collision_array)
        collision_array(i).SoundSource = SoundSource{i};
        collision_array(i).SoundProfile = SoundProfile{i};
    end
% Initialize counters before the loop
array_counter = 0;
% Check for collisions
for line_idx = 1:total_red_lines
    closest_collision_distance(line_idx) = Inf;  % Reset for each line
    startPoint = red_line_start(line_idx, :);
    endPoint = red_line_end(line_idx, :);
    for building_idx = 1:length(world_objects)
        for component_idx = 1:length(world_objects(building_idx).components)
            this_component = world_objects(building_idx).components(component_idx);
            vertices = this_component.vertices;
            faces = this_component.faces;
            
           if isempty(vertices) || isempty(faces)
                continue;
            end

            for f = 1:size(faces, 1)
                face = faces(f, :);
                face = face(~isnan(face));  % Remove NaNs to handle both triangular and quadrilateral faces
                % Identify ceiling by the face index
                isCeiling = (f == 6);  % 6th row is always the ceiling 
                % Collision logic

            v1 = vertices(face(1), :);
            v2 = vertices(face(2), :);
            v3 = vertices(face(3), :);
            calculated_normal = cross(v2 - v1, v3 - v1);

                t = dot(calculated_normal, (v1 - startPoint)) / dot(calculated_normal, (endPoint - startPoint));
                isIntersect = false;
                point = [];
                if t >= 0  && t <= 1 
                    point = startPoint + t * (endPoint - startPoint);
                    isIntersect = true;
                end
                if ~isempty(point)

tolerance = 0.01;
% Check if point or its adjusted version (considering tolerance) is within the polygon
adjustedPoints = [point(1) + tolerance, point(2);
                  point(1) - tolerance, point(2);
                  point(1), point(2) + tolerance;
                  point(1), point(2) - tolerance];

isWithinBoundsXY = any(arrayfun(@(idx) pointInPolygon(adjustedPoints(idx, 1), adjustedPoints(idx, 2), vertices), 1:size(adjustedPoints, 1)));

% Adjust the Z dimension bounds with tolerance
isWithinBoundsZ = (point(3) >= min(vertices(:, 3)) - tolerance & point(3) <= max(vertices(:, 3)) + tolerance);

isWithinBounds = isWithinBoundsXY && isWithinBoundsZ;


                end
                    if isIntersect && isWithinBounds
                        distance_to_collision = norm(point - startPoint);
                        if distance_to_collision < closest_collision_distance(line_idx)
                            closest_collision_distance(line_idx) = distance_to_collision;
                            collision_array(line_idx).Component = this_component.name;
                            collision_array(line_idx).Material = this_component.material;
                            collision_array(line_idx).Sabine_Coefficient = this_component.sabine_coefficient;
                            collision_array(line_idx).Collision_Coordinates = point;
                            collision_array(line_idx).Normal = calculated_normal;
                          if isCeiling
                                collision_array(line_idx).Component = strcat(this_component.name, '_ceiling');
                          end
                            array_counter = array_counter + 1;
                        end
                    end
                end
            end
            % If no collision for this line
            if closest_collision_distance(line_idx) == Inf
                no_collision_idx = [no_collision_idx, line_idx];
            end
    
    
 %% Ground Collision Checks
    for surface_idx = 1:length(surfaces)
        x = surfaces(surface_idx).position.x;
        y = surfaces(surface_idx).position.y;
        z = surfaces(surface_idx).position.z; 

        v1 = [x(1), y(1), z(1)];
        v2 = [x(2), y(2), z(2)];
        v3 = [x(3), y(3), z(3)];
        calculated_normal = cross(v2 - v1, v3 - v1);
        t = dot(calculated_normal, (v1 - startPoint)) / dot(calculated_normal, (endPoint - startPoint));

        point = [];
        if t >= 0 && t <= 1
            point = startPoint + t * (endPoint - startPoint);
            isIntersect = true;
        end

        if ~isempty(point) && inpolygon(point(1), point(2), x, y)
            distance_to_collision = norm(point - startPoint);
            if distance_to_collision < closest_collision_distance(line_idx)
                closest_collision_distance(line_idx) = distance_to_collision;
                collision_array(line_idx).Component = surfaces(surface_idx).name; % Assuming surfaces struct has a name field
                collision_array(line_idx).Material = surfaces(surface_idx).material;
                collision_array(line_idx).Sabine_Coefficient = surfaces(surface_idx).sabine_coefficient;
                collision_array(line_idx).Collision_Coordinates = point;
                collision_array(line_idx).Normal = calculated_normal;
            end
        end
    end

    % Check if no collision for this line
    if closest_collision_distance(line_idx) == Inf
        no_collision_idx = [no_collision_idx, line_idx];
    
    end
    end
    end

%% Preallocate collision_coords with NaN
collision_coords = NaN(length(collision_array), 3);

% Collect the coordinates from the struct
for i = 1:length(collision_array)
    if ~isempty(collision_array(i).Collision_Coordinates)
        collision_coords(i, :) = collision_array(i).Collision_Coordinates;
    end
end

% Plot the collision coordinates
if ~all(isnan(collision_coords), 'all')
    valid_coords = collision_coords(~isnan(collision_coords(:, 1)), :);
    scatter3(valid_coords(:, 1), valid_coords(:, 2), valid_coords(:, 3), 'Parent', collision_group, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'y');
end

