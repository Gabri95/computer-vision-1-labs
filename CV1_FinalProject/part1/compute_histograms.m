function [histograms] = compute_histograms(path, image_names, centroids, FEATURE_METHOD, COLORSPACE, SPATIAL_INFORMATION)
    
    if isempty(SPATIAL_INFORMATION)
        R = 1;
        C = 1;
    else
        [R, C] = SPATIAL_INFORMATION{:};
    end
    
    
    K = size(centroids, 1);

    histograms = [];
    for i= 1:length(image_names)
        img_path = fullfile(path, char(image_names(i)));
        im = imread(img_path);
        
        [H, W, ~] = size(im);
         
        % split the image in the specified number of rows and columns and
        % compute an histogram for each sub-region
        
        dW = ceil(W / C);
        dH = ceil(H / R);
        
        spatial_histograms = [];
        for r=1:R
           for c=1:C
               
              % compute current sub-region of the image
              sub_im = im(dH*(r-1) + 1 : min(end, dH*r), dW*(c-1) + 1 : min(dW*c, end), :);
              
              d = compute_feature(sub_im, FEATURE_METHOD, COLORSPACE);

              norm_term = size(d',1);
              values = dsearchn(centroids, double(d'));
              h = hist(values, 1:K);
              h = h/norm_term;
              
              spatial_histograms = [spatial_histograms, h]; 
              
           end
        end
        
        
        histograms = [histograms; spatial_histograms]; 
    end
end

