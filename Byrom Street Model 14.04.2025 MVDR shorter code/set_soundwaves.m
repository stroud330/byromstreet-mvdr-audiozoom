function [soundwave_choice, custom_soundProfile] = set_soundwaves()
    soundwave_choice = [];  
    custom_soundProfile = struct('SPL', zeros(1,9), 'Azimuth', zeros(1,9), 'Elevation', zeros(1,9), 'HBW', zeros(1,9), 'VBW', zeros(1,9));
    
    fprintf('\n\nSOUNDWAVES:\n');
    fprintf('-----------------------------------------\n');
    fprintf('Would you like to create custom soundwaves?\n');
    fprintf('\n');
    fprintf('1 = No, use predetermined soundwaves from the 9 sources (default)\n');
    fprintf('2 = Yes, I want to create custom soundwaves for the 9 sources\n');
    validChoices = {'1', '2'};
    
    while true
        fprintf('\n');
        fprintf('Enter the choice (or press ''q'' to quit): ');
        soundwave_choice = input('', 's');
        if strcmpi(soundwave_choice, 'q')
            soundwave_choice = 'q';
            custom_soundProfile = [];
            return;
        end
        if any(strcmpi(soundwave_choice, validChoices))
            break;
        else
            fprintf('Invalid choice. Please enter a valid option.\n');
        end
    end
    
if strcmp(soundwave_choice, '2')
    fieldNames = fieldnames(custom_soundProfile);
    validRanges = struct('SPL', [0, 120], 'Azimuth', [0, 360], 'Elevation', [-90, 90], 'HBW', [10, 180], 'VBW', [10, 180]);

    i = 1;
    while i <= 9
        fprintf('\n\nSound Source %d:\n', i);
        fprintf('----------------------------------------------------------\n');
        fprintf('Enter all five parameters in one line separated by spaces\n');
        fprintf('----------------------------------------------------------\n');
        fprintf('SPL dB 1m(0:120) | Azimuth(0:360) | Elevation(-90:90) | HBW(10:180) | VBW(10:180)\n: ');

        input_line = input('', 's');
        if strcmpi(input_line, 'q')
            soundwave_choice = 'q';
            custom_soundProfile = [];
            return;
        end
        params = str2double(strsplit(input_line));

        if length(params) == 5  % Check if all 5 parameters are entered
            isValid = true;  % flag to check if all parameters are valid
            for j = 1:numel(fieldNames)
                fieldName = fieldNames{j};
                minVal = validRanges.(fieldName)(1);
                maxVal = validRanges.(fieldName)(2);
                if params(j) < minVal || params(j) > maxVal
                    fprintf('Invalid input for %s, the accepted range is (%d:%d).\n', fieldName, minVal, maxVal);
                    isValid = false;
                end
            end

            if isValid
                for j = 1:numel(fieldNames)
                    fieldName = fieldNames{j};
                    custom_soundProfile(i).(fieldName) = params(j);
                end
                i = i + 1;  % Move to the next speaker only if the input is valid
            end
        else
            fprintf('Invalid input. Please enter all 5 parameters.\n');
        end
    end
end

