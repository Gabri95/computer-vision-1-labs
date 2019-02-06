close all
clear all
clc

img = imread('images/image2.jpg');

figure;imshow(img)

[H, W] = size(img);

[Gx, Gy, im_magnitude,im_direction] = compute_gradient(img);


figure
magnitude_thr = im_magnitude / max(im_magnitude(:));
imshow(magnitude_thr)
title('Magnitude')
pause(0.4)

Gx_n = (Gx - min(Gx(:))) / (max(Gx(:)) - min(Gx(:)));
Gy_n = (Gy - min(Gy(:))) / (max(Gy(:)) - min(Gy(:)));

im_direction_n = im_direction / pi; %(2*pi);


figure

subplot(2, 2, 1)
imshow(Gx_n)
title('Gradient X')

subplot(2, 2, 2)
imshow(Gy_n)
title('Gradient Y')

subplot(2, 2, 3)
imshow(im_magnitude / max(im_magnitude(:)))
title('Magnitude')

subplot(2, 2, 4)
imshow(im_direction)
title('Angle')




sampling = 15;
start = 8;

[X, Y] = meshgrid(0:W,0:H);

X_s = X(start:sampling:H,start:sampling:W);
Y_s = Y(start:sampling:H,start:sampling:W);
Gx_s = Gx(start:sampling:H,start:sampling:W);
Gy_s = Gy(start:sampling:H,start:sampling:W);


f = figure;
colormap(f, gray);

quiver(X_s,Y_s,Gx_s,Gy_s, 'color', [1 0 0]);
axis image
hax = gca;
imagesc(hax.XLim,hax.YLim,img);
hold on;
quiver(X_s,Y_s,Gx_s,Gy_s, 'color', [1 0 0]);



%normalize the gradient vectors
Gx_s = (Gx ./ im_magnitude);
Gy_s = (Gy ./ im_magnitude);

Gx_s = Gx_s(start:sampling:H,start:sampling:W);
Gy_s = Gy_s(start:sampling:H,start:sampling:W);

figure;
quiver(X_s,Y_s,Gx_s,Gy_s, 'color', [1 0 0]);
axis image
hax = gca; 
imagesc(hax.XLim,hax.YLim,im_magnitude / max(im_magnitude(:)));
hold on;
quiver(X_s,Y_s,Gx_s,Gy_s, 'color', [1 0 0]);

title('Gradient Vector Field')



