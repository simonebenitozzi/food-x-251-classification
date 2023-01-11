clear all
clc
close all
rng(42)
addpath(genpath(pwd))


%% lettura dati da CSV
data_val_degraded=readtable('dati_val_degraded.csv');
data_val_degraded=sortrows(data_val_degraded,'class','ascend');


%% recupero lista immagini train set
train_data_files = importdata('..\annot\train_balanced_info.csv');
test_data_files = importdata('..\annot\val_info.csv');
N_TRAIN = size(train_data_files.data,1);
%N_TRAIN = 20;

train_gt=[];
train_names=[];
for ii=1:N_TRAIN
    if rem(ii,1000)==0
        disp(ii);
    end
    train_im_gt=train_data_files.data(ii,1);
    train_gt=[train_gt; train_im_gt];
    train_im_name=train_data_files.rowheaders(ii,1);
    train_names=[train_names; train_im_name];
end

variable_names={'image','class'};
data_train=table(train_names,train_gt,'VariableNames',variable_names);
data_train=sortrows(data_train,'class','ascend');


%% Calcolo distribuzione classi in train e test set
class_list = importdata('..\annot\class_list.txt');
class_list = split(class_list);

class_list_train = class_list;
class_list_test = class_list;
class_list_train = [class_list_train repmat({0},251,1)];
class_list_test = [class_list_test repmat({0},251,1)];

N_TRAIN = size(train_data_files.data,1);
N_TEST = size(test_data_files.data,1);

for ii=1:N_TRAIN
    for jj=0:250
        if train_data_files.data(ii,1) == jj
            class_list_train{jj+1,3} = class_list_train{jj+1,3} + 1;
        end
    end
end

for ii=1:N_TEST
    for jj=0:250
        if test_data_files.data(ii,1) == jj
            class_list_test{jj+1,3} = class_list_test{jj+1,3} + 1;
        end
    end
end

count_train = 0;
count_test = 0;
for ii=0:250
    count_train = count_train + class_list_train{ii+1,3};
    count_test = count_test + class_list_test{ii+1,3};
end


%% riproduzione difetti sul train set
if ~exist('new_train_set', 'dir')
   mkdir('new_train_set');
end

tic
count=0;
for ii=1:251 %numero di classi
    testo="Classe: " + ii;
    disp(testo);

    n_train_for_a_class=class_list_train{ii,3};
    n_test_for_a_class=class_list_test{ii,3};
    u_train = find(data_train{:,2}==ii-1);
    u_test = find(data_val_degraded{:,8}==ii-1);

    for jj=1:n_train_for_a_class
        index_train=u_train(jj);
        modulo=mod(jj,n_test_for_a_class);
        if modulo==0
            index_test=n_test_for_a_class;
        else
            index_test=u_test(modulo);
        end
        filename=string('..\train\train_set_balanced\'+string(data_train{index_train,1}));
        im=imread(filename);
        sigma_value=data_val_degraded{index_test,2};
        wR=data_val_degraded{index_test,3};
        wG=data_val_degraded{index_test,4};
        wB=data_val_degraded{index_test,5};
        gamma_value=data_val_degraded{index_test,6};
        gauss_var=data_val_degraded{index_test,7};
        [im]=applica_filtro_gaussiano(im,sigma_value);
        [im]=applica_white_balance(im,wR,wG,wB);
        [im]=applica_gamma(im,gamma_value);
        [im]=applica_rumore_gaussiano(im,gauss_var);

        filename=string(pwd)+'\new_train_set\new_'+string(data_train{index_train,1});
        if exist(filename, 'file')
            delete(filename)        
        end
        imwrite(im,filename);     
    end
end
toc




