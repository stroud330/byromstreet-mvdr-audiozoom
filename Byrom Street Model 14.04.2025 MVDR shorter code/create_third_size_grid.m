function dimensions = create_third_size_grid(dimensions)
% Initialize the figure
figure(1);
axis equal;

% Room and grid parameters
distX = dimensions.roomLength / 9;
distY = dimensions.roomWidth / 9;
centerX = dimensions.arraycentreX;
centerY = dimensions.arraycentreY;

dimensions.heightgrid = distX;
% Initialize Z-values for the bottom layer corners
zBottomMatrix = zeros(4, 4);

% Calculate Z-values for the bottom layer corners
for row = 1:4
    for col = 1:4
        xPos = centerX - 1.5 * distX + (col - 1) * distX;
        yPos = centerY - 1.5 * distY + (row - 1) * distY;
        zBottomMatrix(row, col) = calculate_z_positions(xPos, yPos, dimensions);
    end
end

% Draw lines for the top layer
for i = 1:3
    xLine = centerX - 1.5 * distX + i * distX;
    line([xLine, xLine], [centerY - 1.5 * distY, centerY + 1.5 * distY], [dimensions.heightgrid, dimensions.heightgrid], 'Color', 'b');
end
for i = 1:3
    yLine = centerY - 1.5 * distY + i * distY;
    line([centerX - 1.5 * distX, centerX + 1.5 * distX], [yLine, yLine], [dimensions.heightgrid, dimensions.heightgrid], 'Color', 'b');
end

% Draw the remaining 2 lines to complete the top grid "box"
line([centerX - 1.5 * distX, centerX + 1.5 * distX], [centerY - 1.5 * distY, centerY - 1.5 * distY], 'Color', 'b', 'ZData', [dimensions.heightgrid, dimensions.heightgrid]);
line([centerX - 1.5 * distX, centerX - 1.5 * distX], [centerY - 1.5 * distY, centerY + 1.5 * distY], 'Color', 'b', 'ZData', [dimensions.heightgrid, dimensions.heightgrid]);

% Draw vertical lines connecting top and bottom layers
for row = 1:4
    for col = 1:4
        xPos = centerX - 1.5 * distX + (col - 1) * distX;
        yPos = centerY - 1.5 * distY + (row - 1) * distY;
        zBottom = zBottomMatrix(row, col);
        line([xPos, xPos], [yPos, yPos], [zBottom, dimensions.heightgrid], 'Color', 'b');
    end
end

% Draw lines for the bottom layer
for i = 1:3
    xLine = centerX - 1.5 * distX + i * distX;
    zStart = calculate_z_positions(xLine, centerY - 1.5 * distY, dimensions);
    zEnd = calculate_z_positions(xLine, centerY + 1.5 * distY, dimensions);
    line([xLine, xLine], [centerY - 1.5 * distY, centerY + 1.5 * distY], [zStart, zEnd], 'Color', 'b');
end
for i = 1:3
    yLine = centerY - 1.5 * distY + i * distY;
    zStart = calculate_z_positions(centerX - 1.5 * distX, yLine, dimensions);
    zEnd = calculate_z_positions(centerX + 1.5 * distX, yLine, dimensions);
    line([centerX - 1.5 * distX, centerX + 1.5 * distX], [yLine, yLine], [zStart, zEnd], 'Color', 'b');
end

% Draw the remaining 2 lines to complete the bottom grid "box"
zStart = calculate_z_positions(centerX - 1.5 * distX, centerY - 1.5 * distY, dimensions);
zEnd = calculate_z_positions(centerX + 1.5 * distX, centerY - 1.5 * distY, dimensions);
line([centerX - 1.5 * distX, centerX + 1.5 * distX], [centerY - 1.5 * distY, centerY - 1.5 * distY], [zStart, zEnd], 'Color', 'b');

zStart = calculate_z_positions(centerX - 1.5 * distX, centerY - 1.5 * distY, dimensions);
zEnd = calculate_z_positions(centerX - 1.5 * distX, centerY + 1.5 * distY, dimensions);
line([centerX - 1.5 * distX, centerX - 1.5 * distX], [centerY - 1.5 * distY, centerY + 1.5 * distY], [zStart, zEnd], 'Color', 'b');


