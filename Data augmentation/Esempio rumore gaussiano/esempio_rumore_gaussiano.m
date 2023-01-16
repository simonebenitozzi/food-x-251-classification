clear all
clc
close all
rng(42)
addpath(genpath(pwd))

%% prova stima qualità immagini con rumore gaussiano
im1 = imread('..\..\val\val_set\val_000473.jpg');
im2 = imnoise(im1,'gaussian',0.0,0.05);

PSNR=[];
gauss_var = [];
for gl=0:0.01:0.1
    corr=imnoise(im1,'gaussian',0.0,gl);
    PSNR=[PSNR psnr(im2,corr)];
    gauss_var = [gauss_var; gl];
end
maximum=max(PSNR);
u=find(PSNR==maximum);
u=u(1); % per più elementi massimi
best_gauss_var=gauss_var(u);
figure(1),plot(PSNR)

im3 = imnoise(im1,'gaussian',0.0,best_gauss_var);
figure(2),imshow([im2 im3])

