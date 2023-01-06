%% Carico Rete 

clear all
close all 
net = alexnet; % cambiare con la rete desiderata
sz=net.Layers(1).InputSize; 
layer='fc7';
tStart = tic;

%% Leggo path file 
classi = readtable("../annot/class_list.txt");
train = readtable("../annot/train_clean_info.csv");
train = sortrows(train, "Var2");
validation = readtable("../annot/val_info.csv"); 
validation = sortrows(validation, "Var2");


%% Estrazioni features Training
feat_tr=[];
labels_tr=[];
soglia = 100; % numero di immagini per classe
copia_soglia=soglia;

for i=0:250
    idx=find(train.Var2==i, 1, 'first');  %indice inizio classe i-esima
   
    % se classe i-esima ha meno campioni di soglia allora soglia sono i suoi campioni
    if sum(train.Var2==i) < soglia
        soglia = sum(train.Var2==i);
    end 

    % per ogni classe leggo "soglia" immagini
    for j=idx:idx+(soglia-1)
        im=imread(strcat("../train_set/", train{j,1}));
        im=imresize(im,sz(1:2));
        feat_tmp=activations(net, im, layer, "OutputAs","rows");
        feat_tr = [feat_tr; feat_tmp];
        labels_tr = [labels_tr; i];
    end
    soglia=copia_soglia;
end


%% Estrazioni features Test (stesso procedimento di sopra)
feat_te=[];
labels_te=[];
soglia= 50;
copia_soglia=soglia;

for i=0:250
    idx=find(validation.Var2==i, 1, 'first');  

    if sum(validation.Var2==i) < soglia
        soglia = sum(validation.Var2==i);
    end
   
    for j=idx:idx+(soglia-1)
        im=imread(strcat("../val_set/", validation{j,1}));
        im=imresize(im,sz(1:2));
        feat_tmp=activations(net, im, layer, "OutputAs","rows");
        feat_te = [feat_te; feat_tmp];
        labels_te = [labels_te; i];
    end
    soglia=copia_soglia;
end

%% Classificazione + Predizioni

% Normalizzazione delle Features estratte
feat_tr=feat_tr./sqrt(sum(feat_tr.^2, 2));
feat_te=feat_te./sqrt(sum(feat_te.^2, 2));

% Classificatore 1NN
D = pdist2(feat_te, feat_tr); 
[~, idx_pred_te] = min(D, [], 2); 
lab_pred_te=labels_tr(idx_pred_te); 
acc=numel(find(lab_pred_te==labels_te))/numel(labels_te)


% Tempo.....
tEnd = toc(tStart);
fprintf('%d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));



% più di 1 ora con soglia 100 x train e 50 x test

