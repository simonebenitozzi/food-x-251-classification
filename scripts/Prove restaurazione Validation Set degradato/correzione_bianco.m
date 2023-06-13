clear all
close all


im = im2double(imread('val_000638.jpg'));
bri_orig = brisque(im);

%% White Balance (-1,1,5)
[wR, wG, wB, out] = general_cc_truncated(im, 0, 1,0,-1);

bri_corrected = brisque(out);
%imshow([im out])

figure()
subplot(1,2,1), imshow(im), title('Degradata')
subplot(1,2,2), imshow(out), title('Restaurata')