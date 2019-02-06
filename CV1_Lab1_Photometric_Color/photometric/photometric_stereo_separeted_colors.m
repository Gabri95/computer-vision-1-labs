close all
clear all
clc
 

disp('Part 1: Photometric Stereo')

% obtain many images in a fixed view under different illumination
disp('Loading images...')
image_dir = './MonkeyColor';
%image_ext = '*.png';

for c = 1:3
[image_stack, scriptV] = load_syn_images(image_dir, c);
[h, w, n] = size(image_stack);
image_stack = reshape(image_stack, h, w, 1, n);

fprintf('Finish loading %d images.\n\n', n);

% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, false);


%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map_r = construct_surface( p, q, 'row');
height_map_c = construct_surface( p, q, 'column');
height_map = construct_surface( p, q, 'average');

%% Display
show_results(albedo, normals, SE);
% show_model(albedo, height_map_c);
% show_model(albedo, height_map_r);
show_model(albedo, height_map);

show_vector_field(height_map, normals, albedo)
% show_vector_field(height_map_c, normals, albedo)
% show_vector_field(height_map_r, normals, albedo)

n = max(max(height_map_c(:)), max(height_map_r(:)));


figure;
subplot(1, 3, 1);
imshow(height_map / n);
title('average');

% figure;
subplot(1, 3, 2);
imshow(height_map_r / n);
title('row');
% figure;
subplot(1, 3, 3);
imshow(height_map_c / n);
title('column');
    
end
