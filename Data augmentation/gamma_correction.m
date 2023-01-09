function [im_deg_new] = gamma_correction(im_deg_new,gamma)
    
    % gamma correction globale
    im_deg_new=im_deg_new.^gamma;
    
    % gamma correction locale
    %im_ycbcr=rgb2ycbcr(im_deg_new);
    %im_y=im_ycbcr(:,:,1);
    %mask = imbilatfilt(1 - im_y);
    %mean_intensity = mean(mean(im_y));
    %alpha = 0;
    %if mean_intensity > 0.5
    %    alpha = log(0.5)/log(mean_intensity);
    %else
    %    alpha = log(mean_intensity)/log(0.5);
    %end
    %im_y2 = im_y .^ (alpha .^ ((gamma - mask) / gamma)); 
    %im_ycbcr(:,:,1)=im_y2;
    %im_deg_new=ycbcr2rgb(im_ycbcr);
    
end