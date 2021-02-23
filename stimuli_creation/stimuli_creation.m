%% Workspace

clear
close all

%% Copyfile

% [im_name, im_path] = loadNames(fullfile("stimuli", "raw", "KDEF"),  'A*NES.JPG*');
% 
% for i = 1:length(im_path)
%     copyfile(fullfile(im_path{i}, im_name{i}), fullfile("stimuli", "raw", "selection"))
% end

%% Load Files

[all_images, n_image, all_images_name] = readImages("stimuli/raw/filippo/selection", 'jpg'); % this function read all images and convert to greyscale / from SHINE toolbox
all_images_name = strrep(all_images_name,"JPG","png"); %convert to png for writing with the same name

%% General Parameters

scale_factor = 0.4;

exp_path = fullfile("..", "face_sim_masking_filippo", "face");

%% Which Images

females = ["01", "02", "03", "06", "09", "12", "14", "20"];
females = strcat("AF", females);

males = ["02", "03", "05", "07", "10", "21", "28", "35"];
males = strcat("AM", males);

subselection = [males, females];

%% Subset

all_images = all_images(contains(all_images_name, subselection));
all_images_name = all_images_name(contains(all_images_name, subselection));

%% Oval Cropping Parameters

% These are arbitrary parameters based. You need to check the best
% combination: x,y = position (use a programe like Gimp)

x = 130;
y = 226;
width = 300;
height = 407;

%% Mask Preparation

im_mask = all_images{1};
imshow(im_mask);
ellipse = imellipse(gca,[x y width height]);
MASK = double(ellipse.createMask());
close;

% imcrop(im, [xmin, ymin, width, heigth]

MASK = imcrop(MASK,[130 226 width-1 height-4]); % creating the cropped mask
MASK = imresize(MASK, scale_factor);

% This remove extra borders from the image outside the mask

for i = 1:length(all_images)
    all_images{i} = imcrop(all_images{i}, [x y width-1 height-4]);
    all_images{i} = imresize(all_images{i}, scale_factor);
end

%% Mask Creation

mask_exp = cell(length(all_images), 1);

for i = 1:length(mask_exp)
     mask_exp{i} = scramble(all_images{i}, 15);
end

%% Stimuli For Experiment

%% Using the histmatch function

hist_match = input("clc hist match ? (1 = yes, 0 = no)     ");

if hist_match == 1
    all_images = histMatch(all_images, imbinarize(MASK)); %match with Avanaki (2009) algorithm
end

%% Writing Images

% f = 0;
% m = 0;
% 
% for i = 1:length(all_images)
%     im = all_images{i};
%     if contains(all_images_name{i}, "F")
%         f = f + 1;
%         im_name = strcat("f", num2str(f), ".png");
%     else
%         m = m + 1;
%         im_name = strcat("m", num2str(m), ".png");
%     end
%     imwrite(im, fullfile(cd, 'stimuli','final', im_name), "png", "Alpha", MASK);
% end

% 1-5 male 5-8 female


update_exp = input("Update Filippo Experiment ? (1 = yes, 0 = no)     ");

if update_exp == 1
    write_exp = true;
else
     write_exp = false;
end

count_m = 0;
count_f = 0;

for i = 1:length(all_images)
    im = all_images{i};
    mask_temp = mask_exp{i};
    if contains(all_images_name{i}, "F")
        count_f = count_f + 1;
        im_name = strcat("f", num2str(count_f), ".png");
        mask_name = strcat("mask_f", num2str(count_f), ".png");
        %im_name = strcat(num2str(i), ".png");
    else
        count_m = count_m + 1;
        im_name = strcat("m", num2str(count_m), ".png");
        mask_name = strcat("mask_m", num2str(count_m), ".png");
        %im_name = strcat(num2str(i), ".png");
    end
    if write_exp
        imwrite(im, fullfile(exp_path, im_name), "png", "Alpha", MASK);
        imwrite(mask_temp, fullfile(exp_path, mask_name), "png", "Alpha", MASK);
    end
    
    imwrite(im, fullfile(cd, 'stimuli','final', 'filippo', im_name), "png", "Alpha", MASK);
    imwrite(mask_temp, fullfile(cd, 'stimuli', "final", 'filippo', mask_name), "png", "Alpha", MASK);
end

%% Histogram Plotting

for i = 1:length(all_images)
    subplot(11,6,i);
    imhist(all_images{i})
end

sound(sin(2:6000));
disp("Stimuli created! good job man!!")