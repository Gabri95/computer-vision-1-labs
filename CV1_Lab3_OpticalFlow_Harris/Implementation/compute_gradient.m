function [Gx, Gy] = compute_gradient(image)

image = im2double(image);

Sx = double([-1 0 1; -2 0 2; -1 0 1])/8;
Sy = double([-1 -2 -1; 0 0 0; 1 2 1])/8;

Gx = imfilter(image, Sx);
Gy = imfilter(image, Sy);


end

