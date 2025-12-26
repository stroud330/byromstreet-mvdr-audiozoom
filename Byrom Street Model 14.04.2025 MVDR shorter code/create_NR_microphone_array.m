function [mic_coordinates_NR]=create_NR_microphone_array(dimensions)
    % Constants for NR Microphones
    verticalSpacingFeedback = 0.02; % 2 cm for feedback microphone
    verticalSpacingFeedforward = 0.40; % 40 cm for feedforward microphone

    % Define the positions of the two noise reduction microphones
    mic_coordinates_NR = [
        dimensions.arraycentreX, dimensions.arraycentreY, dimensions.arraycentreZ + verticalSpacingFeedback; % Feedback
        dimensions.arraycentreX, dimensions.arraycentreY, dimensions.arraycentreZ + verticalSpacingFeedforward % Feedforward
    ];

    % Define the radius of the noise reduction microphones
    micRadius = 0.05;  % Same radius as main array mics
    NR_labels = {'NR1', 'NR2'}; % Labels for NR microphones

    % Adding NR microphones and the connecting rectangle to existing figures
    for fig = 1:3
        figure(fig); % Select the figure
        hold on;

        % Plotting the rectangle connecting the NR mics
        rectangleWidth = 1 * micRadius; % Slightly wider than the mic
        rectangleX = [mic_coordinates_NR(1, 1) - rectangleWidth / 2, mic_coordinates_NR(1, 1) + rectangleWidth / 2, mic_coordinates_NR(1, 1) + rectangleWidth / 2, mic_coordinates_NR(1, 1) - rectangleWidth / 2];
        rectangleY = [mic_coordinates_NR(1, 2), mic_coordinates_NR(1, 2), mic_coordinates_NR(1, 2), mic_coordinates_NR(1, 2)];
        rectangleZ = [mic_coordinates_NR(1, 3), mic_coordinates_NR(1, 3), mic_coordinates_NR(2, 3), mic_coordinates_NR(2, 3)];
        patch(rectangleX, rectangleY, rectangleZ, [245/255, 245/255, 220/255], 'EdgeColor', 'k');

        % Drawing the NR microphones
        for mic = 1:size(mic_coordinates_NR, 1)
            % Define the coordinates for the circular patch
            theta = linspace(0, 2*pi, 50);
            x = mic_coordinates_NR(mic, 1) + micRadius * cos(theta);
            y = mic_coordinates_NR(mic, 2) + micRadius * sin(theta);
            z = repmat(mic_coordinates_NR(mic, 3), size(x));

            % Draw the circular patch
            patch(x, y, z, 'b'); % Blue color for NR microphones

                     % Add labels for NR microphones
            text(mic_coordinates_NR(mic, 1), mic_coordinates_NR(mic, 2), mic_coordinates_NR(mic, 3), NR_labels{mic}, ...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k', 'FontSize', 6);
        end

        % Adjustments for each specific figure
        if fig == 3
            xlabel('X (metres)');
            ylabel('Y (metres)');
            zlabel('Z (metres)');
            title('Combined Microphone Array with NR Mics');
            view(3); % Set 3D view
            axis equal;
            light('Position', [20, 20, 30]);
            light('Position', [40, 10, 30]);
        end

        hold off;
    end
end
