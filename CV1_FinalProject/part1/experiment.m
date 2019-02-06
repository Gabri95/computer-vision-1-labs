

function [mAP, avg_acc, APs, accs] = experiment(LIMIT_VOCABULARY, LIMIT_SVM, SIZE_TEST, CLUSTERING, K, FEATURE_METHOD, COLORSPACE, SPATIAL_INFORMATION, train_function, predict_function, experiment_name)

tic;

DATASET_PATH = '../Caltech4/';
IMG_PATH = fullfile(DATASET_PATH, 'ImageData/');
SETS_PATH = fullfile(DATASET_PATH, 'ImageSets/');

classes = {'airplanes', 'cars', 'faces', 'motorbikes'};

vocabulary_files = [];

trainset_files = [];
trainlabels = [];

total_training_images_available = 0;

% Read image file names in path
for c = 1:length(classes)
    allimages = read_images(fullfile(SETS_PATH, sprintf('%s_train.txt', classes{c})));
    
    total_training_images_available = total_training_images_available + length(allimages);
    
    vocabulary_files = [vocabulary_files; allimages(1:LIMIT_VOCABULARY)];    
    
    trainset_files = [trainset_files; allimages(end-LIMIT_SVM+1:end)];    
    trainlabels = [trainlabels; repmat(c, LIMIT_SVM, 1)];
end


testset_files = [];
testlabels = [];
for c = 1:length(classes)
    testset_files = [testset_files; read_images(fullfile(SETS_PATH, sprintf('%s_test.txt', classes{c})))];    
    testlabels = [testlabels; repmat(c, SIZE_TEST, 1)];
end


% Compute img descriptor to generate vocabulary

img_desc = compute_descriptors(IMG_PATH, vocabulary_files, FEATURE_METHOD, COLORSPACE);

fprintf('%d seconds elapsed\n', uint8(toc));
disp(["Number of img_descriptors", size(img_desc, 1)]);
disp(["Descriptors size", size(img_desc, 2)]);




if CLUSTERING == "KMEANS"
    % Generate centroids with k-means
    
    [~, centroids] = kmeans(double(img_desc), K);
    fprintf('%d seconds elapsed\n', uint8(toc));
    disp(["Shape of Vocabulary:", size(centroids)]);
    
    
    disp("Starting histogram generation");

    % Compute histograms for different training images
    trainset = compute_histograms(IMG_PATH, trainset_files, centroids, FEATURE_METHOD, COLORSPACE, SPATIAL_INFORMATION);

    % Compute histograms for different test images
    testset = compute_histograms(IMG_PATH, testset_files, centroids, FEATURE_METHOD, COLORSPACE, SPATIAL_INFORMATION);

    
elseif CLUSTERING == "GMM"
    % Compute Gaussian Mixture Model
    
    [means, covariances, priors] = vl_gmm(double(img_desc'), K, 'verbose', 'MaxNumIterations', 100);
                    
    fprintf('%d seconds elapsed\n', uint8(toc));
    disp("GMM built");
    
    disp("Starting histogram generation");

    % Compute histograms for different training images
    trainset = compute_gmm_histograms(IMG_PATH, trainset_files, means, covariances, priors, FEATURE_METHOD, COLORSPACE, SPATIAL_INFORMATION);

    % Compute histograms for different test images
    testset = compute_gmm_histograms(IMG_PATH, testset_files, means, covariances, priors, FEATURE_METHOD, COLORSPACE, SPATIAL_INFORMATION);

else
    fprintf('ERROR! CLUSTERING %s NOT RECOGNIZED', CLUSTERING);
end

fprintf('%d seconds elapsed\n', uint8(toc));
disp("Features computed");

disp("Starting training SVM");


% Training part

models = {};
for c = 1:length(classes)
    binary_labels = double(trainlabels == c);
    models{c} = train_function(trainset, binary_labels);
end


fprintf('%d seconds elapsed\n', uint8(toc));
disp("Starting making predictions");


% Classificate with SVM and generate rankings

ranking_scores = zeros(SIZE_TEST*length(classes), length(classes));

APs = zeros(1, length(classes));
accs = zeros(1, length(classes));

for c = 1:length(classes)
    binary_labels = double(testlabels == c);
    [predictions, stats, scores] = predict_function(binary_labels, sparse(testset), models{c});
    
    class_sign = sign(mean(scores(predictions == 1)));
    notclass_sign = sign(mean(scores(predictions == 0)));
    if class_sign == notclass_sign
       disp('ERROR!!! class and not-class predictions have the same sign in the scores!')
    end
    
    scores = class_sign * scores;
    
    ranking_scores(:, c) = scores;
    
    APs(c) = compute_ap(sortrows([binary_labels, scores], 2, 'descend'));
    accs(c) = stats(1);
end

mAP = mean(APs(:));
avg_acc = mean(accs(:));

fprintf('%d seconds elapsed\n', uint8(toc));
disp(["Final MAP:", mAP]);
disp(["Final AVG Accuracy:", avg_acc]);

% build the HTML report file
report(sprintf('outputs/%s.html', experiment_name), ranking_scores, APs, 4*LIMIT_VOCABULARY/total_training_images_available, LIMIT_SVM, CLUSTERING, K, FEATURE_METHOD, COLORSPACE, SPATIAL_INFORMATION, testset_files, classes, fullfile('../', IMG_PATH));

if exist('experiment_name', 'var')
    
    % write on file the results obtained
    fileID = fopen(sprintf('outputs/%s.txt', experiment_name),'w');
    
    fprintf(fileID, "Final MAP: %f\n", mAP);
    fprintf(fileID, "APs:\n");
    for c=1:length(classes)
        fprintf(fileID, '\t%s: %f\n', classes{c}, APs(c));
    end
    fprintf(fileID, "\n");
    fprintf(fileID, "Final AVG Accuracy: %f\n", avg_acc);
    fprintf(fileID, "Accuracies:\n");
    for c=1:length(classes)
        fprintf(fileID, '\t%s: %f\n', classes{c}, accs(c));
    end
    
    fclose(fileID);
    
    
    % compute and plot TNSE
    
    features = [trainset; testset];
    
    labels = [trainlabels; testlabels];

    f = figure;
    tsne(features, labels, 2);
    title(experiment_name, 'Interpreter', 'none')
    saveas(f, sprintf('outputs/tsne_%s.png', experiment_name));

end

end

