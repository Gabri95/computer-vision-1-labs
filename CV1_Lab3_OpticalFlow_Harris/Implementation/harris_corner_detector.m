function [H, r_list, c_list] = harris_corner_detector(image, visualize, THRESHOLD)

if nargin < 2
    visualize = true;
end


% THRESHOLD =
% 0.2 for pingpong
% 0.03 for person_toy
%THRESHOLD = 0.03; %lower threshold for person_toy
if nargin < 3
    THRESHOLD = 0.2;
end

n = 5;

original = image;
image = rgb2gray(image);
image = im2double(image);

% disp("Generating Gaussians");
Gauss = gauss2D(1, 5);
[Gx, Gy] =  imgradientxy(image); %compute_gradient(image);

% Shall we?
Ix_n = (Gx - min(Gx(:))) / (max(Gx(:)) - min(Gx(:)));
Iy_n = (Gy - min(Gy(:))) / (max(Gy(:)) - min(Gy(:)));

Ix = Gx;
Iy = Gy;

% disp("Start creating Q");

% A = imfilter(Ix.^2, Gauss);
% B = imfilter(Ix.*Iy, Gauss);
% C = imfilter(Iy.^2, Gauss);

A = imgaussfilt(Ix.^2, 0.5);
B = imgaussfilt(Ix.*Iy, 0.5);
C = imgaussfilt(Iy.^2, 0.5);

% disp("Start creating H");
H = (A.*C - B.^2) - 0.04*(A + C).*(A + C);


[rows, columns] = size(H);
c_list = [];
r_list = [];

% disp("Start finding indices");
for r = 1+n:1:rows-n
    for c = 1+n:1:columns-n
        if H(r, c) > THRESHOLD
            neighbours = H(r-n:r+n, c-n:c+n);
%             neighbours = H(max(r-n,1):min(r+n,rows), max(c-n,1):min(c+n,columns));
            if H(r, c) == max(neighbours(:))
                c_list = [c_list, c];
                r_list = [r_list, r];
            end  
        end
    end
end

if visualize

    figure;
    imshow(Ix_n);

    figure;
    imshow(Iy_n);

    pause(0.3)
    figure;
    imshow(original);
    hold on;
    plot(c_list, r_list, 'r*', 'LineWidth', 0.5, 'MarkerSize', 5);
    hold off;

    disp(size(c_list));
end

end
