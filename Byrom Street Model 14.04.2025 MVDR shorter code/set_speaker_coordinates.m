function [spk_location_choice, speaker_coordinates, input_line] = set_speaker_coordinates()
    % Initialize output variables
    spk_location_choice = [];
    speaker_coordinates = zeros(9, 3);  % Initialized to a 9x3 zero array
    input_line = [];
    
    fprintf('\n\nSOUND SOURCE PLACEMENT:\n');
    fprintf('-----------------------------------------\n');
    fprintf('Where would you like to place the sound sources?\n');
    fprintf('\n');
    fprintf('1 = 9 sources in and around the edge of the chosen grid (default)\n');
    fprintf('2 = Your own custom X,Y,Z coordinates for the 9 sound sources\n');
    validChoices = {'1', '2'};
    
    while true
        fprintf('\n');
        fprintf('Enter the choice (or press ''q'' to quit): ');
        spk_location_choice = input('', 's');
        if strcmpi(spk_location_choice, 'q')
            return;  % Exit the function
        end
        if any(strcmpi(spk_location_choice, validChoices))
            break;  % Exit the loop for valid choices
        else
            fprintf('Invalid choice. Please enter a valid option.\n');
        end
    end
    
    if strcmp(spk_location_choice, '2')
        validRanges = struct('X', [0, 80], 'Y', [0, 110], 'Z', [0, 50]);
        coord_str = {'X', 'Y', 'Z'};
        
        i = 1;
        while i <= 9
            fprintf('\n\nSound Source %d:\n', i);
            fprintf('----------------------------------------------------------\n');
            fprintf('Enter X, Y, Z values in one line separated by spaces\n');
            fprintf('----------------------------------------------------------\n');
            fprintf('X (0:80) | Y (0:110) | Z (0:50)\n: ');
            
            input_line = input('', 's');
            if strcmpi(input_line, 'q')
                return;  % Exit the function
            end
            coords = str2double(strsplit(input_line));
            
            if length(coords) == 3  % Check if all 3 coordinates are entered
                isValid = true;  % Flag to check if all coordinates are valid
                for j = 1:numel(coord_str)
                    coord = coord_str{j};
                    minVal = validRanges.(coord)(1);
                    maxVal = validRanges.(coord)(2);
                    if coords(j) < minVal || coords(j) > maxVal
                        fprintf('Invalid input for %s, the accepted range is (%d:%d).\n', coord, minVal, maxVal);
                        isValid = false;
                    end
                end
                
                if isValid
                    speaker_coordinates(i, :) = coords;
                    i = i + 1;  % Move to the next speaker only if the input is valid
                end
            else
                fprintf('Invalid input. Please enter all 3 coordinates.\n');
            end
            figure(1);
        end
    end
end
