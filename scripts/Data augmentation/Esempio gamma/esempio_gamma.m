clear all
clc
close all
rng(42)
addpath(genpath(pwd))

%% prova stima qualità immagini con gamma correction
im1 = imread('..\..\val\val_set\val_000473.jpg');
im1=im2double(im1);
im2 = im1.^3.0;

BRI_im1=brisque(im1);
BRI_im2=[];
gamma=[];
im2=im2double(im2);
for i=1:0.1:10.0
    corr=im2.^i;
    BRI_im2=[BRI_im2 brisque(im2)];
    gamma=[gamma; i];
end
figure(1),plot(BRI_im2)

BRI_im2 = abs(BRI_im2 - BRI_im1);
minimum=min(BRI_im2);
u=find(BRI_im2==minimum);
u=u(1); 
best_gamma=gamma(u);

im2 = im2.^best_gamma;
im1=im2uint8(im1);
im2=im2uint8(im2);
figure(2),imshow([im1 im2])
