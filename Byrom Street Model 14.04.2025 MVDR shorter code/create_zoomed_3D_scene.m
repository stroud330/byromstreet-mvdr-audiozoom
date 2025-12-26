function [building_group, street_group] = create_zoomed_3D_scene(dimensions)
% Create a figure for the scene
figure(2);
hold on;
grid on;

% Define the x and y coordinates based on the corners
x = linspace(dimensions.corners(1).x, dimensions.corners(4).x, 100);
y = linspace(dimensions.corners(3).y, dimensions.corners(1).y, 100);
% Create a grid of x and y values
[X, Y] = meshgrid(x, y);
% Calculate slopes based on zMin and zMax for x and y axes
m_x = (dimensions.zMax_x - dimensions.zMin_x) / dimensions.roomLength;
m_y = (dimensions.zMax_y - dimensions.zMin_y) / dimensions.roomWidth;
% Calculate the z-values for the sloping surface
Z = m_x * X + m_y * Y + dimensions.zMin_x;  % Assuming zMin_x is the base z-coordinate

% Plot the surface without edge lines
surfHandle = surf(X, Y, Z, 'EdgeColor', 'none', 'FaceColor', [0.5, 0.5, 0.5]);

building_group = hggroup;
street_group = hggroup;

%% Sabine Coefficients for different materials
sabine_coefficients = struct('Concrete', 0.02, 'Wood', 0.11, 'Glass', 0.08, 'Pavement', 0.02, 'Carpet', 0.25, 'Tiles', 0.02, 'Air', 0, 'Brick', 0.03, 'Grass', 0.45, 'Hedge', 0.50, 'Trees', 0.55, 'Metal', 0.03);

%% Add 2D surfaces (Ground, floors etc)
% Add a rear garden with material 'Grass'
surfaces(1) = struct('name', 'Rear Garden', 'material', 'Grass','sabine_coefficient', sabine_coefficients.Grass);
surfaces(1).position.x = [0, 30, 30, 0];
surfaces(1).position.y = [55, 55, 80, 80];
surfaces(1).position.z = calculate_z_positions(surfaces(1).position.x, surfaces(1).position.y, dimensions);
% Draw rear garden
patch('Parent', street_group,'XData', surfaces(1).position.x, 'YData', surfaces(1).position.y, 'ZData', surfaces(1).position.z +0.001, 'FaceColor', [0.4660, 0.6740, 0.1880]);

% Add neighborhood gardens with material'Grass'
surfaces(2).name = 'Neighborhood Gardens';
surfaces(2).position.x = [35.5, 50, 50, 34.48];
surfaces(2).position.y = [4.6, 8.5, 48, 48];
surfaces(2).position.z = calculate_z_positions(surfaces(2).position.x, surfaces(2).position.y, dimensions);
surfaces(2).sabine_coefficient = sabine_coefficients.Grass;
surfaces(2).material = 'Grass';
% Draw gardens
patch('Parent', street_group,'XData', surfaces(2).position.x, 'YData', surfaces(2).position.y, 'ZData', surfaces(2).position.z +0.001, 'FaceColor', [0.4660, 0.6740, 0.1880]);

% Add neighborhood gardens with material'Grass'
surfaces(3).name = 'West Gardens';
surfaces(3).position.x = [0, 4, 9, 0];
surfaces(3).position.y = [0, 0, 55, 55];
surfaces(3).position.z = calculate_z_positions(surfaces(3).position.x, surfaces(3).position.y, dimensions);
surfaces(3).sabine_coefficient = sabine_coefficients.Grass;
surfaces(3).material = 'Grass';
% Draw gardens
patch('Parent', street_group,'XData', surfaces(3).position.x, 'YData', surfaces(3).position.y, 'ZData', surfaces(3).position.z +0.001, 'FaceColor', [0.4660, 0.6740, 0.1880]);

% Add base road material 'Concrete'
surfaces(4).name = 'Byrom Way Road';
surfaces(4).position.x = [0,50,50,0];
surfaces(4).position.y = [0,0,80,80];
surfaces(4).position.z = calculate_z_positions(surfaces(4).position.x, surfaces(4).position.y, dimensions);
surfaces(4).sabine_coefficient = sabine_coefficients.Concrete;
surfaces(4).material = 'Concrete';
% Draw concrete
patch('Parent', street_group,'XData', surfaces(4).position.x, 'YData', surfaces(4).position.y, 'ZData', surfaces(4).position.z-0.1, 'FaceColor', [0, 0, 0]);

% Add the carpark with material 'Concrete'
surfaces(5).name = 'Carpark';
surfaces(5).position.x = [4, 30.6, 29, 8.8];
surfaces(5).position.y = [0, 10, 50, 50];
surfaces(5).position.z = calculate_z_positions(surfaces(5).position.x, surfaces(5).position.y, dimensions)+0.001;
surfaces(5).sabine_coefficient = sabine_coefficients.Pavement;
surfaces(5).material = 'Pavement';
% Draw carpark
patch('Parent', street_group,'XData', surfaces(5).position.x, 'YData', surfaces(5).position.y, 'ZData', surfaces(5).position.z, 'FaceColor', [0.4 0.4 0.4]);

% Add south east corner garden with material 'grass'
surfaces(6).name = 'SE Corner Garden';
surfaces(6).position.x = [20, 50, 50];
surfaces(6).position.y = [0, 8.5, 0];
surfaces(6).position.z = calculate_z_positions(surfaces(6).position.x, surfaces(6).position.y, dimensions)+0.001;
surfaces(6).sabine_coefficient = sabine_coefficients.Grass;
surfaces(6).material = 'Grass';
% Draw garden
patch('Parent', street_group,'XData', surfaces(6).position.x, 'YData', surfaces(6).position.y, 'ZData', surfaces(6).position.z+0.001, 'FaceColor', [0, 0.5, 0]);

% Add North east gardens with material 'grass'
surfaces(13).name = 'NE Gardens';
surfaces(13).position.x = [42.5, 50, 50, 42.5];
surfaces(13).position.y = [48, 48, 80, 80];
surfaces(13).position.z = calculate_z_positions(surfaces(13).position.x, surfaces(13).position.y, dimensions)+0.001;
surfaces(13).sabine_coefficient = sabine_coefficients.Grass;
surfaces(13).material = 'Grass';
% Draw garden
patch('Parent', street_group,'XData', surfaces(13).position.x, 'YData', surfaces(13).position.y, 'ZData', surfaces(13).position.z+0.001, 'FaceColor', [0, 0.5, 0]);

