clear all
clc
close all
rng(42)


%% importazione immagini
train_data_files = importdata('G:\Progetto VIPM\annot\train_info.csv');
test_data_files = importdata('G:\Progetto VIPM\annot\val_info.csv');
N_TEST = size(test_data_files.data,1);
%N_TEST = 20;

tic
test_images = {};
test_gt = {};
[test_images,test_gt] = extract_data(test_data_files,N_TEST,test_images,test_gt,1);
toc

tic
test_images_deg = {};
[test_images_deg,test_gt] = extract_data(test_data_files,N_TEST,test_images_deg,test_gt,2);
toc


%% creazione immagini degradate

if ~exist('output', 'dir')
   mkdir('output');
end

im_names=[];
sigma_list=[];
wR_list=[];
wG_list=[];
wB_list=[];
gamma_list=[];
exp_val_list=[];
gauss_var_list=[];

for ii=1:N_TEST
    if rem(ii,10)==0
        disp(ii);
    end
    im_orig=test_images{ii,1};
    im_deg=test_images_deg{ii,1};
    im_name=test_data_files.rowheaders{ii,1};
    im_class=test_gt{ii,1};
    [im_deg_new,im_deg,sigma]=applica_filtro_gaussiano(im_orig,im_deg,0);
    %[im_deg_new,im_deg]=color_transfer(im_deg_new,im_deg);
    [im_deg_new,im_deg,wR,wG,wB]=color_constancy(im_deg_new,im_deg);
    [im_deg_new,im_deg,gamma]=applica_gamma(im_deg_new,im_deg,1);
    [im_deg_new,im_deg,exp_val]=distorci_esposizione(im_deg_new,im_deg,2);
    [im_deg_new,im_deg,gauss_var]=applica_rumore_gaussiano(im_deg_new,im_deg,1);
    im_names=[im_names; im_name];
    sigma_list=[sigma_list; sigma];
    wR_list=[wR_list; wR];
    wG_list=[wG_list; wG];
    wB_list=[wB_list; wB];
    gamma_list=[gamma_list; gamma];
    exp_val_list=[exp_val_list; exp_val];
    gauss_var_list=[gauss_var_list; gauss_var];
    %montage({im_deg,im_deg_new})
    %title('Immagine degradata originale vs. Immagine degradata nuova');
    %saveas(gcf,'./test'+string(ii)+'.jpg');
    %filename='.\output\new_'+string(im_name);
    filename=string(pwd)+'\output\new_'+string(im_name);
    if exist(filename, 'file')
        delete(filename)        
    end
    imwrite(im_deg_new,filename);
end


%% scrittura dati su CSV
variable_names={'image','sigma','wR','wG','wB','gamma','exposure_value','gaussian_variance'};
table=table(im_names,sigma_list,wR_list,wG_list,wB_list,gamma_list, ...
    exp_val_list,gauss_var_list,'VariableNames',variable_names);
writetable(table,'dati_val_degraded.csv');


%% lettura dati da CSV
imported_table=readtable('dati_val_degraded.csv');






