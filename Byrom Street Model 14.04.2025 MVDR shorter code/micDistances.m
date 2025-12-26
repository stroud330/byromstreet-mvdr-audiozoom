function micDistances = micDistances(mic_coordinates)
%% Calculate difference in meters between each Mic. (0.16m or 16 cm between mic 1 and 2) (micDistances 16 x 16)
% Define an array to store the distance between each pair of microphones
micDistances = zeros(size(mic_coordinates, 1), size(mic_coordinates, 1));
% Calculate the distance between each pair of microphones
for i = 1:size(mic_coordinates, 1)
  for j = 1:size(mic_coordinates, 1)
    if i ~= j  % Skip the case where i and j are the same microphone
      mic1X = mic_coordinates(i, 1);
      mic1Y = mic_coordinates(i, 2);
      mic2X = mic_coordinates(j, 1);
      mic2Y = mic_coordinates(j, 2);
      % Calculate the distance between the microphones
      micDistances(i, j) = sqrt((mic1X-mic2X)^2 + (mic1Y-mic2Y)^2); % Divide by 100 to convert from cm to m
    end
  end
end