% Add grid numbers
num = 1;
for row = 1:3
    for col = 1:3
        xPos = centerX - 1.5 * distX + (col - 0.5) * distX;
        yPos = centerY - 1.5 * distY + (3 - row + 0.5) * distY;
        text(xPos, yPos, dimensions.heightgrid, num2str(num), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontWeight', 'bold', 'Color', 'b', 'FontSize', 20);
        num = num + 1;
    end
end

%% DRAW BLUE LINES (The lines are positioned based on the center of the mic array)
figure(2);
axis equal;

% Room and grid parameters
distX = dimensions.roomLength / 9;
distY = dimensions.roomWidth / 9;
centerX = dimensions.arraycentreX;
centerY = dimensions.arraycentreY;

% Initialize Z-values for the bottom layer corners
zBottomMatrix = zeros(4, 4);

% Calculate Z-values for the bottom layer corners
for row = 1:4
    for col = 1:4
        xPos = centerX - 1.5 * distX + (col - 1) * distX;
        yPos = centerY - 1.5 * distY + (row - 1) * distY;
        zBottomMatrix(row, col) = calculate_z_positions(xPos, yPos, dimensions);
    end
end

% Draw horizontal lines for the top layer
for i = 1:3
    xLine = centerX - 1.5 * distX + i * distX;
    line([xLine, xLine], [centerY - 1.5 * distY, centerY + 1.5 * distY], [dimensions.heightgrid, dimensions.heightgrid], 'Color', 'b');
end
for i = 1:3
    yLine = centerY - 1.5 * distY + i * distY;
    line([centerX - 1.5 * distX, centerX + 1.5 * distX], [yLine, yLine], [dimensions.heightgrid, dimensions.heightgrid], 'Color', 'b');
end

% Draw the remaining lines to complete the grid "box"
line([centerX - 1.5 * distX, centerX + 1.5 * distX], [centerY - 1.5 * distY, centerY - 1.5 * distY], 'Color', 'b', 'ZData', [dimensions.heightgrid, dimensions.heightgrid]);
line([centerX - 1.5 * distX, centerX - 1.5 * distX], [centerY - 1.5 * distY, centerY + 1.5 * distY], 'Color', 'b', 'ZData', [dimensions.heightgrid, dimensions.heightgrid]);

% Draw vertical lines connecting top and bottom layers
for row = 1:4
    for col = 1:4
        xPos = centerX - 1.5 * distX + (col - 1) * distX;
        yPos = centerY - 1.5 * distY + (row - 1) * distY;
        zBottom = zBottomMatrix(row, col);
        line([xPos, xPos], [yPos, yPos], [zBottom, dimensions.heightgrid], 'Color', 'b');
    end
end

% Add grid numbers
num = 1;
for row = 1:3
    for col = 1:3
        xPos = centerX - 1.5 * distX + (col - 0.5) * distX;
        yPos = centerY - 1.5 * distY + (3 - row + 0.5) * distY;
        text(xPos, yPos, dimensions.heightgrid, num2str(num), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontWeight', 'bold', 'Color', 'b', 'FontSize', 20);
        num = num + 1;
    end
end
% Return the calculated grid coordinates
gridX_positions = zeros(3, 3);
gridY_positions = zeros(3, 3);

num = 1;
for row = 1:3
    for col = 1:3
        % Calculate the position for the current grid
        xPos = centerX - 1.5 * distX + (col - 0.5) * distX;
        yPos = centerY - 1.5 * distY + (3 - row + 0.5) * distY;
        
        % Save the grid coordinates
        gridX_positions(row, col) = xPos;
        gridY_positions(row, col) = yPos;
        
        % Increment the grid number
        num = num + 1;
    end
end
figure(1);
% Save the grid coordinates in dimensions struct
dimensions.gridX = gridX_positions;
dimensions.gridY = gridY_positions;
dimensions.gridZ = dimensions.heightgrid;
dimensions.lengthgridX = distX;
dimensions.lengthgridY = distY;
dimensions.lengthwholegridX = distX*3;
dimensions.lengthwholegridY = distY*3;
% Calculate the coordinates of the grid corners based on the array center and grid dimensions
dimensions.gridcorners(1).x = dimensions.arraycentreX - dimensions.lengthwholegridX / 2;
dimensions.gridcorners(1).y = dimensions.arraycentreY + dimensions.lengthwholegridY / 2;
dimensions.gridcorners(2).x = dimensions.arraycentreX + dimensions.lengthwholegridX / 2;
dimensions.gridcorners(2).y = dimensions.arraycentreY + dimensions.lengthwholegridY / 2;
dimensions.gridcorners(3).x = dimensions.arraycentreX - dimensions.lengthwholegridX / 2;
dimensions.gridcorners(3).y = dimensions.arraycentreY - dimensions.lengthwholegridY / 2;
dimensions.gridcorners(4).x = dimensions.arraycentreX + dimensions.lengthwholegridX / 2;
dimensions.gridcorners(4).y = dimensions.arraycentreY - dimensions.lengthwholegridY / 2;

for row = 1:3
    for col = 1:3
        gridBoxIndex = (row - 1) * 3 + col;
        
        % Calculate X and Y coordinates (same as your 2D grid)
        xPos = dimensions.gridX(row, col);
        yPos = dimensions.gridY(row, col);
        
        % Compute Z-values at the top and bottom corners
        zTop = dimensions.heightgrid;
        zBottom = calculate_z_positions(xPos, yPos, dimensions);
        
        % Store in the structure
        dimensions.gridBoxes(gridBoxIndex).x = xPos;
        dimensions.gridBoxes(gridBoxIndex).y = yPos;
        dimensions.gridBoxes(gridBoxIndex).z_top = zTop;
        dimensions.gridBoxes(gridBoxIndex).z_bottom = zBottom;
    end
end

return;
end
