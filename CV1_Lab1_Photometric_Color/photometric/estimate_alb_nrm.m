function [ albedo, normal ] = estimate_alb_nrm( image_stack, scriptV, shadow_trick)
%COMPUTE_SURFACE_GRADIENT compute the gradient of the surface
%   image_stack : the images of the desired surface stacked up on the 3rd
%   dimension
%   scriptV : matrix V (in the algorithm) of source and camera information
%   shadow_trick: (true/false) whether or not to use shadow trick in solving
%   	linear equations
%   albedo : the surface albedo
%   normal : the surface normal

if length(size(image_stack)) == 4
    [h, w, c, n] = size(image_stack);
else
    [h, w, n] = size(image_stack);
    c = 1;
    image_stack = reshape(image_stack, h, w, c, n);
end    

if nargin == 2
    shadow_trick = true;
end

% create arrays for 
%   albedo (1 channel)
%   normal (3 channels)
albedo = zeros(h, w, c, 1);
normal = zeros(h, w, c, 3);

% =========================================================================
% YOUR CODE GOES HERE
% for each point in the image array
%   stack image values into a vector i
%   construct the diagonal matrix scriptI
%   solve scriptI * scriptV * g = scriptI * i to obtain g for this point
%   albedo at this point is |g|
%   normal at this point is g / |g|


%for each channel
for z = 1:c
    %for each point in the image array
    for y = 1:h
        for x = 1:w

            %stack image values into a vector i
            i = reshape(image_stack(y, x, z, :), [], 1);

            if abs(sum(i)) > 0 % 10^-17
                %construct the diagonal matrix scriptI
                scriptI = diag(i);

                %solve scriptI * scriptV * g = scriptI * i to obtain g for this point
                if shadow_trick
                    g = (scriptI * scriptV) \ (i.^2);
                else
                    g = scriptV \ i;
                end

                %albedo at this point is |g|
                albedo(y, x, z) = norm(g);

                %normal at this point is g / |g|
                if (albedo(y, x, z) > 0)
                    normal(y, x, z, :) = g / albedo(y, x, z);
                else
                    normal(y, x, z, :) = zeros(size(g));
                end
            else
                albedo(y, x, z) = 0;
                normal(y, x, z, :) = zeros(1, 3);

            end

        end
    end    
end

normal = squeeze(mean(normal, 3));
normal = normal ./ vecnorm(normal, 2, 3);
normal(isnan(normal)) = 0;

% =========================================================================

end

