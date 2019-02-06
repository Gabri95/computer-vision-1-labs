
% clear all
% close all
% clc

function traking(image_dir, output_file, THRESHOLD, use_local_patches)


if nargin < 4
    use_local_patches = false;
end



files = [dir(fullfile(image_dir, '*.jpg')), dir(fullfile(image_dir, '*.jpeg'))];
nfiles = length(files);


image_stack = 0;

indexes = [];
for i = 1:nfiles
    
    [pathstr, name, ext] = fileparts(files(i).name);
    index = str2num(name);
    
    indexes = [indexes, index];
end    

base = min(indexes);

for i = 1:nfiles

    % read input image
    im = imread(fullfile(image_dir, files(i).name));
    
    [pathstr, name, ext] = fileparts(files(i).name);
    
    index = str2num(name) - base + 1;
    
    % stack at third dimension
    if image_stack == 0
        [h, w, c] = size(im);
        image_stack = zeros(h, w, c, nfiles, 'uint8');
    end
    
    image_stack(:, :, :, index) = im;
    
end

size(image_stack)
[H, W, C, N] = size(image_stack);

[X,Y] = meshgrid(1:W, 1:H);

R = 7;
S = 2*R + 1;

video = VideoWriter(output_file);
open(video);

f = figure;


[~, ys, xs] = harris_corner_detector(image_stack(:, :, :, 1), false, THRESHOLD);


for i = 2:N
    
    if use_local_patches
        
        V = lukas_kanade(image_stack(:, :, :, i-1), image_stack(:, :, :, i), round(xs), round(ys), R);

        size(V)
        size(xs)

        ys_n = [];
        xs_n = [];

        magnitudes = [];
        
        SCALE = 1.3;

        for j = 1:length(ys)

           ys_n = [ys_n (ys(j) + SCALE*V(1, j, 2))];
           xs_n = [xs_n (xs(j) + SCALE*V(1, j, 1))];
           magnitudes = [magnitudes norm(squeeze(V(1, j, :)))];
        end

        magnitudes

        xs = round(xs_n);
        ys = round(ys_n);

        imshow(image_stack(:, :, :, i));
        axis image
        hold on

        vis_scale = 10;

        quiver(xs, ys, vis_scale*V(1, :, 1), vis_scale*V(1, :, 2), 'color', [1 1 0], 'AutoScale','off');

        plot(xs,ys,'r.', 'MarkerSize', 8);
        
        xs = xs_n;
        ys = ys_n;
    
    else
        
        [X,Y] = meshgrid(1:W, 1:H);

        X_s = X(R:S:end, R:S:end);
        Y_s = Y(R:S:end, R:S:end);

        V = lukas_kanade(image_stack(:, :, :, i-1), image_stack(:, :, :, i), X_s, Y_s, R);

        SCALE = 1.5;
        V = V * SCALE;
        
        [Hs, Ws, ~] = size(V);

        v = zeros(2, length(ys));

        ys_n = [];
        xs_n = [];

        magnitudes = [];
        
        
        for j = 1:length(ys)
           r = max(1, min(Hs, ceil(ys(j) / S)));
           c = max(1, min(Ws, ceil(xs(j) / S)));

           v(:, j) = V(r, c, :);

           ys_n = [ys_n (ys(j) + V(r, c, 2))];
           xs_n = [xs_n (xs(j) + V(r, c, 1))];
           magnitudes = [magnitudes norm(reshape(V(r, c, :), 1, 2))];
        end

        magnitudes

        xs = round(xs_n);
        ys = round(ys_n);

        imshow(image_stack(:, :, :, i));
        axis image
        hold on
        
        vis_scale = 8;
        
        quiver(xs, ys, vis_scale*v(1, :), vis_scale*v(2, :), 'color', [1 1 0], 'AutoScale','off');
        
        plot(xs,ys,'r.', 'MarkerSize', 8);
        
        xs = xs_n;
        ys = ys_n;
    
    end

    pause(0.1)
    
    
    frame = getframe(gcf);
    writeVideo(video,frame);

    pause(0.1)
    
    xs = xs_n;
    ys = ys_n;
end

close(video);

end

