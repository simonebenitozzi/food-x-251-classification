close all, clear all, clc

%% training set loading

imds_train = load_trainset();

%% histogram for class distribution

n_classes = 251;

figure(1)
set(gcf, 'Renderer', 'painters', 'Position', [10 10 900 600])
edges = linspace(0, n_classes, n_classes+1);
h = histogram(imds_train.Labels, edges);

%% class distribution analysis

values = h.Values;
fprintf("Max number of images per class: %d\n", max(values))
fprintf("Min number of images per class: %d\n", min(values))
fprintf("Avg number of images per class: %.1f\n", mean(values))

fprintf("\nClasses with less than 300 elements: %d\n", size(values(values<300), 2))
fprintf("Classes with less than 350 elements: %d\n", size(values(values<350), 2))
fprintf("Classes with less than 400 elements: %d\n", size(values(values<400), 2))
    
%% oversampling of minority classes
% choose an algorithm
% oversample based on a target number of images to reach for each class
