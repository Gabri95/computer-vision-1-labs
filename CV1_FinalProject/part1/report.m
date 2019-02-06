
function report(filename, rankings_scores, APs, vocabulary_fraction, LIMIT_SVM, CLUSTERING, K, FEATURE_METHOD, COLORSPACE, SPATIAL_INFORMATION, images, classes, relative_path)

rankings = {};
for c= 1:length(classes)
    tmp = sortrows([images, rankings_scores(:, c)], 2, 'descend');
    rankings{c} = tmp(:, 1);
end

fileID = fopen(filename,'w');


fprintf(fileID, '<!DOCTYPE html>\n');
fprintf(fileID, '<html lang="en"><head><meta charset="utf-8"><title>Image list prediction</title><style type="text/css">img{width:200px;}</style></head>\n');
fprintf(fileID, '<body>\n');
fprintf(fileID, '<h2>Davide Belli, Gabriele Cesa</h2>\n');
fprintf(fileID, '<h1>Settings</h1>');
fprintf(fileID, '<table>\n');

if string(FEATURE_METHOD) == "dsift"
    fprintf(fileID, '<tr><th>SIFT step size</th><td>40 px</td></tr>\n');
    fprintf(fileID, '<tr><th>SIFT block sizes</th><td>8 pixels</td></tr>\n');
end

if ~isempty(SPATIAL_INFORMATION) && (SPATIAL_INFORMATION{1} ~= 1 || SPATIAL_INFORMATION{2} ~= 1)
    fprintf(fileID, '<tr><th>Spatial Information Split (rows, columns)</th><td>%d %d</td></tr>\n', SPATIAL_INFORMATION{1}, SPATIAL_INFORMATION{2});
end  

fprintf(fileID, '<tr><th>SIFT method</th><td>%s (%s)</td></tr>\n', upper(FEATURE_METHOD), COLORSPACE);
fprintf(fileID, '<tr><th>Clustering Method</th><td>%s</td></tr>\n', CLUSTERING);
fprintf(fileID, '<tr><th>Vocabulary size</th><td>%d words</td></tr>\n', K);
fprintf(fileID, '<tr><th>Vocabulary fraction</th><td>%f %%</td></tr>\n', vocabulary_fraction*100);
fprintf(fileID, '<tr><th>SVM training data</th><td> %d positive, %d negative per class</td></tr>\n', LIMIT_SVM, 3*LIMIT_SVM);
fprintf(fileID, '<tr><th>SVM kernel type</th><td>Linear</td></tr>\n');
fprintf(fileID, '</table>\n');
fprintf(fileID, '<h1>Prediction lists (MAP: %f)</h1>\n', mean(APs(:)));
% <h3><font color="red">Following are the ranking lists for the four categories. Please fill in your lists.</font></h3>
% <h3><font color="red">The length of each column should be 200 (containing all test images).</font></h3>
fprintf(fileID, '<table>\n');
fprintf(fileID, '<thead>\n');
fprintf(fileID, '<tr>\n');

for c= 1:length(classes)
    fprintf(fileID, '<th>%s (AP: %f)</th>', classes{c}, APs(c));
end
fprintf(fileID, '\n');
fprintf(fileID, '</tr>\n');
fprintf(fileID, '</thead>\n');
fprintf(fileID, '<tbody>\n');

for row=1:length(rankings{1})
    fprintf(fileID, '<tr>');
    for c=1:length(classes)
        fprintf(fileID, '<td><img src="%s"/></td>', fullfile(relative_path, char(rankings{c}(row))));
    end
    fprintf(fileID, '</tr>\n');
end

fprintf(fileID, '</tbody>\n');
fprintf(fileID, '</table>\n');
fprintf(fileID, '</body>\n');
fprintf(fileID, '</html>\n');

fclose(fileID);

end

