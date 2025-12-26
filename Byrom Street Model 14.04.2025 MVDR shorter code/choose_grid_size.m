function [dimensions, grid_size_choice, input_line] = choose_grid_size(dimensions)

    figure(3);
    input_line = '';  % Initialize input_line
    fprintf('\n\nGRID SIZE:\n');
    fprintf('-----------------------------------------\n');
    fprintf('How large would you like the grid around the mic array to be (meters)?\n');
    fprintf('\n');
    fprintf('1 = Full-size (40m x 60m)\n2 = Half-size (20m x 30m)\n3 = Third-size (13.3m x 20m)\n4 = Quarter-size (10m x 15m)\n512 = 5.12 size (4.57m x 3.42m)\nC = Custom-size (User Choice)\n');
    
    validChoices = {'1', '2', '3', '4', '512', 'C'};
    
    while true
        fprintf('\n');
        fprintf('Enter the choice (or press ''q'' to quit): ');
        grid_size_choice = input('', 's');
        
        % Check if the user wants to quit
        if strcmpi(grid_size_choice, 'q')
            return; % Exit the program
        end
        
        % Validate input
        if any(strcmpi(grid_size_choice, validChoices))
            break; % Exit the loop for valid choices
        else
            disp('Invalid choice. Please enter a valid option.');
        end
    end
    
    % Process user's valid choice
    switch upper(grid_size_choice)
        case '1'
            dimensions = create_grid(dimensions);
        case '2'
            dimensions = create_half_size_grid(dimensions);
        case '3'
            dimensions = create_third_size_grid(dimensions);
        case '4'
            dimensions = create_quarter_size_grid(dimensions);
        case '512'
            dimensions = create_512_size_grid(dimensions);
        case 'C'
            while true
                fprintf('\n\nCustom Grid Size:\n');
                fprintf('----------------------------------------------------------\n');
                fprintf('Enter X and Y values (in meters) separated by a space\n');
                fprintf('----------------------------------------------------------\n');
                fprintf('X (0:40) | Y (0:60)\n: ');
                
                input_line = input('', 's');
                
                % Check for quit command
                if strcmpi(input_line, 'q')
                    return;
                end
                
                % Parse input
                xy = str2double(strsplit(input_line, ' '));
                if length(xy) == 2
                    x = xy(1);
                    y = xy(2);
                    if (x >= 0 && x <= 40) && (y >= 0 && y <= 60)
                        dimensions = create_custom_grid(dimensions, x, y);
                        break;
                    else
                        fprintf('Invalid input. The acceptable range for X is 0 to 40 and for Y is 0 to 60.\n');
                    end
                else
                    fprintf('Invalid input. Please enter two numbers separated by a space.\n');
                end
            end
    end
end

