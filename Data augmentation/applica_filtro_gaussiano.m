function [im_deg_new,im_deg,best_sigma] = applica_filtro_gaussiano(im_deg_new,im_deg,quality_metric)
    
    if quality_metric==0
        BRI=[];
        sigma=[];
        for i=1:0.1:10
            corr=imgaussfilt(im_deg_new,i);
            BRI=[BRI brisque(corr)];
            sigma=[sigma; i];
        end
        BRI_deg = brisque(im_deg);
        BRI = abs(BRI - BRI_deg);
        minimum=min(BRI);
        u=find(BRI==minimum);
        u=u(1); % per più elementi minimi
        best_sigma=sigma(u);
        im_deg_new = imgaussfilt(im_deg_new,best_sigma);
        %testo=["best sigma: ", best_sigma];
        %disp(testo)
    elseif quality_metric==1
        PSNR=[];
        sigma=[];
        for i=1:0.1:20
            corr=imgaussfilt(im_deg_new,i);
            PSNR=[PSNR psnr(im_deg,corr)];
            sigma=[sigma; i];
        end
        maximum=max(PSNR);
        u=find(PSNR==maximum);
        u=u(1); % per più elementi massimi
        best_sigma=sigma(u);
        im_deg_new = imgaussfilt(im_deg_new,best_sigma);
        %testo=["best sigma: ", best_sigma];
        %disp(testo)
    elseif quality_metric==2
        SSIM=[];
        sigma=[];
        for i=1:0.1:20
            corr=imgaussfilt(im_deg_new,i);
            SSIM=[SSIM ssim(rgb2gray(im_deg),rgb2gray(corr))];
            sigma=[sigma; i];
        end
        maximum=max(SSIM);
        u=find(SSIM==maximum);
        u=u(1); % per più elementi massimi
        best_sigma=sigma(u);
        im_deg_new = imgaussfilt(im_deg_new,best_sigma);
        %testo=["best sigma: ", best_sigma];
        %disp(testo)
    end

end