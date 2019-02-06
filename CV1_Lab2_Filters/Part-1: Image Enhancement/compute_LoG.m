function imOut = compute_LoG(image, LOG_type)

image = im2double(image);

switch LOG_type
    case 1
        %method 1
        
%         smoothed = imfilter(image, gauss2D(2, 11));
        smoothed = imfilter(image, gauss2D(0.5, 5));
        
        H = fspecial('laplacian');
        imOut = imfilter(smoothed, H);

    case 2
        %method 2
        
        H = fspecial('log', 5, 0.5);        
        imOut = imfilter(image, H);
        
    case 3
        %method 3

        s = 0.3;
        K = 3;
        
        dim = 5;
        H = gauss2D(s, dim) - gauss2D(K*s, dim);
        imOut = imfilter(image, H);
        
        
end
end

