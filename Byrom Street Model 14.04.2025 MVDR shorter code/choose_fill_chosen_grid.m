function [beamform_grid_choice, Gridgroup] = choose_fill_chosen_grid(dimensions)
%% ISOLATE AND FILL A GRID
Gridgroup = [];
%% Prompt the user to enter a grid number to isolate
gridNumber = 0;
while true
    fprintf('\n\nBEAMFORMING:\n');
    fprintf('-----------------------------------------\n');
    fprintf('Which grid number in Figure 2 are you targeting?')
    fprintf('\n');
    fprintf('\n');
    fprintf('Choose a grid number (1 to 9)')
    fprintf('\n');
    fprintf('\n');
    fprintf('Enter the choice (or press ''q'' to quit): ');
    beamform_grid_choice = input('', 's');

    if strcmp(beamform_grid_choice, 'q')
        beamform_grid_choice = 'q'; % Set user_input to 'q' to indicate quitting
        break;
    end
    gridNumber = str2double(beamform_grid_choice);
    if ~isnan(gridNumber) && gridNumber >= 1 && gridNumber <= 9
        break;
    else
        disp('Invalid input. Please enter a number from 1 to 9, or ''q'' to quit.');
    end
end

if ~strcmp(beamform_grid_choice, 'q') % Only proceed if user_input is not 'q'
    % Map user's input to corresponding grid cell
    gridMapping = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    gridNumber = gridMapping(gridNumber);


%% Calculate the coordinates of the chosen grid cell
% Get the coordinates of the chosen grid cell
gridX_positions = dimensions.gridX;
gridY_positions = dimensions.gridY;

gridRow = floor((gridNumber - 1) / 3) + 1; % Adjust for 1-based indexing
gridCol = mod(gridNumber - 1, 3) + 1;       % Adjust for 1-based indexing

% Calculate the distance between grid lines on the new grid
distX = (gridX_positions(gridRow, 3) - gridX_positions(gridRow, 1)) / 2;
distY = (gridY_positions(3, gridCol) - gridY_positions(1, gridCol)) / 2;

% Calculate the size of the fill rectangle (now it's a box)
fillWidth = distX;
fillHeight = distY;

% Calculate the top-left corner coordinates of the chosen grid
topLeftX = gridX_positions(gridRow, gridCol) - fillWidth / 2;
topLeftY = gridY_positions(gridRow, gridCol) - fillHeight / 2;

% Calculate the coordinates for the bottom face of the box
xBottom = [topLeftX, topLeftX + fillWidth, topLeftX + fillWidth, topLeftX];
yBottom = [topLeftY, topLeftY, topLeftY + fillHeight, topLeftY + fillHeight];
zBottom = calculate_z_positions(xBottom, yBottom, dimensions);

% Calculate the coordinates for the top face of the box
zTop = dimensions.heightgrid * ones(size(zBottom));

figure(1)
% Fill the bottom face of the box
patch(xBottom, yBottom, zBottom + 0.01, [1, 1, 0], 'EdgeColor', 'b', 'FaceAlpha', 0.3);
% Fill the top face of the box
patch(xBottom, yBottom, zTop, [1, 1, 0], 'EdgeColor', 'b', 'FaceAlpha', 0.3);
% Left side
patch([xBottom(1), xBottom(4), xBottom(4), xBottom(1)], [yBottom(1), yBottom(4), yBottom(4), yBottom(1)], [zBottom(1), zBottom(4), zTop(4), zTop(1)], [1, 1, 0], 'EdgeColor', 'b', 'FaceAlpha', 0.3);
% Right side
patch([xBottom(2), xBottom(3), xBottom(3), xBottom(2)], [yBottom(2), yBottom(3), yBottom(3), yBottom(2)], [zBottom(2), zBottom(3), zTop(3), zTop(2)], [1, 1, 0], 'EdgeColor', 'b', 'FaceAlpha', 0.3);
% Front side
patch([xBottom(1), xBottom(2), xBottom(2), xBottom(1)], [yBottom(1), yBottom(2), yBottom(2), yBottom(1)], [zBottom(1), zBottom(2), zTop(2), zTop(1)], [1, 1, 0], 'EdgeColor', 'b', 'FaceAlpha', 0.3);
% Back side
patch([xBottom(3), xBottom(4), xBottom(4), xBottom(3)], [yBottom(3), yBottom(4), yBottom(4), yBottom(3)], [zBottom(3), zBottom(4), zTop(4), zTop(3)], [1, 1, 0], 'EdgeColor', 'b', 'FaceAlpha', 0.3);
title(['The user has chosen to steer the Beamformer towards Grid ' num2str(beamform_grid_choice)], 'FontSize', 12);

figure(2)
Gridgroup = hggroup;
% Fill the bottom face of the box
patch(xBottom, yBottom, zBottom + 0.01, [1, 1, 0], 'EdgeColor', 'b', 'FaceAlpha', 0.3, 'Parent', Gridgroup);
% Fill the top face of the box
patch(xBottom, yBottom, zTop, [1, 1, 0], 'EdgeColor', 'b', 'FaceAlpha', 0.3, 'Parent', Gridgroup);
% Left side
patch([xBottom(1), xBottom(4), xBottom(4), xBottom(1)], [yBottom(1), yBottom(4), yBottom(4), yBottom(1)], [zBottom(1), zBottom(4), zTop(4), zTop(1)], [1, 1, 0], 'EdgeColor', 'b', 'FaceAlpha', 0.3, 'Parent', Gridgroup);
% Right side
patch([xBottom(2), xBottom(3), xBottom(3), xBottom(2)], [yBottom(2), yBottom(3), yBottom(3), yBottom(2)], [zBottom(2), zBottom(3), zTop(3), zTop(2)], [1, 1, 0], 'EdgeColor', 'b', 'FaceAlpha', 0.3, 'Parent', Gridgroup);
% Front side
patch([xBottom(1), xBottom(2), xBottom(2), xBottom(1)], [yBottom(1), yBottom(2), yBottom(2), yBottom(1)], [zBottom(1), zBottom(2), zTop(2), zTop(1)], [1, 1, 0], 'EdgeColor', 'b', 'FaceAlpha', 0.3, 'Parent', Gridgroup);
% Back side
patch([xBottom(3), xBottom(4), xBottom(4), xBottom(3)], [yBottom(3), yBottom(4), yBottom(4), yBottom(3)], [zBottom(3), zBottom(4), zTop(4), zTop(3)], [1, 1, 0], 'EdgeColor', 'b', 'FaceAlpha', 0.3, 'Parent', Gridgroup);
title(['The user has chosen to steer the Beamformer towards Grid ' num2str(beamform_grid_choice)], 'FontSize', 12);
%set(hgroup, 'DisplayName', 'Targeted Grid');
end
figure(1)