function [mic_coordinates, dimensions, mic_array_group, micsOn] = create_octagonal_microphone_array(dimensions)
    % Constants
    figure(1);
    num_mics = 16;
    uniform_offset = 0.06; % 3 cm uniform offset inside the edge of the array
    arrayRadius = dimensions.arrayRadius; % Distance from the center to the midpoint of the octagon's edge
    micRadius = 0.05;  % Modified radius

    % Calculate vertices of the octagon
    vertices = zeros(8, 2);
    theta_vertices = linspace(0, 2 * pi, 9);
    theta_vertices(end) = []; % Remove the last point because it's the same as the first
    for i = 1:8
        vertices(i, 1) = dimensions.arraycentreX + arrayRadius * cos(theta_vertices(i));
        vertices(i, 2) = dimensions.arraycentreY + arrayRadius * sin(theta_vertices(i));
    end
    
    % Initialize microphone coordinates
    mic_coordinates = zeros(num_mics, 3);
    
    % Calculate vertices of the inner octagon for microphone placement
    inner_vertices = zeros(8, 2);
    theta_vertices = linspace(0, 2 * pi, 9);
    theta_vertices(end) = []; % Remove the last point because it's the same as the first
    for i = 1:8
        inner_vertices(i, 1) = dimensions.arraycentreX + (arrayRadius - uniform_offset) * cos(theta_vertices(i));
        inner_vertices(i, 2) = dimensions.arraycentreY + (arrayRadius - uniform_offset) * sin(theta_vertices(i));
    end

    % Calculate microphone positions on the inner octagon
    for i = 1:num_mics
        % Determine the closest vertex for each microphone
        vertex_index = mod(floor((i-1)/2), 8) + 1;
        % Calculate positions between vertices
        next_vertex_index = mod(vertex_index, 8) + 1;
        % Interpolate between two adjacent vertices for microphone positions
        fraction = mod(i-1, 2) * 0.5; % 0 for vertex, 0.5 for midpoint
        mic_coordinates(i, 1:2) = inner_vertices(vertex_index, :) * (1-fraction) + inner_vertices(next_vertex_index, :) * fraction;
        mic_coordinates(i, 3) = dimensions.arraycentreZ;
    end

micsOn = true(1, size(mic_coordinates,1)); % set all mics to true
%micsOn(1) = false; % turn off microphone 1
%micsOn(2) = false; % turn off microphone 2
%micsOn(3) = false; % turn off microphone 3
%micsOn(4) = false; % turn off microphone 4
%micsOn(5) = false; % turn off microphone 5
%micsOn(6) = false; % turn off microphone 6
%micsOn(7) = false; % turn off microphone 7
%micsOn(8) = false; % turn off microphone 8
%micsOn(9) = false; % turn off microphone 9
%micsOn(10) = false; % turn off microphone 10
%micsOn(11) = false; % turn off microphone 11
%micsOn(12) = false; % turn off microphone 12
%micsOn(13) = false; % turn off microphone 13
%micsOn(14) = false; % turn off microphone 14
%micsOn(15) = false; % turn off microphone 15
%micsOn(16) = false; % turn off microphone 16

mic_coordinates(micsOn, :) = [mic_coordinates(micsOn, :)];

% Loop through the microphones and plot them
for micCounter = 1:size(mic_coordinates, 1)
    micX = mic_coordinates(micCounter, 1);
    micY = mic_coordinates(micCounter, 2);
    micZ = mic_coordinates(micCounter, 3);
   
      % Skip this loop if this microphone is 'NaN'
    if isnan(micX)
        continue;
    end

