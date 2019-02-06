clear all;
close all;
clc

img1 = imread('person_toy/00000001.jpg');
img2 = imread('pingpong/0000.jpeg');
img_mask = imread('mask.png'); % testing the function with an easy case with 4 corners

angle = randi(360);

%custom image rotator with original background
img1_rotated = smart_rotate(img1, angle);
% img1_rotated = imrotate(img1, angle);


%NB printing two images at once may result in corner of two being plotted on one
[h,r,c] = harris_corner_detector(img1, true, 0.03);
pause(0.3)
[h,r,c] = harris_corner_detector(img2, true, 0.22);
pause(0.3)
[h,r,c] = harris_corner_detector(img_mask, true);
pause(0.3)
[h,r,c] = harris_corner_detector(img1_rotated, true, 0.03);
