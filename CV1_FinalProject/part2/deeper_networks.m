%% main function 
close all
clear all
clc

addpath('../liblinear-2.1/matlab/');
addpath('matconvnet-1.0-beta25/matlab/');



models = {"VGG", "./data/imagenet-vgg-verydeep-16.mat"; "AlexNet", "./data/imagenet-caffe-alex.mat"; "lenet", "./data/pre_trained_model.mat"};



accuracies = zeros(2, length(models));

for m = 1:length(models)
    
    model = models(m, :);
   
    
    fprintf('Experimenting with %s\n', model{1});

    % fine-tune cnn
    [net, info, expdir] = finetune_cnn([], 20, [], [], model);

    disp('Fine Tuning done!')

    % extract features and train svm
    nets.fine_tuned = load(fullfile(expdir, 'net-epoch-50.mat'));
    if isfield(nets.fine_tuned, 'net')
        nets.fine_tuned = nets.fine_tuned.net;
    end
    nets.pre_trained = load(model{2});
    if isfield(nets.pre_trained, 'net')
        nets.pre_trained = nets.pre_trained.net;
    end
    data = load(fullfile(expdir, 'imdb-caltech.mat'));

    [acc_ft, acc_svm_ft, acc_svm_pt] = train_svm(nets, data);

    accuracies(1, m) = acc_ft;
    accuracies(2, m) = acc_svm_ft;
    

    disp('SVMs training done!')
    
    fileID = fopen(fullfile(expdir, 'accuracies.txt'), 'w');
    fprintf(fileID, 'CNN: fine_tuned_accuracy: %0.3f\n', acc_ft);
    fprintf(fileID, 'SVM: pre_trained_accuracy: %0.3f\n', acc_svm_pt);
    fprintf(fileID, 'SVM: fine_tuned_accuracy: %0.3f\n', acc_svm_ft);
    fclose(fileID);

    disp('Saving done!')

    clear net info data nets

    disp('Memory cleaned!')
end

% store the results of all experiments in a CSV file
outfile_path = 'outputs/deeper_networks.csv';
outfile = fopen(outfile_path, 'w');

fprintf(outfile, '#\t\t\t\t');
for m = 1:length(models)
    model = models(m, :);
    fprintf(outfile, '%s\t\t\t', model{1});
end
fprintf(outfile, '\n');

fprintf(outfile, 'FineTuned\t\t');
for m = 1:length(models)
    fprintf(outfile, '%f\t\t', accuracies(1, m));
end
fprintf(outfile, '\n');

fprintf(outfile, 'FineTuned+SVM\t');
for m = 1:length(models)
    fprintf(outfile, '%f\t\t', accuracies(2, m));
end
fprintf(outfile, '\n');

fclose(outfile);

