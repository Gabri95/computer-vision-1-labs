close all
clear all
clc
 
disp('Part 1: Photometric Stereo')

% obtain many images in a fixed view under different illumination
disp('Loading images...')
image_dir = './MonkeyGray/';   % TODO: get the path of the script
%image_ext = '*.png';

[image_stack, scriptV] = load_syn_images(image_dir);
[h, w, n] = size(image_stack);
image_stack = reshape(image_stack, h, w, 1, n);

fprintf('Finish loading %d images.\n\n', n);

% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, true);


%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q, "average");
height_map_c = construct_surface( p, q, "column");
height_map_r = construct_surface( p, q, "row");

%% Display
show_results(albedo, normals, SE);
show_model(albedo, height_map_c, 'column');
show_model(albedo, height_map_r, 'row');
show_model(albedo, height_map, 'average');
show_vector_field(height_map, normals, albedo)

plot_height_maps (height_map, height_map_c, height_map_r)

%% Face
[image_stack, scriptV] = load_face_images('./yaleB02/');
[h, w, n] = size(image_stack);
image_stack = reshape(image_stack, h, w, 1, n);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, false);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q, 'average' );
height_map_c = construct_surface( p, q, 'row' );
height_map_r = construct_surface( p, q, 'column' );

show_results(albedo, normals, SE);
show_model(albedo, height_map_c, 'column');
show_model(albedo, height_map_r, 'row');
show_model(albedo, height_map, 'average');
show_vector_field(height_map, normals, albedo)

plot_height_maps (height_map, height_map_c, height_map_r)
