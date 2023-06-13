clear all
close all


im = imread('val_000399.jpg');
bri_orig = brisque(im);
%% correzione automatica
% mi evito di cercare il sigma corretto per aggiustare le immagini
% lo faccio fare al brisque con diversi valori di sigma

BRI=[];
for sigma=0.01:0.01:3
    corrected=imgaussfilt(im, sigma);
    BRI=[BRI; sigma brisque(corrected)];
end
figure(), plot(BRI(:,1), BRI(:,2))

%% visualizzo miglior risultato
[~ , idx] = min(BRI(:,2));
corrected = imgaussfilt(im, BRI(idx,1));

% corrected(:,:,1)=medfilt2(corrected(:,:,1), [3 3]);
% corrected(:,:,2)=medfilt2(corrected(:,:,2), [3 3]);
% corrected(:,:,3)=medfilt2(corrected(:,:,3), [3 3]);

bri_corrected = brisque(corrected);
figure()
subplot(1,2,1), imshow(im), title('Degradata')
subplot(1,2,2), imshow(corrected), title('Restaurata')



