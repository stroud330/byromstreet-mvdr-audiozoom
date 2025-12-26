function createInteractiveLegend(mic_array_group, building_group, street_group, sound_source_group, soundwave_group, collision_group, reflection_group, Gridgroup)
figure(2)    
% Create the legend
    lgd = legend([mic_array_group, building_group, street_group, sound_source_group, soundwave_group, collision_group, reflection_group, Gridgroup], ...
             {'Mic Array','Buildings', 'Streets', 'Sound Sources', 'Sound Waves', 'Collision Points', 'Reflections', 'Targeted Grid'});
         
    % Add Item Click Function
    set(lgd, 'ItemHitFcn', @(src, event) toggleVisibility(event, soundwave_group, sound_source_group, building_group, street_group, mic_array_group, reflection_group, collision_group, Gridgroup));
    
    % Set legend children color
    c = get(lgd, 'Children');
    set(c, 'Color', [0 1 0]);
    
    % Add title to the legend
    title(lgd, 'Click to toggle visibility');
end

