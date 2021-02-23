%% Simply Rename and Move

clear all

[~, ~, all_images_name] = readImages("stimuli/raw/elise", "png");

mask = all_images_name(startsWith(all_images_name, "scr"));
face = all_images_name(~startsWith(all_images_name, "scr"));


update_exp = input("Update Elise Experiment ? (1 = yes, 0 = no)     ");

if update_exp == 1
    write_exp = true;
else
     write_exp = false;
end

for i = 1:length(face)
    copyfile(fullfile("stimuli", "raw", "elise", face{i}), fullfile("stimuli", "final", "elise", face{i}), 'f');
    copyfile(fullfile("stimuli", "raw", "elise", mask{i}), fullfile("stimuli", "final", "elise", strcat("mask_", face{i})), 'f');
    
    if write_exp
        copyfile(fullfile("stimuli", "raw", "elise", face{i}), fullfile("..", "face_sim_masking_elise", "face", face{i}), 'f');
        copyfile(fullfile("stimuli", "raw", "elise", mask{i}), fullfile("..",  "face_sim_masking_elise", "face", strcat("mask_", face{i})), 'f');
    end
end