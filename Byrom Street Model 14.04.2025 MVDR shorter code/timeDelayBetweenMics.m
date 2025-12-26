function timeDelayBetweenMics = timeDelayBetweenMics(mic_coordinates, timeDelay)
%% Calculate the time delay between each pair of microphones in seconds (timeDelayBetweenMics 16 x 16)
timeDelayBetweenMics = zeros(size(mic_coordinates, 1), size(mic_coordinates, 1));
for i = 1:size(mic_coordinates, 1)
for j = 1:size(mic_coordinates, 1)
timeDelayBetweenMics(i, j) = abs(timeDelay(i) - timeDelay(j));
end
end