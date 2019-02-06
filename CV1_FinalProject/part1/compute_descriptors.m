function [desc] = compute_descriptors(path, image_names, FEATURE_METHOD, COLORSPACE)
% compute interesting points and their descriptors on the images in the 
% "image_names" list and return the set of descriptors found

desc = [];
for i = 1:1:length(image_names)
    img_path = fullfile(path, char(image_names(i)));
    im = imread(img_path);

    d = compute_feature(im, FEATURE_METHOD, COLORSPACE);
    
    desc = [desc; d'];
end

end