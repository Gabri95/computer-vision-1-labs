function [ p, q, SE ] = check_integrability( normals )
%CHECK_INTEGRABILITY check the surface gradient is acceptable
%   normals: normal image
%   p : df / dx
%   q : df / dy
%   SE : Squared Errors of the 2 second derivatives

% initalization
% p = zeros(512,512);
% q = zeros(512,512);
% SE = zeros(size(normals));

% ========================================================================
% YOUR CODE GOES HERE
% Compute p and q, where
% p measures value of df / dx
% q measures value of df / dy

%[p, q] = gradient(normals);

p = normals(:, :, 1) ./ normals(:, :, 3);
q = normals(:, :, 2) ./ normals(:, :, 3);


% ========================================================================

p(isnan(p)) = 0;
q(isnan(q)) = 0;

% p = squeeze(mean(p, 3));
% q = squeeze(mean(q, 3));

% ========================================================================
% YOUR CODE GOES HERE
% approximate second derivate by neighbor difference
% and compute the Squared Errors SE of the 2 second derivatives SE

[fxx, fxy] = gradient(p);
[fyx, fyy] = gradient(q);

SE = (fyx - fxy).^2;

% SE = squeeze(mean(SE, 3));


% ========================================================================




end

