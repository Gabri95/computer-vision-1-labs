clear all;
close all;
clc


img1 = imread('synth1.pgm');
img2 = imread('synth2.pgm');

plot_optical_flow(img1, img2, 7);

pause(0.3);

img1 = imread('sphere1.ppm');
img2 = imread('sphere2.ppm');

plot_optical_flow(img1, img2, 7);



function plot_optical_flow(img1, img2, R)

if length(size(img1)) == 2
    [H, W] = size(img1);
else
    [H, W, C] = size(img1);
end

[X,Y] = meshgrid(1:W, 1:H);

X_s = X(R:2*R+1:end,R:2*R+1:end);
Y_s = Y(R:2*R+1:end,R:2*R+1:end);


V = lukas_kanade(img1, img2, X_s, Y_s, R);


f = figure;
if length(size(img1)) == 2
    colormap(f, gray);
end


imshow(img1);
axis image
hold on
quiver(X_s, Y_s, V(:, :, 1), V(:, :, 2), 'color', [1 0 0]);

end