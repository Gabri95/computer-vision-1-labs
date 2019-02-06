close all;
clear all;
clc;


% In order to run the experiments, it is required to install "vlfeat" in a directory named "vlfeat" in the main directory.

im1 = './right.jpg';
im2 = './left.jpg';

[I_original, I_stitched] = stitch(im1, im2);

figure;
imshow(I_original);
figure;
imshow(I_stitched);
