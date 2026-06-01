% This script clusters an image into 4 dominant shades.

% 1. Load the image
img = imread('Image_with_artifacts.jpg');

% 2. Reshape the image into a list of RGB pixels for clustering
% Reshape from (Rows x Cols x 3) to (TotalPixels x 3)
[rows, cols, ~] = size(img);
pixels = reshape(img, [], 3);

% 3. Use K-means to find 4 dominant colors
% 'idx' contains the cluster assignment for every pixel
% 'centers' contains the RGB values for those 4 clusters
[idx, centers] = kmeans(double(pixels), 4);

% 4. Map the original pixels to the 4 centers
finalPixels = zeros(size(pixels), 'uint8');
for k = 1:4
    % Calculate how many pixels are in this cluster
    count = sum(idx == k);
    % Repeat the center color 'count' times so dimensions match
    finalPixels(idx == k, :) = repmat(uint8(centers(k, :)), count, 1);
end

% 5. Reconstruct the image
finalImg = reshape(finalPixels, [rows, cols, 3]);

% 6. Save and Display
imwrite(finalImg, 'Image_without_artifacts.png');
imshow(finalImg);
