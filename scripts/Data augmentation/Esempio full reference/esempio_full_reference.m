clear all
clc
close all
rng(42)
addpath(genpath(pwd))


%% stima qualità immagini con PSNR
im = imread('..\..\val\val_set\val_010326.jpg');
im_deg = imread('..\..\val_degraded\val_set_degraded\val_010326.jpg');

[im_deg_new,im_deg,sigma]=trova_filtro_gaussiano(im,im_deg,1);
[im_deg_new]=applica_filtro_gaussiano(im,sigma);
figure(1), montage({im_deg,im_deg_new})
title('Immagine degradata originale vs. Immagine degradata con PSNR');


%% stima qualità immagini con BRISQUE
[im_deg_new,im_deg,sigma]=trova_filtro_gaussiano(im,im_deg,0);
[im_deg_new]=applica_filtro_gaussiano(im,sigma);
figure(2), montage({im_deg,im_deg_new})
title('Immagine degradata originale vs. Immagine degradata con BRISQUE');


