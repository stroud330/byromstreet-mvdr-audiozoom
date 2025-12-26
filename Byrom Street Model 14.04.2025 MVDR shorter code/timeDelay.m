function timeDelay = timeDelay(speaker_coordinates, mic_coordinates)
%% Calculate the average time delays for each microphone, based on the distances from all 9 speakers (timeDelay 16 x 1)
% Define the indices of the speakers that you want to include in the calculation
speakerNumber = [1, 2, 3, 4, 5, 6, 7, 8, 9];  % Change this to include the indices of the speakers you want to include 1, 2, 3, 4, 5, 6, 7, 8, 9
% Define the speed of sound in air (in m/s)
speedOfSound = 343;
% Calculate the time delay for each microphone
timeDelay = zeros(size(mic_coordinates, 1), 1);
for i = 1:size(mic_coordinates, 1)
% Calculate the distance from the speaker to the microphone
micX = mic_coordinates(i, 1);
micY = mic_coordinates(i, 2);
distance = 0;
for j = 1:length(speakerNumber)
spkX = speaker_coordinates(speakerNumber(j), 1);
spkY = speaker_coordinates(speakerNumber(j), 2);
distance = distance + sqrt((micX-spkX)^2 + (micY-spkY)^2);
end
% Calculate the time delay (in seconds)
timeDelay(i) = distance / speedOfSound;  % This gives an average of all the speakers delay to each mic in seconds
end