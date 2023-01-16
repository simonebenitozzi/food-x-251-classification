clear all
clc
close all
rng(42)
addpath(genpath(pwd))

%% prima verifica rumore salt and pepper e rumore gaussiano
im1 = imread('..\..\val_degraded\val_set_degraded\val_000473.jpg');
im1 = im2double(im1);

% salt and pepper dovrebbe essere risolto con filtro mediano
im2 = medfilt3(im1);
figure(2),imshow([im1 im2])

% per gaussian noise serve filtro bilaterale
im3 = imbilatfilt(im1,0.2,10);
figure(3),imshow([im1 im3])

im1 = im2uint8(im1);
h1 = histogram(im1);


%% visualizzazione tipici istogrammi rumore salt and pepper e rumore gaussiano
im0 = imread('..\..\val\val_set\val_000473.jpg');
im0 = im2double(im0);

% rumore salt and pepper
im2 = imnoise(im0,'salt & pepper');
h2 = histogram(im2);

% rumore gaussiano
im3 = imnoise(im0,'gaussian');
h3 = histogram(im3);

subplot(3,3,1), imshow(im1)
subplot(3,3,2), imshow(im2)
subplot(3,3,3), imshow(im3)
subplot(3,3,4), histogram(im1)
subplot(3,3,5), histogram(im2)
subplot(3,3,6), histogram(im3)



