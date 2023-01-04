clear all
clc
close all
rng(42)


%% importazione modello
net = resnet101;
sz= net.Layers(1).InputSize;
lgraph = layerGraph(net);


%% replace layers
%ultimo layer: classification output
%penultimo layer: softmax
%terzultimo layer: fully connected layer
%layersTransfer = net.Layers(1:end-3);
%layersTransfer = freezeWeights(layersTransfer); 
lgraph = replaceLayer(lgraph,'fc1000',...
    fullyConnectedLayer(251, ...
        'WeightLearnRateFactor',20,...
        'BiasLearnRateFactor',20,...
        'Name','fcNew'));
lgraph = replaceLayer(lgraph,'ClassificationLayer_predictions',...
    classificationLayer('Name','ClassificationNew'));


%% re-connect layers
layers = lgraph.Layers;
connections = lgraph.Connections;
layers(1:end-3) = freezeWeights(layers(1:end-3));
lgraph = createLgraphUsingConnections(layers,connections);


%% preparazione dati
imdsTrain = load_trainset();
imdsTest = load_testset();


%% divisione train-test
[imdsTrain,imdsVal]=splitEachLabel(imdsTrain,0.7,'randomized');


%% data augmentation
imageAugmenter = imageDataAugmenter(... 
    'RandXReflection',true);

augimdsTrain=augmentedImageDatastore(sz(1:2),imdsTrain,...
    'DataAugmentation',imageAugmenter,...
    'OutputSizeMode','randcrop');

augimdsVal=augmentedImageDatastore(sz(1:2),imdsVal);

augimdsTest=augmentedImageDatastore(sz(1:2),imdsTest);


%% configurazione fine-tuning
options = trainingOptions('adam',...    
    'MiniBatchSize',64,...              
    'MaxEpochs',50,...                  
    'InitialLearnRate',5e-5,...
    'LearnRateDropFactor',1e-1,...
    'LearnRateDropPeriod',10,...
    'Shuffle','every-epoch',...
    'ValidationData',augimdsVal,...
    'ValidationFrequency',3,...
    'ValidationPatience',5,... %early stopping
    'Verbose',false,...
    'Plots','training-progress', ...
    'OutputNetwork','best-validation-loss',...
    'ExecutionEnvironment','cpu');

%adam optimizer
%learning rate 5e-5 ridotto di un fattore 10 ogni 10 epoche
%numero massimo di epoche 50
%early stopping
%random horizontal flips
%random crop
%model checkpoint con le performance migliori


%% training vero e proprio
tic
netTransfer = trainNetwork(augimdsTrain,lgraph,options);
toc


%% test
tic
[lab_pred_te,scores]=classify(netTransfer,augimdsTest);
toc


%% valutazione performance
acc=numel(find(lab_pred_te==imdsTest.Labels))/numel(lab_pred_te)









