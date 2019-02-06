
function d = compute_feature(im, method, colorspace)
    
    if size(im,3) == 3
        grayscale_img = im2single(rgb2gray(im));
    else
        grayscale_img = im2single(im);
    end
    
    % convert to the required colorspace
%     disp(colorspace);
    switch colorspace
        case 'grayscale'
            img = grayscale_img;
        case 'RGB'
            if size(im,3) == 3
                img = im2single(im);
            else
                img = zeros([size(im) 3], 'single');
                im = im2single(im);
                img(:, :, 1) = im;
                img(:, :, 2) = im;
                img(:, :, 3) = im;
            end
        case 'rgb'
            if size(im,3) == 3
                img = im2single(im);
                
                [R, G, B] = getColorChannels(img);
                sum = (R + G + B);
                sum(sum == 0) = 1;
                
                img(:, :, 1)= R ./ sum;
                img(:, :, 2)= G ./ sum;
                img(:, :, 3)= B ./ sum;
                
            else
                img = zeros([size(im) 3], 'single');
                im = im2single(im);
                img(:, :, 1) = im;
                img(:, :, 2) = im;
                img(:, :, 3) = im;
            end
        case 'opponent'
            
            if size(im,3) == 3
                img = im2single(im);
                
                [R, G, B] = getColorChannels(img);

                img(:, :, 1)= (R - G)/sqrt(2);
                img(:, :, 2)= (R + G - 2*B)/sqrt(6);
                img(:, :, 3)= (R + G + B)/sqrt(3);
                
            else
                img = zeros([size(im) 3], 'single');
                im = im2single(im);
                img(:, :, 1) = im;
                img(:, :, 2) = im;
                img(:, :, 3) = im;
            end
        otherwise
            disp(['ERROR! ' colorspace ' option not known!']) 
    end
    
    
    if method == "sift"
        % is SIFT method is required, we need to first find the interesting
        % point on the image and then compute their descriptors in each of
        % the channels, otherwise each channel could return a different set
        % of interesting points.
        
        [F, gs_d] =  vl_sift(grayscale_img);
        
        if colorspace == "grayscale"
            % in case the colorspace is grayscale we can just return these
            % descriptors: there's no need to compute them again
            d = gs_d;
            return
        end
        
    end
    
    d = [];
    
    % compute for each channel the descriptors of each interesting point
    % found and stack the descriptors together
    for c = 1:size(img, 3)
        % compute the descriptors for this channel
        switch method
            case 'sift'
                [~, dc] =  vl_sift(img(:, :, c), 'Frames', F);
            case 'dsift'
                binSize = 8;
                magnif = 3;
                Is = vl_imsmooth(img(:, :, c), sqrt((binSize/magnif)^2 - .25)) ;
                [~, dc] = vl_dsift(Is, 'size', binSize, 'step', 40) ;
            otherwise
                disp(['ERROR! ' method ' option not known!'])
        end
        
        % stack descriptors to the ones of the other channels
        d = [d; dc];
    end
    
end


function [R, G, B] = getColorChannels(input_image)
% helper function that seperates an image into its color channels
R = input_image(:,:,1);
G = input_image(:,:,2);
B = input_image(:,:,3);
end
