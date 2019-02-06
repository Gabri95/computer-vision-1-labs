close all
clear all
clc

img = imread('images/image2.jpg');

 
% figure
% imshow(img)
% pause(0.5)

[H, W] = size(img);

% figure

for i = 1:3
    
    out = compute_LoG(img, i);
    out = out / max(out(:));

    figure
%     subplot(1, 3, i)
    imshow(out)
    title(i)
    pause(0.3)
    
end


