function distanceSpkMics = distanceSpkMics(speaker_coordinates, mic_coordinates)
%% Calculate the distance between the sound sources and the mics in meters (distanceSpkMics 9 x 16)

% Initialize an array to store the distances
distanceSpkMics = zeros(size(speaker_coordinates, 1), size(mic_coordinates, 1));
% Loop through all the speaker positions
for i = 1:size(speaker_coordinates, 1)
    % Loop through all the microphone positions
    for j = 1:size(mic_coordinates, 1)
        % Calculate the distance between the speaker and microphone using the Pythagorean theorem
        distanceSpkMics(i, j) = sqrt((speaker_coordinates(i, 1) - mic_coordinates(j, 1))^2 + ...
                             (speaker_coordinates(i, 2) - mic_coordinates(j, 2))^2 + ...
                             (speaker_coordinates(i, 3) - mic_coordinates(j, 3))^2);

    end
end