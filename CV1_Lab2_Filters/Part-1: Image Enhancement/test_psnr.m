close all
clear all
clc

img1_orig = imread('images/image1.jpg');
img1_sp = imread('images/image1_saltpepper.jpg');
img1_g = imread('images/image1_gaussian.jpg');

myPSNR( img1_orig, img1_sp)
myPSNR( img1_orig, img1_g)