% Octagon boundary plotting
num_vertices = size(vertices, 1);
z_values = repmat(dimensions.arraycentreZ, 1, num_vertices); % Create a Z vector of the same length as X and Y
patch(vertices(:,1), vertices(:,2), z_values, [245/255, 245/255, 220/255], 'EdgeColor', 'k');

        % Draw the microphones
        if ~isnan(micX) && ~isnan(micY) % check if the microphone is not turned off
            if micsOn(micCounter)
                faceColor = 'g';
            else
                faceColor = 'r';
            end

    % Define the coordinates for the circular microphone patches
    theta = linspace(0, 2*pi, 50);
    x = micX + micRadius * cos(theta);
    y = micY + micRadius * sin(theta);
    z = repmat(micZ, size(x));
    
    % Draw the circular microphones
    patch('XData', x, 'YData', y, 'ZData', z, 'FaceColor', faceColor);
    
    % Add the microphone number
    textObj = text(micX, micY, num2str(micCounter), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k', 'FontSize', 6);
    set(textObj, 'Position', [micX, micY, micZ]); % Set Z-coordinate
       end
end
%% ZOOMED 3D SCENE
figure(2);

mic_array_group = hggroup;

% Octagon boundary plotting
num_vertices = size(vertices, 1);
z_values = repmat(dimensions.arraycentreZ, 1, num_vertices); % Create a Z vector of the same length as X and Y
patch(vertices(:,1), vertices(:,2), z_values, [245/255, 245/255, 220/255], 'EdgeColor', 'k', 'Parent', mic_array_group);

% Loop through the microphones and plot them
micRadius = 0.05;  % Modified radius
for micCounter = 1:size(mic_coordinates, 1)
    micX = mic_coordinates(micCounter, 1);
    micY = mic_coordinates(micCounter, 2);
    micZ = mic_coordinates(micCounter, 3);

        % Draw the microphones
        if ~isnan(micX) && ~isnan(micY) % check if the microphone is not turned off
            if micsOn(micCounter)
                faceColor = 'g';
            else
                faceColor = 'r';
            end
       
    % Define the coordinates for the circular microphone patches
    theta = linspace(0, 2*pi, 50);
    x = micX + micRadius * cos(theta);
    y = micY + micRadius * sin(theta);
    z = repmat(micZ, size(x));

    %faceColor = [245/255, 245/255, 220/255];
    % Draw the circular microphones
    patch('Parent', mic_array_group, 'XData', x, 'YData', y, 'ZData', z, 'FaceColor', faceColor);
    
    % Add the microphone number
    textObj = text(micX, micY, num2str(micCounter), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k', 'FontSize', 6, 'Parent', mic_array_group);
    set(textObj, 'Position', [micX, micY, dimensions.arraycentreZ]); % Set Z-coordinate
        end
end

%% Create figure(3) for displaying just the microphone array and microphones
figure(3);
clf; % Clear the figure if needed
hold on;

% Octagon boundary plotting
% Corrected octagon boundary plotting
num_vertices = size(vertices, 1);
z_values = repmat(dimensions.arraycentreZ, 1, num_vertices); % Create a Z vector of the same length as X and Y
patch(vertices(:,1), vertices(:,2), z_values, [245/255, 245/255, 220/255], 'EdgeColor', 'k');


% Loop through the microphones and plot them
for micCounter = 1:size(mic_coordinates, 1)
    % Get the x, y, and z position of the current microphone
    micX = mic_coordinates(micCounter, 1);
    micY = mic_coordinates(micCounter, 2);
    micZ = mic_coordinates(micCounter, 3);
    
  % Draw the microphones
    if ~isnan(micX) && ~isnan(micY)
        if micsOn(micCounter)
            faceColor = 'g';
        else
            faceColor = 'r';
        end

        % Define the coordinates for the circular patch
        theta = linspace(0, 2*pi, 50);
        x = micX + micRadius * cos(theta);
        y = micY + micRadius * sin(theta);
        z = repmat(micZ, size(x));

        % Draw the circular patch
        patch(x, y, z, faceColor);
        
        % Add the microphone number
        textObj = text(micX, micY, num2str(micCounter), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k', 'FontSize', 6);
        set(textObj, 'Position', [micX, micY, dimensions.arraycentreZ]); 
    end
end

% Labeling, lighting, view adjustments, etc.
xlabel('X (metres)');
ylabel('Y (metres)');
zlabel('Z (metres)');
title('Octagonal Microphone Array');
view(3); % Set 3D (3) or 2D (2) view
axis equal
%light('Position', [20, 20, 30]);
%light('Position', [40, 10, 30]);

hold off;
return;
    
end
