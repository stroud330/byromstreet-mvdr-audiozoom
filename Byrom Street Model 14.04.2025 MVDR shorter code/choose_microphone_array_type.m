function [array_shape_choice,mic_coordinates, dimensions, mic_array_group, micsOn] = choose_microphone_array_type(dimensions)
    
    fprintf('\n\nMICROPHONE ARRAY TYPE:\n');
    fprintf('-----------------------------------------\n');
    fprintf('Choose a microphone array type:\n');
    fprintf('\n');
    fprintf('S = Square array\n');
    fprintf('C = Circular array\n');
    fprintf('O = Octagonal array\n');
    fprintf('+ = Cross array\n');
    fprintf('* = Star array\n');
    
    validChoices = {'S', 'C', 'O', '+', '*'}; % Valid choices
    while true
        fprintf('\n');
        fprintf('Enter your choice (or press ''q'' to quit): ');
        array_shape_choice = input('', 's');
        
        % Check if the user wants to quit
        if strcmpi(array_shape_choice, 'Q')
          mic_coordinates = []; % Return an empty array
          dimensions = [];
          mic_array_group = [];
          micsOn = [];
            return; % Exit the program
        end
        
        % Check if the input is valid
        if any(strcmpi(array_shape_choice, validChoices))
            break; % Exit the loop for valid choices
        else
            disp('Invalid choice. Please enter a valid option.');
        end
    end
    
    switch upper(array_shape_choice)
        case 'S'
            [mic_coordinates,dimensions, mic_array_group, micsOn] = create_square_microphone_array(dimensions);
        case 'C'
            [mic_coordinates, dimensions, mic_array_group, micsOn] = create_circular_microphone_array(dimensions);
        case 'O'
            [mic_coordinates, dimensions, mic_array_group, micsOn] = create_octagonal_microphone_array(dimensions);
        case '+'
            [mic_coordinates, dimensions, mic_array_group, micsOn] = create_cross_microphone_array(dimensions);
        case '*'
            [mic_coordinates, dimensions, mic_array_group, micsOn] = create_star_microphone_array(dimensions);
    end
   end

