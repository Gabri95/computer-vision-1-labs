function [V] = lukas_kanade(img1, img2, xs, ys, R)

assert(length(size(xs)) == length(size(ys)) & all(size(xs) == size(ys)));

orig_size = size(xs);

xs = reshape(xs, 1, []);
ys = reshape(ys, 1, []);


if length(size(img1)) == 3
    img1 = im2double(rgb2gray(img1));
else
    img1 = im2double(img1);
end

if length(size(img2)) == 3
    img2 = im2double(rgb2gray(img2));
else
    img2 = im2double(img2);
end


[Ix, Iy] = compute_gradient(img1); %imgradientxy(img1); %
It = img2 - img1;

[H, W] = size(img1);

V = zeros(length(ys), 2);

for j = 1:length(ys)
    
    r_idxs = max(1, ys(j) - R) : min(H, ys(j) + R);
    c_idxs = max(1, xs(j) - R) : min(W, xs(j) + R);
    
    n_elems = length(r_idxs)*length(c_idxs);
    
    A = zeros(n_elems, 2);
    
    A(:, 1) = reshape(Ix(r_idxs, c_idxs), [], 1);
    A(:, 2) = reshape(Iy(r_idxs, c_idxs), [], 1);

    b = -1* reshape(It(r_idxs, c_idxs), [], 1);

    V(j, :) = A \ b;
    
end

V = reshape(V, [orig_size 2]);

% h = floor(H/R);
% w = floor(W/R);
% V = zeros(h, w, 2);
% 
% for r = 1:h
%     for c = 1:w
%         A = zeros(R^2, 2);
%         
%         r_idxs = R*(r-1) +1 : R*r;
%         c_idxs = R*(c-1) +1 : R*c;
%         
%         
%         A(:, 1) = reshape(Ix(r_idxs, c_idxs), [], 1);
%         A(:, 2) = reshape(Iy(r_idxs, c_idxs), [], 1);
%         
%         b = -1* reshape(It(r_idxs, c_idxs), [], 1);
%         
%         v = A \ b;
%         V(r, c, : ) = v;
%         
%         
%     end
% end


end

