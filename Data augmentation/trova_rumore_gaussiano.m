function [im_deg_new,im_deg,best_gauss_var] = trova_rumore_gaussiano(im_deg_new,im_deg,quality_metric)
    
    im_deg_double=double(im_deg);
    nlevel = NoiseLevel(im_deg_double);
    best_gauss_var=0;

    if (nlevel(1)>2.0 || nlevel(2)>2.0 || nlevel(3)>2.0)
        
        if quality_metric==0
            BRI=[];
            gauss_var = [];
            for gl=0:0.001:0.05
                corr=imnoise(im_deg_new,'gaussian',0.0,gl);
                BRI=[BRI brisque(corr)];
                gauss_var = [gauss_var; gl];
            end
            BRI_deg = brisque(im_deg);
            BRI = abs(BRI - BRI_deg);
            minimum=min(BRI);
            u=find(BRI==minimum);
            u=u(1); 
            best_gauss_var=gauss_var(u);
            im_deg_new = imnoise(im_deg_new,'gaussian',0.0,best_gauss_var);
        elseif quality_metric==1
            PIQE=[];
            gauss_var = [];
            for gl=0:0.001:0.1
                corr=imnoise(im_deg_new,'gaussian',0.0,gl);
                PIQE=[PIQE piqe(corr)];
                gauss_var = [gauss_var; gl];
            end
            PIQE_deg = piqe(im_deg);
            PIQE = abs(PIQE - PIQE_deg);
            minimum=min(PIQE);
            u=find(PIQE==minimum);
            u=u(1); 
            best_gauss_var=gauss_var(u);
            im_deg_new = imnoise(im_deg_new,'gaussian',0.0,best_gauss_var);
        elseif quality_metric==2
            PSNR=[];
            gauss_var = [];
            for gl=0:0.01:0.1
                corr=imnoise(im_deg_new,'gaussian',0.0,gl);
                PSNR=[PSNR psnr(im_deg,corr)];
                gauss_var = [gauss_var; gl];
            end
            maximum=max(PSNR);
            u=find(PSNR==maximum);
            u=u(1); % per più elementi massimi
            best_gauss_var=gauss_var(u);
            im_deg_new = imnoise(im_deg_new,'gaussian',0.0,best_gauss_var);
        elseif quality_metric==3
            SSIM=[];
            gauss_var = [];
            for gl=0:0.01:0.1
                corr=imnoise(im_deg_new,'gaussian',0.0,gl);
                SSIM=[SSIM ssim(rgb2gray(im_deg),rgb2gray(corr))];
                gauss_var = [gauss_var; gl];
            end
            maximum=max(SSIM);
            u=find(SSIM==maximum);
            u=u(1); % per più elementi massimi
            best_gauss_var=gauss_var(u);
            im_deg_new = imnoise(im_deg_new,'gaussian',0.0,best_gauss_var);
        end
        
    end

end