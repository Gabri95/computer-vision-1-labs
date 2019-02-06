function [output_image] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb

[R, G, B] = getColorChannels(input_image);

output_image = zeros(size(input_image));

sum = (R + G + B);

output_image(:, :, 1)= R ./ sum;
output_image(:, :, 2)= G ./ sum;
output_image(:, :, 3)= B ./ sum;

end

