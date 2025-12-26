function [sound_source_group, speaker_coordinates] = create_sound_sources(dimensions, spk_location_choice, speaker_coordinates)
%% Create the boxes representing the speakers
sound_source_group =[];
if strcmp(spk_location_choice, '1')
SpeakerZ = 0; % standing on the floor , change height, width etc in 'dimensions'.

% Speaker coordinates (9 speakers, each with an x, y, z position)
speaker_coordinates = [    
[dimensions.gridcorners(1).x, dimensions.gridcorners(1).y-dimensions.speakerLength, SpeakerZ];                        % spk 1
[dimensions.arraycentreX-dimensions.speakerLength/2, dimensions.gridcorners(2).y-dimensions.speakerLength, SpeakerZ]; % spk 2
[dimensions.gridcorners(2).x-dimensions.speakerWidth, dimensions.gridcorners(2).y-dimensions.speakerLength, SpeakerZ];% spk 3
[dimensions.gridcorners(1).x, dimensions.arraycentreY-dimensions.speakerLength/2, SpeakerZ];                          % spk 4
[dimensions.arraycentreX-dimensions.speakerLength/2, dimensions.arraycentreY-dimensions.speakerLength/2, SpeakerZ];   % spk 5
[dimensions.gridcorners(2).x-dimensions.speakerWidth, dimensions.arraycentreY-dimensions.speakerLength/2, SpeakerZ];  % spk 6
[dimensions.gridcorners(3).x, dimensions.gridcorners(3).y, SpeakerZ];                                                 % spk 7
[dimensions.arraycentreX-dimensions.speakerLength/2, dimensions.gridcorners(3).y, SpeakerZ];                          % spk 8
[dimensions.gridcorners(4).x-dimensions.speakerWidth, dimensions.gridcorners(4).y, SpeakerZ];                         % spk 9
];

% fix speakers on the slope
SpeakerX = speaker_coordinates(:, 1);
SpeakerY = speaker_coordinates(:, 2);
SpeakerZ = calculate_z_positions(SpeakerX, SpeakerY, dimensions);
speaker_coordinates(:, 3) = SpeakerZ;

figure (1);
% Draw the speakers
for i = 1:length(speaker_coordinates)
    x = speaker_coordinates(i, 1);
    y = speaker_coordinates(i, 2);
    z = speaker_coordinates(i, 3);
    % Define the vertices of the box
    vertices = [
        x, y, z;
        x + dimensions.speakerWidth, y, z;
        x + dimensions.speakerWidth, y + dimensions.speakerLength, z;
        x, y + dimensions.speakerLength, z;
        x, y, z + dimensions.speakerHeight;
        x + dimensions.speakerWidth, y, z + dimensions.speakerHeight;
        x + dimensions.speakerWidth, y + dimensions.speakerLength, z + dimensions.speakerHeight;
        x, y + dimensions.speakerLength, z + dimensions.speakerHeight;
    ];
    % Define the faces of the boxes
    faces = [
        1, 2, 3, 4;
        5, 6, 7, 8;
        1, 2, 6, 5;
        3, 4, 8, 7;
        1, 4, 8, 5;
        2, 3, 7, 6;
    ];
    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', [245/255, 245/255, 220/255]);
    text(x + dimensions.speakerWidth/2, y + dimensions.speakerLength/2, speaker_coordinates(i, 3)+2.5, num2str(i), 'FontSize', 12,'Color', 'r', 'HorizontalAlignment', 'center');
end
figure(2);

sound_source_group = hggroup;

