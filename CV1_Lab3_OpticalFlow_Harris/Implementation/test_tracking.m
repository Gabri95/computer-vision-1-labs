
clear all
close all
clc


traking('./pingpong', 'pingpong_fixed_patches.avi', 0.2, false);
traking('./pingpong', 'pingpong_moving_patches.avi', 0.2, true);
traking('./person_toy', 'person_toy_fixed_patches.avi', 0.05, false);
traking('./person_toy', 'person_toy_moving_patches.avi', 0.05, true);

