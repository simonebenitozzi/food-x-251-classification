function [im_deg_new,im_deg,best_sat] = trova_saturazione(im_deg_new,im_deg,quality_metric)

    if quality_metric==0
        BRI=[];
        sat=[];
        for i=-0.3:0.01:0.3
            im_hsv=rgb2hsv(im_deg_new);
            im_s=im_hsv(:,:,2);
            im_s=im_s+i;
            im_hsv(:,:,2)=im_s;
            im_hsv(im_hsv>1)=1;
            corr=im2uint8(hsv2rgb(im_hsv));
            BRI=[BRI brisque(corr)];
            sat=[sat; i];
        end
        BRI_deg = brisque(im_deg);
        BRI = abs(BRI - BRI_deg);
        minimum=min(BRI);
        u=find(BRI==minimum);
        u=u(1); % per più elementi minimi
        best_sat=sat(u);
        im_hsv=rgb2hsv(im_deg_new);
        im_s=im_hsv(:,:,2);
        im_s=im_s+best_sat;
        im_hsv(:,:,2)=im_s;
        im_deg_new=im2uint8(hsv2rgb(im_hsv));
    elseif quality_metric==1
        PSNR=[];
        sat=[];
        for i=-0.3:0.01:0.3
            im_hsv=rgb2hsv(im_deg_new);
            im_s=im_hsv(:,:,2);
            im_s=im_s+i;
            im_hsv(:,:,2)=im_s;
            im_hsv(im_hsv>1)=1;
            corr=im2uint8(hsv2rgb(im_hsv));
            PSNR=[PSNR psnr(im_deg,corr)];
            sat=[sat; i];
        end
        maximum=max(PSNR);
        u=find(PSNR==maximum);
        u=u(1); % per più elementi massimi
        best_sat=sat(u);
        im_hsv=rgb2hsv(im_deg_new);
        im_s=im_hsv(:,:,2);
        im_s=im_s+best_sat;
        im_hsv(:,:,2)=im_s;
        im_deg_new=im2uint8(hsv2rgb(im_hsv));
    elseif quality_metric==2
        SSIM=[];
        sat=[];
        for i=-0.3:0.01:0.3
            im_hsv=rgb2hsv(im_deg_new);
            im_s=im_hsv(:,:,2);
            im_s=im_s+i;
            im_hsv(:,:,2)=im_s;
            im_hsv(im_hsv>1)=1;
            corr=im2uint8(hsv2rgb(im_hsv));
            SSIM=[SSIM ssim(rgb2gray(im_deg),rgb2gray(corr))];
            sat=[sat; i];
        end
        maximum=max(SSIM);
        u=find(SSIM==maximum);
        u=u(1); % per più elementi massimi
        best_sat=sat(u);
        im_hsv=rgb2hsv(im_deg_new);
        im_s=im_hsv(:,:,2);
        im_s=im_s+best_sat;
        im_hsv(:,:,2)=im_s;
        im_deg_new=im2uint8(hsv2rgb(im_hsv));
    end

end