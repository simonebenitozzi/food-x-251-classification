clear all
clc
close all
rng(42)
addpath(genpath(pwd))


%% prova stima qualità immagini con e senza valore di esposizione
im1 = imread('..\..\val\val_set\val_010325.jpg');
im2 = imread('..\..\val\val_set\val_010325.jpg');
im_deg = imread('..\..\val_degraded\val_set_degraded\val_010325.jpg');

sigma_value=1;
wR=0.627443990219015;
wG=0.626784047513238;
wB=0.462012767054076;
gamma_value=2.3;
exp_value=5;
gauss_var=0.06;

[im1]=applica_filtro_gaussiano(im1,sigma_value);
[im1]=applica_white_balance(im1,wR,wG,wB);
[im1]=applica_gamma(im1,gamma_value);
[im1]=applica_valore_esposizione(im1,exp_value);
[im1]=applica_rumore_gaussiano(im1,gauss_var);

[im2]=applica_filtro_gaussiano(im2,sigma_value);
[im2]=applica_white_balance(im2,wR,wG,wB);
[im2]=applica_gamma(im2,gamma_value);
[im2]=applica_rumore_gaussiano(im2,gauss_var);

BRI_im1=brisque(im1);
BRI_im2=brisque(im2);
BRI_im_deg=brisque(im_deg);

subplot(1,3,1), imshow(im_deg)
subplot(1,3,2), imshow(im1)
title('Immagine degradata originale vs. Immagine degradata exp vs. Immagine degradata senza exp');
subplot(1,3,3), imshow(im2)

