%% main function 
close all
clear all
clc

addpath('../liblinear-2.1/matlab/');
addpath('matconvnet-1.0-beta25/matlab/');

nums_epochs = [40, 60, 80, 100, 120];
batch_sizes = [20, 50, 100, 150];
learning_rates = [0.05, 0.02, 0.01];


ft_accs = zeros(length(nums_epochs), length(batch_sizes), length(learning_rates));
svm_ft_accs = zeros(length(nums_epochs), length(batch_sizes), length(learning_rates));

record_table = zeros(length(nums_epochs)*length(batch_sizes)*length(learning_rates), 5);

next_row = 1;

for n = 1:length(nums_epochs)
        
    num_epochs = nums_epochs(n);
    
    for b = 1:length(batch_sizes)

        batchsize = batch_sizes(b);
        
        for l = 1:length(learning_rates)
    
            lr = learning_rates(l);

            fprintf('Experimenting with Num Epochs: %d; Batch Size: %d; LR: %f\n', num_epochs, batchsize, lr);

            % fine-tune cnn
            [net, info, expdir] = finetune_cnn(num_epochs, batchsize, false, lr, []);

            disp('Fine Tuning done!')

            % extract features and train svm
            nets.fine_tuned = load(fullfile(expdir, sprintf('net-epoch-%d.mat', num_epochs))); nets.fine_tuned = nets.fine_tuned.net;
            nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
            data = load(fullfile(expdir, 'imdb-caltech.mat'));

            [acc_ft, acc_svm_ft, acc_svm_pt] = train_svm(nets, data);


            svm_ft_accs(n, b, l) = acc_svm_ft;
            ft_accs(n, b, l) = acc_ft;
            
            record_table(next_row, :) = [num_epochs, batchsize, lr, ft_accs(n, b, l), svm_ft_accs(n, b, l)];
            next_row = next_row + 1;
            
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
    end
end

% store the results of all experiments in a CSV file

outfile_path = 'outputs/hyperparameter_optimization.csv';
outfile = fopen(outfile_path, 'w');
fprintf(outfile, '# NumberOfEpochs, BatchSize, LearningRate, FineTuned_Accuracy, FineTuned+SVM_Accuracy\n');
fclose(outfile);
dlmwrite(outfile_path, record_table, '-append');


% compute the best combination of hyper-parameters

[max_accuracy, best_params] = max(ft_accs(:));
[n, b, l] = ind2sub(size(ft_accs), best_params);

sprintf('Best Accuracy: %f found with Number of Epochs = %d, Batch Size = %d and LR = %f\n', max_accuracy, nums_epochs(n), batch_sizes(b), learning_rates(l));


% draw some plots

plot_performances_wrt_two_parameters('FineTunedCNN', ...
                                    {'Number of Epochs', nums_epochs}, ...
                                    {'Batch Size', batch_sizes}, ...
                                    'Accuracy', ...
                                    squeeze(ft_accs(:, :, l)), ...
                                    sprintf('with LearningRate = %f', learning_rates(l)));

plot_performances_wrt_two_parameters('FineTunedCNN', ...
                                    {'Number of Epochs', nums_epochs}, ...
                                    {'Learning Rate', learning_rates}, ...
                                    'Accuracy', ...
                                    squeeze(ft_accs(:, b, :)), ...
                                    sprintf('with BatchSize = %d', batch_sizes(b)));                                


plot_performances_wrt_two_parameters('FineTunedCNN+SVM', ...
                                    {'Number of Epochs', nums_epochs}, ...
                                    {'Batch Size', batch_sizes}, ...
                                    'Accuracy', ...
                                    squeeze(svm_ft_accs(:, :, l)), ...
                                    sprintf('with LearningRate = %f', learning_rates(l)));                           

plot_performances_wrt_two_parameters('FineTunedCNN+SVM', ...
                                    {'Number of Epochs', nums_epochs}, ...
                                    {'Learning Rate', learning_rates}, ...
                                    'Accuracy', ...
                                    squeeze(svm_ft_accs(:, b, :)), ...
                                    sprintf('with BatchSize = %d', batch_sizes(b)));                                



% using the best combination of hyper-parameters we try, now, to use Data Augmentation


% fine-tune cnn

disp('Experimenting with Data Augmentation');

[net, info, expdir] = finetune_cnn(nums_epochs(n), batch_sizes(b), true, learning_rates(l), []);

disp('Fine Tuning done!')

% extract features and train svm
nets.fine_tuned = load(fullfile(expdir, sprintf('net-epoch-%d.mat', nums_epochs(n)))); nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile(expdir, 'imdb-caltech.mat'));

[acc_ft, acc_svm_ft, acc_svm_pt] = train_svm(nets, data);

disp('SVMs training done!')

fileID = fopen(fullfile(expdir, 'accuracies.txt'), 'w');
fprintf(fileID, 'CNN: fine_tuned_accuracy: %0.3f\n', acc_ft);
fprintf(fileID, 'SVM: pre_trained_accuracy: %0.3f\n', acc_svm_pt);
fprintf(fileID, 'SVM: fine_tuned_accuracy: %0.3f\n', acc_svm_ft);
fclose(fileID);

disp('Saving done!')




                                
function plot_performances_wrt_two_parameters(plot_name, param1, param2, measure, performances, subtitle)

fig = figure;    

hold on
for b = 1:length(param2{2})
    plot(param1{2}, performances(:, b));
    labels(b) = string(param2{2}(b));
end

lgd = legend(labels);
lgd.Location = 'bestoutside';
title(lgd, param2{1});
xlabel(param1{1});
ylabel(measure);
title({sprintf('%s: %s', plot_name, measure), subtitle});

hold off

saveas(fig, sprintf('outputs/%s_(%s-%s).png', lower(plot_name), param1{1}, param2{1}));

end


