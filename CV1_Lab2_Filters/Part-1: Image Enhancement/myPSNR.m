function [ PSNR ] = myPSNR( orig_image, approx_image )

orig_image = im2double(orig_image);
approx_image = im2double(approx_image);

se = (orig_image - approx_image).^2;
mse = mean(se(:));

i_max = double(max(orig_image(:)));

PSNR = 10 * log10(i_max^2 / mse);

end

