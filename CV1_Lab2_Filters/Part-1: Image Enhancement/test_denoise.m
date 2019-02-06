close all
clear all
clc

img1_orig = imread('images/image1.jpg');
img1_sp = imread('images/image1_saltpepper.jpg');
img1_g = imread('images/image1_gaussian.jpg');

save_plots_flag = false;


figure; plot_denoised(img1_orig, img1_g, 'median', 5);
pause(0.5)
figure; plot_denoised(img1_orig, img1_g, 'box', 5);
pause(0.5)

experiment('image1', 'saltpepper', 'median', save_plots_flag);
experiment('image1', 'saltpepper', 'box', save_plots_flag);
experiment('image1', 'saltpepper', 'gaussian', save_plots_flag, 0.5);

experiment('image1', 'gaussian', 'median', save_plots_flag);
experiment('image1', 'gaussian', 'box', save_plots_flag);

experiment('image1', 'gaussian', 'gaussian', save_plots_flag, 0.5);
experiment('image1', 'gaussian', 'gaussian', save_plots_flag, 1);
experiment('image1', 'gaussian', 'gaussian', save_plots_flag, 2);

experiment_gaussian('image1', 'gaussian', [0.2, 0.5, 1, 1.5, 2, 4], save_plots_flag);



function fix_position()
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];
end

function add_xlabel(label)
xlabel(label)
xh = get(gca,'xlabel');
p = get(xh,'position');
p(2) = 0.7*p(2);       
set(xh,'position',p);
end

function plot_denoised(orig, noise, kernel, kernel_size, varargin)
denoised = denoise(noise, kernel, kernel_size, varargin{:});
imshow(denoised);
title(sprintf('%dx%d', kernel_size, kernel_size));
psnr = myPSNR( orig, denoised);
add_xlabel(psnr);

fprintf('%s %dx%d: %f\n', kernel, kernel_size, kernel_size, psnr);
end

function experiment(orig_name, noise_type, kernel, save_plots_flag, varargin)


orig = imread(['./images/' orig_name '.jpg']);
noise = imread(['./images/' orig_name '_' noise_type '.jpg']);

figure('name', [noise_type ': ' kernel]);

exp = 6;

subplot(1, exp + 2, 1)
imshow(orig)
fix_position()
title('Original')

subplot(1, exp + 2, 2)
imshow(noise)
psnr = myPSNR(orig, noise);
add_xlabel(psnr);
fix_position()
title('Noise')

for i = [1:exp]
    subplot(1, exp+2, 2 + i)
    plot_denoised(orig, noise, kernel, 2*i + 1, varargin{:});
    fix_position()

end

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

if save_plots_flag
    print(fig, ['./outputs/4.2_denoising/' noise_type '_' kernel], '-deps')
end
end


function experiment_gaussian(orig_name, noise_type, sigmas, save_plots_flag)


orig = imread(['./images/' orig_name '.jpg']);
noise = imread(['./images/' orig_name '_' noise_type '.jpg']);

figure('name', 'Gaussian Experiments');

exp = 4;

rows = length(sigmas);

subplot(rows, exp + 2, 1)


for r = 1:rows
    for c = 1:exp
        subplot(rows, exp, (r -1)*exp + c)
        plot_denoised(orig, noise, 'gaussian', 2*c + 1, sigmas(r));
        if c == 1
            ylabel({'sigma' sigmas(r)});
            set(get(gca,'ylabel'),'rotation',0)
        end
        if r ~= 1
            title('');
        end
        fix_position()
    end
end

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

if save_plots_flag
    print(fig, './outputs/4.2_denoising/gaussian_experiments', '-deps')
end
end


