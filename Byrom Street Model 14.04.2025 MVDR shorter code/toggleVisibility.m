function toggleVisibility(event, soundwave_group, sound_source_group, building_group, street_group, mic_array_group, reflection_group, collision_group, Gridgroup)
    handle = event.Peer;
    if strcmp(handle.Type, 'hggroup') || strcmp(handle.Type, 'patch')
        if any(ismember(handle, [reflection_group, collision_group, soundwave_group, sound_source_group, building_group, street_group, mic_array_group, Gridgroup])) || strcmp(handle.DisplayName, 'Targeted Grid')
                    
            % Toggle the visibility for sound sources and sound waves
            if strcmp(handle.Visible, 'on')
                handle.Visible = 'off';
            else
                handle.Visible = 'on';           
            end

            % Force redraw
            drawnow;
        end
    end
end








