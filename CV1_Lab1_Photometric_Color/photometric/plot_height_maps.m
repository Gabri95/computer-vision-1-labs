

function plot_height_maps (height_map, height_map_c, height_map_r)

n = max(max(height_map_c(:)), max(height_map_r(:)));

figure;
subplot(1, 3, 1);
imshow(height_map / n);
title('average');

% figure;
subplot(1, 3, 2);
imshow(height_map_r / n);
title('row');
% figure;
subplot(1, 3, 3);
imshow(height_map_c / n);
title('column');

end