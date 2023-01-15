clear all
clc
close all
rng(42)
addpath(genpath(pwd))


%% caricamento train set e test set
train_info = readtable("..\annot\train_balanced_info.csv");
train_info.Properties.VariableNames = {'image_name', 'label'};
train_info = sortrows(train_info);
test_info = readtable("..\annot\val_info.csv");
test_info.Properties.VariableNames = {'image_name', 'label'};
test_info = sortrows(test_info);

train_labels = uint8(table2array(train_info(:,2)));
test_labels = uint8(table2array(test_info(:,2)));

train_imds = imageDatastore("..\train\train_set_balanced\", ...
    "IncludeSubfolders", false, ...
    "labels", train_labels);
test_imds = imageDatastore("..\val\val_set\", ...
    "IncludeSubfolders", false, ...
    "labels", test_labels);


%% calcolo LBP features
N_TRAIN = size(train_labels);
N_TEST = size(test_labels);
soglia_train = 40;
soglia_test = 10;
tr_feat=[];
te_feat=[];
tr_labels=[];
te_labels=[];

tic
for ii=0:250
    idx=find(train_imds.Labels==ii,1,"first");
    if sum(train_imds.Labels==ii) < soglia_train
        soglia_train = sum(train_imds.Labels==ii);
    else
        soglia_train = 40;
    end
    for jj=idx:idx+(soglia_train-1)
        im_path = train_imds.Files{jj};
        im = imread(im_path);
        im = imresize(im,[224 224]);
        im_ycbcr = rgb2ycbcr(im);
        im_y = im_ycbcr(:,:,1);
        lbp_feat1 = extractLBPFeatures(im_y,...
            'Upright',true,... 
            'NumNeighbors',8,...
            'Radius',2,...
            'CellSize',[8,8],... 
            'Normalization','L2');
        tr_feat = [tr_feat; lbp_feat1];
        tr_labels = [tr_labels; ii];
    end
end
toc
save("lbp_train.mat","tr_feat","tr_labels");

tic
for ii=0:250
    idx=find(test_imds.Labels==ii,1,"first");
    if sum(test_imds.Labels==ii) < soglia_test
        soglia_test = sum(test_imds.Labels==ii);
    else
        soglia_test = 10;
    end
    for jj=idx:idx+(soglia_test-1)
        im_path = test_imds.Files{jj};
        im = imread(im_path);
        im = imresize(im,[224 224]);
        im_ycbcr = rgb2ycbcr(im);
        im_y = im_ycbcr(:,:,1);
        lbp_feat1 = extractLBPFeatures(im_y,...
            'Upright',true,... 
            'NumNeighbors',8,...
            'Radius',2,...
            'CellSize',[8,8],... 
            'Normalization','L2');
        te_feat = [te_feat; lbp_feat1];
        te_labels = [te_labels; ii];
    end
end
toc
%save("lbp_train.mat","tr_feat","tr_labels");


%% creazione modello 1-NN
%KNNModel = fitcknn(tr_feat,tr_labels, ...
%    'NumNeighbors',1,...
%    'Distance','spearman');
t = templateSVM("KernelFunction","polynomial", ...
    "PolynomialOrder",2, ...
    "KernelScale","auto", ...
    "Standardize",true);
SVMModel = fitcecoc(tr_feat,tr_labels,"Learners",t);


%% classificatore: 1-NN (su test)
pred_labels_te=[];
%[pred_te,score_te] = predict(KNNModel,te_feat);
[pred_te,score_te] = predict(SVMModel,te_feat);
pred_labels_te = pred_te;
save("lbp_balanced_pred.mat","pred_te","score_te");

%% calcolo performance su test
% top-1 accuracy
acc_te = numel(find(pred_labels_te==te_labels)) / numel(te_labels)







