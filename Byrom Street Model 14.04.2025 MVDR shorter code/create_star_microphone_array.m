function [mic_coordinates, dimensions, mic_array_group, micsOn] = create_star_microphone_array(dimensions)
    % Constants   
    figure(1); % Open figure 1
    hold on; % Hold on for multiple plots
    num_mics = 16;  % Total number of microphones
    uniform_offset = 0.06;  % Uniform offset towards the center from the outer star
    arrayRadius = dimensions.arrayRadius; % Distance from the center to the midpoint of the star's outer arm
    micRadius = 0.05; % Radius of the microphone markers in meters
    numPoints = 30; % Number of points to approximate the circle
   
    % Calculate vertices of the outer eight-pointed star
    vertices = zeros(16, 2);
    for i = 1:16
        if mod(i, 2) == 1
            radius = arrayRadius; % Outer vertices
        else
            radius = arrayRadius * cos(pi/4); % Inner vertices
        end
        angle = (i-1) * (pi/8);
        vertices(i, 1) = dimensions.arraycentreX + radius * cos(angle);
        vertices(i, 2) = dimensions.arraycentreY + radius * sin(angle);
    end
  
    % Adjusted radius for the inner eight-pointed star
    adjustedRadius_outer = arrayRadius - uniform_offset; % Outer points
    adjustedRadius_inner = (arrayRadius * cos(pi/4)) - uniform_offset; % Inner points
    
    % Calculate microphone positions on the inner eight-pointed star
    mic_coordinates = zeros(num_mics, 3);
    
    for i = 1:num_mics
        if mod(i, 2) == 1
            radius = adjustedRadius_outer;
        else
            radius = adjustedRadius_inner;
        end
        angle = (i-1) * (pi/8);
        mic_coordinates(i, 1) = dimensions.arraycentreX + radius * cos(angle);
        mic_coordinates(i, 2) = dimensions.arraycentreY + radius * sin(angle);
        mic_coordinates(i, 3) = dimensions.arraycentreZ;  % Ensure they are at the same height as the array
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


%    % Loop through the microphones and plot them
for micCounter = 1:size(mic_coordinates, 1)
    micX = mic_coordinates(micCounter, 1);
    micY = mic_coordinates(micCounter, 2);
    micZ = mic_coordinates(micCounter, 3); % Assuming this Z value places them at the correct height

      % Skip this loop if this microphone is 'NaN'
    if isnan(micX)
        continue;
    end
 
    % Check if the microphone is not turned off
    if micsOn(micCounter)
        faceColor = 'g'; % Green for active microphones
    else
        faceColor = 'r'; % Red for inactive microphones
    end


     % Plot the outer star
    patch('XData', vertices(:,1), 'YData', vertices(:,2), 'ZData', zeros(size(vertices, 1), 1) + dimensions.arraycentreZ, 'FaceColor', [245/255, 245/255, 220/255], 'EdgeColor', 'black');
    
    % Calculate circle points
    theta = linspace(0, 2*pi, numPoints);
    xCircle = micRadius * cos(theta) + micX;
    yCircle = micRadius * sin(theta) + micY;
    zCircle = repmat(micZ, size(xCircle)); % Keep all points at the same Z height
    
    % Draw the circle using fill for a solid color
    fill3(xCircle, yCircle, zCircle, faceColor, 'EdgeColor', 'black');
    
    % Optionally, add microphone numbers
    text(micX, micY, micZ, num2str(micCounter), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 6);
end
    
% %% ZOOMED 3D SCENE
figure(2);

mic_array_group = hggroup;

% Plot the outer star and add it to mic_array_group
patch('XData', vertices(:,1), 'YData', vertices(:,2), 'ZData', zeros(size(vertices, 1), 1) + dimensions.arraycentreZ, 'FaceColor', [245/255, 245/255, 220/255], 'EdgeColor', 'black', 'Parent', mic_array_group);

   % Loop through the microphones and plot them
for micCounter = 1:size(mic_coordinates, 1)
    micX = mic_coordinates(micCounter, 1);
    micY = mic_coordinates(micCounter, 2);
    micZ = mic_coordinates(micCounter, 3); % Assuming this Z value places them at the correct height
    
    % Check if the microphone is not turned off
    if micsOn(micCounter)
        faceColor = 'g'; % Green for active microphones
    else
        faceColor = 'r'; % Red for inactive microphones
    end
    
    % Calculate circle points
    theta = linspace(0, 2*pi, numPoints);
    xCircle = micRadius * cos(theta) + micX;
    yCircle = micRadius * sin(theta) + micY;
    zCircle = repmat(micZ, size(xCircle)); % Keep all points at the same Z height
    
% Draw the circle with fill3 and add it to mic_array_group
fill3(xCircle, yCircle, zCircle, faceColor, 'EdgeColor', 'black', 'Parent', mic_array_group);
    
    % Optionally, add microphone numbers
    text(micX, micY, micZ, num2str(micCounter), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 6);
end
%% Create figure(3) for displaying just the microphone array and microphones
figure(3);
clf; % Clear the figure if needed
hold on;

  % Plot the outer star
    patch('XData', vertices(:,1), 'YData', vertices(:,2), 'ZData', zeros(size(vertices, 1), 1) + dimensions.arraycentreZ, 'FaceColor', [245/255, 245/255, 220/255], 'EdgeColor', 'black');

   % Loop through the microphones and plot them
for micCounter = 1:size(mic_coordinates, 1)
    micX = mic_coordinates(micCounter, 1);
    micY = mic_coordinates(micCounter, 2);
    micZ = mic_coordinates(micCounter, 3); % Assuming this Z value places them at the correct height
    
    % Check if the microphone is not turned off
    if micsOn(micCounter)
        faceColor = 'g'; % Green for active microphones
    else
        faceColor = 'r'; % Red for inactive microphones
    end
    
    % Calculate circle points
    theta = linspace(0, 2*pi, numPoints);
    xCircle = micRadius * cos(theta) + micX;
    yCircle = micRadius * sin(theta) + micY;
    zCircle = repmat(micZ, size(xCircle)); % Keep all points at the same Z height
    
    % Draw the circle using fill for a solid color
    fill3(xCircle, yCircle, zCircle, faceColor, 'EdgeColor', 'black');
    
    % Optionally, add microphone numbers
    text(micX, micY, micZ, num2str(micCounter), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 6);
end

% Labeling, lighting, view adjustments, etc.
xlabel('X (metres)');
ylabel('Y (metres)');
zlabel('Z (metres)');
title('Star Microphone Array');
view(3); % Set 3D (3) or 2D (2) view
axis equal
%light('Position', [20, 20, 30]);
%light('Position', [40, 10, 30]);

hold off;
return;
    
end
