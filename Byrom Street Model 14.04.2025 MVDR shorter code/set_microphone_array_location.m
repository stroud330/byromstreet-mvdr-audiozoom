function [array_location_choice, dimensions, input_line] = set_microphone_array_location(dimensions)
    figure(1)
    input_line = '';  % Initialize input_line

    fprintf('-----------------------------------------\n');
    fprintf('        AUDIO ZOOMING EXPERIMENT\n');
    fprintf('            Steve Stroud 2024\n');
    fprintf('-----------------------------------------\n');

    fprintf('\n\nMICROPHONE ARRAY PLACEMENT:\n');
    fprintf('-----------------------------------------\n');
    fprintf('Where would you like to place the microphone array?\n');
    fprintf('\n');
    fprintf('1 = Default Position\n');
    fprintf('2 = Custom X,Y,Z coordinates\n');

    validChoices = {'1', '2'};
    validRanges = struct('X', [0, 50], 'Y', [0, 80], 'Z', [0, 50]);

    while true
        fprintf('\n');
        fprintf('Enter your choice (or press ''q'' to quit): ');
        array_location_choice = input('', 's');

        if strcmpi(array_location_choice, 'q')
            return; % Exit the function
        end

        if any(strcmpi(array_location_choice, validChoices))
            break; % Exit the loop for valid choices
        else
            fprintf('Invalid choice. Please enter a valid option.\n');
        end
    end

    if strcmp(array_location_choice, '1')
        dimensions.arraycentreX = 25; % Default X-coordinate
        dimensions.arraycentreY = 40; % Default Y-coordinate
        dimensions.arraycentreZ = 2.5;  % Default Z-coordinate
    elseif strcmp(array_location_choice, '2')
        fprintf('\n\nCustom Microphone Location:\n');
        fprintf('----------------------------------------------------------\n');
        fprintf('Enter X, Y, Z values in one line separated by spaces\n');
        fprintf('----------------------------------------------------------\n');
        fprintf('X (0:50) | Y (0:80) | Z (0:50)\n: ');

        while true
            input_line = input('', 's');
            if strcmpi(input_line, 'q')
                return; % Exit the function
            end
            coords = str2double(strsplit(input_line));

            if length(coords) == 3
                isValid = true;
                coord_str = {'X', 'Y', 'Z'};
                for i = 1:3
                    coord = coord_str{i};
                    minVal = validRanges.(coord)(1);
                    maxVal = validRanges.(coord)(2);
                    if coords(i) < minVal || coords(i) > maxVal
                        fprintf('Invalid input for %s, the accepted range is (%d:%d).\n', coord, minVal, maxVal);
                        isValid = false;
                    end
                end

                if isValid
                    dimensions.arraycentreX = coords(1);
                    dimensions.arraycentreY = coords(2);
                    dimensions.arraycentreZ = coords(3);
                    break;
                end
            else
                fprintf('Invalid input. Please enter all 3 coordinates.\n');
            end
        end
    end
end
