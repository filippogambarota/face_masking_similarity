% Copy Files

[im_name, im_path] = loadNames(fullfile("stimuli", "raw", "KDEF"),  'A*NES.JPG*');

for i = 1:length(im_path)
    copyfile(fullfile(im_path{i}, im_name{i}), fullfile("stimuli", "raw", "selection"))
end