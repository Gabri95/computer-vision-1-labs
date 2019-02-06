function G = gauss1D( sigma , kernel_size)
%     G = zeros(1, kernel_size);
    if mod(kernel_size, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end
    
    G = 0:1:kernel_size - 1;
    G = G - floor(kernel_size/2);
    G = normpdf(G, 0, sigma);
    G = G / sum(G(:));
end
