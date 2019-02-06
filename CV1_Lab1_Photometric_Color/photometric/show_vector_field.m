function show_vector_field(height_map, normals, albedo)
% SHOW_VECTOR_FIELD: display a sample of the normal vectors on the surface
%   albedo: image used as texture for the model
%   normals: normal vectors to surface
%   height_map: height in z direction, describing the model geometry


downsampling = 20;



% if length(size(albedo)) == 2
%     A = albedo(1:downsampling:end, 1:downsampling:end);
% else
%     A = albedo(1:downsampling:end, 1:downsampling:end, :);
% end

[hgt, wid] = size(height_map);
[X,Y] = meshgrid(1:wid, 1:hgt);


X_s = X(1:downsampling:end, 1:downsampling:end);
Y_s = Y(1:downsampling:end, 1:downsampling:end);
H = height_map(1:downsampling:end, 1:downsampling:end);

N = normals(1:downsampling:end, 1:downsampling:end, :);
N(:, :, 1) = -1* N(:, :, 1);
N(:, :, 2) = -1* N(:, :, 2);

f = figure;

quiver3(X_s, Y_s, H, N(:, :, 1), N(:, :, 2), N(:, :, 3), 'r');
axis equal;

hold on
mesh(X, Y, height_map, albedo);
axis equal;
if length(size(albedo)) == 2
    colormap(f, gray);


hold off



end

