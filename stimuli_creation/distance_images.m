for i = 1:length(all_images)
    %imwrite(all_images{i}, fullfile("prova", strcat("im", num2str(i), ".png")), 'alpha', MASK);
    imwrite(all_images{i}, fullfile("prova", "nonmatch", strcat("im", num2str(i), ".png")), 'alpha', MASK);
end

[all_images, n_image, all_images_name] = readImages("prova", 'png'); % this function read all images and convert to greyscale / from SHINE toolbox

all_images_cor = cell(length(all_images), 1);

for i = 1:length(all_images)
    im = all_images{i};
    im_n = imhist(im)./numel(im);
    all_images_cor{i} = im_n;
end

im_matrix =zeros(256,length(all_images));

for i = 1:length(all_images)
    im_matrix(:, i) = all_images_cor{i};
end

im_euc = squareform(pdist(im_matrix', "euclidean"));
im_cor = squareform(pdist(im_matrix', "correlation"));
%im_mal = squareform(pdist(im_matrix', "mahalanobis"));

imagesc(im_euc), colormap(hot)
title('Euclidean distance')
xlabel('Image No.')
ylabel('Image No.')
colorbar

Z = linkage(im_euc)

dendrogram(Z)

im = histMatch(all_images, 1);


for i = 1:length(im)
    imwrite(im{i}, fullfile("prova", all_images_name{i}));
end




imhausdorff(im1, im)

im1 = imbinarize(all_images{1});
im2 = imbinarize(all_images{2});

im_matrix =zeros(70,70);

for i = 1:70
    for j = 1:70
        im_matrix(i, j) = imhausdorff(imbinarize(all_images{i}), imbinarize(all_images{j}));
    end
end

colmin = min(im_matrix);
colmax = max(im_matrix);

im_matrix_r = im_matrix ./ max(im_matrix(:));

imagesc(im_matrix), colormap(hot)
title('Euclidean distance')
xlabel('First Sample No.')
ylabel('Second Sample No.')
colorbar