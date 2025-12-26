function z_positions = calculate_z_positions(x_positions, y_positions, dimensions)
    % Initialize parameters for x and y axes
    zMin_x = dimensions.zMin_x;
    zMax_x = dimensions.zMax_x;
    zMin_y = dimensions.zMin_y;
    zMax_y = dimensions.zMax_y;
    roomLength = dimensions.roomLength;
    roomWidth = dimensions.roomWidth;
    
    % Calculate slopes for x and y axes
    m_x = (zMax_x - zMin_x) / roomLength;
    m_y = (zMax_y - zMin_y) / roomWidth;
    
    % Initialize z_positions
    z_positions = zeros(1, length(x_positions));
    
    % Calculate z_positions based on the slopes for x and y axes
    for i = 1:length(x_positions)
        z_positions(i) = m_x * x_positions(i) + m_y * y_positions(i) + zMin_x;
    end
end





