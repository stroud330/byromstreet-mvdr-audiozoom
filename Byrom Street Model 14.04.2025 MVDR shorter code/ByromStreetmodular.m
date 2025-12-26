% Virtual Crime Scene - Byrom Street Campus 14.04.2025 | Steve Stroud PhD Audio Project LJMU
%% Clear all
clc; clear; close all;
%% DIMENSIONS
dimensions = define_dimensions();
%% CREATE 3D SCENE
[surfaces, world_objects] = create_3D_scene(dimensions);
%% PROMPT TO MOVE ARRAY
[array_location_choice,dimensions, input_line] = set_microphone_array_location(dimensions);
% Check if the user wants to quit
    if strcmpi(array_location_choice, 'q') || strcmpi(input_line, 'q')
        disp('Exiting program.');
        return; % Exit the program
    end
%% CREATE MICROPHONE ARRAY + MICROPHONES
[array_shape_choice,mic_coordinates, dimensions, mic_array_group, micsOn] ...
= choose_microphone_array_type(dimensions);
% Check if the user wants to quit
    if strcmpi(array_shape_choice, 'q')
        disp('Exiting program.');
        return; % Exit the program
    end
%% CREATE A NOISE REDUCTION MICROPHONE ARRAY
[mic_coordinates_NR]=create_NR_microphone_array(dimensions);
%% CREATE GRID
[dimensions, grid_size_choice, input_line] = choose_grid_size(dimensions);
 % Check if the user wants to quit
    if strcmpi(grid_size_choice, 'q') || strcmpi(input_line, 'q')
        disp('Exiting program.');
        return; % Exit the program
    end
%% CREATE SOUND SOURCES
[spk_location_choice,speaker_coordinates,input_line] = set_speaker_coordinates();
[sound_source_group, speaker_coordinates]...
= create_sound_sources(dimensions, spk_location_choice, speaker_coordinates);
 if strcmpi(spk_location_choice, 'q') || strcmpi(input_line, 'q')
    disp('Exiting program.');
    return; % Exit the program
 end
 %% CREATE THE SOUNDWAVES
[soundwave_choice, custom_soundProfile] = set_soundwaves();
 if strcmpi(soundwave_choice, 'q')
        disp('Exiting program.');
        return; % Exit the program
 end
 [start_point, end_point, dimensions, soundwave_group, soundProfile, red_line_start, red_line_end, ...
     collision_array, reflection_group, collision_coords, collision_group, collision_array2, ...
     collision_coords2, collision_array3, collision_coords3, collision_array4, collision_coords4, reflection_data]...
     = create_soundwaves(dimensions, speaker_coordinates, soundwave_choice, custom_soundProfile, world_objects, surfaces);
%% CREATE ZOOMED 3D SCENE
[building_group, street_group] = create_zoomed_3D_scene(dimensions);

%% CHOOSE THEN FILL CHOSEN GRID
[beamform_grid_choice, Gridgroup] = choose_fill_chosen_grid(dimensions);
% Check if the user wants to quit
    if strcmpi(beamform_grid_choice, 'q')
        disp('Exiting program.');
        return; % Exit the program
    end
%% CREATE INTERACTIVE LEGEND
    createInteractiveLegend(mic_array_group, building_group, street_group, sound_source_group, soundwave_group, ...
    collision_group, reflection_group, Gridgroup)
%% DISTANCE AND DELAY CALCULATIONS
distanceSpkMics = distanceSpkMics(speaker_coordinates, mic_coordinates);   ...
% Calculate the distance between the sound sources and the mics in meters (distanceSpkMics 9 x 16)
timeDelay = timeDelay(speaker_coordinates, mic_coordinates);               ...
% Calculate the average time delays for each microphone, based on the distances from all 9 speakers (timeDelay 16 x 1)
timeDelayBetweenMics = timeDelayBetweenMics(mic_coordinates, timeDelay);   ...
% Calculate the time delay between each pair of microphones in seconds (timeDelayBetweenMics 16 x 16)
timeDelaySpkMics = timeDelaySpkMics(speaker_coordinates, mic_coordinates); ...
% Calculate the time delay between each speaker and each microphone (timeDelaySpkMics 9 x 16)
micDistances = micDistances(mic_coordinates);                              ...
% Calculate difference in meters between each Mic. (0.16m or 16 cm between mic 1 and 2) (micDistances 16 x 16)
%% CREATE VIRTUAL AUDIO SIGNALS
%[ALLSPKMics, fs, speedOfSound] = create_virtual_audio_signals(distanceSpkMics, ...
% mic_coordinates, speaker_coordinates, micsOn, soundProfile);
%% IMPORT REAL WORLD AUDIO SIGNALS
[ALLSPKMics, fs, speedOfSound, drone_noise] = import_audio_signals(distanceSpkMics, mic_coordinates, ...
speaker_coordinates, micsOn, soundProfile, reflection_data);
%% MVDR BEAMFORMER
% Check if any mic is on
if any(micsOn)
    % Proceed with beamforming
if ~strcmp(beamform_grid_choice, 'q') % Only proceed if user_input is not 'q'
    [final_filtered_signal, beamformer_audio, beamformer, azimuth_grids]  = beamformer_MVDR...
    (fs, dimensions, beamform_grid_choice, mic_coordinates, speaker_coordinates, ALLSPKMics);
end
else
    % Handle the situation when all mics are off
    warning('All microphones are turned off. Beamforming cannot proceed!');
end

%% DISPLAY SUMMARY
fprintf('\n\nSUMMARY:\n');
fprintf('-----------------------------------------\n');
fprintf(['Figure 1 = Full-size 3D Scene\nFigure 2 = 3D Scene zoomed into chosen grid (with visibility toggle)' ...
    '\nFigure 3 = Microphone array 3D plot\nFigure 4 = Virtual audio signals from the 16 microphones on the array\' ...
    'nFigure 5 = Polar plot of the steered beamformer pattern\nFigure 6 = Polar plot of the chosen array shape Pre Beamforming' ...
    '\nFigure 7 = Beamformer and Filter plots\n']);
fprintf('-----------------------------------------\n');
fprintf(['Upon successful beamforming, 3 audio files in .wav format will be stored in the active directory\n1: pre beamforming, ' ...
    '2: beamformed array, 3: enchanced beamformed array.\n']);
