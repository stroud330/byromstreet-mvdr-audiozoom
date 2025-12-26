function [mic_coordinates,dimensions, mic_array_group, micsOn] = create_cross_microphone_array(dimensions)
figure(1);
% Dimensions of the microphone array
dimensions.arrayWidth = 0.16; % in meters
dimensions.arrayLength = 1.36; % in meters

% Draw the vertical arm of the cross
x1 = [dimensions.arraycentreX  - dimensions.arrayWidth / 2, dimensions.arraycentreX  + dimensions.arrayWidth / 2, dimensions.arraycentreX  + dimensions.arrayWidth / 2, dimensions.arraycentreX  - dimensions.arrayWidth / 2];
y1 = [dimensions.arraycentreY - dimensions.arrayLength / 2, dimensions.arraycentreY - dimensions.arrayLength / 2, dimensions.arraycentreY + dimensions.arrayLength / 2, dimensions.arraycentreY + dimensions.arrayLength / 2];
z1 = [dimensions.arraycentreZ, dimensions.arraycentreZ, dimensions.arraycentreZ, dimensions.arraycentreZ];
patch(x1, y1, z1, [245/255, 245/255, 220/255], 'EdgeColor', 'k');
% Draw the horizontal arm of the cross
x2 = [dimensions.arraycentreX - dimensions.arrayLength / 2, dimensions.arraycentreX + dimensions.arrayLength / 2, dimensions.arraycentreX + dimensions.arrayLength / 2, dimensions.arraycentreX - dimensions.arrayLength / 2];
y2 = [dimensions.arraycentreY - dimensions.arrayWidth / 2, dimensions.arraycentreY - dimensions.arrayWidth / 2, dimensions.arraycentreY + dimensions.arrayWidth / 2, dimensions.arraycentreY + dimensions.arrayWidth / 2];
z2 = [dimensions.arraycentreZ, dimensions.arraycentreZ, dimensions.arraycentreZ, dimensions.arraycentreZ];
patch(x2, y2, z2, [245/255, 245/255, 220/255], 'EdgeColor', 'k');


%% Create the Circles representing the microphones

% Initialize variables
micSpacing = 0.16;  % Spacing between microphones
edgeOffset = 0.03;  % Offset from the edge
newMicPositions = zeros(16, 2);  % Initialize the array for new mic positions

% Compute the start and end points for the vertical and horizontal arms
startPointV = dimensions.arraycentreY - dimensions.arrayLength / 2 + edgeOffset*2;
endPointV = dimensions.arraycentreY + dimensions.arrayLength / 2 - edgeOffset*2;

startPointH = dimensions.arraycentreX - dimensions.arrayLength / 2 + edgeOffset*2;
endPointH = dimensions.arraycentreX + dimensions.arrayLength / 2 - edgeOffset*2;

% Vertical arm positions
for i = 1:4
    newMicPositions(i, 1) = dimensions.arraycentreX;
    newMicPositions(i, 2) = endPointV - (i - 1) * micSpacing;
end

for i = 5:8
    newMicPositions(i, 1) = dimensions.arraycentreX;
    newMicPositions(i, 2) = startPointV + (8 - i) * micSpacing;
end

% Horizontal arm positions
for i = 9:12
    newMicPositions(i, 1) = startPointH + (i - 9) * micSpacing;
    newMicPositions(i, 2) = dimensions.arraycentreY;
end

for i = 13:16
    newMicPositions(i, 1) = endPointH - (16 - i) * micSpacing;
    newMicPositions(i, 2) = dimensions.arraycentreY;
end


% Combine the microphone positions into an array
micZ = ones(16, 1) * dimensions.arraycentreZ; % Set all mic z-values to the height of the microphone array (zMicArray)
mic_coordinates = [newMicPositions, micZ];
% Define the radius of the microphones
micRadius = 0.05;  % Modified radius
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

mic_coordinates(micsOn, :) = [newMicPositions(micsOn, :), micZ(micsOn)];
% Loop through the microphones and plot them
for micCounter = 1:size(mic_coordinates,1)
    
    % Get the x, y and z position of the current microphone
    micX = mic_coordinates(micCounter, 1);
    micY = mic_coordinates(micCounter, 2);
    micZ = mic_coordinates(micCounter, 3); % assuming you have also defined the z-coordinate of each microphone
    
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
%%  ZOOMED 3D SCENE
figure(2);

mic_array_group = hggroup;

 % Draw the vertical arm of the cross