%% Create 3D fences
% Define neighborhood gardens fence 1 dimensions
E_fence1_x = 35.5;
E_fence1_y = 4.6;
E_fence1_width = 0.2; 
E_fence1_depth = 43.4;
E_fence1_height = 3;
E_fence1_endx = 34.48;
% Define the 2D coordinates of the fence vertices
fence1_vertices_x = [E_fence1_x, E_fence1_x + E_fence1_width, E_fence1_endx, E_fence1_endx - E_fence1_width];
fence1_vertices_y = [E_fence1_y, E_fence1_y, E_fence1_y + E_fence1_depth, E_fence1_y + E_fence1_depth];
% Calculate the z-positions for each vertex using the calculate_z_positions function
fence1_vertices_z = calculate_z_positions(fence1_vertices_x, fence1_vertices_y, dimensions);
% Combine x, y, and z to form the 3D vertices
E_fence1_vertices_bottom = [fence1_vertices_x', fence1_vertices_y', fence1_vertices_z'];
E_fence1_vertices_top = [fence1_vertices_x', fence1_vertices_y', fence1_vertices_z' + E_fence1_height];
% Combine bottom and top vertices
E_fence1_vertices = [E_fence1_vertices_bottom; E_fence1_vertices_top];
% Define window5 faces
E_fence1_faces = [1, 2, 6, 5;
                   2, 3, 7, 6;
                   3, 4, 8, 7;
                   4, 1, 5, 8;
                   1, 2, 3, 4;
                   5, 6, 7, 8];

% Define neighborhood gardens fence 2 dimensions
E_fence2_x = 20;
E_fence2_y = 0;
E_fence2_width = 30; 
E_fence2_depth = 0.2;
E_fence2_height = 3;
E_fence2_endy = 8.5;
slope_y2 = (8.7 - 8.5) / (50 - 20);

% Define the 2D coordinates of the fence vertices
fence2_vertices_x = [20, 20.2, 50, 50];
fence2_vertices_y = [0.2, 0, 8.5, 8.7];
% Calculate the z-positions for each vertex using the calculate_z_positions function
fence2_vertices_z = calculate_z_positions(fence2_vertices_x, fence2_vertices_y, dimensions);
% Combine x, y, and z to form the 3D vertices
E_fence2_vertices_bottom = [fence2_vertices_x', fence2_vertices_y', fence2_vertices_z'];
E_fence2_vertices_top = [fence2_vertices_x', fence2_vertices_y', fence2_vertices_z' + E_fence2_height];
% Combine bottom and top vertices
E_fence2_vertices = [E_fence2_vertices_bottom; E_fence2_vertices_top];
% Define fence 2 faces
E_fence2_faces = [1, 2, 6, 5;
                   2, 3, 7, 6;
                   3, 4, 8, 7;
                   4, 1, 5, 8;
                   1, 2, 3, 4;
                   5, 6, 7, 8];

% Define neighborhood gardens fence 3 dimensions
E_fence3_x = 34.28;
E_fence3_y = 48;
E_fence3_width = 15.72; 
E_fence3_depth = 0.2;
E_fence3_height = 3;
% Define the 2D coordinates of the fence vertices
fence3_vertices_x = [E_fence3_x, E_fence3_x + E_fence3_width, E_fence3_x + E_fence3_width, E_fence3_x];
fence3_vertices_y = [E_fence3_y, E_fence3_y, E_fence3_y + E_fence3_depth, E_fence3_y + E_fence3_depth];
% Calculate the z-positions for each vertex using the calculate_z_positions function
fence3_vertices_z = calculate_z_positions(fence3_vertices_x, fence3_vertices_y, dimensions);
% Combine x, y, and z to form the 3D vertices
E_fence3_vertices_bottom = [fence3_vertices_x', fence3_vertices_y', fence3_vertices_z'];
E_fence3_vertices_top = [fence3_vertices_x', fence3_vertices_y', fence3_vertices_z' + E_fence3_height];
% Combine bottom and top vertices
E_fence3_vertices = [E_fence3_vertices_bottom; E_fence3_vertices_top];
% Define fence 3 faces
E_fence3_faces = E_fence1_faces;

% Define fence 4 dimensions
E_fence4_x = 4;
E_fence4_y = 0;
E_fence4_width = 0.2; 
E_fence4_depth = 55;
E_fence4_height = 0.5;
E_fence4_endx = 9;
slope_x4 = (55 - E_fence4_y) / (E_fence4_endx - E_fence4_x);

% Define the 2D coordinates of the fence vertices
fence4_vertices_x = [E_fence4_x, E_fence4_x + E_fence4_width, E_fence4_endx + E_fence4_width, E_fence4_endx];
fence4_vertices_y = [E_fence4_y, E_fence4_y, E_fence4_y + E_fence4_depth, E_fence4_y + E_fence4_depth];
% Calculate the z-positions for each vertex using the calculate_z_positions function
fence4_vertices_z = calculate_z_positions(fence4_vertices_x, fence4_vertices_y, dimensions);
% Combine x, y, and z to form the 3D vertices
E_fence4_vertices_bottom = [fence4_vertices_x', fence4_vertices_y', fence4_vertices_z'];
E_fence4_vertices_top = [fence4_vertices_x', fence4_vertices_y', fence4_vertices_z' + E_fence4_height];
% Combine bottom and top vertices
E_fence4_vertices = [E_fence4_vertices_bottom; E_fence4_vertices_top];
% Define fence 4 faces
E_fence4_faces = E_fence1_faces;

% Define Hedge dimensions
E_fence5_x = 2;
E_fence5_y = 0;
E_fence5_width = 2; 
E_fence5_depth = 55;
E_fence5_height = 2.90;
E_fence5_endx = 7;
slope_x5 = (55 - E_fence5_y) / (E_fence5_endx - E_fence5_x);
% Define the 2D coordinates of the fence vertices
fence5_vertices_x = [E_fence5_x, E_fence5_x + E_fence5_width, E_fence5_endx + E_fence5_width, E_fence5_endx];
fence5_vertices_y = [E_fence5_y, E_fence5_y, E_fence5_y + E_fence5_depth, E_fence5_y + E_fence5_depth];
% Calculate the z-positions for each vertex using the calculate_z_positions function
fence5_vertices_z = calculate_z_positions(fence5_vertices_x, fence5_vertices_y, dimensions);
% Combine x, y, and z to form the 3D vertices
E_fence5_vertices_bottom = [fence5_vertices_x', fence5_vertices_y', fence5_vertices_z'];
E_fence5_vertices_top = [fence5_vertices_x', fence5_vertices_y', fence5_vertices_z' + E_fence5_height];
% Combine bottom and top vertices
E_fence5_vertices = [E_fence5_vertices_bottom; E_fence5_vertices_top];
% Define Hedge faces
E_fence5_faces = E_fence1_faces;

% Define neighborhood gardens fence 6 dimensions
E_fence6_x = 42.5;
E_fence6_y = 48;
E_fence6_width = 0.2; 
E_fence6_depth = 32;
E_fence6_height = 3;
% Define the 2D coordinates of the fence vertices
fence6_vertices_x = [E_fence6_x, E_fence6_x + E_fence6_width, E_fence6_x + E_fence6_width, E_fence6_x];
fence6_vertices_y = [E_fence6_y, E_fence6_y, E_fence6_y + E_fence6_depth, E_fence6_y + E_fence6_depth];
% Calculate the z-positions for each vertex using the calculate_z_positions function
fence6_vertices_z = calculate_z_positions(fence6_vertices_x, fence6_vertices_y, dimensions);
% Combine x, y, and z to form the 3D vertices
E_fence6_vertices_bottom = [fence6_vertices_x', fence6_vertices_y', fence6_vertices_z'];
E_fence6_vertices_top = [fence6_vertices_x', fence6_vertices_y', fence6_vertices_z' + E_fence6_height];
% Combine bottom and top vertices
E_fence6_vertices = [E_fence6_vertices_bottom; E_fence6_vertices_top];
% Define window5 faces
E_fence6_faces = E_fence1_faces;

% Define Hedge 2 dimensions
E_fence7_x = 42.7;
E_fence7_y = 48.2;
E_fence7_width = 2; 
E_fence7_depth = 31.8;
E_fence7_height = 5;
E_fence7_endx = 42.7;
% Define the 2D coordinates of the fence vertices
fence7_vertices_x = [E_fence7_x, E_fence7_x + E_fence7_width, E_fence7_endx + E_fence7_width, E_fence7_endx];
fence7_vertices_y = [E_fence7_y, E_fence7_y, E_fence7_y + E_fence7_depth, E_fence7_y + E_fence7_depth];
% Calculate the z-positions for each vertex using the calculate_z_positions function
fence7_vertices_z = calculate_z_positions(fence7_vertices_x, fence7_vertices_y, dimensions);
% Combine x, y, and z to form the 3D vertices
E_fence7_vertices_bottom = [fence7_vertices_x', fence7_vertices_y', fence7_vertices_z'];
E_fence7_vertices_top = [fence7_vertices_x', fence7_vertices_y', fence7_vertices_z' + E_fence7_height];
% Combine bottom and top vertices
E_fence7_vertices = [E_fence7_vertices_bottom; E_fence7_vertices_top];
% Define Hedge faces
E_fence7_faces = E_fence5_faces;

% Define Hedge 3 dimensions
E_fence8_x = 34.485;
E_fence8_y = 46;
E_fence8_width = 15.515; 
E_fence8_depth = 2;
E_fence8_height = 5;
E_fence8_endx = 34.485;
% Define the 2D coordinates of the fence vertices
fence8_vertices_x = [E_fence8_x, E_fence8_x + E_fence8_width, E_fence8_endx + E_fence8_width, E_fence8_endx];
fence8_vertices_y = [E_fence8_y, E_fence8_y, E_fence8_y + E_fence8_depth, E_fence8_y + E_fence8_depth];
% Calculate the z-positions for each vertex using the calculate_z_positions function
fence8_vertices_z = calculate_z_positions(fence8_vertices_x, fence8_vertices_y, dimensions);
% Combine x, y, and z to form the 3D vertices
E_fence8_vertices_bottom = [fence8_vertices_x', fence8_vertices_y', fence8_vertices_z'];
E_fence8_vertices_top = [fence8_vertices_x', fence8_vertices_y', fence8_vertices_z' + E_fence8_height];
% Combine bottom and top vertices
E_fence8_vertices = [E_fence8_vertices_bottom; E_fence8_vertices_top];
% Define Hedge faces
E_fence8_faces = E_fence5_faces;

% Define Hedge 4 dimensions
E_fence9_x = 35.85;
E_fence9_y = 4.8;
E_fence9_width = 2; 
E_fence9_depth = 41.16;
E_fence9_height = 5;
E_fence9_endx = 34.6;
E_fence9_endy = 5.3;
% Define the 2D coordinates of the fence vertices
fence9_vertices_x = [E_fence9_x, E_fence9_x + E_fence9_width, E_fence9_endx + E_fence9_width, E_fence9_endx];
fence9_vertices_y = [E_fence9_y, E_fence9_endy, E_fence9_y + E_fence9_depth, E_fence9_y + E_fence9_depth];
% Calculate the z-positions for each vertex using the calculate_z_positions function
fence9_vertices_z = calculate_z_positions(fence9_vertices_x, fence9_vertices_y, dimensions);
% Combine x, y, and z to form the 3D vertices
E_fence9_vertices_bottom = [fence9_vertices_x', fence9_vertices_y', fence9_vertices_z'];
E_fence9_vertices_top = [fence9_vertices_x', fence9_vertices_y', fence9_vertices_z' + E_fence9_height];
% Combine bottom and top vertices
E_fence9_vertices = [E_fence9_vertices_bottom; E_fence9_vertices_top];
% Define Hedge faces
E_fence9_faces = E_fence5_faces;

% Define Hedge 5 dimensions
E_fence10_x = 20.4;%26.77;
E_fence10_y = 0;
E_fence10_width = 2;%29.6; 
E_fence10_depth = 29.6;%2;
E_fence10_height = 5;
E_fence10_endx = 26.77;%20.4;
E_fence10_endy = 6.4;
slope_y10 = (8.4 - 6.4 / 50 - 26.77);
%slope_y10 = (50 - 26.77 / 8.4 - 6.4);
% Define the 2D coordinates of the fence vertices
fence10_vertices_x = [20.4, 26.77, 50, 50];
fence10_vertices_y = [0, 0, 6.4, 8.4];
% Calculate the z-positions for each vertex using the calculate_z_positions function
fence10_vertices_z = calculate_z_positions(fence10_vertices_x, fence10_vertices_y, dimensions);
% Combine x, y, and z to form the 3D vertices
E_fence10_vertices_bottom = [fence10_vertices_x', fence10_vertices_y', fence10_vertices_z'];
E_fence10_vertices_top = [fence10_vertices_x', fence10_vertices_y', fence10_vertices_z' + E_fence10_height];
% Combine bottom and top vertices
E_fence10_vertices = [E_fence10_vertices_bottom; E_fence10_vertices_top];
% Define Hedge faces
E_fence10_faces = E_fence5_faces;

%% Labeling the roads
text('Parent', street_group, 'Position', [32, 30, 6], 'String', 'BYROM WAY', 'HorizontalAlignment', 'center', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'k');

%% Combine Garden vertices and faces
gardens_all_vertices = [E_fence1_vertices;
                        E_fence2_vertices;
                        E_fence3_vertices;
                        E_fence4_vertices;
                        E_fence5_vertices;
                        E_fence6_vertices;
                        E_fence7_vertices;
                        E_fence8_vertices;
                        E_fence9_vertices;
                        E_fence10_vertices];

offset_fence2 = size(E_fence1_vertices, 1);
offset_fence3 = offset_fence2 + size(E_fence2_vertices, 1);
offset_fence4 = offset_fence3 + size(E_fence3_vertices, 1);
offset_fence5 = offset_fence4 + size(E_fence4_vertices, 1);
offset_fence6 = offset_fence5 + size(E_fence5_vertices, 1);
offset_fence7 = offset_fence6 + size(E_fence6_vertices, 1);
offset_fence8 = offset_fence7 + size(E_fence7_vertices, 1);
offset_fence9 = offset_fence8 + size(E_fence8_vertices, 1);
offset_fence10 = offset_fence9 + size(E_fence9_vertices, 1);

gardens_all_faces = [E_fence1_faces;
                     E_fence2_faces + offset_fence2;
                     E_fence3_faces + offset_fence3;
                     E_fence4_faces + offset_fence4;
                     E_fence5_faces + offset_fence5;
                     E_fence6_faces + offset_fence6;
                     E_fence7_faces + offset_fence7;
                     E_fence8_faces + offset_fence8;
                     E_fence9_faces + offset_fence9;
                     E_fence10_faces + offset_fence10;
                     ];
                     
% Define the colors
gardens_colors = [repmat([0.8, 0.4, 0.1], size(E_fence1_faces, 1), 1);
                  repmat([0.8, 0.4, 0.1], size(E_fence2_faces, 1), 1);
                  repmat([0.8, 0.4, 0.1], size(E_fence3_faces, 1), 1);
                  repmat([0.8, 0.4, 0.1], size(E_fence4_faces, 1), 1);
                  repmat([0.6, 1, 0.6], size(E_fence5_faces, 1), 1);
                  repmat([0.8, 0.4, 0.1], size(E_fence6_faces, 1), 1);
                  repmat([0, 0.6, 0], size(E_fence7_faces, 1), 1);
                  repmat([0, 0.6, 0], size(E_fence8_faces, 1), 1);
                  repmat([0.3, 1, 0.3], size(E_fence9_faces, 1), 1);
                  repmat([0, 0.6, 0], size(E_fence10_faces, 1), 1);
                  ];
          
Fences(1) = struct('name', 'Fence 1', 'vertices', E_fence1_vertices, 'faces', E_fence1_faces, 'material', 'Brick', 'sabine_coefficient', sabine_coefficients.Brick, 'isDiagonal', false, 'slope', NaN, 'orientation', '');
Fences(2) = struct('name', 'Fence 2', 'vertices', E_fence2_vertices, 'faces', E_fence2_faces, 'material', 'Brick', 'sabine_coefficient', sabine_coefficients.Brick, 'isDiagonal', true, 'slope', slope_y2, 'orientation', 'Y');
Fences(3) = struct('name', 'Fence 3', 'vertices', E_fence3_vertices, 'faces', E_fence3_faces, 'material', 'Brick', 'sabine_coefficient', sabine_coefficients.Brick, 'isDiagonal', false, 'slope', NaN, 'orientation', '');
Fences(4) = struct('name', 'Fence 4', 'vertices', E_fence4_vertices, 'faces', E_fence4_faces, 'material', 'Brick', 'sabine_coefficient', sabine_coefficients.Brick, 'isDiagonal', true, 'slope', slope_x4, 'orientation', 'X');
Fences(5) = struct('name', 'Hedge 1', 'vertices', E_fence5_vertices, 'faces', E_fence5_faces, 'material', 'Hedge', 'sabine_coefficient', sabine_coefficients.Hedge, 'isDiagonal', true, 'slope', slope_x5, 'orientation', 'X');
Fences(6) = struct('name', 'Fence 5', 'vertices', E_fence6_vertices, 'faces', E_fence6_faces, 'material', 'Brick', 'sabine_coefficient', sabine_coefficients.Brick, 'isDiagonal', false, 'slope', NaN, 'orientation', '');
Fences(7) = struct('name', 'Hedge 2', 'vertices', E_fence7_vertices, 'faces', E_fence7_faces, 'material', 'Hedge', 'sabine_coefficient', sabine_coefficients.Hedge, 'isDiagonal', false, 'slope', NaN, 'orientation', '');
Fences(8) = struct('name', 'Hedge 3', 'vertices', E_fence8_vertices, 'faces', E_fence8_faces, 'material', 'Hedge', 'sabine_coefficient', sabine_coefficients.Hedge, 'isDiagonal', false, 'slope', NaN, 'orientation', '');
Fences(9) = struct('name', 'Hedge 4', 'vertices', E_fence9_vertices, 'faces', E_fence9_faces, 'material', 'Hedge', 'sabine_coefficient', sabine_coefficients.Hedge, 'isDiagonal', false, 'slope', NaN, 'orientation', '');
Fences(10) = struct('name', 'Hedge 5', 'vertices', E_fence10_vertices, 'faces', E_fence10_faces, 'material', 'Hedge', 'sabine_coefficient', sabine_coefficients.Hedge, 'isDiagonal', true, 'slope', slope_y10, 'orientation', 'Y');
% Combine these into a higher-order struct
world_objects(6).name = 'GARDENS';
world_objects(6).components(1) = Fences(1);
world_objects(6).components(2) = Fences(2);
world_objects(6).components(3) = Fences(3);
world_objects(6).components(4) = Fences(4);
world_objects(6).components(5) = Fences(5);
world_objects(6).components(6) = Fences(6);
world_objects(6).components(7) = Fences(7);
world_objects(6).components(8) = Fences(8);
world_objects(6).components(9) = Fences(9);
world_objects(6).components(10) = Fences(10);
% Create the patch object
patch('Parent', building_group,'Vertices', gardens_all_vertices, 'Faces', gardens_all_faces, 'FaceVertexCData', gardens_colors, 'FaceColor', 'flat');
%% Creating 'PLOT 1' building
% Define PLOT 1 dimensions
building1_x = 10;
building1_y = 25.42;
building1_width = 5;
building1_depth = 10.70;
building1_z = 1;
building1_height = 6.27 + building1_z;
building1_vertices = [building1_x, building1_y, building1_z-0.01;                                      %1 [0 , 20,  -0.01]
                      building1_x + building1_width, building1_y, building1_z-0.01;                    %2 [30, 20,  -0.01]
                      building1_x + building1_width, building1_y + building1_depth, building1_z-0.01;  %3 [30, 80,  -0.01]
                      building1_x, building1_y + building1_depth, building1_z-0.01;                    %4 [0 , 80,  -0.01]
                      building1_x, building1_y, building1_height;                                       %5 [0 , 20, 20]
                      building1_x + building1_width, building1_y, building1_height;                     %6 [30, 20, 20]
                      building1_x + building1_width, building1_y + building1_depth, building1_height;   %7 [30, 80, 20]
                      building1_x, building1_y + building1_depth, building1_height];                    %8 [0 , 80, 20]
building1_faces = [1, 2, 6, 5;
                   2, 3, 7, 6;
                   3, 4, 8, 7;
                   4, 1, 5, 8;
                   1, 2, 3, 4;
                   5, 6, 7, 8];

% Define PLOT 1 base dimensions
building1base_x = 10;
building1base_y = 25.42;
building1base_width = 5;
building1base_depth = 10.70;
building1base_z = dimensions.zMin_x;
building1base_height = building1_z;

building1base_vertices = [building1base_x, building1base_y, building1base_z;                                              %1 [0 , 20,  -0.01]
                      building1base_x + building1base_width, building1base_y, building1base_z;                            %2 [30, 20,  -0.01]
                      building1base_x + building1base_width, building1base_y + building1base_depth, building1base_z;      %3 [30, 80,  -0.01]
                      building1base_x, building1base_y + building1base_depth, building1base_z;                            %4 [0 , 80,  -0.01]
                      building1base_x, building1base_y, building1base_height;                                             %5 [0 , 20, 20]
                      building1base_x + building1base_width, building1base_y, building1base_height;                       %6 [30, 20, 20]
                      building1base_x + building1base_width, building1base_y + building1base_depth, building1base_height; %7 [30, 80, 20]
                      building1base_x, building1base_y + building1base_depth, building1base_height];                      %8 [0 , 80, 20]
% Define building1 base faces
building1base_faces = building1_faces;

% ROOF 1 of PLOT1
building1R_x = 12.42;
building1R_y = 25.42;
building1R_width = 2.2;
building1R_depth = 10.70;
building1R_height = 7.52 + building1_z;
building1R_vertices = [building1R_x, building1R_y, building1_height;  
                               building1R_x + building1R_width, building1R_y, building1_height;  
                               building1R_x + building1R_width, building1R_y + building1R_depth, building1_height; 
                               building1R_x, building1R_y + building1R_depth, building1_height;
                               building1R_x + building1R_width/2, building1R_y + building1R_depth, building1R_height;
                               building1R_x + building1R_width/2, building1R_y, building1R_height];
building1R_faces = [1 2 6 6;  % Front triangle
                    4 3 5 5;  % Back triangle
                    1 4 5 6;  % Left side
                    5 3 2 6;  % Right side
                    1 2 3 4];  % Top

% Define building1 window 1 dimensions
building1_window1_x = 10.70;
building1_window1_y = 25.42;
building1_window1_width = 0.95; 
building1_window1_depth = 0.2;
building1_window1_height = 2.15;
building1_window1_z = 3 + building1_z;
building1_window1_vertices = [building1_window1_x, building1_window1_y, building1_window1_z;                                                                          %1 []
                        building1_window1_x + building1_window1_width, building1_window1_y, building1_window1_z;                                                      %2 []
                        building1_window1_x + building1_window1_width, building1_window1_y + building1_window1_depth, building1_window1_z;                            %3 []
                        building1_window1_x, building1_window1_y + building1_window1_depth, building1_window1_z;                                                      %4 []
                        building1_window1_x, building1_window1_y, building1_window1_z + building1_window1_height;                                                     %5 []
                        building1_window1_x + building1_window1_width, building1_window1_y, building1_window1_z + building1_window1_height;                           %6 []
                        building1_window1_x + building1_window1_width, building1_window1_y + building1_window1_depth, building1_window1_z + building1_window1_height; %7 []
                        building1_window1_x, building1_window1_y + building1_window1_depth, building1_window1_z + building1_window1_height];                          %8 []
building1_window1_vertices(:, 2) = building1_window1_vertices(:,2)-0.01; % this is to stop flickering
% Define building1 window 1 faces
building1_window1_faces = building1_faces;

% Define building1 window 2 dimensions
building1_window2_x = 12.64;
building1_window2_y = 25.42-0.4;
building1_window2_width = 2; 
building1_window2_depth = 0.4;
building1_window2_height = 2.60;
building1_window2_z = 3 + building1_z;
building1_window2_vertices = [building1_window2_x, building1_window2_y, building1_window2_z;                                                                          %1 []
                        building1_window2_x + building1_window2_width, building1_window2_y, building1_window2_z;                                                      %2 []
                        building1_window2_x + building1_window2_width, building1_window2_y + building1_window2_depth, building1_window2_z;                            %3 []
                        building1_window2_x, building1_window2_y + building1_window2_depth, building1_window2_z;                                                      %4 []
                        building1_window2_x, building1_window2_y, building1_window2_z + building1_window2_height;                                                     %5 []
                        building1_window2_x + building1_window2_width, building1_window2_y, building1_window2_z + building1_window2_height;                           %6 []
                        building1_window2_x + building1_window2_width, building1_window2_y + building1_window2_depth, building1_window2_z + building1_window2_height; %7 []
                        building1_window2_x, building1_window2_y + building1_window2_depth, building1_window2_z + building1_window2_height];                          %8 []
building1_window2_vertices(:, 2) = building1_window2_vertices(:,2)-0.01; % this is to stop flickering
% Define building1 window 2 faces
building1_window2_faces = building1_faces;

% Define building1 window 3 dimensions
building1_window3_x = 12.88;
building1_window3_y = 25.42;
building1_window3_width = 1.50; 
building1_window3_depth = 0.2;
building1_window3_height = 2.15;
building1_window3_z = building1_z;
building1_window3_vertices = [building1_window3_x, building1_window3_y, building1_window3_z;                                                                          %1 []
                        building1_window3_x + building1_window3_width, building1_window3_y, building1_window3_z;                                                      %2 []
                        building1_window3_x + building1_window3_width, building1_window3_y + building1_window3_depth, building1_window3_z;                            %3 []
                        building1_window3_x, building1_window3_y + building1_window3_depth, building1_window3_z;                                                      %4 []
                        building1_window3_x, building1_window3_y, building1_window3_z + building1_window3_height;                                                     %5 []
                        building1_window3_x + building1_window3_width, building1_window3_y, building1_window3_z + building1_window3_height;                           %6 []
                        building1_window3_x + building1_window3_width, building1_window3_y + building1_window3_depth, building1_window3_z + building1_window3_height; %7 []
                        building1_window3_x, building1_window3_y + building1_window3_depth, building1_window3_z + building1_window3_height];                          %8 []
building1_window3_vertices(:, 2) = building1_window3_vertices(:,2)-0.01; % this is to stop flickering
% Define building1 window 3 faces
building1_window3_faces = building1_faces;

% Define building1 door2 dimensions
building1_window4_x = 10.70;
building1_window4_y = 25.42;
building1_window4_width = 0.95; 
building1_window4_depth = 0.2;
building1_window4_height = 2.15;
building1_window4_z = building1_z;
building1_window4_vertices = [building1_window4_x, building1_window4_y, building1_window4_z;                                                                          %1 []
                        building1_window4_x + building1_window4_width, building1_window4_y, building1_window4_z;                                                      %2 []
                        building1_window4_x + building1_window4_width, building1_window4_y + building1_window4_depth, building1_window4_z;                            %3 []
                        building1_window4_x, building1_window4_y + building1_window4_depth, building1_window4_z;                                                      %4 []
                        building1_window4_x, building1_window4_y, building1_window4_z + building1_window4_height;                                                     %5 []
                        building1_window4_x + building1_window4_width, building1_window4_y, building1_window4_z + building1_window4_height;                           %6 []
                        building1_window4_x + building1_window4_width, building1_window4_y + building1_window4_depth, building1_window4_z + building1_window4_height; %7 []
                        building1_window4_x, building1_window4_y + building1_window4_depth, building1_window4_z + building1_window4_height];                          %8 []
building1_window4_vertices(:, 2) = building1_window4_vertices(:,2)-0.01; % this is to stop flickering
% Define window4 faces
building1_window4_faces = building1_faces;

% Define window 5 dimensions
building1_window5_x = 12.70;
building1_window5_y = 36.12;
building1_window5_width = 1.90; 
building1_window5_depth = 0.3;
building1_window5_height = 1.90;
building1_window5_z = 3.65 +building1_z;
building1_window5_vertices = [building1_window5_x, building1_window5_y, building1_window5_z;                                                                          %1 []
                        building1_window5_x + building1_window5_width, building1_window5_y, building1_window5_z;                                                      %2 []
                        building1_window5_x + building1_window5_width, building1_window5_y + building1_window5_depth, building1_window5_z;                            %3 []
                        building1_window5_x, building1_window5_y + building1_window5_depth, building1_window5_z;                                                      %4 []
                        building1_window5_x, building1_window5_y, building1_window5_z + building1_window5_height;                                                     %5 []
                        building1_window5_x + building1_window5_width, building1_window5_y, building1_window5_z + building1_window5_height;                           %6 []
                        building1_window5_x + building1_window5_width, building1_window5_y + building1_window5_depth, building1_window5_z + building1_window5_height; %7 []
                        building1_window5_x, building1_window5_y + building1_window5_depth, building1_window5_z + building1_window5_height];                          %8 []
building1_window5_vertices(:, 2) = building1_window5_vertices(:,2)+0.01; % this is to stop flickering
% Define window5 faces
building1_window5_faces = building1_faces;

% Define window 6 dimensions
building1_window6_x = 10.70;
building1_window6_y = 36.12 - 0.2;
building1_window6_width = 1; 
building1_window6_depth = 0.2;
building1_window6_height = 2.05;
building1_window6_z = 3.25 +building1_z;
building1_window6_vertices = [building1_window6_x, building1_window6_y, building1_window6_z;                                                                          %1 []
                        building1_window6_x + building1_window6_width, building1_window6_y, building1_window6_z;                                                      %2 []
                        building1_window6_x + building1_window6_width, building1_window6_y + building1_window6_depth, building1_window6_z;                            %3 []
                        building1_window6_x, building1_window6_y + building1_window6_depth, building1_window6_z;                                                      %4 []
                        building1_window6_x, building1_window6_y, building1_window6_z + building1_window6_height;                                                     %5 []
                        building1_window6_x + building1_window6_width, building1_window6_y, building1_window6_z + building1_window6_height;                           %6 []
                        building1_window6_x + building1_window6_width, building1_window6_y + building1_window6_depth, building1_window6_z + building1_window6_height; %7 []
                        building1_window6_x, building1_window6_y + building1_window6_depth, building1_window6_z + building1_window6_height];                          %8 []
building1_window6_vertices(:, 2) = building1_window6_vertices(:,2)+0.01; % this is to stop flickering
% Define window6 faces
building1_window6_faces = building1_faces;

% Define window 7 dimensions
building1_window7_x = 12.80;
building1_window7_y = 36.12 - 0.2;
building1_window7_width = 1.50; 
building1_window7_depth = 0.2;
building1_window7_height = 1.40;
building1_window7_z = 0.70 + building1_z;
building1_window7_vertices = [building1_window7_x, building1_window7_y, building1_window7_z;                                                                          %1 []
                        building1_window7_x + building1_window7_width, building1_window7_y, building1_window7_z;                                                      %2 []
                        building1_window7_x + building1_window7_width, building1_window7_y + building1_window7_depth, building1_window7_z;                            %3 []
                        building1_window7_x, building1_window7_y + building1_window7_depth, building1_window7_z;                                                      %4 []
                        building1_window7_x, building1_window7_y, building1_window7_z + building1_window7_height;                                                     %5 []
                        building1_window7_x + building1_window7_width, building1_window7_y, building1_window7_z + building1_window7_height;                           %6 []
                        building1_window7_x + building1_window7_width, building1_window7_y + building1_window7_depth, building1_window7_z + building1_window7_height; %7 []
                        building1_window7_x, building1_window7_y + building1_window7_depth, building1_window7_z + building1_window7_height];                          %8 []
building1_window7_vertices(:, 2) = building1_window7_vertices(:,2)+0.01; % this is to stop flickering
% Define window7 faces
building1_window7_faces = building1_faces;

% Define window 8 dimensions
building1_window8_x = 10.70;
building1_window8_y = 36.12 - 0.2;
building1_window8_width = 1; 
building1_window8_depth = 0.2;
building1_window8_height = 0.30;
building1_window8_z = 2.16+building1_z;
building1_window8_vertices = [building1_window8_x, building1_window8_y, building1_window8_z;                                                                          %1 []
                        building1_window8_x + building1_window8_width, building1_window8_y, building1_window8_z;                                                      %2 []
                        building1_window8_x + building1_window8_width, building1_window8_y + building1_window8_depth, building1_window8_z;                            %3 []
                        building1_window8_x, building1_window8_y + building1_window8_depth, building1_window8_z;                                                      %4 []
                        building1_window8_x, building1_window8_y, building1_window8_z + building1_window8_height;                                                     %5 []
                        building1_window8_x + building1_window8_width, building1_window8_y, building1_window8_z + building1_window8_height;                           %6 []
                        building1_window8_x + building1_window8_width, building1_window8_y + building1_window8_depth, building1_window8_z + building1_window8_height; %7 []
                        building1_window8_x, building1_window8_y + building1_window8_depth, building1_window8_z + building1_window8_height];                          %8 []
building1_window8_vertices(:, 2) = building1_window8_vertices(:,2)+0.01; % this is to stop flickering
% Define window8 faces
building1_window8_faces = building1_faces;

% Define window 9 dimensions
building1_window9_x = 10.55;
building1_window9_y = 36.12;
building1_window9_width = 1.30; 
building1_window9_depth = 0.5;
building1_window9_height = 1.30;
building1_window9_z = 3+building1_z;
building1_window9_vertices = [building1_window9_x, building1_window9_y, building1_window9_z;                                                                          %1 []
                        building1_window9_x + building1_window9_width, building1_window9_y, building1_window9_z;                                                      %2 []
                        building1_window9_x + building1_window9_width, building1_window9_y + building1_window9_depth, building1_window9_z;                            %3 []
                        building1_window9_x, building1_window9_y + building1_window9_depth, building1_window9_z;                                                      %4 []
                        building1_window9_x, building1_window9_y, building1_window9_z + building1_window9_height;                                                     %5 []
                        building1_window9_x + building1_window9_width, building1_window9_y, building1_window9_z + building1_window9_height;                           %6 []
                        building1_window9_x + building1_window9_width, building1_window9_y + building1_window9_depth, building1_window9_z + building1_window9_height; %7 []
                        building1_window9_x, building1_window9_y + building1_window9_depth, building1_window9_z + building1_window9_height];                          %8 []
building1_window9_vertices(:, 2) = building1_window9_vertices(:,2)+0.01; % this is to stop flickering
% Define window9 faces
building1_window9_faces = building1_faces;

% Define roof panel dimensions
building1_window10_x = 10.45;
building1_window10_y = 33.6;
building1_window10_width = 1.67; 
building1_window10_depth = 1.1;
building1_window10_height = 0.2;
building1_window10_z = building1_height;
building1_window10_vertices = [building1_window10_x, building1_window10_y, building1_window10_z;                                                                          %1 []
                        building1_window10_x + building1_window10_width, building1_window10_y, building1_window10_z;                                                      %2 []
                        building1_window10_x + building1_window10_width, building1_window10_y + building1_window10_depth, building1_window10_z;                            %3 []
                        building1_window10_x, building1_window10_y + building1_window10_depth, building1_window10_z;                                                      %4 []
                        building1_window10_x, building1_window10_y, building1_window10_z + building1_window10_height;                                                     %5 []
                        building1_window10_x + building1_window10_width, building1_window10_y, building1_window10_z + building1_window10_height;                           %6 []
                        building1_window10_x + building1_window10_width, building1_window10_y + building1_window10_depth, building1_window10_z + building1_window10_height; %7 []
                        building1_window10_x, building1_window10_y + building1_window10_depth, building1_window10_z + building1_window10_height];                          %8 []
%building1_window10_vertices(:, 3) = building1_window10_vertices(:,3)+0.01; % this is to stop flickering
% Define window10 faces
building1_window10_faces = building1_faces;

% Define roof panel dimensions
building1_window11_x = 10.45;
building1_window11_y = 32;
building1_window11_width = 1.67; 
building1_window11_depth = 1.1;
building1_window11_height = 0.2;
building1_window11_z = building1_height;
building1_window11_vertices = [building1_window11_x, building1_window11_y, building1_window11_z;                                                                          %1 []
                        building1_window11_x + building1_window11_width, building1_window11_y, building1_window11_z;                                                      %2 []
                        building1_window11_x + building1_window11_width, building1_window11_y + building1_window11_depth, building1_window11_z;                            %3 []
                        building1_window11_x, building1_window11_y + building1_window11_depth, building1_window11_z;                                                      %4 []
                        building1_window11_x, building1_window11_y, building1_window11_z + building1_window11_height;                                                     %5 []
                        building1_window11_x + building1_window11_width, building1_window11_y, building1_window11_z + building1_window11_height;                           %6 []
                        building1_window11_x + building1_window11_width, building1_window11_y + building1_window11_depth, building1_window11_z + building1_window11_height; %7 []
                        building1_window11_x, building1_window11_y + building1_window11_depth, building1_window11_z + building1_window11_height];                          %8 []
%building1_window10_vertices(:, 3) = building1_window10_vertices(:,3)+0.01; % this is to stop flickering
% Define window11 faces
building1_window11_faces = building1_faces;

% Define roof panel dimensions
building1_window12_x = 10.45;
building1_window12_y = 30.3;
building1_window12_width = 1.67; 
building1_window12_depth = 1.1;
building1_window12_height = 0.2;
building1_window12_z = building1_height;
building1_window12_vertices = [building1_window12_x, building1_window12_y, building1_window12_z;                                                                          %1 []
                        building1_window12_x + building1_window12_width, building1_window12_y, building1_window12_z;                                                      %2 []
                        building1_window12_x + building1_window12_width, building1_window12_y + building1_window12_depth, building1_window12_z;                            %3 []
                        building1_window12_x, building1_window12_y + building1_window12_depth, building1_window12_z;                                                      %4 []
                        building1_window12_x, building1_window12_y, building1_window12_z + building1_window12_height;                                                     %5 []
                        building1_window12_x + building1_window12_width, building1_window12_y, building1_window12_z + building1_window12_height;                           %6 []
                        building1_window12_x + building1_window12_width, building1_window12_y + building1_window12_depth, building1_window12_z + building1_window12_height; %7 []
                        building1_window12_x, building1_window12_y + building1_window12_depth, building1_window12_z + building1_window12_height];                          %8 []
%building1_window10_vertices(:, 3) = building1_window10_vertices(:,3)+0.01; % this is to stop flickering
% Define window12 faces
building1_window12_faces = building1_faces;

% Define roof panel dimensions
building1_window13_x = 10.45;
building1_window13_y = 28.6;
building1_window13_width = 1.67; 
building1_window13_depth = 1.1;
building1_window13_height = 0.2;
building1_window13_z = building1_height;
building1_window13_vertices = [building1_window13_x, building1_window13_y, building1_window13_z;                                                                          %1 []
                        building1_window13_x + building1_window13_width, building1_window13_y, building1_window13_z;                                                      %2 []
                        building1_window13_x + building1_window13_width, building1_window13_y + building1_window13_depth, building1_window13_z;                            %3 []
                        building1_window13_x, building1_window13_y + building1_window13_depth, building1_window13_z;                                                      %4 []
                        building1_window13_x, building1_window13_y, building1_window13_z + building1_window13_height;                                                     %5 []
                        building1_window13_x + building1_window13_width, building1_window13_y, building1_window13_z + building1_window13_height;                           %6 []
                        building1_window13_x + building1_window13_width, building1_window13_y + building1_window13_depth, building1_window13_z + building1_window13_height; %7 []
                        building1_window13_x, building1_window13_y + building1_window13_depth, building1_window13_z + building1_window13_height];                          %8 []
%building1_window10_vertices(:, 3) = building1_window10_vertices(:,3)+0.01; % this is to stop flickering
% Define window13 faces
building1_window13_faces = building1_faces;

% Define roof panel dimensions
building1_window14_x = 10.9;
building1_window14_y = 26;
building1_window14_width = 0.8; 
building1_window14_depth = 2;
building1_window14_height = 0.2;
building1_window14_z = building1_height;
building1_window14_vertices = [building1_window14_x, building1_window14_y, building1_window14_z;                                                                          %1 []
                        building1_window14_x + building1_window14_width, building1_window14_y, building1_window14_z;                                                      %2 []
                        building1_window14_x + building1_window14_width, building1_window14_y + building1_window14_depth, building1_window14_z;                            %3 []
                        building1_window14_x, building1_window14_y + building1_window14_depth, building1_window14_z;                                                      %4 []
                        building1_window14_x, building1_window14_y, building1_window14_z + building1_window14_height;                                                     %5 []
                        building1_window14_x + building1_window14_width, building1_window14_y, building1_window14_z + building1_window14_height;                           %6 []
                        building1_window14_x + building1_window14_width, building1_window14_y + building1_window14_depth, building1_window14_z + building1_window14_height; %7 []
                        building1_window14_x, building1_window14_y + building1_window14_depth, building1_window14_z + building1_window14_height];                          %8 []
%building1_window10_vertices(:, 3) = building1_window10_vertices(:,3)+0.01; % this is to stop flickering
% Define window13 faces
building1_window14_faces = building1_faces;

% Define door 1 dimensions
building1_door1_x = 10.70;
building1_door1_y = 36.12 - 0.2;
building1_door1_width = 1; 
building1_door1_depth = 0.2;
building1_door1_height = 2.15;
building1_door1_z = building1_z;
building1_door1_vertices = [building1_door1_x, building1_door1_y, building1_door1_z;                                                                          %1 []
                        building1_door1_x + building1_door1_width, building1_door1_y, building1_door1_z;                                                      %2 []
                        building1_door1_x + building1_door1_width, building1_door1_y + building1_door1_depth, building1_door1_z;                            %3 []
                        building1_door1_x, building1_door1_y + building1_door1_depth, building1_door1_z;                                                      %4 []
                        building1_door1_x, building1_door1_y, building1_door1_z + building1_door1_height;                                                     %5 []
                        building1_door1_x + building1_door1_width, building1_door1_y, building1_door1_z + building1_door1_height;                           %6 []
                        building1_door1_x + building1_door1_width, building1_door1_y + building1_door1_depth, building1_door1_z + building1_door1_height; %7 []
                        building1_door1_x, building1_door1_y + building1_door1_depth, building1_door1_z + building1_door1_height];                          %8 []
building1_door1_vertices(:, 2) = building1_door1_vertices(:,2)+0.01; % this is to stop flickering
% Define door1 faces
building1_door1_faces = building1_faces;

% Add a roof surface (PLOT 1) with material 'tiles'
surfaces(12).name = 'PLOT 1 Roof2';
surfaces(12).position.x = [10, 15, 15, 10];
surfaces(12).position.y = [25.42, 25.42, 36.12, 36.12];
surfaces(12).position.z = [building1_z + 6.27, building1_z + 6.27, building1_z + 6.27, building1_z + 6.27];
surfaces(12).sabine_coefficient = sabine_coefficients.Tiles;
surfaces(12).material = 'Tiles';
% Draw ROOF
patch('Parent', street_group,'XData', surfaces(12).position.x, 'YData', surfaces(12).position.y, 'ZData', surfaces(12).position.z, 'FaceColor', [0.5, 0.5, 0.5]);

% Define ramp 1a dimensions
building1_ramp1_x = 10;
building1_ramp1_y = 24.42;
building1_ramp1_width = 5; 
building1_ramp1_depth = 1;
building1_ramp1_height = 0.2;
building1_ramp1_z = building1_z;
building1_ramp1_vertices = [building1_ramp1_x, building1_ramp1_y, building1_ramp1_z;                                                                          %1 []
                        building1_ramp1_x + building1_ramp1_width, building1_ramp1_y, building1_ramp1_z;                                                      %2 []
                        building1_ramp1_x + building1_ramp1_width, building1_ramp1_y + building1_ramp1_depth, building1_ramp1_z;                            %3 []
                        building1_ramp1_x, building1_ramp1_y + building1_ramp1_depth, building1_ramp1_z;                                                      %4 []
                        building1_ramp1_x, building1_ramp1_y, building1_ramp1_z + building1_ramp1_height;                                                     %5 []
                        building1_ramp1_x + building1_ramp1_width, building1_ramp1_y, building1_ramp1_z + building1_ramp1_height;                           %6 []
                        building1_ramp1_x + building1_ramp1_width, building1_ramp1_y + building1_ramp1_depth, building1_ramp1_z + building1_ramp1_height; %7 []
                        building1_ramp1_x, building1_ramp1_y + building1_ramp1_depth, building1_ramp1_z + building1_ramp1_height];                          %8 []
building1_ramp1_vertices(:, 2) = building1_ramp1_vertices(:,2)+0.01; % this is to stop flickering
% Define ramp 1a faces
building1_ramp1_faces = building1_faces;

% Define ramp 1b dimensions
building1_ramp1b_x = 10.7;
building1_ramp1b_y = 22.43;
building1_ramp1b_width = 1.3; 
building1_ramp1b_depth = 2;
building1_ramp1b_height = 0.2;
building1_ramp1b_z = building1_z;
building1_ramp1b_z2 = calculate_z_positions(building1_ramp1b_x, building1_ramp1b_y, dimensions);

building1_ramp1b_vertices = [building1_ramp1b_x, building1_ramp1b_y, building1_ramp1b_z2;                                                                          %1 []
                        building1_ramp1b_x + building1_ramp1b_width, building1_ramp1b_y, building1_ramp1b_z2;                                                      %2 []
                        building1_ramp1b_x + building1_ramp1b_width, building1_ramp1b_y + building1_ramp1b_depth, building1_ramp1b_z;                            %3 []
                        building1_ramp1b_x, building1_ramp1b_y + building1_ramp1b_depth, building1_ramp1b_z;                                                      %4 []
                        building1_ramp1b_x, building1_ramp1b_y, building1_ramp1b_z2 + building1_ramp1b_height;                                                     %5 []
                        building1_ramp1b_x + building1_ramp1b_width, building1_ramp1b_y, building1_ramp1b_z2 + building1_ramp1b_height;                           %6 []
                        building1_ramp1b_x + building1_ramp1b_width, building1_ramp1b_y + building1_ramp1b_depth, building1_ramp1b_z + building1_ramp1b_height; %7 []
                        building1_ramp1b_x, building1_ramp1b_y + building1_ramp1b_depth, building1_ramp1b_z + building1_ramp1b_height];                          %8 []
building1_ramp1b_vertices(:, 2) = building1_ramp1b_vertices(:,2)-0.01; % this is to stop flickering
% Define door1 faces
building1_ramp1b_faces = building1_faces;

% Define ramp 2a dimensions
building1_ramp2_x = 10.7;
building1_ramp2_y = 36.12;
building1_ramp2_width = 4.3; 
building1_ramp2_depth = 1.5;
building1_ramp2_height = 0.2;
building1_ramp2_z = calculate_z_positions(building1_ramp2_x, building1_ramp2_y, dimensions)+building1_z/2;
building1_ramp2_vertices = [building1_ramp2_x, building1_ramp2_y, building1_z;                                                                          %1 []
                        building1_ramp2_x + building1_ramp2_width, building1_ramp2_y, building1_ramp2_z;                                                      %2 []
                        building1_ramp2_x + building1_ramp2_width, building1_ramp2_y + building1_ramp2_depth, building1_ramp2_z;                            %3 []
                        building1_ramp2_x, building1_ramp2_y + building1_ramp2_depth, building1_z;                                                      %4 []
                        building1_ramp2_x, building1_ramp2_y, building1_z + building1_ramp2_height;                                                     %5 []
                        building1_ramp2_x + building1_ramp2_width, building1_ramp2_y, building1_ramp2_z + building1_ramp2_height;                           %6 []
                        building1_ramp2_x + building1_ramp2_width, building1_ramp2_y + building1_ramp2_depth, building1_ramp2_z + building1_ramp2_height; %7 []
                        building1_ramp2_x, building1_ramp2_y + building1_ramp2_depth, building1_z + building1_ramp2_height];                          %8 []
building1_ramp2_vertices(:, 2) = building1_ramp2_vertices(:,2)+0.01; % this is to stop flickering
% Define ramp 2a faces
building1_ramp2_faces = building1_faces;

% Define ramp 2b dimensions
building1_ramp3_x = 10.7;
building1_ramp3_y = 37.62;
building1_ramp3_width = 4.3; 
building1_ramp3_depth = 1.5;
building1_ramp3_height = 0.2;
building1_ramp3_z1 = calculate_z_positions(building1_ramp3_x, building1_ramp3_y, dimensions)+building1_z/2;
building1_ramp3_z2 = calculate_z_positions(building1_ramp3_x, building1_ramp3_y, dimensions);
building1_ramp3_vertices = [building1_ramp3_x, building1_ramp3_y, building1_ramp3_z2;                                                                          %1 []
                        building1_ramp3_x + building1_ramp3_width, building1_ramp3_y, building1_ramp3_z1;                                                      %2 []
                        building1_ramp3_x + building1_ramp3_width, building1_ramp3_y + building1_ramp3_depth, building1_ramp3_z1;                            %3 []
                        building1_ramp3_x, building1_ramp3_y + building1_ramp3_depth, building1_ramp3_z2;                                                     %4 []
                        building1_ramp3_x, building1_ramp3_y, building1_ramp3_z2 + building1_ramp3_height;                                                     %5 []
                        building1_ramp3_x + building1_ramp3_width, building1_ramp3_y, building1_ramp3_z1 + building1_ramp3_height;                           %6 []
                        building1_ramp3_x + building1_ramp3_width, building1_ramp3_y + building1_ramp3_depth, building1_ramp3_z1 + building1_ramp3_height; %7 []
                        building1_ramp3_x, building1_ramp3_y + building1_ramp3_depth, building1_ramp3_z2 + building1_ramp3_height];                          %8 []
building1_ramp3_vertices(:, 2) = building1_ramp3_vertices(:,2)+0.01; % this is to stop flickering
% Define ramp 2a faces
building1_ramp3_faces = building1_faces;

% Add a floor (PLOT 1 FLOOR) with material 'carpet'
surfaces(7).name = 'PLOT 1 floor';
surfaces(7).position.x = [10, 15, 15, 10];
surfaces(7).position.y = [25.42, 25.42, 36.12,36.12];
surfaces(7).position.z = [building1_z, building1_z, building1_z, building1_z];
surfaces(7).sabine_coefficient = sabine_coefficients.Carpet;
surfaces(7).material = 'Carpet';
% Draw PLOT 1 floor
patch('Parent', street_group,'XData', surfaces(7).position.x, 'YData', surfaces(7).position.y, 'ZData', surfaces(7).position.z, 'FaceColor', 'r');

% Combine building and window vertices and faces
building1_all_vertices = [building1_vertices; 
                          building1_window1_vertices; 
                          building1_window2_vertices; 
                          building1_window3_vertices;
                          building1_window4_vertices;
                          building1_window5_vertices;
                          building1_window6_vertices;
                          building1_window7_vertices;
                          building1_window8_vertices;
                          building1_window9_vertices;
                          building1_window10_vertices;
                          building1_window11_vertices;
                          building1_window12_vertices;
                          building1_window13_vertices;
                          building1_window14_vertices;
                          building1_door1_vertices;
                          building1R_vertices;
                          building1base_vertices;
                          building1_ramp1_vertices;
                          building1_ramp2_vertices;
                          building1_ramp3_vertices;
                          building1_ramp1b_vertices];

offset_window1 = size(building1_vertices, 1);
offset_window2 = offset_window1 + size(building1_window1_vertices, 1);
offset_window3 = offset_window2 + size(building1_window2_vertices, 1);
offset_window4 = offset_window3 + size(building1_window3_vertices, 1);
offset_window5 = offset_window4 + size(building1_window4_vertices, 1);
offset_window6 = offset_window5 + size(building1_window5_vertices, 1);
offset_window7 = offset_window6 + size(building1_window6_vertices, 1);
offset_window8 = offset_window7 + size(building1_window7_vertices, 1);
offset_window9 = offset_window8 + size(building1_window8_vertices, 1);
offset_window10 = offset_window9 + size(building1_window9_vertices, 1);
offset_window11 = offset_window10 + size(building1_window10_vertices, 1);
offset_window12 = offset_window11 + size(building1_window11_vertices, 1);
offset_window13 = offset_window12 + size(building1_window12_vertices, 1);
offset_window14 = offset_window13 + size(building1_window13_vertices, 1);
offset_door1 = offset_window14 + size(building1_window14_vertices, 1);
offset_roof = offset_door1 + size(building1_door1_vertices, 1);
offset_base = offset_roof + size(building1R_vertices, 1);
offset_ramp1 = offset_base + size(building1base_vertices, 1);
offset_ramp2 = offset_ramp1 + size(building1_ramp1_vertices, 1);
offset_ramp3 = offset_ramp2 + size(building1_ramp2_vertices, 1);
offset_ramp1b = offset_ramp3 + size(building1_ramp3_vertices, 1);

building1_all_faces = [building1_faces; 
                       building1_window1_faces + offset_window1;
                       building1_window2_faces + offset_window2;
                       building1_window3_faces + offset_window3;
                       building1_window4_faces + offset_window4;
                       building1_window5_faces + offset_window5;
                       building1_window6_faces + offset_window6;
                       building1_window7_faces + offset_window7;
                       building1_window8_faces + offset_window8;
                       building1_window9_faces + offset_window9;
                       building1_window10_faces + offset_window10;
                       building1_window11_faces + offset_window11;
                       building1_window12_faces + offset_window12;
                       building1_window13_faces + offset_window13;
                       building1_window14_faces + offset_window14;
                       building1_door1_faces + offset_door1
                       building1R_faces + offset_roof;
                       building1base_faces + offset_base;
                       building1_ramp1_faces + offset_ramp1;
                       building1_ramp2_faces + offset_ramp2;
                       building1_ramp3_faces + offset_ramp3;
                       building1_ramp1b_faces + offset_ramp1b];
                       
% Define the colors
building1_colors = [repmat([0.96, 0.96, 0.86], size(building1_faces, 1), 1);
          repmat([0.9, 0.9, 0.9], size(building1_window1_faces, 1), 1);
          repmat([0.9, 0.9, 0.9], size(building1_window2_faces, 1), 1);
          repmat([0.9, 0.9, 0.9], size(building1_window3_faces, 1), 1);
          repmat([0.9, 0.9, 0.9], size(building1_window4_faces, 1), 1);
          repmat([0.9, 0.9, 0.9], size(building1_window5_faces, 1), 1);
          repmat([0.9, 0.9, 0.9], size(building1_window6_faces, 1), 1);
          repmat([0.9, 0.9, 0.9], size(building1_window7_faces, 1), 1);
          repmat([0.9, 0.9, 0.9], size(building1_window8_faces, 1), 1);
          repmat([0, 0, 0], size(building1_window9_faces, 1), 1);
          repmat([0, 0, 0], size(building1_window10_faces, 1), 1);
          repmat([0, 0, 0], size(building1_window11_faces, 1), 1);
          repmat([0, 0, 0], size(building1_window12_faces, 1), 1);
          repmat([0, 0, 0], size(building1_window13_faces, 1), 1);
          repmat([0, 0, 0], size(building1_window14_faces, 1), 1);
          repmat([0, 0, 0], size(building1_door1_faces, 1), 1);
          repmat([0, 0, 0], size(building1R_faces, 1), 1);
          repmat([0.5, 0.5, 0.5], size(building1base_faces, 1), 1);
          repmat([1, 1, 1], size(building1_ramp1_faces, 1), 1);
          repmat([0.8, 0.7, 0.5], size(building1_ramp2_faces, 1), 1);
          repmat([0.8, 0.7, 0.5], size(building1_ramp3_faces, 1), 1);
          repmat([1, 1, 1], size(building1_ramp1b_faces, 1), 1);
          ];

% 'PLOT 1' building with 'concrete'
buildings(1) = struct('name', 'PLOT 1', 'vertices', building1_vertices, 'faces', building1_faces, 'material', 'Concrete', 'sabine_coefficient', sabine_coefficients.Concrete);
buildings(2) = struct('name', 'PLOT 1 Base', 'vertices', building1base_vertices, 'faces', building1base_faces, 'material', 'Concrete', 'sabine_coefficient', sabine_coefficients.Concrete);

% 'PLOT 1' Windows with 'glass'
windows(1) = struct('name', 'PLOT 1 Window 1', 'vertices', building1_window1_vertices, 'faces', building1_window1_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(2) = struct('name', 'PLOT 1 Window 2', 'vertices', building1_window2_vertices, 'faces', building1_window2_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(3) = struct('name', 'PLOT 1 Window 3', 'vertices', building1_window3_vertices, 'faces', building1_window3_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(4) = struct('name', 'PLOT 1 Window 4', 'vertices', building1_window5_vertices, 'faces', building1_window5_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(5) = struct('name', 'PLOT 1 Window 5', 'vertices', building1_window6_vertices, 'faces', building1_window6_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(6) = struct('name', 'PLOT 1 Window 6', 'vertices', building1_window7_vertices, 'faces', building1_window7_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(7) = struct('name', 'PLOT 1 Window 7', 'vertices', building1_window8_vertices, 'faces', building1_window8_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(8) = struct('name', 'PLOT 1 Balcony', 'vertices', building1_window9_vertices, 'faces', building1_window9_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
doors(1) = struct('name', 'PLOT 1 Door 1', 'vertices', building1_door1_vertices, 'faces', building1_door1_faces, 'material', 'Wood', 'sabine_coefficient', sabine_coefficients.Wood);
doors(2) = struct('name', 'PLOT 1 Door 2', 'vertices', building1_window4_vertices, 'faces', building1_window4_faces, 'material', 'Wood', 'sabine_coefficient', sabine_coefficients.Wood);
roofs(1) = struct('name', 'PLOT 1 Roof 1', 'vertices', building1R_vertices, 'faces', building1R_faces, 'material', 'Tiles', 'sabine_coefficient', sabine_coefficients.Tiles);
roofpanels(1) = struct('name', 'PLOT 1 Roof Panel 1', 'vertices', building1_window10_vertices, 'faces', building1_window10_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
roofpanels(2) = struct('name', 'PLOT 1 Roof Panel 2', 'vertices', building1_window11_vertices, 'faces', building1_window11_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
roofpanels(3) = struct('name', 'PLOT 1 Roof Panel 3', 'vertices', building1_window12_vertices, 'faces', building1_window12_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
roofpanels(4) = struct('name', 'PLOT 1 Roof Panel 4', 'vertices', building1_window13_vertices, 'faces', building1_window13_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
roofpanels(5) = struct('name', 'PLOT 1 Roof Panel 5', 'vertices', building1_window14_vertices, 'faces', building1_window14_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
ramp(1) = struct('name', 'PLOT 1 Ramp 1', 'vertices', building1_ramp1_vertices, 'faces', building1_ramp1_faces, 'material', 'Metal', 'sabine_coefficient', sabine_coefficients.Metal);
ramp(2) = struct('name', 'PLOT 1 Ramp 2a', 'vertices', building1_ramp2_vertices, 'faces', building1_ramp2_faces, 'material', 'Metal', 'sabine_coefficient', sabine_coefficients.Metal);
ramp(3) = struct('name', 'PLOT 1 Ramp 2b', 'vertices', building1_ramp3_vertices, 'faces', building1_ramp3_faces, 'material', 'Metal', 'sabine_coefficient', sabine_coefficients.Metal);
ramp(4) = struct('name', 'PLOT 1 Ramp 1b', 'vertices', building1_ramp1b_vertices, 'faces', building1_ramp1b_faces, 'material', 'Metal', 'sabine_coefficient', sabine_coefficients.Metal);
% Combine these into a higher-order struct
world_objects(1).name = 'PLOT 1';
world_objects(1).components(1) = buildings(1);
world_objects(1).components(2) = buildings(2);
world_objects(1).components(3) = windows(1);
world_objects(1).components(4) = windows(2);
world_objects(1).components(5) = windows(3);
world_objects(1).components(6) = windows(4);
world_objects(1).components(7) = windows(5);
world_objects(1).components(8) = windows(6);
world_objects(1).components(9) = windows(7);
world_objects(1).components(10) = windows(8);
world_objects(1).components(11) = doors(1);
world_objects(1).components(12) = doors(2);
world_objects(1).components(13) = roofs(1);
world_objects(1).components(14) = roofpanels(1);
world_objects(1).components(15) = roofpanels(2);
world_objects(1).components(16) = roofpanels(3);
world_objects(1).components(17) = roofpanels(4);
world_objects(1).components(18) = roofpanels(5);
world_objects(1).components(19) = ramp(1);
world_objects(1).components(20) = ramp(2);
world_objects(1).components(21) = ramp(3);
world_objects(1).components(22) = ramp(4);
% Create the patch object
patch('Parent', building_group,'Vertices', building1_all_vertices, 'Faces', building1_all_faces, 'FaceVertexCData', building1_colors, 'FaceColor', 'flat');
%% Creating 'PLOT 2' building
% Define PLOT 2 dimensions
building2_x = 18.32;
building2_y = 25.671;
building2_width = 4.314;
building2_depth = 10.449;
building2_z = 1;
building2_height = 5.32 + building2_z;
building2_vertices = [building2_x, building2_y, building2_z - 0.01;
                      building2_x + building2_width, building2_y,building2_z - 0.01;
                      building2_x + building2_width, building2_y + building2_depth,building2_z - 0.01;
                      building2_x, building2_y + building2_depth, building2_z - 0.01;
                      building2_x, building2_y, building2_height;
                      building2_x + building2_width, building2_y, building2_height;
                      building2_x + building2_width, building2_y + building2_depth, building2_height;
                      building2_x, building2_y + building2_depth, building2_height];
building2_faces = building1_faces;
%building2_vertices(1:4, 3) = dimensions.zMin;

% Define PLOT 1 base dimensions
building2base_x = 18.32;
building2base_y = 25.671;
building2base_width = 4.314;
building2base_depth = 10.449;
building2base_z = dimensions.zMin_x;
building2base_height = building2_z;
building2base_vertices = [building2base_x, building2base_y, building2base_z;                                              %1 [0 , 20,  -0.01]
                      building2base_x + building2base_width, building2base_y, building2base_z;                            %2 [30, 20,  -0.01]
                      building2base_x + building2base_width, building2base_y + building2base_depth, building2base_z;      %3 [30, 80,  -0.01]
                      building2base_x, building2base_y + building2base_depth, building2base_z;                            %4 [0 , 80,  -0.01]
                      building2base_x, building2base_y, building2base_height;                                             %5 [0 , 20, 20]
                      building2base_x + building2base_width, building2base_y, building2base_height;                       %6 [30, 20, 20]
                      building2base_x + building2base_width, building2base_y + building2base_depth, building2base_height; %7 [30, 80, 20]
                      building2base_x, building2base_y + building2base_depth, building2base_height];                      %8 [0 , 80, 20]
% Define building1 base faces
building2base_faces = building1_faces;

% ROOF 1 of PLOT2
building2R_x = 18.32;
building2R_y = 25.671;
building2R_width = 4.314;
building2R_depth = 10.449;
building2R_height = 6.543 + building2_z;
building2R_vertices = [building2R_x, building2R_y, building2_height;  
                               building2R_x + building2R_width, building2R_y, building2_height;  
                               building2R_x + building2R_width, building2R_y + building2R_depth, building2_height; 
                               building2R_x, building2R_y + building2R_depth, building2_height;
                               building2R_x + building2R_width/3, building2R_y + building2R_depth, building2R_height;
                               building2R_x + building2R_width/3, building2R_y, building2R_height];
building2R_faces = [1 2 6 6;  % Front triangle
                    4 3 5 5;  % Back triangle
                    1 4 5 6;  % Left side
                    5 3 2 6;  % Right side
                    1 2 3 4];  % Top

% Define window 1 dimensions
building2_window1_x = 20;
building2_window1_y = 36.12 - 0.2;
building2_window1_width = 1;
building2_window1_depth = 0.2;
building2_window1_height = 2.05;
building2_window1_z = building2_z;
building2_window1_vertices = [building2_window1_x, building2_window1_y, building2_window1_z;                                                                          %1 [0 , 20,  0]
                        building2_window1_x + building2_window1_width, building2_window1_y, building2_window1_z;                                                      %2 [30, 20,  0]
                        building2_window1_x + building2_window1_width, building2_window1_y + building2_window1_depth, building2_window1_z;                            %3 [30, 80,  0]
                        building2_window1_x, building2_window1_y + building2_window1_depth, building2_window1_z;                                                      %4 [0 , 80,  0]
                        building2_window1_x, building2_window1_y, building2_window1_height + building2_window1_z;                                                     %5 [0 , 20, 20]
                        building2_window1_x + building2_window1_width, building2_window1_y, building2_window1_height + building2_window1_z;                           %6 [30, 20, 20]
                        building2_window1_x + building2_window1_width, building2_window1_y + building2_window1_depth, building2_window1_height + building2_window1_z; %7 [30, 80, 20]
                        building2_window1_x, building2_window1_y + building2_window1_depth, building2_window1_height + building2_window1_z];                          %8 [0 , 80, 20]
building2_window1_vertices(:, 2) = building2_window1_vertices(:,2)+0.01; % this is to stop flickering
% Define window faces
building2_window1_faces = building1_faces;

% Define window 2 dimensions
building2_window2_x = 20;
building2_window2_y = 36.12 - 0.2;
building2_window2_width = 1;
building2_window2_depth = 0.2;
building2_window2_height = 2.05;
building2_window2_z = 2.78 +building2_z;
building2_window2_vertices = [building2_window2_x, building2_window2_y, building2_window2_z;                                                                          %1 [0 , 20,  0]
                        building2_window2_x + building2_window2_width, building2_window2_y, building2_window2_z;                                                      %2 [30, 20,  0]
                        building2_window2_x + building2_window2_width, building2_window2_y + building2_window2_depth, building2_window2_z;                            %3 [30, 80,  0]
                        building2_window2_x, building2_window2_y + building2_window2_depth, building2_window2_z;                                                      %4 [0 , 80,  0]
                        building2_window2_x, building2_window2_y, building2_window2_height + building2_window2_z;                                                     %5 [0 , 20, 20]
                        building2_window2_x + building2_window2_width, building2_window2_y, building2_window2_height + building2_window2_z;                           %6 [30, 20, 20]
                        building2_window2_x + building2_window2_width, building2_window2_y + building2_window2_depth, building2_window2_height + building2_window2_z; %7 [30, 80, 20]
                        building2_window2_x, building2_window2_y + building2_window2_depth, building2_window2_height + building2_window2_z];                          %8 [0 , 80, 20]
building2_window2_vertices(:, 2) = building2_window2_vertices(:,2)+0.01; % this is to stop flickering
% Define window faces
building2_window2_faces = building1_faces;

% Define door 1 dimensions (FRONT DOOR)
building2_door1_x = 21;
building2_door1_y = 36.12 - 0.2;
building2_door1_width = 1;
building2_door1_depth = 0.2;
building2_door1_height = 2.05;
building2_door1_z = building2_z;
building2_door1_vertices = [building2_door1_x, building2_door1_y, building2_door1_z;                                                                          %1 [0 , 20,  0]
                        building2_door1_x + building2_door1_width, building2_door1_y, building2_door1_z;                                                      %2 [30, 20,  0]
                        building2_door1_x + building2_door1_width, building2_door1_y + building2_door1_depth, building2_door1_z;                            %3 [30, 80,  0]
                        building2_door1_x, building2_door1_y + building2_door1_depth, building2_door1_z;                                                      %4 [0 , 80,  0]
                        building2_door1_x, building2_door1_y, building2_door1_height + building2_door1_z;                                                     %5 [0 , 20, 20]
                        building2_door1_x + building2_door1_width, building2_door1_y, building2_door1_height + building2_door1_z;                           %6 [30, 20, 20]
                        building2_door1_x + building2_door1_width, building2_door1_y + building2_door1_depth, building2_door1_height + building2_door1_z; %7 [30, 80, 20]
                        building2_door1_x, building2_door1_y + building2_door1_depth, building2_door1_height + building2_door1_z];                          %8 [0 , 80, 20]
building2_door1_vertices(:, 2) = building2_door1_vertices(:,2)+0.01; % this is to stop flickering
% Define door1 faces
building2_door1_faces = building1_faces;

% Define window 4 (moved to rear) dimensions
building2_window4_x = 21;
building2_window4_y = 25.671-0.4;
building2_window4_width = 1.2;
building2_window4_depth = 0.2;
building2_window4_height = 1.1;
building2_window4_z = 3 +building2_z;
building2_window4_vertices = [building2_window4_x, building2_window4_y, building2_window4_z;                                                                          %1 [0 , 20,  0]
                        building2_window4_x + building2_window4_width, building2_window4_y, building2_window4_z;                                                      %2 [30, 20,  0]
                        building2_window4_x + building2_window4_width, building2_window4_y + building2_window4_depth, building2_window4_z;                            %3 [30, 80,  0]
                        building2_window4_x, building2_window4_y + building2_window4_depth, building2_window4_z;                                                      %4 [0 , 80,  0]
                        building2_window4_x, building2_window4_y, building2_window4_height + building2_window4_z;                                                     %5 [0 , 20, 20]
                        building2_window4_x + building2_window4_width, building2_window4_y, building2_window4_height + building2_window4_z;                           %6 [30, 20, 20]
                        building2_window4_x + building2_window4_width, building2_window4_y + building2_window4_depth, building2_window4_height + building2_window4_z; %7 [30, 80, 20]
                        building2_window4_x, building2_window4_y + building2_window4_depth, building2_window4_height + building2_window4_z];                          %8 [0 , 80, 20]
building2_window4_vertices(:, 2) = building2_window4_vertices(:,2)+0.01; % this is to stop flickering
% Define window faces
building2_window4_faces = building1_faces;

% Define window 5 dimensions
building2_window5_x = 19;
building2_window5_y = 25.671;
building2_window5_width = 1.4; 
building2_window5_depth = 0.2;
building2_window5_height = 2;
building2_window5_z = building2_z + 3;
building2_window5_vertices = [building2_window5_x, building2_window5_y, building2_window5_z;                                                                          %1 []
                        building2_window5_x + building2_window5_width, building2_window5_y, building2_window5_z;                                                      %2 []
                        building2_window5_x + building2_window5_width, building2_window5_y + building2_window5_depth, building2_window5_z;                            %3 []
                        building2_window5_x, building2_window5_y + building2_window5_depth, building2_window5_z;                                                      %4 []
                        building2_window5_x, building2_window5_y, building2_window5_z + building2_window5_height;                                                     %5 []
                        building2_window5_x + building2_window5_width, building2_window5_y, building2_window5_z + building2_window5_height;                           %6 []
                        building2_window5_x + building2_window5_width, building2_window5_y + building2_window5_depth, building2_window5_z + building2_window5_height; %7 []
                        building2_window5_x, building2_window5_y + building2_window5_depth, building2_window5_z + building2_window5_height];                          %8 []
building2_window5_vertices(:, 2) = building2_window5_vertices(:,2)-0.01; % this is to stop flickering
% Define window5 faces
building2_window5_faces = building1_faces;

% Define window 6 dimensions
building2_window6_x = 19;
building2_window6_y = 25.671;
building2_window6_width = 1.4; 
building2_window6_depth = 0.2;
building2_window6_height = 1.1;
building2_window6_z = 1.1 + building2_z;
building2_window6_vertices = [building2_window6_x, building2_window6_y, building2_window6_z;                                                                          %1 []
                        building2_window6_x + building2_window6_width, building2_window6_y, building2_window6_z;                                                      %2 []
                        building2_window6_x + building2_window6_width, building2_window6_y + building2_window6_depth, building2_window6_z;                            %3 []
                        building2_window6_x, building2_window6_y + building2_window6_depth, building2_window6_z;                                                      %4 []
                        building2_window6_x, building2_window6_y, building2_window6_z + building2_window6_height;                                                     %5 []
                        building2_window6_x + building2_window6_width, building2_window6_y, building2_window6_z + building2_window6_height;                           %6 []
                        building2_window6_x + building2_window6_width, building2_window6_y + building2_window6_depth, building2_window6_z + building2_window6_height; %7 []
                        building2_window6_x, building2_window6_y + building2_window6_depth, building2_window6_z + building2_window6_height];                          %8 []
building2_window6_vertices(:, 2) = building2_window6_vertices(:,2)-0.01; % this is to stop flickering
% Define window5 faces
building2_window6_faces = building1_faces;

% Define window S1 (moved to side) dimensions
building2_windowS1_x = 22.634 - 0.2;
building2_windowS1_y = 32;
building2_windowS1_width = 0.2;
building2_windowS1_depth = 0.6;
building2_windowS1_height = 1.5;
building2_windowS1_z = 3 + building2_z;
building2_windowS1_vertices = [building2_windowS1_x, building2_windowS1_y, building2_windowS1_z;                                                                          %1 [0 , 20,  0]
                        building2_windowS1_x + building2_windowS1_width, building2_windowS1_y, building2_windowS1_z;                                                      %2 [30, 20,  0]
                        building2_windowS1_x + building2_windowS1_width, building2_windowS1_y + building2_windowS1_depth, building2_windowS1_z;                            %3 [30, 80,  0]
                        building2_windowS1_x, building2_windowS1_y + building2_windowS1_depth, building2_windowS1_z;                                                      %4 [0 , 80,  0]
                        building2_windowS1_x, building2_windowS1_y, building2_windowS1_height + building2_windowS1_z;                                                     %5 [0 , 20, 20]
                        building2_windowS1_x + building2_windowS1_width, building2_windowS1_y, building2_windowS1_height + building2_windowS1_z;                           %6 [30, 20, 20]
                        building2_windowS1_x + building2_windowS1_width, building2_windowS1_y + building2_windowS1_depth, building2_windowS1_height + building2_windowS1_z; %7 [30, 80, 20]
                        building2_windowS1_x, building2_windowS1_y + building2_windowS1_depth, building2_windowS1_height + building2_windowS1_z];                          %8 [0 , 80, 20]
building2_windowS1_vertices(:, 1) = building2_windowS1_vertices(:,1)+0.01; % this is to stop flickering
% Define window S1 faces
building2_windowS1_faces = building1_faces;

% Define window S2 (moved to side) dimensions
building2_windowS2_x = 22.634 - 0.2;
building2_windowS2_y = 34.1;
building2_windowS2_width = 0.2; 
building2_windowS2_depth = 0.6;
building2_windowS2_height = 1.5;
building2_windowS2_z = building2_z + 3;
building2_windowS2_vertices = [building2_windowS2_x, building2_windowS2_y, building2_windowS2_z;                                                                          %1 []
                        building2_windowS2_x + building2_windowS2_width, building2_windowS2_y, building2_windowS2_z;                                                      %2 []
                        building2_windowS2_x + building2_windowS2_width, building2_windowS2_y + building2_windowS2_depth, building2_windowS2_z;                            %3 []
                        building2_windowS2_x, building2_windowS2_y + building2_windowS2_depth, building2_windowS2_z;                                                      %4 []
                        building2_windowS2_x, building2_windowS2_y, building2_windowS2_z + building2_windowS2_height;                                                     %5 []
                        building2_windowS2_x + building2_windowS2_width, building2_windowS2_y, building2_windowS2_z + building2_windowS2_height;                           %6 []
                        building2_windowS2_x + building2_windowS2_width, building2_windowS2_y + building2_windowS2_depth, building2_windowS2_z + building2_windowS2_height; %7 []
                        building2_windowS2_x, building2_windowS2_y + building2_windowS2_depth, building2_windowS2_z + building2_windowS2_height];                          %8 []
building2_windowS2_vertices(:, 1) = building2_windowS2_vertices(:,1)+0.01; % this is to stop flickering
% Define window S2 faces
building2_windowS2_faces = building1_faces;

% Define window S3 (moved to side) dimensions
building2_windowS3_x = 22.634 - 0.2;
building2_windowS3_y = 27.8;
building2_windowS3_width = 0.2; 
building2_windowS3_depth = 0.6;
building2_windowS3_height = 1.4;
building2_windowS3_z = building2_z + 0.6;
building2_windowS3_vertices = [building2_windowS3_x, building2_windowS3_y, building2_windowS3_z;                                                                          %1 []
                        building2_windowS3_x + building2_windowS3_width, building2_windowS3_y, building2_windowS3_z;                                                      %2 []
                        building2_windowS3_x + building2_windowS3_width, building2_windowS3_y + building2_windowS3_depth, building2_windowS3_z;                            %3 []
                        building2_windowS3_x, building2_windowS3_y + building2_windowS3_depth, building2_windowS3_z;                                                      %4 []
                        building2_windowS3_x, building2_windowS3_y, building2_windowS3_z + building2_windowS3_height;                                                     %5 []
                        building2_windowS3_x + building2_windowS3_width, building2_windowS3_y, building2_windowS3_z + building2_windowS3_height;                           %6 []
                        building2_windowS3_x + building2_windowS3_width, building2_windowS3_y + building2_windowS3_depth, building2_windowS3_z + building2_windowS3_height; %7 []
                        building2_windowS3_x, building2_windowS3_y + building2_windowS3_depth, building2_windowS3_z + building2_windowS3_height];                          %8 []
building2_windowS3_vertices(:, 1) = building2_windowS3_vertices(:,1)+0.01; % this is to stop flickering
% Define window S3 faces
building2_windowS3_faces = building1_faces;

% Define window S4 SIDE DOOR (new side) dimensions
building2_windowS4_x = 22.634 - 0.2;
building2_windowS4_y = 28.9;
building2_windowS4_width = 0.2;
building2_windowS4_depth = 1.2;
building2_windowS4_height = 2;
building2_windowS4_z =  building2_z;
building2_windowS4_vertices = [building2_windowS4_x, building2_windowS4_y, building2_windowS4_z;                                                                          %1 [0 , 20,  0]
                        building2_windowS4_x + building2_windowS4_width, building2_windowS4_y, building2_windowS4_z;                                                      %2 [30, 20,  0]
                        building2_windowS4_x + building2_windowS4_width, building2_windowS4_y + building2_windowS4_depth, building2_windowS4_z;                            %3 [30, 80,  0]
                        building2_windowS4_x, building2_windowS4_y + building2_windowS4_depth, building2_windowS4_z;                                                      %4 [0 , 80,  0]
                        building2_windowS4_x, building2_windowS4_y, building2_windowS4_height + building2_windowS4_z;                                                     %5 [0 , 20, 20]
                        building2_windowS4_x + building2_windowS4_width, building2_windowS4_y, building2_windowS4_height + building2_windowS4_z;                           %6 [30, 20, 20]
                        building2_windowS4_x + building2_windowS4_width, building2_windowS4_y + building2_windowS4_depth, building2_windowS4_height + building2_windowS4_z; %7 [30, 80, 20]
                        building2_windowS4_x, building2_windowS4_y + building2_windowS4_depth, building2_windowS4_height + building2_windowS4_z];                          %8 [0 , 80, 20]
building2_windowS4_vertices(:, 1) = building2_windowS4_vertices(:,1)+0.01; % this is to stop flickering
% Define window S4 faces
building2_windowS4_faces = building1_faces;

% Define window S5 (new side) dimensions
building2_windowS5_x = 22.634 - 0.2;
building2_windowS5_y = 32;
building2_windowS5_width = 0.2; 
building2_windowS5_depth = 0.6;
building2_windowS5_height = 2;
building2_windowS5_z = building2_z;
building2_windowS5_vertices = [building2_windowS5_x, building2_windowS5_y, building2_windowS5_z;                                                                          %1 []
                        building2_windowS5_x + building2_windowS5_width, building2_windowS5_y, building2_windowS5_z;                                                      %2 []
                        building2_windowS5_x + building2_windowS5_width, building2_windowS5_y + building2_windowS5_depth, building2_windowS5_z;                            %3 []
                        building2_windowS5_x, building2_windowS5_y + building2_windowS5_depth, building2_windowS5_z;                                                      %4 []
                        building2_windowS5_x, building2_windowS5_y, building2_windowS5_z + building2_windowS5_height;                                                     %5 []
                        building2_windowS5_x + building2_windowS5_width, building2_windowS5_y, building2_windowS5_z + building2_windowS5_height;                           %6 []
                        building2_windowS5_x + building2_windowS5_width, building2_windowS5_y + building2_windowS5_depth, building2_windowS5_z + building2_windowS5_height; %7 []
                        building2_windowS5_x, building2_windowS5_y + building2_windowS5_depth, building2_windowS5_z + building2_windowS5_height];                          %8 []
building2_windowS5_vertices(:, 1) = building2_windowS5_vertices(:,1)+0.01; % this is to stop flickering
% Define window S5 faces
building2_windowS5_faces = building1_faces;

% Define window S6 (new side) dimensions
building2_windowS6_x = 22.634 - 0.2;
building2_windowS6_y = 34.1;
building2_windowS6_width = 0.2; 
building2_windowS6_depth = 0.6;
building2_windowS6_height = 2;
building2_windowS6_z = building2_z;
building2_windowS6_vertices = [building2_windowS6_x, building2_windowS6_y, building2_windowS6_z;                                                                          %1 []
                        building2_windowS6_x + building2_windowS6_width, building2_windowS6_y, building2_windowS6_z;                                                      %2 []
                        building2_windowS6_x + building2_windowS6_width, building2_windowS6_y + building2_windowS6_depth, building2_windowS6_z;                            %3 []
                        building2_windowS6_x, building2_windowS6_y + building2_windowS6_depth, building2_windowS6_z;                                                      %4 []
                        building2_windowS6_x, building2_windowS6_y, building2_windowS6_z + building2_windowS6_height;                                                     %5 []
                        building2_windowS6_x + building2_windowS6_width, building2_windowS6_y, building2_windowS6_z + building2_windowS6_height;                           %6 []
                        building2_windowS6_x + building2_windowS6_width, building2_windowS6_y + building2_windowS6_depth, building2_windowS6_z + building2_windowS6_height; %7 []
                        building2_windowS6_x, building2_windowS6_y + building2_windowS6_depth, building2_windowS6_z + building2_windowS6_height];                          %8 []
building2_windowS6_vertices(:, 1) = building2_windowS6_vertices(:,1)+0.01; % this is to stop flickering
% Define window S6 faces
building2_windowS6_faces = building1_faces;

% Add a floor (PLOT 2 FLOOR) with material 'carpet'
surfaces(8).name = 'PLOT 2 floor';
surfaces(8).position.x = [18.32, 22.634, 22.634, 18.32];
surfaces(8).position.y = [25.671, 25.671, 36.12, 36.12];
surfaces(8).position.z = [building2_z, building2_z,building2_z,building2_z];
surfaces(8).sabine_coefficient = sabine_coefficients.Carpet;
surfaces(8).material = 'Carpet';
% Draw PLOT 2 floor
patch('Parent', street_group,'XData', surfaces(8).position.x, 'YData', surfaces(8).position.y, 'ZData', surfaces(8).position.z, 'FaceColor', 'b');

% Define ramp 1a dimensions
building2_ramp1a_x = 22.634;
building2_ramp1a_y = 26.2;
building2_ramp1a_width = 1.5; 
building2_ramp1a_depth = 3.9;
building2_ramp1a_z = building2_z;
building2_ramp1a_z2 = calculate_z_positions(building2_ramp1a_x, building2_ramp1a_y, dimensions);
building2_ramp1a_vertices = [building2_ramp1a_x, building2_ramp1a_y, building2_ramp1a_z2;                                                                          %1 []
                        building2_ramp1a_x + building2_ramp1a_width, building2_ramp1a_y, building2_ramp1a_z2;                                                      %2 []
                        building2_ramp1a_x + building2_ramp1a_width, building2_ramp1a_y + building2_ramp1a_depth, building2_ramp1a_z2;                            %3 []
                        building2_ramp1a_x, building2_ramp1a_y + building2_ramp1a_depth, building2_ramp1a_z2;                                                      %4 []
                        building2_ramp1a_x, building2_ramp1a_y, building2_ramp1a_z;                                                     %5 []
                        building2_ramp1a_x + building2_ramp1a_width, building2_ramp1a_y, building2_ramp1a_z;                           %6 []
                        building2_ramp1a_x + building2_ramp1a_width, building2_ramp1a_y + building2_ramp1a_depth, building2_ramp1a_z; %7 []
                        building2_ramp1a_x, building2_ramp1a_y + building2_ramp1a_depth, building2_ramp1a_z];                          %8 []
building2_ramp1a_vertices(:, 2) = building2_ramp1a_vertices(:,2)+0.01; % this is to stop flickering
% Define ramp 1a faces
building2_ramp1a_faces = building1_faces;

% Define ramp 1b dimensions
building2_ramp1b_x = 24.134;
building2_ramp1b_y = 26.2;
building2_ramp1b_width = 1.5; 
building2_ramp1b_depth = 7.25;
building2_ramp1b_z = building2_z;
building2_ramp1b_z2 = calculate_z_positions(building2_ramp1b_x, building2_ramp1b_y, dimensions);
building2_ramp1b_vertices = [building2_ramp1b_x, building2_ramp1b_y, building2_ramp1b_z2;                                                                          %1 []
                        building2_ramp1b_x + building2_ramp1b_width, building2_ramp1b_y, building2_ramp1b_z2;                                                      %2 []
                        building2_ramp1b_x + building2_ramp1b_width, building2_ramp1b_y + building2_ramp1b_depth, building2_ramp1b_z2;                            %3 []
                        building2_ramp1b_x, building2_ramp1b_y + building2_ramp1b_depth, building2_ramp1b_z2;                                                      %4 []
                        building2_ramp1b_x, building2_ramp1b_y, building2_ramp1b_z;                                                     %5 []
                        building2_ramp1b_x + building2_ramp1b_width, building2_ramp1b_y, building2_ramp1b_z;                           %6 []
                        building2_ramp1b_x + building2_ramp1b_width, building2_ramp1b_y + building2_ramp1b_depth, building2_ramp1b_z2; %7 []
                        building2_ramp1b_x, building2_ramp1b_y + building2_ramp1b_depth, building2_ramp1b_z2];                          %8 []
building2_ramp1b_vertices(:, 2) = building2_ramp1b_vertices(:,2)+0.01; % this is to stop flickering
% Define ramp 1b faces
building2_ramp1b_faces = building1_faces;

% Define ramp 2a dimensions
building2_ramp2a_x = 20;
building2_ramp2a_y = 36.13;
building2_ramp2a_width = 2; 
building2_ramp2a_depth = 1.5;
building2_ramp2a_height = 0.2;
building2_ramp2a_z = building1_z;
building2_ramp2a_vertices = [building2_ramp2a_x, building2_ramp2a_y, building2_ramp2a_z;                                                                          %1 []
                        building2_ramp2a_x + building2_ramp2a_width, building2_ramp2a_y, building2_ramp2a_z;                                                      %2 []
                        building2_ramp2a_x + building2_ramp2a_width, building2_ramp2a_y + building2_ramp2a_depth, building2_ramp2a_z;                            %3 []
                        building2_ramp2a_x, building2_ramp2a_y + building2_ramp2a_depth, building2_ramp2a_z;                                                      %4 []
                        building2_ramp2a_x, building2_ramp2a_y, building2_ramp2a_z + building2_ramp2a_height;                                                     %5 []
                        building2_ramp2a_x + building2_ramp2a_width, building2_ramp2a_y, building2_ramp2a_z + building2_ramp2a_height;                           %6 []
                        building2_ramp2a_x + building2_ramp2a_width, building2_ramp2a_y + building2_ramp2a_depth, building2_ramp2a_z + building2_ramp2a_height; %7 []
                        building2_ramp2a_x, building2_ramp2a_y + building2_ramp2a_depth, building2_ramp2a_z + building2_ramp2a_height];                          %8 []
building2_ramp2a_vertices(:, 2) = building2_ramp2a_vertices(:,2)+0.01; % this is to stop flickering
% Define ramp 1a faces
building2_ramp2a_faces = building1_faces;

% Define ramp 2b dimensions
building2_ramp2b_x = 20.35;
building2_ramp2b_y = 37.64;
building2_ramp2b_width = 1.3; 
building2_ramp2b_depth = 1;
building2_ramp2b_height = 0.2;
building2_ramp2b_z = building1_z;
building2_ramp2b_z2 = calculate_z_positions(building2_ramp2b_x, building2_ramp2b_y, dimensions);
building2_ramp2b_vertices = [building2_ramp2b_x, building2_ramp2b_y, building2_ramp2b_z;                                                                          %1 []
                        building2_ramp2b_x + building2_ramp2b_width, building2_ramp2b_y, building2_ramp2b_z;                                                      %2 []
                        building2_ramp2b_x + building2_ramp2b_width, building2_ramp2b_y + building2_ramp2b_depth, building2_ramp2b_z2;                            %3 []
                        building2_ramp2b_x, building2_ramp2b_y + building2_ramp2b_depth, building2_ramp2b_z2;                                                      %4 []                    
                        building2_ramp2b_x, building2_ramp2b_y, building2_ramp2b_z + building2_ramp2b_height;                                                     %5 []
                        building2_ramp2b_x + building2_ramp2b_width, building2_ramp2b_y, building2_ramp2b_z + building2_ramp2b_height;                           %6 []
                        building2_ramp2b_x + building2_ramp2b_width, building2_ramp2b_y + building2_ramp2b_depth, building2_ramp2b_z2 + building2_ramp2b_height; %7 []
                        building2_ramp2b_x, building2_ramp2b_y + building2_ramp2b_depth, building2_ramp2b_z2 + building2_ramp2b_height];                          %8 []
building2_ramp2b_vertices(:, 2) = building2_ramp2b_vertices(:,2)+0.01; % this is to stop flickering
% Define door1 faces
building2_ramp2b_faces = building1_faces;


% Combine building and window vertices and faces
building2_all_vertices = [building2_vertices; 
                          building2_window1_vertices;
                          building2_window2_vertices;
                          building2_windowS1_vertices;
                          building2_window4_vertices;
                          building2_window5_vertices;
                          building2_window6_vertices;
                          building2_windowS2_vertices;
                          building2_windowS3_vertices;
                          building2R_vertices;
                          building2_door1_vertices;
                          building2base_vertices;
                          building2_windowS4_vertices;
                          building2_windowS5_vertices;
                          building2_windowS6_vertices;
                          building2_ramp1a_vertices;
                          building2_ramp1b_vertices;
                          building2_ramp2a_vertices;
                          building2_ramp2b_vertices;
                          ];

offset_window1 = size(building2_vertices, 1);
offset_window2 = offset_window1 + size(building2_window1_vertices, 1);
offset_window3 = offset_window2 + size(building2_window2_vertices, 1);
offset_window4 = offset_window3 + size(building2_windowS1_vertices, 1);
offset_window5 = offset_window4 + size(building2_window4_vertices, 1);
offset_window6 = offset_window5 + size(building2_window5_vertices, 1);
offset_window7 = offset_window6 + size(building2_window6_vertices, 1);
offset_window8 = offset_window7 + size(building2_windowS2_vertices, 1);
offset_roof = offset_window8 + size(building2_windowS3_vertices, 1);
offset_door1 = offset_roof + size(building2R_vertices, 1);
offset_base = offset_door1 + size(building2_door1_vertices, 1);
offset_windowS4 = offset_base + size(building2base_vertices, 1);
offset_windowS5 = offset_windowS4 + size(building2_windowS4_vertices, 1);
offset_windowS6 = offset_windowS5 + size(building2_windowS5_vertices, 1);
offset_ramp1a = offset_windowS6 + size(building2_windowS6_vertices, 1);
offset_ramp1b = offset_ramp1a + size(building2_ramp1a_vertices, 1);
offset_ramp2a = offset_ramp1b + size(building2_ramp1b_vertices, 1);
offset_ramp2b = offset_ramp2a + size(building2_ramp2a_vertices, 1);

building2_all_faces = [building2_faces; 
                       building2_window1_faces + offset_window1;
                       building2_window2_faces + offset_window2;
                       building2_windowS1_faces + offset_window3;
                       building2_window4_faces + offset_window4;
                       building2_window5_faces + offset_window5;
                       building2_window6_faces + offset_window6;
                       building2_windowS2_faces + offset_window7;
                       building2_windowS3_faces + offset_window8;
                       building2R_faces + offset_roof;
                       building2_door1_faces + offset_door1;
                       building2base_faces + offset_base;
                       building2_windowS4_faces + offset_windowS4;
                       building2_windowS5_faces + offset_windowS5;
                       building2_windowS6_faces + offset_windowS6;
                       building2_ramp1a_faces + offset_ramp1a;
                       building2_ramp1b_faces + offset_ramp1b;
                       building2_ramp2a_faces + offset_ramp2a;
                       building2_ramp2b_faces + offset_ramp2b;
                       ];
% Define the colours
building2_colors = [repmat([1, 0.6, 0.2], size(building2_faces, 1), 1);
                    repmat([0.9, 0.9, 0.9], size(building2_window1_faces, 1), 1);
                    repmat([0.9, 0.9, 0.9], size(building2_window2_faces, 1), 1);
                    repmat([0.9, 0.9, 0.9], size(building2_windowS1_faces, 1), 1);
                    repmat([0.9, 0.9, 0.9], size(building2_window4_faces, 1), 1);
                    repmat([0.9, 0.9, 0.9], size(building2_window5_faces, 1), 1);
                    repmat([1, 1, 1], size(building2_window6_faces, 1), 1);
                    repmat([0.9, 0.9, 0.9], size(building2_windowS2_faces, 1), 1);
                    repmat([0.9, 0.9, 0.9], size(building2_windowS3_faces, 1), 1);
                    repmat([0.5, 0.5, 0.5], size(building2R_faces, 1), 1);
                    repmat([1, 1, 1], size(building2_door1_faces, 1), 1);
                    repmat([0.5, 0.5, 0.5], size(building2base_faces, 1), 1);
                    repmat([0.9, 0.9, 0.9], size(building2_windowS4_faces, 1), 1);
                    repmat([0.9, 0.9, 0.9], size(building2_windowS5_faces, 1), 1);
                    repmat([0.9, 0.9, 0.9], size(building2_windowS6_faces, 1), 1);
                    repmat([0.8, 0.7, 0.5], size(building2_ramp1a_faces, 1), 1);
                    repmat([0.8, 0.7, 0.5], size(building2_ramp1b_faces, 1), 1);
                    repmat([1, 1, 1], size(building2_ramp2a_faces, 1), 1);
                    repmat([1, 1, 1], size(building2_ramp2b_faces, 1), 1);
                    ];

% 'PLOT 2' building with 'concrete'
buildings(2) = struct('name', 'PLOT 2', 'vertices', building2_vertices, 'faces', building2_faces, 'material', 'Concrete', 'sabine_coefficient', sabine_coefficients.Concrete);
buildings(3) = struct('name', 'PLOT 2 Base', 'vertices', building2base_vertices, 'faces', building2base_faces, 'material', 'Concrete', 'sabine_coefficient', sabine_coefficients.Concrete);
% 'PLOT 2' Window with 'glass'
windows(9) = struct('name', 'PLOT 2 Window 1', 'vertices', building2_window1_vertices, 'faces', building2_window1_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(10) = struct('name', 'PLOT 2 Window 2', 'vertices', building2_window2_vertices, 'faces', building2_window2_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(11) = struct('name', 'PLOT 2 Window 3', 'vertices', building2_window5_vertices, 'faces', building2_window5_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(12) = struct('name', 'PLOT 2 Window 4', 'vertices', building2_window4_vertices, 'faces', building2_window4_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(13) = struct('name', 'PLOT 2 Side Window 1', 'vertices', building2_windowS1_vertices, 'faces', building2_windowS1_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(14) = struct('name', 'PLOT 2 Side Window 2', 'vertices', building2_windowS2_vertices, 'faces', building2_windowS2_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(15) = struct('name', 'PLOT 2 Side Window 3', 'vertices', building2_windowS3_vertices, 'faces', building2_windowS3_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(16) = struct('name', 'PLOT 2 Side Window 4', 'vertices', building2_windowS4_vertices, 'faces', building2_windowS4_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(17) = struct('name', 'PLOT 2 Side Window 5', 'vertices', building2_windowS5_vertices, 'faces', building2_windowS5_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(18) = struct('name', 'PLOT 2 Side Window 6', 'vertices', building2_windowS6_vertices, 'faces', building2_windowS6_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
doors(3) = struct('name', 'PLOT 2 Door 1', 'vertices', building2_door1_vertices, 'faces', building2_door1_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
doors(4) = struct('name', 'PLOT 2 Door 2', 'vertices', building2_window6_vertices, 'faces', building2_window6_faces, 'material', 'Wood', 'sabine_coefficient', sabine_coefficients.Wood);
roofs(2) = struct('name', 'PLOT 2 Roof 1', 'vertices', building2R_vertices, 'faces', building2R_faces, 'material', 'Tiles', 'sabine_coefficient', sabine_coefficients.Tiles);
ramps(1) = struct('name', 'PLOT 2 Ramp 1a', 'vertices', building2_ramp1a_vertices, 'faces', building2_ramp1a_faces, 'material', 'Metal', 'sabine_coefficient', sabine_coefficients.Metal);
ramps(2) = struct('name', 'PLOT 2 Ramp 1b', 'vertices', building2_ramp1b_vertices, 'faces', building2_ramp1b_faces, 'material', 'Metal', 'sabine_coefficient', sabine_coefficients.Metal);
ramps(3) = struct('name', 'PLOT 2 Ramp 2a', 'vertices', building2_ramp2a_vertices, 'faces', building2_ramp2a_faces, 'material', 'Concrete', 'sabine_coefficient', sabine_coefficients.Concrete);
ramps(4) = struct('name', 'PLOT 2 Ramp 2b', 'vertices', building2_ramp2b_vertices, 'faces', building2_ramp2b_faces, 'material', 'Concrete', 'sabine_coefficient', sabine_coefficients.Concrete);

% Combine these into a higher-order struct
world_objects(2).name = 'PLOT 2';
world_objects(2).components(1) = buildings(2);
world_objects(2).components(2) = buildings(3);
world_objects(2).components(3) = windows(9);
world_objects(2).components(4) = windows(10);
world_objects(2).components(5) = windows(11);
world_objects(2).components(6) = windows(12);
world_objects(2).components(7) = windows(13);
world_objects(2).components(8) = windows(14);
world_objects(2).components(9) = windows(15);
world_objects(2).components(10) = windows(16);
world_objects(2).components(11) = windows(17);
world_objects(2).components(12) = windows(18);
world_objects(2).components(13) = doors(3);
world_objects(2).components(14) = doors(4);
world_objects(2).components(15) = roofs(2);
world_objects(2).components(16) = ramps(1);
world_objects(2).components(17) = ramps(2);
world_objects(2).components(18) = ramps(3);
world_objects(2).components(19) = ramps(4);
% Create the patch object
patch('Parent', building_group,'Vertices', building2_all_vertices, 'Faces', building2_all_faces, 'FaceVertexCData', building2_colors, 'FaceColor', 'flat');

%% Creating 'TERRACE 1' building
building3_x = 10;
building3_y = 45.72;
building3_width = 5.09; %15.27;
building3_depth = 8.28;
building3_z = 0.2;
building3_height = building3_z + 4.65;
building3_vertices = [building3_x, building3_y, building3_z - 0.01;
                      building3_x + building3_width, building3_y, building3_z - 0.01;
                      building3_x + building3_width, building3_y + building3_depth, building3_z - 0.01;
                      building3_x, building3_y + building3_depth, building3_z - 0.01;
                      building3_x, building3_y, building3_height;
                      building3_x + building3_width, building3_y, building3_height;
                      building3_x + building3_width, building3_y + building3_depth, building3_height;
                      building3_x, building3_y + building3_depth, building3_height];
building3_faces = building1_faces;

% Define TERRACE 1 base dimensions
building3base_x = 10;
building3base_y = 45.72;
building3base_width = 5.09;
building3base_depth = 8.28;
building3base_z = dimensions.zMin_x;
building3base_height = building3_z;
building3base_vertices = [building3base_x, building3base_y, building3base_z;                                              %1 [0 , 20,  -0.01]
                      building3base_x + building3base_width, building3base_y, building3base_z;                            %2 [30, 20,  -0.01]
                      building3base_x + building3base_width, building3base_y + building3base_depth, building3base_z;      %3 [30, 80,  -0.01]
                      building3base_x, building3base_y + building3base_depth, building3base_z;                            %4 [0 , 80,  -0.01]
                      building3base_x, building3base_y, building3base_height;                                             %5 [0 , 20, 20]
                      building3base_x + building3base_width, building3base_y, building3base_height;                       %6 [30, 20, 20]
                      building3base_x + building3base_width, building3base_y + building3base_depth, building3base_height; %7 [30, 80, 20]
                      building3base_x, building3base_y + building3base_depth, building3base_height];                      %8 [0 , 80, 20]
% Define building1 base faces
building3base_faces = building1_faces;

% ROOF of TERRACE 1
building3R_x = 9.80;
building3R_y = 45.52;
building3R_width = 5.223; %15.67;
building3R_depth = 8.68;
building3R_height = building3_z + 8;
building3R_vertices = [building3R_x, building3R_y, building3_height;  
                       building3R_x + building3R_width, building3R_y, building3_height;  
                       building3R_x + building3R_width, building3R_y + building3R_depth, building3_height; 
                       building3R_x, building3R_y + building3R_depth, building3_height; 
                       building3R_x, building3R_y + building3R_depth/2, building3R_height; 
                       building3R_x + building3R_width, building3R_y + building3R_depth/2, building3R_height;  
                       building3R_x, building3R_y + building3R_depth, building3_height;  
                       building3R_x + building3R_width, building3R_y + building3R_depth, building3_height]; 
building3R_faces = [1 2 6 5;  % Side 1
                    3 4 5 6;  % Side 2
                    1 4 5 5;  % Front triangle
                    2 3 6 6;  % Rear triangle
                    1 2 3 4]; % Bottom

% Define TERRACE 1 Door 1 dimensions
building3_door1_x = 10.60;
building3_door1_y = 45.72;
building3_door1_width = 1; 
building3_door1_depth = 0.2;
building3_door1_z = building3_z; 
building3_door1_height = 2.05 + building3_door1_z;
% Define door1 vertices
building3_door1_vertices = [building3_door1_x, building3_door1_y, building3_door1_z;
                        building3_door1_x + building3_door1_width, building3_door1_y, building3_door1_z;
                        building3_door1_x + building3_door1_width, building3_door1_y + building3_door1_depth, building3_door1_z;
                        building3_door1_x, building3_door1_y + building3_door1_depth, building3_door1_z;
                        building3_door1_x, building3_door1_y, building3_door1_height;
                        building3_door1_x + building3_door1_width, building3_door1_y, building3_door1_height;
                        building3_door1_x + building3_door1_width, building3_door1_y + building3_door1_depth, building3_door1_height;
                        building3_door1_x, building3_door1_y + building3_door1_depth, building3_door1_height];
building3_door1_vertices(:, 2) = building3_door1_vertices(:,2)-0.01; % This is to stop flickering
% Define door1 faces
building3_door1_faces = building1_faces;

% Define TERRACE 1 door 2 dimensions
building3_door2_x = 10.70;
building3_door2_y = 54 - 0.2;
building3_door2_width = 1; 
building3_door2_depth = 0.2;
building3_door2_z = building3_z + 0.1; 
building3_door2_height = 2.15 + building3_door2_z;
% Define door 2 vertices
building3_door2_vertices = [building3_door2_x, building3_door2_y, building3_door2_z;
                        building3_door2_x + building3_door2_width, building3_door2_y, building3_door2_z;
                        building3_door2_x + building3_door2_width, building3_door2_y + building3_door2_depth, building3_door2_z;
                        building3_door2_x, building3_door2_y + building3_door2_depth, building3_door2_z;
                        building3_door2_x, building3_door2_y, building3_door2_height;
                        building3_door2_x + building3_door2_width, building3_door2_y, building3_door2_height;
                        building3_door2_x + building3_door2_width, building3_door2_y + building3_door2_depth, building3_door2_height;
                        building3_door2_x, building3_door2_y + building3_door2_depth, building3_door2_height];
building3_door2_vertices(:, 2) = building3_door2_vertices(:,2)+0.01; % This is to stop flickering
% Define door 2 faces
building3_door2_faces = building1_faces;

% Define TERRACE 1 window 1 dimensions
building3_window1_x = 12.42;
building3_window1_y = 45.72;
building3_window1_width = 1.4; 
building3_window1_depth = 0.2;
building3_window1_z = building3_z + 0.75; 
building3_window1_height = 1.3 + building3_window1_z ;
% Define window1 vertices 
building3_window1_vertices = [building3_window1_x, building3_window1_y, building3_window1_z;
                   building3_window1_x + building3_window1_width, building3_window1_y, building3_window1_z;
                   building3_window1_x + building3_window1_width, building3_window1_y + building3_window1_depth, building3_window1_z;
                   building3_window1_x, building3_window1_y + building3_window1_depth, building3_window1_z;
                   building3_window1_x, building3_window1_y, building3_window1_height;
                   building3_window1_x + building3_window1_width, building3_window1_y, building3_window1_height;
                   building3_window1_x + building3_window1_width, building3_window1_y + building3_window1_depth, building3_window1_height;
                   building3_window1_x, building3_window1_y + building3_window1_depth, building3_window1_height];
building3_window1_vertices(:, 2) = building3_window1_vertices(:,2)-0.01; % This is to stop flickering
% Define window 1 faces
building3_window1_faces = building1_faces;

% Define TERRACE 1 window 2 dimensions
building3_window2_x = 12.42;
building3_window2_y = 45.72;
building3_window2_width = 1.4; 
building3_window2_depth = 0.2;
building3_window2_z = building3_z + 3.4; 
building3_window2_height = 1.2 + building3_window2_z ;
% Define window 2 vertices
building3_window2_vertices = [building3_window2_x, building3_window2_y, building3_window2_z;
                   building3_window2_x + building3_window2_width, building3_window2_y, building3_window2_z;
                   building3_window2_x + building3_window2_width, building3_window2_y + building3_window2_depth, building3_window2_z;
                   building3_window2_x, building3_window2_y + building3_window2_depth, building3_window2_z;
                   building3_window2_x, building3_window2_y, building3_window2_height;
                   building3_window2_x + building3_window2_width, building3_window2_y, building3_window2_height;
                   building3_window2_x + building3_window2_width, building3_window2_y + building3_window2_depth, building3_window2_height;
                   building3_window2_x, building3_window2_y + building3_window2_depth, building3_window2_height];
building3_window2_vertices(:, 2) = building3_window2_vertices(:,2)-0.01; % This is to stop flickering
% Define window 2 faces
building3_window2_faces = building1_faces;

% Define TERRACE 1 window 3 dimensions
building3_window3_x = 12.67;
building3_window3_y = 54 - 0.2;
building3_window3_width = 1.2; 
building3_window3_depth = 0.2;
building3_window3_z = building3_z + 3.5; 
building3_window3_height = 1.1 + building3_window3_z ;
% Define window 3 vertices 
building3_window3_vertices = [building3_window3_x, building3_window3_y, building3_window3_z;
                   building3_window3_x + building3_window3_width, building3_window3_y, building3_window3_z;
                   building3_window3_x + building3_window3_width, building3_window3_y + building3_window3_depth, building3_window3_z;
                   building3_window3_x, building3_window3_y + building3_window3_depth, building3_window3_z;
                   building3_window3_x, building3_window3_y, building3_window3_height;
                   building3_window3_x + building3_window3_width, building3_window3_y, building3_window3_height;
                   building3_window3_x + building3_window3_width, building3_window3_y + building3_window3_depth, building3_window3_height;
                   building3_window3_x, building3_window3_y + building3_window3_depth, building3_window3_height];
building3_window3_vertices(:, 2) = building3_window3_vertices(:,2)+0.01; % This is to stop flickering
% Define window 3 faces
building3_window3_faces = building1_faces;

% Define TERRACE 1 window 4 dimensions
building3_window4_x = 10.70;
building3_window4_y = 54 - 0.2;
building3_window4_width = 0.9; 
building3_window4_depth = 0.2;
building3_window4_z = building3_z + 3.5; 
building3_window4_height = 1.1 + building3_window4_z ;
% Define window 4 vertices 
building3_window4_vertices = [building3_window4_x, building3_window4_y, building3_window4_z;
                   building3_window4_x + building3_window4_width, building3_window4_y, building3_window4_z;
                   building3_window4_x + building3_window4_width, building3_window4_y + building3_window4_depth, building3_window4_z;
                   building3_window4_x, building3_window4_y + building3_window4_depth, building3_window4_z;
                   building3_window4_x, building3_window4_y, building3_window4_height;
                   building3_window4_x + building3_window4_width, building3_window4_y, building3_window4_height;
                   building3_window4_x + building3_window4_width, building3_window4_y + building3_window4_depth, building3_window4_height;
                   building3_window4_x, building3_window4_y + building3_window4_depth, building3_window4_height];
building3_window4_vertices(:, 2) = building3_window4_vertices(:,2)+0.01; % This is to stop flickering
% Define window 4 faces
building3_window4_faces = building1_faces;

% Define window 5 dimensions
building3_window5_x = 12.60;
building3_window5_y = 54 - 0.2;
building3_window5_width = 1.2; 
building3_window5_depth = 0.2;
building3_window5_z = 1.25 + building3_z ; 
building3_window5_height = 1 + building3_window5_z ;
% Define window 5 vertices 
building3_window5_vertices = [building3_window5_x, building3_window5_y, building3_window5_z;
                   building3_window5_x + building3_window5_width, building3_window5_y, building3_window5_z;
                   building3_window5_x + building3_window5_width, building3_window5_y + building3_window5_depth, building3_window5_z;
                   building3_window5_x, building3_window5_y + building3_window5_depth, building3_window5_z;
                   building3_window5_x, building3_window5_y, building3_window5_height;
                   building3_window5_x + building3_window5_width, building3_window5_y, building3_window5_height;
                   building3_window5_x + building3_window5_width, building3_window5_y + building3_window5_depth, building3_window5_height;
                   building3_window5_x, building3_window5_y + building3_window5_depth, building3_window5_height];
building3_window5_vertices(:, 2) = building3_window5_vertices(:,2)+0.01; % This is to stop flickering
% Define window 5 faces
building3_window5_faces = building1_faces;

% Define window 6 dimensions (side window)
building3_window6_x = 10-0.2;
building3_window6_y = 49.5;
building3_window6_width = 0.2; 
building3_window6_depth = 0.90;
building3_window6_z = 3.77 + building3_z; 
building3_window6_height = 1.16 + building3_window6_z ;

% Define window 6 vertices 
building3_window6_vertices = [building3_window6_x, building3_window6_y, building3_window6_z;
                   building3_window6_x + building3_window6_width, building3_window6_y, building3_window6_z;
                   building3_window6_x + building3_window6_width, building3_window6_y + building3_window6_depth, building3_window6_z;
                   building3_window6_x, building3_window6_y + building3_window6_depth, building3_window6_z;
                   building3_window6_x, building3_window6_y, building3_window6_height;
                   building3_window6_x + building3_window6_width, building3_window6_y, building3_window6_height;
                   building3_window6_x + building3_window6_width, building3_window6_y + building3_window6_depth, building3_window6_height;
                   building3_window6_x, building3_window6_y + building3_window6_depth, building3_window6_height];
building3_window6_vertices(:, 1) = building3_window6_vertices(:,1)-0.01; % This is to stop flickering
% Define window 6 faces
building3_window6_faces = building1_faces;

% Add a floor (TERRACE 1 floor) with material 'carpet'
surfaces(9).name = 'TERRACE 1 floor';
surfaces(9).position.x = [10, 15.09, 15.09, 10];
surfaces(9).position.y = [45.72, 45.72, 54, 54];
surfaces(9).position.z = [building3_z, building3_z, building3_z, building3_z];
surfaces(9).sabine_coefficient = sabine_coefficients.Carpet;
surfaces(9).material = 'Carpet';
% Draw M&S floor
patch('Parent', street_group,'XData', surfaces(9).position.x, 'YData', surfaces(9).position.y, 'ZData', surfaces(9).position.z, 'FaceColor', 'g');

%% Creating 'TERRACE 2' building
building4_x = 15.09;
building4_y = 45.72;
building4_width = 5.09; %15.27;
building4_depth = 8.28;
building4_z = 0.4;
building4_height = building4_z + 4.65;
building4_vertices = [building4_x, building4_y, building4_z - 0.01;
                      building4_x + building4_width, building4_y,building4_z - 0.01;
                      building4_x + building4_width, building4_y + building4_depth, building4_z - 0.01;
                      building4_x, building4_y + building4_depth, building4_z - 0.01;
                      building4_x, building4_y, building4_height;
                      building4_x + building4_width, building4_y, building4_height;
                      building4_x + building4_width, building4_y + building4_depth, building4_height;
                      building4_x, building4_y + building4_depth, building4_height];
building4_faces = building1_faces;

% Define TERRACE 2 base dimensions
building4base_x = 15.09;
building4base_y = 45.72;
building4base_width = 5.09;
building4base_depth = 8.28;
building4base_z = dimensions.zMin_x;
building4base_height = building4_z;

building4base_vertices = [building4base_x, building4base_y, building4base_z;                                              %1 [0 , 20,  -0.01]
                      building4base_x + building4base_width, building4base_y, building4base_z;                            %2 [30, 20,  -0.01]
                      building4base_x + building4base_width, building4base_y + building4base_depth, building4base_z;      %3 [30, 80,  -0.01]
                      building4base_x, building4base_y + building4base_depth, building4base_z;                            %4 [0 , 80,  -0.01]
                      building4base_x, building4base_y, building4base_height;                                             %5 [0 , 20, 20]
                      building4base_x + building4base_width, building4base_y, building4base_height;                       %6 [30, 20, 20]
                      building4base_x + building4base_width, building4base_y + building4base_depth, building4base_height; %7 [30, 80, 20]
                      building4base_x, building4base_y + building4base_depth, building4base_height];                      %8 [0 , 80, 20]
% Define building1 base faces
building4base_faces = building1_faces;

% ROOF of TERRACE 2
building4R_x = 15.023;
building4R_y = 45.52;
building4R_width = 5.223; %15.67;
building4R_depth = 8.68;
building4R_height = building4_z + 8;
building4R_vertices = [building4R_x, building4R_y, building4_height;  
                       building4R_x + building4R_width, building4R_y, building4_height;  
                       building4R_x + building4R_width, building4R_y + building4R_depth, building4_height; 
                       building4R_x, building4R_y + building4R_depth, building4_height; 
                       building4R_x, building4R_y + building4R_depth/2, building4R_height; 
                       building4R_x + building4R_width, building4R_y + building4R_depth/2, building4R_height;  
                       building4R_x, building4R_y + building4R_depth, building4_height;  
                       building4R_x + building4R_width, building4R_y + building4R_depth, building4_height]; 

building4R_faces = building3R_faces;

% Chimney of TERRACE 2
building4C_x = 15.023;
building4C_y = 47;
building4C_width = 1.5;
building4C_depth = 0.90;
building4C_z = building4_z + 5.2; 
building4C_height = 1.7;
building4C_vertices = [building4C_x, building4C_y, building4C_z;  
                       building4C_x + building4C_width, building4C_y, building4C_z;   
                       building4C_x + building4C_width, building4C_y + building4C_depth, building4C_z;  
                       building4C_x, building4C_y + building4C_depth, building4C_z;  
                       building4C_x, building4C_y, building4C_z+building4C_height;  
                       building4C_x + building4C_width, building4C_y, building4C_z+building4C_height;   
                       building4C_x + building4C_width, building4C_y + building4C_depth, building4C_z+building4C_height;  
                       building4C_x, building4C_y + building4C_depth, building4C_z+building4C_height]; 

building4C_faces = building1_faces;

% Define Terrace 2 Door 1 dimensions
building4_door1_x = 18.8;
building4_door1_y = 45.72;
building4_door1_width = 1; 
building4_door1_depth = 0.2;
building4_door1_z = building4_z; 
building4_door1_height = 2.05 + building4_door1_z;

% Define door 1 vertices
building4_door1_vertices = [building4_door1_x, building4_door1_y, building4_door1_z;
                        building4_door1_x + building4_door1_width, building4_door1_y, building4_door1_z;
                        building4_door1_x + building4_door1_width, building4_door1_y + building4_door1_depth, building4_door1_z;
                        building4_door1_x, building4_door1_y + building4_door1_depth, building4_door1_z;
                        building4_door1_x, building4_door1_y, building4_door1_height;
                        building4_door1_x + building4_door1_width, building4_door1_y, building4_door1_height;
                        building4_door1_x + building4_door1_width, building4_door1_y + building4_door1_depth, building4_door1_height;
                        building4_door1_x, building4_door1_y + building4_door1_depth, building4_door1_height];
building4_door1_vertices(:, 2) = building4_door1_vertices(:,2)-0.01; % This is to stop flickering

% Define door1 faces
building4_door1_faces = building1_faces;

% Define Door 2 dimensions
building4_door2_x = 15.70;
building4_door2_y = 54 - 0.2;
building4_door2_width = 1; 
building4_door2_depth = 0.2;
building4_door2_z = building4_z + 0.1; 
building4_door2_height = 2.15 + building4_door2_z;

% Define door2 vertices
building4_door2_vertices = [building4_door2_x, building4_door2_y, building4_door2_z;
                        building4_door2_x + building4_door2_width, building4_door2_y, building4_door2_z;
                        building4_door2_x + building4_door2_width, building4_door2_y + building4_door2_depth, building4_door2_z;
                        building4_door2_x, building4_door2_y + building4_door2_depth, building4_door2_z;
                        building4_door2_x, building4_door2_y, building4_door2_height;
                        building4_door2_x + building4_door2_width, building4_door2_y, building4_door2_height;
                        building4_door2_x + building4_door2_width, building4_door2_y + building4_door2_depth, building4_door2_height;
                        building4_door2_x, building4_door2_y + building4_door2_depth, building4_door2_height];
building4_door2_vertices(:, 2) = building4_door2_vertices(:,2)+0.01; % This is to stop flickering
% Define door2 faces
building4_door2_faces = building1_faces;

% Define window 1 dimensions
building4_window1_x = 16.2;
building4_window1_y = 45.72;
building4_window1_width = 1.4; 
building4_window1_depth = 0.2;
building4_window1_z = building4_z + 0.75; 
building4_window2_height = 1.3 + building4_window1_z ;


% Define window1 vertices 
building4_window1_vertices = [building4_window1_x, building4_window1_y, building4_window1_z;
                   building4_window1_x + building4_window1_width, building4_window1_y, building4_window1_z;
                   building4_window1_x + building4_window1_width, building4_window1_y + building4_window1_depth, building4_window1_z;
                   building4_window1_x, building4_window1_y + building4_window1_depth, building4_window1_z;
                   building4_window1_x, building4_window1_y, building4_window2_height;
                   building4_window1_x + building4_window1_width, building4_window1_y, building4_window2_height;
                   building4_window1_x + building4_window1_width, building4_window1_y + building4_window1_depth, building4_window2_height;
                   building4_window1_x, building4_window1_y + building4_window1_depth, building4_window2_height];
building4_window1_vertices(:, 2) = building4_window1_vertices(:,2)-0.01; % This is to stop flickering
% Define window 1 faces
building4_window1_faces = building1_faces;

% Define window 2 dimensions
building4_window2_x = 16.2;
building4_window2_y = 45.72;
building4_window2_width = 1.4; 
building4_window2_depth = 0.2;
building4_window2_z = 3.4 + building4_z; 
building4_window2_height = 1.2 + building4_window2_z ;

% Define window 2 vertices 
building4_window2_vertices = [building4_window2_x, building4_window2_y, building4_window2_z;
                   building4_window2_x + building4_window2_width, building4_window2_y, building4_window2_z;
                   building4_window2_x + building4_window2_width, building4_window2_y + building4_window2_depth, building4_window2_z;
                   building4_window2_x, building4_window2_y + building4_window2_depth, building4_window2_z;
                   building4_window2_x, building4_window2_y, building4_window2_height;
                   building4_window2_x + building4_window2_width, building4_window2_y, building4_window2_height;
                   building4_window2_x + building4_window2_width, building4_window2_y + building4_window2_depth, building4_window2_height;
                   building4_window2_x, building4_window2_y + building4_window2_depth, building4_window2_height];
building4_window2_vertices(:, 2) = building4_window2_vertices(:,2)-0.01; % This is to stop flickering
% Define window 2 faces
building4_window2_faces = building1_faces;

% Define window 3 dimensions
building4_window3_x = 18.5;
building4_window3_y = 45.72;
building4_window3_width = 0.90; 
building4_window3_depth = 0.2;
building4_window3_z = 3.5 + building4_z; 
building4_window3_height = 1.1 + building4_window3_z ;

% Define window3 vertices 
building4_window3_vertices = [building4_window3_x, building4_window3_y, building4_window3_z;
                   building4_window3_x + building4_window3_width, building4_window3_y, building4_window3_z;
                   building4_window3_x + building4_window3_width, building4_window3_y + building4_window3_depth, building4_window3_z;
                   building4_window3_x, building4_window3_y + building4_window3_depth, building4_window3_z;
                   building4_window3_x, building4_window3_y, building4_window3_height;
                   building4_window3_x + building4_window3_width, building4_window3_y, building4_window3_height;
                   building4_window3_x + building4_window3_width, building4_window3_y + building4_window3_depth, building4_window3_height;
                   building4_window3_x, building4_window3_y + building4_window3_depth, building4_window3_height];
building4_window3_vertices(:, 2) = building4_window3_vertices(:,2)-0.01; % This is to stop flickering
% Define window 3 faces
building4_window3_faces = building1_faces;

% Define window 4 dimensions
building4_window4_x = 17.67;
building4_window4_y = 54 - 0.2;
building4_window4_width = 1.2; 
building4_window4_depth = 0.2;
building4_window4_z = 3.5 + building4_z; 
building4_window4_height = 1.1 + building4_window4_z;

% Define window 4 vertices 
building4_window4_vertices = [building4_window4_x, building4_window4_y, building4_window4_z;
                   building4_window4_x + building4_window4_width, building4_window4_y, building4_window4_z;
                   building4_window4_x + building4_window4_width, building4_window4_y + building4_window4_depth, building4_window4_z;
                   building4_window4_x, building4_window4_y + building4_window4_depth, building4_window4_z;
                   building4_window4_x, building4_window4_y, building4_window4_height;
                   building4_window4_x + building4_window4_width, building4_window4_y, building4_window4_height;
                   building4_window4_x + building4_window4_width, building4_window4_y + building4_window4_depth, building4_window4_height;
                   building4_window4_x, building4_window4_y + building4_window4_depth, building4_window4_height];
building4_window4_vertices(:, 2) = building4_window4_vertices(:,2)+0.01; % This is to stop flickering
% Define window 4 faces
building4_window4_faces = building1_faces;

% Define window 5 dimensions
building4_window5_x = 15.70;
building4_window5_y = 54 - 0.2;
building4_window5_width = 0.9; 
building4_window5_depth = 0.2;
building4_window5_z = 3.5 + building4_z; 
building4_window5_height = 1.1 + building4_window5_z ;

% Define window 5 vertices 
building4_window5_vertices = [building4_window5_x, building4_window5_y, building4_window5_z;
                   building4_window5_x + building4_window5_width, building4_window5_y, building4_window5_z;
                   building4_window5_x + building4_window5_width, building4_window5_y + building4_window5_depth, building4_window5_z;
                   building4_window5_x, building4_window5_y + building4_window5_depth, building4_window5_z;
                   building4_window5_x, building4_window5_y, building4_window5_height;
                   building4_window5_x + building4_window5_width, building4_window5_y, building4_window5_height;
                   building4_window5_x + building4_window5_width, building4_window5_y + building4_window5_depth, building4_window5_height;
                   building4_window5_x, building4_window5_y + building4_window5_depth, building4_window5_height];
building4_window5_vertices(:, 2) = building4_window5_vertices(:,2)+0.01; % This is to stop flickering
% Define window 5 faces
building4_window5_faces = building1_faces;

% Define window 6 dimensions
building4_window6_x = 17.67;
building4_window6_y = 54 - 0.2;
building4_window6_width = 1.2; 
building4_window6_depth = 0.2;
building4_window6_z = 1.25 + building4_z; 
building4_window6_height = 1 + building4_window6_z ;
% Define window 6 vertices 
building4_window6_vertices = [building4_window6_x, building4_window6_y, building4_window6_z;
                   building4_window6_x + building4_window6_width, building4_window6_y, building4_window6_z;
                   building4_window6_x + building4_window6_width, building4_window6_y + building4_window6_depth, building4_window6_z;
                   building4_window6_x, building4_window6_y + building4_window6_depth, building4_window6_z;
                   building4_window6_x, building4_window6_y, building4_window6_height;
                   building4_window6_x + building4_window6_width, building4_window6_y, building4_window6_height;
                   building4_window6_x + building4_window6_width, building4_window6_y + building4_window6_depth, building4_window6_height;
                   building4_window6_x, building4_window6_y + building4_window6_depth, building4_window6_height];
building4_window6_vertices(:, 2) = building4_window6_vertices(:,2)+0.01; % This is to stop flickering
% Define window 6 faces
building4_window6_faces = building1_faces;

% Add a floor (TERRACE 2 floor) with material 'carpet'
surfaces(10).name = 'TERRACE 2 floor';
surfaces(10).position.x = [15.09, 20.18, 20.18, 15.09];
surfaces(10).position.y = [45.72, 45.72, 54, 54];
surfaces(10).position.z = [building4_z, building4_z, building4_z, building4_z];
surfaces(10).sabine_coefficient = sabine_coefficients.Carpet;
surfaces(10).material = 'Carpet';
% Draw M&S floor
patch('Parent', street_group,'XData', surfaces(10).position.x, 'YData', surfaces(10).position.y, 'ZData', surfaces(10).position.z, 'FaceColor', 'r');


%% Creating 'TERRACE 3' building
building5_x = 20.18;
building5_y = 45.72;
building5_width = 5.09;
building5_depth = 8.28;
building5_z = 0.6;
building5_height = building5_z + 4.65;
building5_vertices = [building5_x, building5_y, building5_z - 0.01;
                      building5_x + building5_width, building5_y, building5_z - 0.01;
                      building5_x + building5_width, building5_y + building5_depth, building5_z - 0.01;
                      building5_x, building5_y + building5_depth, building5_z - 0.01;
                      building5_x, building5_y, building5_height;
                      building5_x + building5_width, building5_y, building5_height;
                      building5_x + building5_width, building5_y + building5_depth, building5_height;
                      building5_x, building5_y + building5_depth, building5_height];
building5_faces = building1_faces;

% Define TERRACE 3 base dimensions
building5base_x = 20.18;
building5base_y = 45.72;
building5base_width = 5.09;
building5base_depth = 8.28;
building5base_z = dimensions.zMin_x;
building5base_height = building5_z;
building5base_vertices = [building5base_x, building5base_y, building5base_z;                                              %1 [0 , 20,  -0.01]
                      building5base_x + building5base_width, building5base_y, building5base_z;                            %2 [30, 20,  -0.01]
                      building5base_x + building5base_width, building5base_y + building5base_depth, building5base_z;      %3 [30, 80,  -0.01]
                      building5base_x, building5base_y + building5base_depth, building5base_z;                            %4 [0 , 80,  -0.01]
                      building5base_x, building5base_y, building5base_height;                                             %5 [0 , 20, 20]
                      building5base_x + building5base_width, building5base_y, building5base_height;                       %6 [30, 20, 20]
                      building5base_x + building5base_width, building5base_y + building5base_depth, building5base_height; %7 [30, 80, 20]
                      building5base_x, building5base_y + building5base_depth, building5base_height];                      %8 [0 , 80, 20]
building5base_faces = building1_faces;

% ROOF of TERRACE 3
building5R_x = 20.246;
building5R_y = 45.52;
building5R_width = 5.223;
building5R_depth = 8.68;
building5R_height = building5_z + 8;
building5R_vertices = [building5R_x, building5R_y, building5_height;  
                       building5R_x + building5R_width, building5R_y, building5_height;  
                       building5R_x + building5R_width, building5R_y + building5R_depth, building5_height; 
                       building5R_x, building5R_y + building5R_depth, building5_height; 
                       building5R_x, building5R_y + building5R_depth/2, building5R_height; 
                       building5R_x + building5R_width, building5R_y + building5R_depth/2, building5R_height;  
                       building5R_x, building5R_y + building5R_depth, building5_height;  
                       building5R_x + building5R_width, building5R_y + building5R_depth, building5_height]; 
building5R_faces = building3R_faces;

% Define Door 1 dimensions
building5_door1_x = 22.95;
building5_door1_y = 45.72;
building5_door1_width = 1; 
building5_door1_depth = 0.2;
building5_door1_z = building5_z; 
building5_door1_height = 2.05 + building5_door1_z;
building5_door1_vertices = [building5_door1_x, building5_door1_y, building5_door1_z;
                        building5_door1_x + building5_door1_width, building5_door1_y, building5_door1_z;
                        building5_door1_x + building5_door1_width, building5_door1_y + building5_door1_depth, building5_door1_z;
                        building5_door1_x, building5_door1_y + building5_door1_depth, building5_door1_z;
                        building5_door1_x, building5_door1_y, building5_door1_height;
                        building5_door1_x + building5_door1_width, building5_door1_y, building5_door1_height;
                        building5_door1_x + building5_door1_width, building5_door1_y + building5_door1_depth, building5_door1_height;
                        building5_door1_x, building5_door1_y + building5_door1_depth, building5_door1_height];
building5_door1_vertices(:, 2) = building5_door1_vertices(:,2)-0.01; % This is to stop flickering
building5_door1_faces = building1_faces;

% Define window 1 dimensions
building5_window1_x = 20.6;
building5_window1_y = 45.72;
building5_window1_width = 1.7; 
building5_window1_depth = 0.2;
building5_window1_z = building5_z + 0.75; 
building5_window1_height = 1.3 + building5_window1_z ;
building5_window1_vertices = [building5_window1_x, building5_window1_y, building5_window1_z;
                   building5_window1_x + building5_window1_width, building5_window1_y, building5_window1_z;
                   building5_window1_x + building5_window1_width, building5_window1_y + building5_window1_depth, building5_window1_z;
                   building5_window1_x, building5_window1_y + building5_window1_depth, building5_window1_z;
                   building5_window1_x, building5_window1_y, building5_window1_height;
                   building5_window1_x + building5_window1_width, building5_window1_y, building5_window1_height;
                   building5_window1_x + building5_window1_width, building5_window1_y + building5_window1_depth, building5_window1_height;
                   building5_window1_x, building5_window1_y + building5_window1_depth, building5_window1_height];
building5_window1_vertices(:, 2) = building5_window1_vertices(:,2)-0.01; % This is to stop flickering
building5_window1_faces = building1_faces;

% Define window 2 dimensions
building5_window2_x = 24.42;
building5_window2_y = 45.72;
building5_window2_width = 0.45; 
building5_window2_depth = 0.2;
building5_window2_z = building5_z + 1.3; 
building5_window2_height = 1.3 + building5_window1_z ;
building5_window2_vertices = [building5_window2_x, building5_window2_y, building5_window2_z;
                   building5_window2_x + building5_window2_width, building5_window2_y, building5_window2_z;
                   building5_window2_x + building5_window2_width, building5_window2_y + building5_window2_depth, building5_window2_z;
                   building5_window2_x, building5_window2_y + building5_window2_depth, building5_window2_z;
                   building5_window2_x, building5_window2_y, building5_window2_height;
                   building5_window2_x + building5_window2_width, building5_window2_y, building5_window2_height;
                   building5_window2_x + building5_window2_width, building5_window2_y + building5_window2_depth, building5_window2_height;
                   building5_window2_x, building5_window2_y + building5_window2_depth, building5_window2_height];
building5_window2_vertices(:, 2) = building5_window2_vertices(:,2)-0.01; % This is to stop flickering
building5_window2_faces = building1_faces;

% Define window 3 dimensions
building5_window3_x = 20.9;
building5_window3_y = 45.72;
building5_window3_width = 1.2; 
building5_window3_depth = 0.2;
building5_window3_z = 3.4 + building5_z; 
building5_window3_height = 1.2 + building5_window3_z ;
building5_window3_vertices = [building5_window3_x, building5_window3_y, building5_window3_z;
                   building5_window3_x + building5_window3_width, building5_window3_y, building5_window3_z;
                   building5_window3_x + building5_window3_width, building5_window3_y + building5_window3_depth, building5_window3_z;
                   building5_window3_x, building5_window3_y + building5_window3_depth, building5_window3_z;
                   building5_window3_x, building5_window3_y, building5_window3_height;
                   building5_window3_x + building5_window3_width, building5_window3_y, building5_window3_height;
                   building5_window3_x + building5_window3_width, building5_window3_y + building5_window3_depth, building5_window3_height;
                   building5_window3_x, building5_window3_y + building5_window3_depth, building5_window3_height];
building5_window3_vertices(:, 2) = building5_window3_vertices(:,2)-0.01; % This is to stop flickering
building5_window3_faces = building1_faces;

% Define window 4 dimensions
building5_window4_x = 23.2;
building5_window4_y = 45.72;
building5_window4_width = 1.3; 
building5_window4_depth = 0.2;
building5_window4_z = 3.5 + building5_z; 
building5_window4_height = 1.1 + building5_window4_z ;
building5_window4_vertices = [building5_window4_x, building5_window4_y, building5_window4_z;
                   building5_window4_x + building5_window4_width, building5_window4_y, building5_window4_z;
                   building5_window4_x + building5_window4_width, building5_window4_y + building5_window4_depth, building5_window4_z;
                   building5_window4_x, building5_window4_y + building5_window4_depth, building5_window4_z;
                   building5_window4_x, building5_window4_y, building5_window4_height;
                   building5_window4_x + building5_window4_width, building5_window4_y, building5_window4_height;
                   building5_window4_x + building5_window4_width, building5_window4_y + building5_window4_depth, building5_window4_height;
                   building5_window4_x, building5_window4_y + building5_window4_depth, building5_window4_height];
building5_window4_vertices(:, 2) = building5_window4_vertices(:,2)-0.01; % This is to stop flickering
building5_window4_faces = building1_faces;

% Define window 5 dimensions
building5_window5_x = 23.35;
building5_window5_y = 54 - 0.2;
building5_window5_width = 1.2; 
building5_window5_depth = 0.2;
building5_window5_z = 3.5 + building5_z; 
building5_window5_height = 1.1 + building5_window5_z ;
building5_window5_vertices = [building5_window5_x, building5_window5_y, building5_window5_z;
                   building5_window5_x + building5_window5_width, building5_window5_y, building5_window5_z;
                   building5_window5_x + building5_window5_width, building5_window5_y + building5_window5_depth, building5_window5_z;
                   building5_window5_x, building5_window5_y + building5_window5_depth, building5_window5_z;
                   building5_window5_x, building5_window5_y, building5_window5_height;
                   building5_window5_x + building5_window5_width, building5_window5_y, building5_window5_height;
                   building5_window5_x + building5_window5_width, building5_window5_y + building5_window5_depth, building5_window5_height;
                   building5_window5_x, building5_window5_y + building5_window5_depth, building5_window5_height];
building5_window5_vertices(:, 2) = building5_window5_vertices(:,2)+0.01; % This is to stop flickering
building5_window5_faces = building1_faces;

% Define window 6 dimensions
building5_window6_x = 20.96;
building5_window6_y = 54 - 0.2;
building5_window6_width = 1.2; 
building5_window6_depth = 0.2;
building5_window6_z = 3.5 + building5_z; 
building5_window6_height = 1.1 + building5_window6_z ;
building5_window6_vertices = [building5_window6_x, building5_window6_y, building5_window6_z;
                   building5_window6_x + building5_window6_width, building5_window6_y, building5_window6_z;
                   building5_window6_x + building5_window6_width, building5_window6_y + building5_window6_depth, building5_window6_z;
                   building5_window6_x, building5_window6_y + building5_window6_depth, building5_window6_z;
                   building5_window6_x, building5_window6_y, building5_window6_height;
                   building5_window6_x + building5_window6_width, building5_window6_y, building5_window6_height;
                   building5_window6_x + building5_window6_width, building5_window6_y + building5_window6_depth, building5_window6_height;
                   building5_window6_x, building5_window6_y + building5_window6_depth, building5_window6_height];
building5_window6_vertices(:, 2) = building5_window6_vertices(:,2)+0.01; % This is to stop flickering
building5_window6_faces = building1_faces;

% Define window 7 dimensions
building5_window7_x = 21.536;
building5_window7_y = 54 - 0.2;
building5_window7_width = 2.47; 
building5_window7_depth = 0.2;
building5_window7_z = 0.1 + building5_z; 
building5_window7_height = 2.15 + building5_window7_z ;
building5_window7_vertices = [building5_window7_x, building5_window7_y, building5_window7_z;
                   building5_window7_x + building5_window7_width, building5_window7_y, building5_window7_z;
                   building5_window7_x + building5_window7_width, building5_window7_y + building5_window7_depth, building5_window7_z;
                   building5_window7_x, building5_window7_y + building5_window7_depth, building5_window7_z;
                   building5_window7_x, building5_window7_y, building5_window7_height;
                   building5_window7_x + building5_window7_width, building5_window7_y, building5_window7_height;
                   building5_window7_x + building5_window7_width, building5_window7_y + building5_window7_depth, building5_window7_height;
                   building5_window7_x, building5_window7_y + building5_window7_depth, building5_window7_height];
building5_window7_vertices(:, 2) = building5_window7_vertices(:,2)+0.01; % This is to stop flickering
building5_window7_faces = building1_faces;

% Define window 8 dimensions (side window)
building5_window8_x = 25.27-0.2;
building5_window8_y = 48.84;
building5_window8_width = 0.2; 
building5_window8_depth = 0.70;
building5_window8_z = 3.05 + building5_z; 
building5_window8_height = 1.16 + building5_window8_z ;
building5_window8_vertices = [building5_window8_x, building5_window8_y, building5_window8_z;
                   building5_window8_x + building5_window8_width, building5_window8_y, building5_window8_z;
                   building5_window8_x + building5_window8_width, building5_window8_y + building5_window8_depth, building5_window8_z;
                   building5_window8_x, building5_window8_y + building5_window8_depth, building5_window8_z;
                   building5_window8_x, building5_window8_y, building5_window8_height;
                   building5_window8_x + building5_window8_width, building5_window8_y, building5_window8_height;
                   building5_window8_x + building5_window8_width, building5_window8_y + building5_window8_depth, building5_window8_height;
                   building5_window8_x, building5_window8_y + building5_window8_depth, building5_window8_height];
building5_window8_vertices(:, 1) = building5_window8_vertices(:,1)+0.01; % This is to stop flickering
building5_window8_faces = building1_faces;

% Add a floor (TERRACE 3 floor) with material 'carpet'
surfaces(11).name = 'TERRACE 3 floor';
surfaces(11).position.x = [20.18, 25.27, 25.27, 20.18];
surfaces(11).position.y = [45.72, 45.72, 54, 54];
surfaces(11).position.z = [building5_z, building5_z, building5_z, building5_z];
surfaces(11).sabine_coefficient = sabine_coefficients.Carpet;
surfaces(11).material = 'Carpet';
% Draw TERRACE 3 floor
patch('Parent', street_group,'XData', surfaces(11).position.x, 'YData', surfaces(11).position.y, 'ZData', surfaces(11).position.z, 'FaceColor', [0.4 0.4 0.4]);

% Combine building and window vertices and faces
building3_all_vertices = [building3_vertices; 
                      building3_window1_vertices;
                      building4_window1_vertices;
                      building5_window1_vertices;
                      building5_window2_vertices;
                      building3_window2_vertices;
                      building4_window2_vertices;
                      building4_window3_vertices;
                      building5_window3_vertices;
                      building5_window4_vertices;
                      building5_window5_vertices;
                      building5_window6_vertices;
                      building4_window4_vertices;
                      building4_window5_vertices;
                      building3_window3_vertices;
                      building3_window4_vertices;
                      building5_window7_vertices;
                      building4_window6_vertices;
                      building3_window5_vertices;
                      building5_window8_vertices;
                      building3_window6_vertices;
                      building3R_vertices;
                      building4C_vertices;
                      building3_door1_vertices;
                      building4_door1_vertices;
                      building5_door1_vertices;
                      building4_door2_vertices;
                      building3_door2_vertices;
                      building4_vertices;
                      building4R_vertices;
                      building5_vertices;
                      building5R_vertices;
                      building3base_vertices;
                      building4base_vertices;
                      building5base_vertices]; 

% Define offset for windows, roof, and door.
offset_window1 = size(building3_vertices, 1);
offset_window2 = offset_window1 + size(building3_window1_vertices, 1);
offset_window3 = offset_window2 + size(building4_window1_vertices, 1);
offset_window4 = offset_window3 + size(building5_window1_vertices, 1);
offset_window5 = offset_window4 + size(building5_window2_vertices, 1);
offset_window6 = offset_window5 + size(building3_window2_vertices, 1);
offset_window7 = offset_window6 + size(building4_window2_vertices, 1);
offset_window8 = offset_window7 + size(building4_window3_vertices, 1);
offset_window9 = offset_window8 + size(building5_window3_vertices, 1);
offset_window10 = offset_window9 + size(building5_window4_vertices, 1);
offset_window11 = offset_window10 + size(building5_window5_vertices, 1);
offset_window12 = offset_window11 + size(building5_window6_vertices, 1);
offset_window13 = offset_window12 + size(building4_window4_vertices, 1);
offset_window14 = offset_window13 + size(building4_window5_vertices, 1);
offset_window15 = offset_window14 + size(building3_window3_vertices, 1);
offset_window16 = offset_window15 + size(building3_window4_vertices, 1);
offset_window17 = offset_window16 + size(building5_window7_vertices, 1);
offset_window18 = offset_window17 + size(building4_window6_vertices, 1);
offset_window19 = offset_window18 + size(building3_window5_vertices, 1);
offset_window20 = offset_window19 + size(building5_window8_vertices, 1);
offset_roof = offset_window20 + size(building3_window6_vertices, 1);
offset_chimney = offset_roof + size(building3R_vertices, 1);
offset_door1 = offset_chimney + size(building4C_vertices, 1);
offset_door2 = offset_door1 + size(building3_door1_vertices, 1);
offset_door3 = offset_door2 + size(building4_door1_vertices, 1);
offset_door4 = offset_door3 + size(building5_door1_vertices, 1);
offset_door5 = offset_door4 + size(building4_door2_vertices, 1);
offset_building4 = offset_door5 + size(building3_door2_vertices, 1);
offset_building4R = offset_building4+ size(building4_vertices, 1);
offset_building5 = offset_building4R + size(building4R_vertices, 1);
offset_building5R = offset_building5+ size(building5_vertices, 1);
offset_base1 = offset_building5R + size(building5R_vertices, 1);
offset_base2 = offset_base1 + size(building3base_vertices, 1);
offset_base3 = offset_base2 + size(building4base_vertices, 1);

building3_all_faces = [building3_faces; 
                       building3_window1_faces + offset_window1; 
                       building4_window1_faces + offset_window2;
                       building5_window1_faces + offset_window3;
                       building5_window2_faces + offset_window4;
                       building3_window2_faces + offset_window5;
                       building4_window2_faces + offset_window6;
                       building4_window3_faces + offset_window7;
                       building5_window3_faces + offset_window8;
                       building5_window4_faces + offset_window9;
                       building5_window5_faces + offset_window10;
                       building5_window6_faces + offset_window11;
                       building4_window4_faces + offset_window12;
                       building4_window5_faces + offset_window13;
                       building3_window3_faces + offset_window14;
                       building3_window4_faces + offset_window15;
                       building5_window7_faces + offset_window16;
                       building4_window6_faces + offset_window17;
                       building3_window5_faces + offset_window18;
                       building5_window8_faces + offset_window19;
                       building3_window6_faces + offset_window20;
                       building3R_faces + offset_roof;
                       building4C_faces + offset_chimney;
                       building3_door1_faces + offset_door1;
                       building4_door1_faces + offset_door2;
                       building5_door1_faces + offset_door3;
                       building4_door2_faces + offset_door4;
                       building3_door2_faces + offset_door5;
                       building4_faces + offset_building4;
                       building4R_faces + offset_building4R;
                       building5_faces + offset_building5;
                       building5R_faces + offset_building5R;
                       building3base_faces + offset_base1;
                       building4base_faces + offset_base2;
                       building5base_faces + offset_base3];

% Define the colors
building3_colors = [repmat([1, 0.6, 0.2], size(building3_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building3_window1_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building4_window1_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building5_window1_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building5_window2_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building3_window2_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building4_window2_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building4_window3_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building5_window3_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building5_window4_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building5_window5_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building5_window6_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building4_window4_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building4_window5_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building3_window3_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building3_window4_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building5_window7_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building4_window6_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building3_window5_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building5_window8_faces, 1), 1);
                repmat([0.9, 0.9, 0.9], size(building3_window6_faces, 1), 1);
                repmat([0.5, 0.5, 0.5], size(building3R_faces, 1), 1);
                repmat([1, 0.6, 0.2], size(building4C_faces, 1), 1);
                repmat([1, 1, 1], size(building3_door1_faces, 1), 1);
                repmat([1, 1, 1], size(building4_door1_faces, 1), 1);
                repmat([1, 1, 1], size(building5_door1_faces, 1), 1);
                repmat([1, 1, 1], size(building4_door2_faces, 1), 1);
                repmat([1, 1, 1], size(building3_door2_faces, 1), 1);
                repmat([1, 0.6, 0.2], size(building4_faces, 1), 1);
                repmat([0.5, 0.5, 0.5], size(building4R_faces, 1), 1);
                repmat([1, 0.6, 0.2], size(building5_faces, 1), 1);
                repmat([0.5, 0.5, 0.5], size(building5R_faces, 1), 1);
                repmat([1, 0.5, 0], size(building3base_faces, 1), 1);
                repmat([1, 0.5, 0], size(building4base_faces, 1), 1);
                repmat([1, 0.5, 0], size(building5base_faces, 1), 1)];

buildings(4) = struct('name', 'TERRACE 1', 'vertices', building3_vertices, 'faces', building3_faces, 'material', 'Brick', 'sabine_coefficient', sabine_coefficients.Brick);
buildings(5) = struct('name', 'TERRACE 1 Base', 'vertices', building3base_vertices, 'faces', building3base_faces, 'material', 'Brick', 'sabine_coefficient', sabine_coefficients.Brick);
buildings(6) = struct('name', 'TERRACE 2', 'vertices', building4_vertices, 'faces', building4_faces, 'material', 'Brick', 'sabine_coefficient', sabine_coefficients.Brick);
buildings(7) = struct('name', 'TERRACE 2 Base', 'vertices', building4base_vertices, 'faces', building4base_faces, 'material', 'Brick', 'sabine_coefficient', sabine_coefficients.Brick);
buildings(8) = struct('name', 'TERRACE 3', 'vertices', building5_vertices, 'faces', building5_faces, 'material', 'Brick', 'sabine_coefficient', sabine_coefficients.Brick);
buildings(9) = struct('name', 'TERRACE 3 Base', 'vertices', building5base_vertices, 'faces', building5base_faces, 'material', 'Brick', 'sabine_coefficient', sabine_coefficients.Brick);
windows(19) = struct('name', 'TERRACE 1 Window 1', 'vertices', building3_window1_vertices, 'faces', building3_window1_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(20) = struct('name', 'TERRACE 1 Window 2', 'vertices', building3_window2_vertices, 'faces', building3_window2_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(21) = struct('name', 'TERRACE 1 Window 3', 'vertices', building3_window3_vertices, 'faces', building3_window3_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(22) = struct('name', 'TERRACE 1 Window 4', 'vertices', building3_window4_vertices, 'faces', building3_window4_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(23) = struct('name', 'TERRACE 1 Window 5', 'vertices', building3_window5_vertices, 'faces', building3_window5_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(24) = struct('name', 'TERRACE 1 Window 6', 'vertices', building3_window6_vertices, 'faces', building3_window6_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(25) = struct('name', 'TERRACE 2 Window 1', 'vertices', building4_window1_vertices, 'faces', building4_window1_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(26) = struct('name', 'TERRACE 2 Window 2', 'vertices', building4_window2_vertices, 'faces', building4_window2_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(27) = struct('name', 'TERRACE 2 Window 3', 'vertices', building4_window3_vertices, 'faces', building4_window3_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(28) = struct('name', 'TERRACE 2 Window 4', 'vertices', building4_window4_vertices, 'faces', building4_window4_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(29) = struct('name', 'TERRACE 2 Window 5', 'vertices', building4_window5_vertices, 'faces', building4_window5_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(30) = struct('name', 'TERRACE 2 Window 6', 'vertices', building4_window6_vertices, 'faces', building4_window6_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(31) = struct('name', 'TERRACE 3 Window 1', 'vertices', building5_window1_vertices, 'faces', building5_window1_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(32) = struct('name', 'TERRACE 3 Window 2', 'vertices', building5_window2_vertices, 'faces', building5_window2_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(33) = struct('name', 'TERRACE 3 Window 3', 'vertices', building5_window3_vertices, 'faces', building5_window3_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(34) = struct('name', 'TERRACE 3 Window 4', 'vertices', building5_window4_vertices, 'faces', building5_window4_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(35) = struct('name', 'TERRACE 3 Window 5', 'vertices', building5_window5_vertices, 'faces', building5_window5_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(36) = struct('name', 'TERRACE 3 Window 6', 'vertices', building5_window6_vertices, 'faces', building5_window6_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
windows(37) = struct('name', 'TERRACE 3 Window 7', 'vertices', building5_window8_vertices, 'faces', building5_window8_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
roofs(3) = struct('name', 'TERRACE 1 Roof', 'vertices', building3R_vertices, 'faces', building3R_faces, 'material', 'Tiles', 'sabine_coefficient', sabine_coefficients.Tiles);
roofs(4) = struct('name', 'TERRACE 2 Roof', 'vertices', building4R_vertices, 'faces', building4R_faces, 'material', 'Tiles', 'sabine_coefficient', sabine_coefficients.Tiles);
roofs(5) = struct('name', 'TERRACE 3 Roof', 'vertices', building5R_vertices, 'faces', building5R_faces, 'material', 'Tiles', 'sabine_coefficient', sabine_coefficients.Tiles);
doors(5) = struct('name', 'TERRACE 1 Door 1', 'vertices', building3_door1_vertices, 'faces', building3_door1_faces, 'material', 'Wood', 'sabine_coefficient', sabine_coefficients.Wood);
doors(6) = struct('name', 'TERRACE 1 Door 2', 'vertices', building3_door2_vertices, 'faces', building3_door2_faces, 'material', 'Wood', 'sabine_coefficient', sabine_coefficients.Wood);
doors(7) = struct('name', 'TERRACE 2 Door 1', 'vertices', building4_door1_vertices, 'faces', building4_door1_faces, 'material', 'Wood', 'sabine_coefficient', sabine_coefficients.Wood);
doors(8) = struct('name', 'TERRACE 2 Door 2', 'vertices', building4_door2_vertices, 'faces', building4_door2_faces, 'material', 'Wood', 'sabine_coefficient', sabine_coefficients.Wood);
doors(9) = struct('name', 'TERRACE 3 Door 1', 'vertices', building5_door1_vertices, 'faces', building5_door1_faces, 'material', 'Wood', 'sabine_coefficient', sabine_coefficients.Wood);
doors(10) = struct('name', 'TERRACE 3 Door 2', 'vertices', building5_window7_vertices, 'faces', building5_window7_faces, 'material', 'Glass', 'sabine_coefficient', sabine_coefficients.Glass);
chimney(1) = struct('name', 'TERRACE 2 Chimney', 'vertices', building4C_vertices, 'faces', building4C_faces, 'material', 'Brick', 'sabine_coefficient', sabine_coefficients.Brick);

% Combine these into a higher-order struct
world_objects(3).name = 'TERRACE 1';
world_objects(3).components(1) = buildings(4);
world_objects(3).components(2) = buildings(5);
world_objects(3).components(3) = windows(19);
world_objects(3).components(4) = windows(20);
world_objects(3).components(5) = windows(21);
world_objects(3).components(6) = windows(22);
world_objects(3).components(7) = windows(23);
world_objects(3).components(8) = windows(24);
world_objects(3).components(9) = roofs(3);
world_objects(3).components(10) = doors(5);
world_objects(3).components(11) = doors(6);

world_objects(4).name = 'TERRACE 2';
world_objects(4).components(1) = buildings(6);
world_objects(4).components(2) = buildings(7);
world_objects(4).components(3) = windows(25);
world_objects(4).components(4) = windows(26);
world_objects(4).components(5) = windows(27);
world_objects(4).components(6) = windows(28);
world_objects(4).components(7) = windows(29);
world_objects(4).components(8) = windows(30);
world_objects(4).components(9) = roofs(4);
world_objects(4).components(10) = doors(7);
world_objects(4).components(11) = doors(8);
world_objects(4).components(12) = chimney(1);

world_objects(5).name = 'TERRACE 3';
world_objects(5).components(1) = buildings(8);
world_objects(5).components(2) = buildings(9);
world_objects(5).components(3) = windows(31);
world_objects(5).components(4) = windows(32);
world_objects(5).components(5) = windows(33);
world_objects(5).components(6) = windows(34);
world_objects(5).components(7) = windows(35);
world_objects(5).components(8) = windows(36);
world_objects(5).components(9) = windows(37);
world_objects(5).components(10) = roofs(5);
world_objects(5).components(11) = doors(9);
world_objects(5).components(12) = doors(10);

% Create the patch object
patch('Parent', building_group,'Vertices', building3_all_vertices, 'Faces', building3_all_faces, 'FaceVertexCData', building3_colors, 'FaceColor', 'flat');
%% Labeling the buildings
text('Parent', building_group, 'Position', [12, 25, 10], 'String', 'PLOT 1', 'HorizontalAlignment', 'center', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'k');
text('Parent', building_group, 'Position', [21, 25, 10], 'String', 'PLOT 2', 'HorizontalAlignment', 'center', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'k');
text('Parent', building_group, 'Position', [17, 45, 10], 'String', 'EXEMPLAR HOUSES', 'HorizontalAlignment', 'center', 'FontSize', 11, 'FontWeight', 'bold', 'Color', 'k');

% Draw a red circle symbolising crime scene
x = 16.7 + cos(linspace(0, 2*pi, 100)) * 1.3;
y = 32 + sin(linspace(0, 2*pi, 100)) * 1.3;
z = calculate_z_positions(x, y, dimensions);
% Create the patch
patch('XData', x, 'YData', y, 'ZData', z+0.01, 'FaceColor', 'r', 'EdgeColor', 'none', 'FaceAlpha', 0.4);

% Labeling, lighting, view adjustments, etc.
xlabel('X (metres)');
ylabel('Y (metres)');
zlabel('Z (metres)');
%title('BYROM WAY LJMU');
view(3); % Set 3D (3) or 2D (2) view
axis equal
light('Position', [-20, 10, 30]); % Adjusted position
light('Position', [-30, 10, 30]); % Adjusted position
hold off
  %% Calculate the limits for the zoomed-in space
if dimensions.lengthwholegridX == 4.572
    desiredXLength = 4.572;  % Desired X length for the grid
    desiredYLength = 3.429;  % Desired Y length for the grid
    distX = desiredXLength / 3;  % Divide by 3 since the grid is 3x3
    distY = desiredYLength / 3;  % Divide by 3 since the grid is 3x3
    minX = dimensions.arraycentreX - 1.5 * distX;
    maxX = dimensions.arraycentreX + 1.5 * distX;
    minY = dimensions.arraycentreY - 1.5 * distY;
    maxY = dimensions.arraycentreY + 1.5 * distY;
else
    % Use the gridX and gridY dimensions if available
    minX = dimensions.gridX(1) - (dimensions.lengthgridX / 2);
    maxX = dimensions.gridX(9) + (dimensions.lengthgridX / 2);
    minY = dimensions.gridY(9) - (dimensions.lengthgridY / 2);
    maxY = dimensions.gridY(1) + (dimensions.lengthgridY / 2);

end
minZ = -0.1;
maxZ = dimensions.heightgrid;
% Set the axis limits for the zoomed-in space
xlim([minX, maxX]);
ylim([minY, maxY]);
zlim([minZ, maxZ]);
drawnow;