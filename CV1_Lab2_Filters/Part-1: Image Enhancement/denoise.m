function [ imOut ] = denoise( image, kernel_type, varargin)

switch kernel_type
    case 'box'
        kernel_size = varargin{1};
        
        H = ones(kernel_size, kernel_size) / (kernel_size^2);
        imOut = imfilter(image, H);
        
        
    case 'median'
        kernel_size = varargin{1};
        
        imOut = medfilt2(image, [kernel_size kernel_size]);
        
    case 'gaussian'
        kernel_size = varargin{1};
        sigma = varargin{2};
        
        H = gauss2D(sigma, kernel_size);
        
        imOut = imfilter(image, H);
        
end



end