x1 = [dimensions.arraycentreX  - dimensions.arrayWidth / 2, dimensions.arraycentreX  + dimensions.arrayWidth / 2, dimensions.arraycentreX  + dimensions.arrayWidth / 2, dimensions.arraycentreX  - dimensions.arrayWidth / 2];
y1 = [dimensions.arraycentreY - dimensions.arrayLength / 2, dimensions.arraycentreY - dimensions.arrayLength / 2, dimensions.arraycentreY + dimensions.arrayLength / 2, dimensions.arraycentreY + dimensions.arrayLength / 2];
z1 = [dimensions.arraycentreZ, dimensions.arraycentreZ, dimensions.arraycentreZ, dimensions.arraycentreZ];
patch('Parent', mic_array_group, 'XData', x1, 'YData', y1, 'ZData', z1, 'FaceColor', [245/255, 245/255, 220/255], 'EdgeColor', 'k');
% Draw the horizontal arm of the cross
x2 = [dimensions.arraycentreX - dimensions.arrayLength / 2, dimensions.arraycentreX + dimensions.arrayLength / 2, dimensions.arraycentreX + dimensions.arrayLength / 2, dimensions.arraycentreX - dimensions.arrayLength / 2];
y2 = [dimensions.arraycentreY - dimensions.arrayWidth / 2, dimensions.arraycentreY - dimensions.arrayWidth / 2, dimensions.arraycentreY + dimensions.arrayWidth / 2, dimensions.arraycentreY + dimensions.arrayWidth / 2];
z2 = [dimensions.arraycentreZ, dimensions.arraycentreZ, dimensions.arraycentreZ, dimensions.arraycentreZ];
patch('Parent', mic_array_group, 'XData', x2, 'YData', y2, 'ZData', z2, 'FaceColor', [245/255, 245/255, 220/255], 'EdgeColor', 'k');

    % Loop through the microphones and plot them
    for micCounter = 1:size(mic_coordinates, 1)
        % Get the x, y, and z position of the current microphone
        micX = mic_coordinates(micCounter, 1);
        micY = mic_coordinates(micCounter, 2);
        micZ = mic_coordinates(micCounter, 3); % assuming you have also defined the z-coordinate of each microphone
        
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

   % Draw the vertical arm of the cross
x1 = [dimensions.arraycentreX  - dimensions.arrayWidth / 2, dimensions.arraycentreX  + dimensions.arrayWidth / 2, dimensions.arraycentreX  + dimensions.arrayWidth / 2, dimensions.arraycentreX  - dimensions.arrayWidth / 2];
y1 = [dimensions.arraycentreY - dimensions.arrayLength / 2, dimensions.arraycentreY - dimensions.arrayLength / 2, dimensions.arraycentreY + dimensions.arrayLength / 2, dimensions.arraycentreY + dimensions.arrayLength / 2];
z1 = [dimensions.arraycentreZ, dimensions.arraycentreZ, dimensions.arraycentreZ, dimensions.arraycentreZ];
patch(x1, y1, z1, [245/255, 245/255, 220/255], 'EdgeColor', 'k');
% Draw the horizontal arm of the cross
x2 = [dimensions.arraycentreX - dimensions.arrayLength / 2, dimensions.arraycentreX + dimensions.arrayLength / 2, dimensions.arraycentreX + dimensions.arrayLength / 2, dimensions.arraycentreX - dimensions.arrayLength / 2];
y2 = [dimensions.arraycentreY - dimensions.arrayWidth / 2, dimensions.arraycentreY - dimensions.arrayWidth / 2, dimensions.arraycentreY + dimensions.arrayWidth / 2, dimensions.arraycentreY + dimensions.arrayWidth / 2];
z2 = [dimensions.arraycentreZ, dimensions.arraycentreZ, dimensions.arraycentreZ, dimensions.arraycentreZ];
patch(x2, y2, z2, [245/255, 245/255, 220/255], 'EdgeColor', 'k');


    % Loop through the microphones and plot them
    for micCounter = 1:size(mic_coordinates, 1)
        % Get the x, y, and z position of the current microphone
        micX = mic_coordinates(micCounter, 1);
        micY = mic_coordinates(micCounter, 2);
        micZ = mic_coordinates(micCounter, 3); % assuming you have also defined the z-coordinate of each microphone
        
        % Draw the microphones
        if ~isnan(micX) && ~isnan(micY) % check if the microphone is not turned off
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
    set(textObj, 'Position', [micX, micY, dimensions.arraycentreZ]); % Set Z-coordinate
        end
    end
  
    % Labeling, lighting, view adjustments, etc.
xlabel('X (metres)');
ylabel('Y (metres)');
zlabel('Z (metres)');
title('Cross Microphone Array');
view(3); % Set 3D (3) or 2D (2) view
axis equal
%light('Position', [20, 20, 30]);
%light('Position', [40, 10, 30]);

    hold off;
    return;
end
 


