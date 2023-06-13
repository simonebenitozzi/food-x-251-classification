function [im_deg_new,im_deg,best_value] = trova_valore_esposizione(im_deg_new,im_deg,quality_metric)

     if quality_metric==0
        BRI=[];
        value=[];
        for i=-25:5:25
            %corr=im_deg_new+i;
            im_ycbcr=rgb2ycbcr(im_deg_new);
            im_y=im_ycbcr(:,:,1);
            im_y=im_y+i;
            im_ycbcr(:,:,1)=im_y;
            corr=ycbcr2rgb(im_ycbcr);
            BRI=[BRI brisque(corr)];
            value=[value; i];
        end
        BRI_deg = brisque(im_deg);
        BRI = abs(BRI - BRI_deg);
        minimum=min(BRI);
        u=find(BRI==minimum);
        u=u(1); % per più elementi minimi
        best_value=value(u);
        %im_deg_new = im_deg_new+best_value;
        im_ycbcr=rgb2ycbcr(im_deg_new);
        im_y=im_ycbcr(:,:,1);
        im_y=im_y+best_value;
        im_ycbcr(:,:,1)=im_y;
        im_deg_new=ycbcr2rgb(im_ycbcr);
        %testo=["best value: ", best_value];
        %disp(testo)
    elseif quality_metric==1
        PSNR=[];
        value=[];
        for i=-25:5:25
            %corr=im_deg_new+i;
            im_ycbcr=rgb2ycbcr(im_deg_new);
            im_y=im_ycbcr(:,:,1);
            im_y=im_y+i;
            im_ycbcr(:,:,1)=im_y;
            corr=ycbcr2rgb(im_ycbcr);
            PSNR=[PSNR psnr(im_deg,corr)];
            value=[value; i];
        end
        maximum=max(PSNR);
        u=find(PSNR==maximum);
        u=u(1); % per più elementi massimi
        best_value=value(u);
        %im_deg_new = im_deg_new+best_value;
        im_ycbcr=rgb2ycbcr(im_deg_new);
        im_y=im_ycbcr(:,:,1);
        im_y=im_y+best_value;
        im_ycbcr(:,:,1)=im_y;
        im_deg_new=ycbcr2rgb(im_ycbcr);
        %testo=["best value: ", best_value];
        %disp(testo)
    elseif quality_metric==2
        SSIM=[];
        value=[];
        for i=-25:5:25
            %corr=im_deg_new+i;
            im_ycbcr=rgb2ycbcr(im_deg_new);
            im_y=im_ycbcr(:,:,1);
            im_y=im_y+i;
            im_ycbcr(:,:,1)=im_y;
            corr=ycbcr2rgb(im_ycbcr);
            SSIM=[SSIM ssim(rgb2gray(im_deg),rgb2gray(corr))];
            value=[value; i];
        end
        maximum=max(SSIM);
        u=find(SSIM==maximum);
        u=u(1); % per più elementi massimi
        best_value=value(u);
        %im_deg_new = im_deg_new+best_value;
        im_ycbcr=rgb2ycbcr(im_deg_new);
        im_y=im_ycbcr(:,:,1);
        im_y=im_y+best_value;
        im_ycbcr(:,:,1)=im_y;
        im_deg_new=ycbcr2rgb(im_ycbcr);
        %testo=["best value: ", best_value];
        %disp(testo)
    end

end