function [net, info, expdir] = finetune_cnn(num_epochs, batchsize, augment, learning_rate, pretrained_model, varargin)

%% Define options
% run(fullfile(fileparts(mfilename('fullpath')), ...
%   '..', '..', '..', 'matlab', 'vl_setupnn.m')) ;

if isempty(batchsize)
    batchsize = 100;
end

if isempty(num_epochs)
    num_epochs = 50;
end

if isempty(augment)
    augment = false;
end

if isempty(learning_rate)
    learning_rate = 0.05;
end

if augment
    augment_text = '_augmented';
else
    augment_text = '';
end

run(fullfile(fileparts(mfilename('fullpath')), 'matconvnet-1.0-beta25', 'matlab', 'vl_setupnn.m')) ;

if isempty(pretrained_model)
    opts.modelType = 'lenet' ;
else
    opts.modelType = pretrained_model{1};
end

[opts, varargin] = vl_argparse(opts, varargin) ;

opts.expDir = fullfile('data', ...
  sprintf('cnn_assignment-%s_%d_%d_%d%s', opts.modelType, batchsize, num_epochs, learning_rate, augment_text)) ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.dataDir = './data/' ;
opts.imdbPath = fullfile(opts.expDir, 'imdb-caltech.mat');
opts.whitenData = true ;
opts.contrastNormalization = true ;
opts.networkType = 'simplenn' ;
opts.train = struct() ;
opts = vl_argparse(opts, varargin) ;
if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end

% opts.train.gpus = [1];



%% update model
if isempty(pretrained_model)
    net = update_model(batchsize, num_epochs, learning_rate);
else
    net = update_model2(pretrained_model{2}, batchsize, num_epochs, learning_rate);
end

H = net.meta.inputSize(1);
W = net.meta.inputSize(2);


%% TODO: Implement getCaltechIMDB function below

if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = getCaltechIMDB(H, W, augment) ;
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end


%%
net.meta.classes.name = imdb.meta.classes(:)' ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------

trainfn = @cnn_train ;
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 2)) ;

expdir = opts.expDir;
end
% -------------------------------------------------------------------------
function fn = getBatch(opts)
% -------------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

end

function [images, labels] = getSimpleNNBatch(imdb, batch)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if rand > 0.5, images=fliplr(images) ; end

end

% -------------------------------------------------------------------------
function imdb = getCaltechIMDB(H, W, augment)
% -------------------------------------------------------------------------
% Preapre the imdb structure, returns image data with mean image subtracted
classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
splits = {'train', 'test'};

%% TODO: Implement your loop here, to create the data structure described in the assignment

IMG_PATH = '../Caltech4/ImageData';

% we count the number of images in the dataset
tot_train_images = 0;
tot_test_images = 0;

for s = 1:length(splits)
    split = splits{s};
    for c = 1:length(classes)
        class = classes{c};
        
        dir_name = [class '_' split '/'];
        
        files = dir(fullfile(IMG_PATH, dir_name, '*.jpg'));
        nfiles = length(files);
        if s == 1
            tot_train_images = tot_train_images + nfiles;
        else
            tot_test_images = tot_test_images + nfiles;
        end
    end    
end

ROTATIONS = 45:45:359;

if augment
    tot_images = tot_test_images + tot_train_images * (length(ROTATIONS) + 1);
else
    tot_images = tot_test_images + tot_train_images;
end

data = zeros(H, W, 3, tot_images, 'single');
labels = zeros(1, tot_images);
sets = zeros(1, tot_images);

next_index = 1;

for s = 1:length(splits)
    split = splits{s};
    for c = 1:length(classes)
        class = classes{c};
        
        dir_name = [class '_' split '/'];
        
        files = dir(fullfile(IMG_PATH, dir_name, '*.jpg'));
        nfiles = length(files);
    
        for j = 1:nfiles

            % read input image
            original_image = im2single(imread(fullfile(IMG_PATH, dir_name, files(j).name)));
            
            % if the image is grayscale, its channel is repeated 3 times
            [h, w, channels] = size(original_image);
            if channels == 1
               tmp = zeros(h, w, 3);
               tmp(:, :, 1) = original_image;
               tmp(:, :, 2) = original_image;
               tmp(:, :, 3) = original_image;
               original_image = tmp;
            end
            
            
            % resize it to match the network input
            im = imresize(original_image, [H, W]);
            
            data(:, :, :, next_index) = im;
            labels(next_index) = c;
            sets(next_index) = s;

            next_index = next_index + 1;
            
            if augment && s == 1
            
                for r = ROTATIONS
                    % rotate the image
                    im = imrotate(original_image, r);
                    
                    % resize it to match the network input
                    im = imresize(im, [H, W]);

                    data(:, :, :, next_index) = im;
                    labels(next_index) = c;
                    sets(next_index) = s;

                    next_index = next_index + 1;
                end
            end

        end 
    end
end



%%
% subtract mean
dataMean = mean(data(:, :, :, sets == 1), 4);
data = bsxfun(@minus, data, dataMean);

imdb.images.data = data ;
imdb.images.labels = single(labels) ;
imdb.images.set = sets;
imdb.meta.sets = {'train', 'val'} ;
imdb.meta.classes = classes;

perm = randperm(numel(imdb.images.labels));
imdb.images.data = imdb.images.data(:,:,:, perm);
imdb.images.labels = imdb.images.labels(perm);
imdb.images.set = imdb.images.set(perm);

end