% Draw the speakers
for i = 1:length(speaker_coordinates)
    x = speaker_coordinates(i, 1);
    y = speaker_coordinates(i, 2);
    z = speaker_coordinates(i, 3);
    % Define the vertices of the box
    vertices = [
        x, y, z;
        x + dimensions.speakerWidth, y, z;
        x + dimensions.speakerWidth, y + dimensions.speakerLength, z;
        x, y + dimensions.speakerLength, z;
        x, y, z + dimensions.speakerHeight;
        x + dimensions.speakerWidth, y, z + dimensions.speakerHeight;
        x + dimensions.speakerWidth, y + dimensions.speakerLength, z + dimensions.speakerHeight;
        x, y + dimensions.speakerLength, z + dimensions.speakerHeight;
    ];
    % Define the faces of the boxes
    faces = [
        1, 2, 3, 4;
        5, 6, 7, 8;
        1, 2, 6, 5;
        3, 4, 8, 7;
        1, 4, 8, 5;
        2, 3, 7, 6;
    ];
    patch('Parent', sound_source_group, 'Vertices', vertices, 'Faces', faces, 'FaceColor', 'b');%[245/255, 245/255, 220/255]);
    text(x + dimensions.speakerWidth/2, y + dimensions.speakerLength/2, speaker_coordinates(i, 3)+2.5, num2str(i), 'FontSize', 12, 'Color', 'r', 'HorizontalAlignment', 'center', 'Parent', sound_source_group);
    drawnow;
end
elseif strcmp(spk_location_choice, '2')

figure (1);
% Draw the speakers
for i = 1:length(speaker_coordinates)
    x = speaker_coordinates(i, 1);
    y = speaker_coordinates(i, 2);
    z = speaker_coordinates(i, 3);
    % Define the vertices of the box
    vertices = [
        x, y, z;
        x + dimensions.speakerWidth, y, z;
        x + dimensions.speakerWidth, y + dimensions.speakerLength, z;
        x, y + dimensions.speakerLength, z;
        x, y, z + dimensions.speakerHeight;
        x + dimensions.speakerWidth, y, z + dimensions.speakerHeight;
        x + dimensions.speakerWidth, y + dimensions.speakerLength, z + dimensions.speakerHeight;
        x, y + dimensions.speakerLength, z + dimensions.speakerHeight;
    ];
    % Define the faces of the boxes
    faces = [
        1, 2, 3, 4;
        5, 6, 7, 8;
        1, 2, 6, 5;
        3, 4, 8, 7;
        1, 4, 8, 5;
        2, 3, 7, 6;
    ];
    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', [245/255, 245/255, 220/255]);
    text(x + dimensions.speakerWidth/2, y + dimensions.speakerLength/2, speaker_coordinates(i, 3)+2.5, num2str(i), 'FontSize', 12,'Color', 'r', 'HorizontalAlignment', 'center');
end
figure(2);
sound_source_group = hggroup; 

% Draw the speakers
for i = 1:length(speaker_coordinates)
    x = speaker_coordinates(i, 1);
    y = speaker_coordinates(i, 2);
    z = speaker_coordinates(i, 3);
    % Define the vertices of the box
    vertices = [
        x, y, z;
        x + dimensions.speakerWidth, y, z;
        x + dimensions.speakerWidth, y + dimensions.speakerLength, z;
        x, y + dimensions.speakerLength, z;
        x, y, z + dimensions.speakerHeight;
        x + dimensions.speakerWidth, y, z + dimensions.speakerHeight;
        x + dimensions.speakerWidth, y + dimensions.speakerLength, z + dimensions.speakerHeight;
        x, y + dimensions.speakerLength, z + dimensions.speakerHeight;
    ];
    % Define the faces of the boxes
    faces = [
        1, 2, 3, 4;
        5, 6, 7, 8;
        1, 2, 6, 5;
        3, 4, 8, 7;
        1, 4, 8, 5;
        2, 3, 7, 6;
    ];
    patch('Parent', sound_source_group, 'Vertices', vertices, 'Faces', faces, 'FaceColor', [245/255, 245/255, 220/255]);
    text(x + dimensions.speakerWidth/2, y + dimensions.speakerLength/2, speaker_coordinates(i, 3)+2.5, num2str(i), 'FontSize', 12, 'Color', 'r', 'HorizontalAlignment', 'center', 'Parent', sound_source_group);
 
end
drawnow;
end
