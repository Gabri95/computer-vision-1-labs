function [histogram] = build_hist(d, k, centroids)
%     disp([size(d'), size(centroids)]);
    norm_term = size(d',1);
    values = dsearchn(centroids, double(d'));
    histogram = hist(values, 1:400);
    histogram = histogram/norm_term;
    
end

