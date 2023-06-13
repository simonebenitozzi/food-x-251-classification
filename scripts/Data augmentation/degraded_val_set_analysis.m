clear all
clc
close all
rng(42)
addpath(genpath(pwd))


%% importazione immagini
train_data_files = importdata('..\annot\train_clean_info.csv');
test_data_files = importdata('..\annot\val_info.csv');
N_TEST = size(test_data_files.data,1);
%N_TEST = 10;

tic
test_images = {};
test_gt = {};
[test_images,test_gt] = extract_data(test_data_files,N_TEST,test_images,test_gt,1);
toc

tic
test_images_deg = {};
[test_images_deg,test_gt] = extract_data(test_data_files,N_TEST,test_images_deg,test_gt,2);
toc


%% creazione file CSV per i dati del validation set degradato
im_names=[];
sigma_list=[];
wR_list=[];
wG_list=[];
wB_list=[];
gamma_list=[];
gauss_var_list=[];
classes=[];
variable_names={'image','sigma','wR','wG','wB','gamma',...
    'gaussian_variance','class'};
data_table=table(im_names,sigma_list,wR_list,wG_list,wB_list,gamma_list, ...
    gauss_var_list,classes,'VariableNames',variable_names);
writetable(data_table,'dati_val_degraded.csv');


%% recupero dati del validation set degradato
if ~exist('output', 'dir')
   mkdir('output');
end

tic
for ii=1:N_TEST
    row={};
    im_orig=test_images{ii,1};
    im_deg=test_images_deg{ii,1};
    im_name=test_data_files.rowheaders{ii,1};
    im_class=test_gt{ii,1};
    [im_deg_new,im_deg,sigma]=trova_filtro_gaussiano(im_orig,im_deg,0);
    [im_deg_new,im_deg,wR,wG,wB]=trova_white_balance(im_deg_new,im_deg);
    [im_deg_new,im_deg,gamma]=trova_gamma(im_deg_new,im_deg,2);
    [im_deg_new,im_deg,gauss_var]=trova_rumore_gaussiano(im_deg_new,im_deg,0);
    row={im_name,sigma,wR,wG,wB,gamma,gauss_var,im_class};
    data_table=[data_table; row];
    %subplot(1,3,1), imshow(im_orig)
    %subplot(1,3,2), imshow(im_deg)
    %title('Immagine pulita originale vs. Immagine degradata originale vs. Immagine degradata nuova');
    %subplot(1,3,3), imshow(im_deg_new)
    %saveas(gcf,'./test'+string(ii)+'.jpg');
    filename='.\output\new_'+string(im_name);
    filename=string(pwd)+'\output\new_'+string(im_name);
    if exist(filename, 'file')
        delete(filename)        
    end
    imwrite(im_deg_new,filename);
    if rem(ii,100)==0
        disp(ii);
        writetable(data_table,'dati_val_degraded.csv');
    end
end
toc


%% scrittura dati su CSV
writetable(data_table,'dati_val_degraded.csv');


%% lettura dati da CSV
imported_table=readtable('dati_val_degraded.csv');















