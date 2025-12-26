function name_save_audio_file(user_input, beamformed_audio, fs)
user_input_numeric = str2double(user_input);
filename = sprintf('Beamformed_Audio_Grid_%d.wav', user_input_numeric);
audiowrite(filename, beamformed_audio, fs);