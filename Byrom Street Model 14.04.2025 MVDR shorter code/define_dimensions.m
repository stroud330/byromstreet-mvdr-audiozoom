function dimensions = define_dimensions()
%% Define the dimensions of the virtual crime scene
dimensions.heightgrid = 15;                         % height of the grid and any text that needs to clear the top of the buildings (22 meters)
dimensions.roomLength = 50;                         % length of scene = 50 meters
dimensions.roomWidth = 80;                          % width of scene = 80 meters
dimensions.roomHeight = 50;                         % height of scene = 50 meters
dimensions.arrayLength = 0.7;                       % length of the mic array = 0.70 meters
dimensions.arrayWidth = 0.7;                        % width of the mic array = 0.70 meters
dimensions.zMin_x = -0.01; %-0.01;                  % Lowest point of the ground (x)
dimensions.zMax_x = 1.3;                            % Highest point of the ground  (x)
dimensions.zMin_y = -0.01; %-0.01;                  % Lowest point of the ground (y)
dimensions.zMax_y = -0.3;                           % Highest point of the ground  (y)
dimensions.speakerLength = 0.5;                     % length of the speaker icon = 0.5 meters (av width of UK person)
dimensions.speakerWidth = 0.5;                      % width of the speaker icon = 0.5 meters  (av width of UK person)
dimensions.speakerHeight = 1.8;                     % Height of the speaker icon = 1.8 meters (av height of UK person)
dimensions.centreX = dimensions.roomLength /2;      % x coordinate of the centre of the scene
dimensions.centreY = dimensions.roomWidth /2;       % y coordinate of the centre of the scene
dimensions.centreZ = dimensions.roomHeight /2;      % z coordinate of the centre of the scene 
dimensions.corners(1).x = 0;                        % x coodinate of the top left corner of the scene (0 meters)
dimensions.corners(1).y = dimensions.roomWidth;     % y coordinate of the top left corner of the scene (60 meters)
dimensions.corners(2).x = dimensions.roomLength;    % x coordinate of the top right corner of the scene (40 meters)
dimensions.corners(2).y = dimensions.roomWidth;     % y coordinate of the top right corner of the scene (60 meters)
dimensions.corners(3).x = 0;                        % x coordinate of the bottom left corner of the scene (0 meters)
dimensions.corners(3).y = 0;                        % y coordinate of the bottom left corner of the scene(0 meters)
dimensions.corners(4).x = dimensions.roomLength;    % x coordinate of the bottom right corner of the scene (40 meters)
dimensions.corners(4).y = 0;                        % y coordinate of the bottom right corner of the scene (0 meters)
dimensions.arraycentreX = dimensions.roomLength/2;  % default X axis coordinate for the centre of the microphone array (40 meters)
dimensions.arraycentreY = dimensions.roomWidth/2;   % default Y axis coordinate for the centre of the microphone array (55 meters)
dimensions.arraycentreZ = 1;                        % default Z axis coordinate for the centre of the microphone array (1 meters)
dimensions.arrayRadius = 0.52;                      % Radius of circular array is 52 cm (0.52 meters)

