function [ image_stack, scriptV ] = load_syn_images( image_dir, channels)
%LOAD_SYN_IMAGES read from directory image_dir all files with extension png
%   image_dir: path to the image directory
%   channels: the image channels to be loaded
%
%   image_stack: all images stacked along the 3rd channel
%   scriptV: light directions

files = dir(fullfile(image_dir, '*.png'));
nfiles = length(files);


image_stack = 0;
V = 0;
Z = 0.5;

for i = 1:nfiles

    % read input image
    im = imread(fullfile(image_dir, files(i).name));
    im = im(:, :, channels);
    
    % stack at third dimension
    if image_stack == 0
        [h, w, c] = size(im);
        fprintf('Image size (HxWxC): %dx%dx%d\n', h, w, c);
        image_stack = zeros(h, w, c, nfiles, 'uint8');
        V = zeros(nfiles, 3, 'double');
    end
    
    image_stack(:, :, :, i) = im;
    
    % read light direction from image name
    name = files(i).name(8:end);
    m = strfind(name,'_')-1;
    X = str2double(name(1:m));
    n = strfind(name,'.png')-1;
    Y = str2double(name(m+2:n));
    V(i, :) = [-X, Y, Z];
end


% image_stack = squeeze(max(image_stack, [], 3));
% min_val = double(min(image_stack(:)));
% max_val = double(max(image_stack(:)));
% image_stack = (double(image_stack) - min_val) / (max_val - min_val);

% normalization
min_val = double(min(min(min(image_stack, [], 1), [], 2), [], 4));
max_val = double(max(max(max(image_stack, [], 1), [], 2), [], 4));

norm = max_val - min_val;
norm(norm == 0) = 1;

image_stack = (double(image_stack) - min_val) ./ norm;

normV = sqrt(sum(V.^2, 2));
scriptV = bsxfun(@rdivide, V, normV);

end

