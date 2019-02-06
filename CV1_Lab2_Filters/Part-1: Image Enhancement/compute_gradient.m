function [Gx, Gy, im_magnitude,im_direction] = compute_gradient(image)

image = im2double(image);

Sx = double([-1 0 1; -2 0 2; -1 0 1])/8;
Sy = double([1 2 1; 0 0 0; -1 -2 -1])/8;

Gx = imfilter(image, Sx);
Gy = imfilter(image, Sy);

im_magnitude = sqrt(Gx.^2 + Gy.^2);

% im_direction = pi + atan2(Gy, Gx);
im_direction = pi/2 + atan(Gy ./ Gx);

end

