clear all
close all


im = imread('val_000001.jpg');
bri_orig = brisque(im);



corrected = im;
%% 1
corrected(:,:,1)=medfilt2(corrected(:,:,1), [7 7]);
corrected(:,:,2)=medfilt2(corrected(:,:,2), [7 7]);
corrected(:,:,3)=medfilt2(corrected(:,:,3), [7 7]);

bri_corrected = brisque(corrected);
figure()
subplot(1,2,1), imshow(im), title('Degradata')
subplot(1,2,2), imshow(corrected), title('Restaurata')

%% 2
PSF = fspecial('gaussian',7,10);
V = .0001;
WT = zeros(size(im));
WT(5:end-4,5:end-4) = 1;
INITPSF = ones(size(PSF));

[J P] = deconvblind(corrected,INITPSF);
