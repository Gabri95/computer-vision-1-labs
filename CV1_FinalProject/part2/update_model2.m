function net = update_model(pretrained_model_path, batchsize, num_epochs, lr_base, varargin)
opts.networkType = 'simplenn' ;
opts = vl_argparse(opts, varargin) ;


%% TODO: PLAY WITH THESE PARAMETERTS TO GET A BETTER ACCURACY

lr_prev_layers = [.2, 2];
lr_new_layers  = [1, 4]; 

lr = lr_prev_layers ;

net = load(pretrained_model_path);
if isfield(net, 'net')
    net = net.net;
end

% Meta parameters
if ~ isfield(net.meta, 'inputSize')
    net.meta.inputSize = net.meta.inputs.size;
end
% net.meta.trainOpts.learningRate = [ 0.05*ones(1,20) ...
%                                     0.005*ones(1,20)...
%                                     0.0005*ones(1,10)...
%                                     ] ;

net.meta.trainOpts.learningRate = zeros(1, num_epochs);
ep = 0;
% lr_base = 0.05; % Now this is set from parameters
while ep*20 < num_epochs
    net.meta.trainOpts.learningRate(ep*20 + 1: min(end, (ep + 1)*20)) = lr_base;
    lr_base = lr_base / 10;
    ep = ep + 1;
end

net.meta.trainOpts.weightDecay = 0.0001 ;
net.meta.trainOpts.batchSize = batchsize ;
net.meta.trainOpts.numEpochs = numel(net.meta.trainOpts.learningRate) ;


support = size(net.layers{end-1}.weights{1}, 1);
NEW_INPUT_SIZE  = size(net.layers{end-1}.weights{1}, 3);
NEW_OUTPUT_SIZE = 4;

net.layers{end-1} = struct('type', 'conv', ...
                           'weights', {{0.05*randn(support,support,NEW_INPUT_SIZE,NEW_OUTPUT_SIZE, 'single'), zeros(1,NEW_OUTPUT_SIZE,'single')}}, ...
                           'learningRate', .1*lr_new_layers, ...
                           'stride', 1, ...
                           'pad', 0) ;

%%  Define loss                     
% Loss layer
net.layers{end} = struct('type', 'softmaxloss') ;


oldnet = load(pretrained_model_path);
if isfield(oldnet, 'net')
    oldnet = oldnet.net;
end

end

%% Assign previous weights to the network
function newnet = update_weights(oldnet, newnet)

% loop until loss layer
for i = 1:numel(oldnet.layers)-2
    
    if(isfield(oldnet.layers{i}, 'weights'))
       
        newnet.layers{i}.weights = oldnet.layers{i}.weights;
        
    end
    
end

end

