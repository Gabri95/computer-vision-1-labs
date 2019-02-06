clear
clc
close all

I = imread('sky.jpg');

output_image = automatic_color_balance(I);

figure

subplot(1, 3, 1);
imshow(I);
title('original');
subplot(1, 3, 2);
imshow(output_image);
title('awb');

I_lin = rgb2lin(I);
percentiles = 5;
illuminant = illumgray(I_lin,percentiles);
B_lin = chromadapt(I_lin,illuminant,'ColorSpace','linear-rgb');
B = lin2rgb(B_lin);
 
subplot(1, 3, 3);
imshow(B);
title('illumgray');



function [output_image] = automatic_color_balance (input_image)

input_image = im2double(input_image);

R = input_image(:,:,1);
G = input_image(:,:,2);
B = input_image(:,:,3);
R_norm = mean(R(:));
G_norm = mean(G(:));
B_norm = mean(B(:));
output_image = zeros(size(input_image));
output_image(:, :, 1) = R / R_norm;
output_image(:, :, 2) = G / G_norm;
output_image(:, :, 3) = B / B_norm;

% [h, w, ~] = size(input_image);
% N = h*w;
% norm = 3 * sum(sum(input_image, 1), 2) / N;
% output_image = sum(input_image, 3) ./ norm;

% output_image = output_image / max(output_image(:));
output_image = output_image ./ max(max(output_image, 1), 2);
end