clc;
clear all;
close all;

run('./vlfeat/toolbox/vl_setup')

addpath('../liblinear-2.1/matlab/');
addpath('../tSNE_matlab');


% Default Parameters
LIMIT_VOCABULARY = 200;     % Images taken for each class to build vocabulary
LIMIT_SVM = 150;            % Images taken for each class to build the training set
SIZE_TEST = 50;             % number of images in the test set for each class
K = 400;                    % number of clusters for K-Means (or for GMM)
SPATIAL_INFORMATION = {1, 1};   % number of rows and columns an image is split in for computing different histograms

classes = {'airplanes', 'cars', 'faces', 'motorbikes'};



 
disp('SIFT METHODS AND COLORSPACES EXPERIMENTS');

sift_methods = {'sift' 'dsift'};
colorspaces = {'rgb'}; %{'grayscale' 'rgb' 'opponent' 'RGB'};
for m = 1:length(sift_methods)
    method = sift_methods{m};
    
    mAPs = zeros(1, length(colorspaces));
    APSs = zeros(4, length(colorspaces));
    
    mAccs = zeros(1, length(colorspaces));
    ACCs = zeros(4, length(colorspaces));
    
    for c = 1:length(colorspaces)
        cs = colorspaces{c};
        fprintf('Running %s with %s\n', method, cs);
        
        [mAP, avg_acc, APs, Accs] = experiment(LIMIT_VOCABULARY, ...
                                               LIMIT_SVM, ...
                                               SIZE_TEST, ...
                                               "KMEANS", ...
                                               K, ...
                                               method, ...
                                               cs, ...
                                               SPATIAL_INFORMATION, ...
                                               @(x, l) trainsvm(x, l), ...
                                               @(l, x, m) predict(l, x, m), ...
                                               sprintf('%s_%s', method, cs) ...
                                               );
        mAPs(c) = mAP;
        mAccs(c) = avg_acc;
        
        for class=1:4
            APSs(class, c) = APs(class);
            ACCs(class, c) = Accs(class);
        end
        
        fprintf('Finished %s with %s\n', method, cs);
    end
    
    
    plot_experiments(APSs, sprintf("%s_AP", method), colorspaces, classes)
    
    pause(0.5)
    
    plot_experiments(ACCs, sprintf("%s_Acc", method), colorspaces, classes)
    
end



disp('VOCABULARY SIZE (number of centroids in k-means) EXPERIMENTS');

CENTROIDS = {20, 50, 100, 200, 400, 800};
mAPs = zeros(1, length(CENTROIDS));
APSs = zeros(4, length(CENTROIDS));
mAccs = zeros(1, length(CENTROIDS));
ACCs = zeros(4, length(CENTROIDS));

for c = 1:length(CENTROIDS)
    k = CENTROIDS{c};
    fprintf('Running %d\n', k)

    [mAP, avg_acc, APs, Accs] = experiment(LIMIT_VOCABULARY, ...
                                           LIMIT_SVM, ...
                                           SIZE_TEST, ...
                                           "KMEANS", ...
                                           k, ...
                                           'sift', ...
                                           'grayscale', ...
                                           SPATIAL_INFORMATION, ...
                                           @(x, l) trainsvm(x, l), ...
                                           @(l, x, m) predict(l, x, m), ...
                                           sprintf('K_%d', k) ...
                                           );
    mAPs(c) = mAP;
    mAccs(c) = avg_acc;

    for class=1:4
        APSs(class, c) = APs(class);
        ACCs(class, c) = Accs(class);
    end

    fprintf('Finished %d\n', k);
end

plot_experiments(APSs, 'K_AP', CENTROIDS, classes)
pause(0.5)
plot_experiments(ACCs, 'K_Acc', CENTROIDS, classes)


disp('TRAINING SET SIZE EXPERIMENTS');

TRAIN_SIZES = {20, 50, 100, 150, 200};
mAPs = zeros(1, length(TRAIN_SIZES));
APSs = zeros(4, length(TRAIN_SIZES));
mAccs = zeros(1, length(TRAIN_SIZES));
ACCs = zeros(4, length(TRAIN_SIZES));

for s = 1:length(TRAIN_SIZES)
    t_size = TRAIN_SIZES{s};
    fprintf('Running %d\n', t_size)

    [mAP, avg_acc, APs, Accs] = experiment(LIMIT_VOCABULARY, ...
                                           t_size, ...
                                           SIZE_TEST, ...
                                           "KMEANS", ...
                                           K, ...
                                           'sift', ...
                                           'grayscale', ...
                                           SPATIAL_INFORMATION, ...
                                           @(x, l) trainsvm(x, l), ...
                                           @(l, x, m) predict(l, x, m), ...
                                           sprintf('trainsize_%d', t_size) ...
                                           );
    mAPs(s) = mAP;
    mAccs(s) = avg_acc;

    for class=1:4
        APSs(class, s) = APs(class);
        ACCs(class, s) = Accs(class);
    end

    fprintf('Finished %d\n', t_size);
end

plot_experiments(APSs, 'trainsize_AP', TRAIN_SIZES, classes)
pause(0.5)
plot_experiments(ACCs, 'trainsize_Acc', TRAIN_SIZES, classes)



