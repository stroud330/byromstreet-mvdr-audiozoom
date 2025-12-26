function timeDelaySpkMics = timeDelaySpkMics(speaker_coordinates, mic_coordinates)
%% Define an array to store the time differences between each speaker and each microphone (timeDelaySpkMics 9 x 16)
speakerNumber = [1, 2, 3, 4, 5, 6, 7, 8, 9];
speedOfSound = 343;
timeDelaySpkMics = zeros(length(speakerNumber), size(mic_coordinates, 1));
% Calculate the time differences between each speaker and each microphone
for i = 1:length(speakerNumber)
    spkX = speaker_coordinates(speakerNumber(i), 1);
    spkY = speaker_coordinates(speakerNumber(i), 2);
    spkZ = speaker_coordinates(speakerNumber(i), 3);
    for j = 1:size(mic_coordinates, 1)
        micX = mic_coordinates(j, 1);
        micY = mic_coordinates(j, 2);
        micZ = mic_coordinates(j, 3);
        timeDelaySpkMics(i, j) = sqrt((spkX-micX)^2 + (spkY-micY)^2 + (spkZ-micZ)^2) / speedOfSound;
    end
end