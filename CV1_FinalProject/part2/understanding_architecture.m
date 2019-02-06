
close all
clear all
clc


net = load('./data/pre_trained_model.mat'); net = net.net;
vl_simplenn_display(net)

% net = load('./data/imagenet-caffe-alex.mat');
% vl_simplenn_display(net)