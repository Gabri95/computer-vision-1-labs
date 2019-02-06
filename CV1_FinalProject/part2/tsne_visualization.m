%% main function 
close all
clear all
clc

addpath('../tSNE_matlab');

models = {"AlexNet", "./data/imagenet-caffe-alex.mat"; "VGG", "./data/imagenet-vgg-verydeep-16.mat"; "lenet", "./data/pre_trained_model.mat"};

NUM_EPOCHS = 40;
BATCH_SIZE = 20;
AUGMENTATION = true;
LR = 0.05;
MODEL = 3;

model = models(MODEL, :);

%% fine-tune cnn

[net, info, expdir] = finetune_cnn(NUM_EPOCHS, BATCH_SIZE, AUGMENTATION, LR, model);

%% extract features and train svm

% TODO: Replace the name with the name of your fine-tuned model
nets.fine_tuned = load(fullfile(expdir, sprintf('net-epoch-%d.mat', NUM_EPOCHS)));
if isfield(nets.fine_tuned, 'net')
    nets.fine_tuned = nets.fine_tuned.net;
end
nets.pre_trained = load(model{2});
if isfield(nets.pre_trained, 'net')
    nets.pre_trained = nets.pre_trained.net;
end

data = load(fullfile(expdir, 'imdb-caltech.mat'));

nets.pre_trained.layers{end}.type = 'softmax';
nets.fine_tuned.layers{end}.type = 'softmax';

%%

pre_trained = get_visualization_data(data, nets.pre_trained);
fine_tuned = get_visualization_data(data, nets.fine_tuned);

f1 = figure;
tsne(fine_tuned.features, fine_tuned.labels, 2);
title('Fine Tuned');
saveas(f1, fullfile(expdir, 'tsne_finetuned.png'));

pause(0.5)

f2 = figure;
tsne(pre_trained.features, pre_trained.labels, 2);
title('Pre Trained');
saveas(f2, fullfile(expdir, 'tsne_pretrained.png'));





function dataset = get_visualization_data(data, net)

dataset.labels = [];
dataset.features = [];

for i = 1:size(data.images.data, 4)
    
    res = vl_simplenn(net, data.images.data(:,:,:,i));
    feat = res(end-3).x; feat = squeeze(feat);

    dataset.features = [dataset.features feat];
    dataset.labels   = [dataset.labels;  data.images.labels(i)];

end

dataset.labels = double(dataset.labels);
dataset.features = double(dataset.features');

end
