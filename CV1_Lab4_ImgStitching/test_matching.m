close all;
clear all;
clc;


% In order to run the experiments, it is required to install "vlfeat" in a directory named "vlfeat" in the main directory.

im1 = './boat1.pgm';
im2 = './boat2.pgm';

Ia = imread(im1);
Ib = imread(im2);

SET_SIZE = 50;

[matches, fa, fb] = keypoint_matching(Ia, Ib, 0);

dh1 = max(size(Ia,1)-size(Ia,1),0) ;
dh2 = max(size(Ib,1)-size(Ib,1),0) ;
matches = matches(:, randperm(size(matches,2)));
sel = matches(:, 1:SET_SIZE); 

imshow([padarray(Ia,dh1,'post') padarray(Ib,dh2,'post')]) ;

o = size(Ia,2) ;
% disp(size(Ia));
line([fa(1,sel(1,:));fb(1,sel(2,:))+o], ...
     [fa(2,sel(1,:));fb(2,sel(2,:))],'Color','red','LineStyle','--', 'LineWidth', 2) ;
 
shift = zeros(4, size(fb,2));
shift(1, 1:size(fb,2)) = o;
fb_shifted = fb + shift;
 
hold on;
h1a = vl_plotframe(fa(:,sel(1,:))) ;
h2a = vl_plotframe(fa(:,sel(1,:))) ;
set(h1a,'color','k','linewidth',3) ;
set(h2a,'color','y','linewidth',2) ;

hold on;
h2a = vl_plotframe(fb_shifted(:,sel(2,:))) ;
h2b = vl_plotframe(fb_shifted(:,sel(2,:))) ;
set(h2a,'color','k','linewidth',3) ;
set(h2b,'color','y','linewidth',2) ;

% Compute and print transformed images


best = RANSAC(matches, fa, fb);
m = [best(1), best(2); best(3), best(4)];
t = [best(5); best(6)];
m_i = inv(m);
for x = 1:1:size(Ia, 2)
    for y = 1:1:size(Ia, 1)
        p_t = m*[x; y] +t;
        p_t = round(p_t);
        if p_t(1)>0 && p_t(2)>0 && p_t(1)<=size(Ib,2) && p_t(2)<=size(Ib,1)
            Ia_t(p_t(2), p_t(1)) = Ia(y, x);
        end
        p_t = m_i * ([x; y] - t);
        p_t = round(p_t);
        if p_t(1)>0 && p_t(2)>0 && p_t(1)<=size(Ia,2) && p_t(2)<=size(Ia,1)
            Ib_t(p_t(2), p_t(1)) = Ib(y, x);
        end
    end
end

figure;
imshow([padarray(Ia,dh1,'post') padarray(Ib_t,dh2,'post')]) ;
figure;
imshow([padarray(Ia_t,dh1,'post') padarray(Ib,dh2,'post')]) ;

% Using MATLAB Transformation imwarp

tr = [best(1), best(2), 0; best(3), best(4), 0; best(5), best(6), 1];
tr_i = inv(tr);
tr_i(:,end) = [0;0;1]; % affine2d sees -0.000 as != 0

tform = affine2d(tr);
tform_i = affine2d(tr_i);

figure;
imshow(imwarp(Ia, tform_i));
figure;
imshow(imwarp(Ib, tform));

