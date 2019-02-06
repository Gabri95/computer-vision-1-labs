clear
clc
close all

reflectance = im2double(imread('ball_reflectance.png'));
shading = im2double(imread('ball_shading.png'));
original = imread('ball.png');

reconstructed = zeros(size(reflectance));
for i = 1:3
    reconstructed(:, :, i) = reflectance(:, :, i) .* shading;
end


figure
plots = 4;

subplot(1, plots, 1);
imshow(reflectance);
title('reflectance');
subplot(1, plots, 2);
imshow(shading);
title('shading');
subplot(1, plots, 3);
imshow(reconstructed);
title('reconstructed');
subplot(1, plots, 4);
imshow(original);
title('original');

% subplot(1, plots, 4);
% hist(double(reshape(reconstructed, 1, [])));
