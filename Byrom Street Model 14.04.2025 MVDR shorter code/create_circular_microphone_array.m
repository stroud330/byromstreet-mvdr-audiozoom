function [mic_coordinates,dimensions, mic_array_group, micsOn] = create_circular_microphone_array(dimensions)
% Constants
figure(1);
num_mics = 16;
arrayRadius = dimensions.arrayRadius; % 0.52 meters
offset = 0.03; % 3 cm in meters
%micRadius = 0.005; % Radius of the microphone markers in meters

% Initialize microphone coordinates
mic_coordinates = zeros(num_mics, 3);

% Calculate angular separation between mics
theta_step = 2 * pi / num_mics;

% Generate coordinates for each microphone
for i = 1:num_mics
    theta = (i-1) * theta_step;
    x = dimensions.arraycentreX + (arrayRadius - offset) * cos(theta);
    y = dimensions.arraycentreY + (arrayRadius - offset) * sin(theta);
    z = dimensions.arraycentreZ;
    mic_coordinates(i, :) = [x, y, z];
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
% Plot the outer boundary circle
theta = linspace(0, 2*pi, 100);
x = dimensions.arraycentreX + arrayRadius * cos(theta);
y = dimensions.arraycentreY + arrayRadius * sin(theta);
z = repmat(dimensions.arraycentreZ, size(x));
patch(x, y, z, [245/255, 245/255, 220/255], 'EdgeColor', 'k');

% Loop through the microphones and plot them
micRadius = 0.05;  % Modified radius
for micCounter = 1:size(mic_coordinates, 1)
    micX = mic_coordinates(micCounter, 1);
    micY = mic_coordinates(micCounter, 2);
    micZ = mic_coordinates(micCounter, 3);
   
      % Skip this loop if this microphone is 'NaN'
    if isnan(micX)
        continue;
    end

    % Define the coordinates for the circular patch
    theta = linspace(0, 2*pi, 50);
    x = micX + micRadius * cos(theta);
    y = micY + micRadius * sin(theta);
    z = repmat(micZ, size(x));
     % Draw the microphones
   if micsOn(micCounter)
      faceColor = 'g';
  else
      faceColor = 'r';
  end
    % Draw the circular patch
    patch(x, y, z, faceColor)
    hold off
    
    % Add the microphone number
    textObj = text(micX, micY, num2str(micCounter), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k', 'FontSize', 6);
    set(textObj, 'Position', [micX, micY, dimensions.arraycentreZ]); % Set Z-coordinate
 end
 
%% ZOOMED 3D SCENE
figure(2);

mic_array_group = hggroup;

  % Plot the outer boundary circle
theta = linspace(0, 2*pi, 100);
x = dimensions.arraycentreX + arrayRadius * cos(theta);
y = dimensions.arraycentreY + arrayRadius * sin(theta);
z = repmat(dimensions.arraycentreZ, size(x));
patch('Parent', mic_array_group, 'XData', x, 'YData', y, 'ZData', z, 'FaceColor', [245/255, 245/255, 220/255], 'EdgeColor', 'k');

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

% Plot the outer boundary circle
theta = linspace(0, 2*pi, 100);
x = dimensions.arraycentreX + arrayRadius * cos(theta);
y = dimensions.arraycentreY + arrayRadius * sin(theta);
z = repmat(dimensions.arraycentreZ, size(x));
patch(x, y, z, [245/255, 245/255, 220/255], 'EdgeColor', 'k');

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
title('Circular Microphone Array');
view(3); % Set 3D (3) or 2D (2) view
axis equal
%light('Position', [20, 20, 30]);
%light('Position', [40, 10, 30]);

hold off;
return;