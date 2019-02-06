function [I_original, I_stitched] = stitch(im1, im2)

    Ia = im2double(rgb2gray(imread(im1)));
    Ib = im2double(rgb2gray(imread(im2)));
    Ia_color = im2double(imread(im1));
    Ib_color = im2double(imread(im2));
    
    % Adding padding if necessary
    
    dh1 = [max(size(Ia,1)-size(Ib,1),0) max(size(Ia,2)-size(Ib,2),0)];
    dh2 = [max(size(Ib,1)-size(Ia,1),0) max(size(Ib,2)-size(Ia,2),0)];
    Ia_pad = padarray(Ia_color, dh2, 'post');
    Ib_pad = padarray(Ib_color, dh1, 'post');
    I_original = [Ib_pad Ia_pad];

    % Compute matchings
    
    [matches, fa, fb] = keypoint_matching(Ia, Ib, 0);

    % Compute and print transformed images

    best = RANSAC(matches, fa, fb);
    m = [best(1), best(2); best(3), best(4)];
    t = [best(5); best(6)];
    for x = 1:1:size(Ia, 2)
        for y = 1:1:size(Ia, 1)
            p_t = m*[x; y] +t;
            p_t = round(p_t);
            if p_t(1)>0 && p_t(2)>0
                It(p_t(2), p_t(1), :) = Ia_color(y, x, :);
            end
        end
    end
    
%     figure;
%     imshow(It);

    % Compute padding for the trasformed image
    
    dh1 = [max(size(It,1)-size(Ib,1),0) max(size(It,2)-size(Ib,2),0)];
    dh2 = [max(size(Ib,1)-size(It,1),0) max(size(Ib,2)-size(It,2),0)];
    Ib_padded = padarray(Ib_color, dh1, 'post');
    It_padded = padarray(It, dh2, 'post');
    
%     figure;
%     imshow(It_padded);

    % Stitch the two images together

    for x = 1:1:size(Ib_padded, 1)
        for y = 1:1:size(Ib_padded, 2)
            if Ib_padded(x, y) == 0
                I_stitched(x, y, :) = It_padded(x, y, :);
            else
                I_stitched(x, y, :) = Ib_padded(x, y, :);
            end
        end
    end


end

