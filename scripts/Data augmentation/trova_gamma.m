function [im_deg_new,im_deg,best_gamma] = trova_gamma(im_deg_new,im_deg,quality_metric)

    if quality_metric==0
        BRI=[];
        gamma=[];
        im_deg=im2double(im_deg);
        im_deg_new=im2double(im_deg_new);
        for i=1:0.1:5.0
            corr=gamma_correction(im_deg_new,i);
            BRI=[BRI brisque(corr)];
            gamma=[gamma; i];
        end
        BRI_deg = brisque(im_deg);
        BRI = abs(BRI - BRI_deg);
        minimum=min(BRI);
        u=find(BRI==minimum);
        u=u(1); % per più elementi minimi
        best_gamma=gamma(u);
        im_deg_new = gamma_correction(im_deg_new,best_gamma);
        im_deg=im2uint8(im_deg);
        im_deg_new=im2uint8(im_deg_new);
    elseif quality_metric==1
        PSNR=[];
        gamma=[];
        im_deg=im2double(im_deg);
        im_deg_new=im2double(im_deg_new);
        for i=1:0.1:5.0
            corr=gamma_correction(im_deg_new,i);
            corr=im_deg_new.^i;
            PSNR=[PSNR psnr(im_deg,corr)];
            gamma=[gamma; i];
        end
        maximum=max(PSNR);
        u=find(PSNR==maximum);
        u=u(1); % per più elementi massimi
        best_gamma=gamma(u);
        im_deg_new = gamma_correction(im_deg_new,best_gamma);
        im_deg=im2uint8(im_deg);
        im_deg_new=im2uint8(im_deg_new);
    elseif quality_metric==2
        SSIM=[];
        gamma=[];
        im_deg=im2double(im_deg);
        im_deg_new=im2double(im_deg_new);
        for i=1:0.1:5.0
            corr=gamma_correction(im_deg_new,i);
            SSIM=[SSIM ssim(rgb2gray(im_deg),rgb2gray(corr))];
            gamma=[gamma; i];
        end
        maximum=max(SSIM);
        u=find(SSIM==maximum);
        u=u(1); % per più elementi massimi
        best_gamma=gamma(u);
        im_deg_new = im_deg_new.^best_gamma;
        im_deg=im2uint8(im_deg);
        im_deg_new=im2uint8(im_deg_new);
    end

end