% Analisi qualità delle immagini Validation / Validation degraded
clear all
close all

% Leggo file 
validation = readtable("annot/val_info.csv"); 
validation = sortrows(validation, "Var2");

%% Leggo imgs 
disp('brisque')
BRI_normal = [];
BRI_deg = [];
for i=1:size(validation,1)
        im1=imread(strcat("val_set/", validation{i,1}));
        im2=imread(strcat("val_set_degraded/", validation{i,1}));
        BRI_normal=[BRI_normal brisque(im1)];
        BRI_deg=[BRI_deg brisque(im2)];
end

%% Plot 
media_brisque_normal = mean(BRI_normal); %28.8350
media_brisque_deg = mean(BRI_deg);  %49.2941
figure(1), plot(BRI_normal)
figure(2), plot(BRI_deg)