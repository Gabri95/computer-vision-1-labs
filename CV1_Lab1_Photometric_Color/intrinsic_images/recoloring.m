
clear
clc
close all




reflectance = imread('ball_reflectance.png');

disp("Ball real color in RGB:");
disp(reshape(max(max(reflectance, [], 1), [], 2), 1, []));

reflectance = im2double(reflectance);
shading = im2double(imread('ball_shading.png'));
original = imread('ball.png');


magenta_reflectance = reflectance;
magenta_reflectance(:, :, 2) = 0;

recontruct_and_display(magenta_reflectance, shading, original);

green_reflectance = reflectance;
green_reflectance(:, :, 1) = 0;
green_reflectance(:, :, 3) = 0;

recontruct_and_display(green_reflectance, shading, original);





function recontruct_and_display(reflectance, shading, original)
    reconstructed = zeros(size(reflectance));
    for i = 1:3
        reconstructed(:, :, i) = reflectance(:, :, i) .* shading;
    end

    figure
    plots = 4;

    subplot(1, plots, 1);
    imshow(reflectance);
    title('reflectance');
    subplot(1, plots, 2);
    imshow(shading);
    title('shading');
    subplot(1, plots, 3);
    imshow(reconstructed);
    title('reconstructed');
    subplot(1, plots, 4);
    imshow(original);
    title('original');

    % subplot(1, plots, 4);
    % hist(double(reshape(reconstructed, 1, [])));

end