disp('TRAINING SET FRACTION FOR VOCABULARY COMPUTATION EXPERIMENTS');

VOCABULARY_LIMITS = {20, 50, 100, 200};
mAPs = zeros(1, length(VOCABULARY_LIMITS));
APSs = zeros(4, length(VOCABULARY_LIMITS));
mAccs = zeros(1, length(VOCABULARY_LIMITS));
ACCs = zeros(4, length(VOCABULARY_LIMITS));

for v = 1:length(VOCABULARY_LIMITS)
    v_size = VOCABULARY_LIMITS{v};
    fprintf('Running %d\n', v_size)

    [mAP, avg_acc, APs, Accs] = experiment(v_size, ...
                                           LIMIT_SVM, ...
                                           SIZE_TEST, ...
                                           "KMEANS", ...
                                           K, ...
                                           'sift', ...
                                           'grayscale', ...
                                           SPATIAL_INFORMATION, ...
                                           @(x, l) trainsvm(x, l), ...
                                           @(l, x, m) predict(l, x, m), ...
                                           sprintf('vocabularylimit_%d', v_size) ...
                                           );
    mAPs(v) = mAP;
    mAccs(v) = avg_acc;

    for class=1:4
        APSs(class, v) = APs(class);
        ACCs(class, v) = Accs(class);
    end

    fprintf('Finished %d\n', v_size);
end

plot_experiments(APSs, 'vocabularylimit_AP', VOCABULARY_LIMITS, classes)
pause(0.5)
plot_experiments(ACCs, 'vocabularylimit_Acc', VOCABULARY_LIMITS, classes)



disp('EXPERIMENT WITH GMM');
[mAP, avg_acc, APs, Accs] = experiment(LIMIT_VOCABULARY, ...
                                       LIMIT_SVM, ...
                                       SIZE_TEST, ...
                                       "KMEANS", ...
                                       "GMM", ...
                                       K, ...
                                       'sift', ...
                                       'grayscale', ...
                                       SPATIAL_INFORMATION, ...                                       
                                       @(x, l) trainsvm(x, l), ...
                                       @(l, x, m) predict(l, x, m), ...
                                       sprintf('gmm_%d', K) ...
                                       ); 


disp('EXPERIMENTS WITH SPATIAL INFORMATION');

SPATIAL_INFORMATION = {3, 1};
[mAP, avg_acc, APs, Accs] = experiment(LIMIT_VOCABULARY, ...
                                       LIMIT_SVM, ...
                                       SIZE_TEST, ...
                                       "KMEANS", ...
                                       K, ...
                                       'sift', ...
                                       'grayscale', ...
                                       SPATIAL_INFORMATION, ...                                       
                                       @(x, l) trainsvm(x, l), ...
                                       @(l, x, m) predict(l, x, m), ...
                                       sprintf('spatialinformation_(%d_%d)', SPATIAL_INFORMATION{1}, SPATIAL_INFORMATION{2}) ...
                                       );

SPATIAL_INFORMATION = {3, 1};                                   
[mAP, avg_acc, APs, Accs] = experiment(LIMIT_VOCABULARY, ...
                                       LIMIT_SVM, ...
                                       SIZE_TEST, ...
                                       "GMM", ...
                                       K, ...
                                       'sift', ...
                                       'grayscale', ...
                                       SPATIAL_INFORMATION, ...                                       
                                       @(x, l) trainsvm(x, l), ...
                                       @(l, x, m) predict(l, x, m), ...
                                       sprintf('gmm_%d_spatialinformation_(%d_%d)', K, SPATIAL_INFORMATION{1}, SPATIAL_INFORMATION{2}) ...
                                       ); 


[mAP, avg_acc, APs, Accs] = experiment(50, ...
                                       200, ...
                                       50, ...
                                       "GMM", ...
                                       400, ...
                                       'sift', ...
                                       'rgb', ...
                                       {1, 1}, ...                                       
                                       @(x, l) trainsvm(x, l), ...
                                       @(l, x, m) predict(l, x, m), ...
                                       'BestExperiment' ...
                                       ); 





function model = trainsvm(x, labels)
    % helper function to tune the hyperparameter C through Cross-Validation
    % of an SVM and, then, use it to train it
    
    best_C = train(labels, sparse(x), '-q -s 2 -C');
    model = train(labels, sparse(x), sprintf('-q -s 2 -c %d', best_C(1)));
end



function plot_experiments(measures, experiment_title, xlabels, classes)

    mean_trend = mean(measures, 1);
    
    fig = figure;    
    plot(1:length(xlabels), mean_trend);
    labels(1) = "mean";
    hold on

    for class=1:length(classes)
        plot(1:length(xlabels), measures(class, :));
        labels(class + 1) = classes{class};
    end

    lgd = legend(labels);
    lgd.Location = 'bestoutside';

    set(gca, 'xtick', 1:length(xlabels), 'xticklabel', xlabels);
    
    title(experiment_title, 'Interpreter', 'none');
    
    hold off
    
    saveas(fig, sprintf('outputs/%s.png', experiment_title));

end
