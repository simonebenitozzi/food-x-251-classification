function [im] = applica_valore_esposizione(im,exp_value)
    
    im_ycbcr=rgb2ycbcr(im);
    im_y=im_ycbcr(:,:,1);
    im_y=im_y+exp_value;
    im_ycbcr(:,:,1)=im_y;
    im=ycbcr2rgb(im_ycbcr);

end