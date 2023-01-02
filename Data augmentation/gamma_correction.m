function [im_deg_new] = gamma_correction(im_deg_new,gamma)
    
    im_ycbcr=rgb2ycbcr(im_deg_new);
    im_y=im_ycbcr(:,:,1);

    patch = imcrop(im_y,[10,20,40,50]);
    patchSq = patch.^2;
    edist = sqrt(sum(patchSq,3));
    patchVar = std2(edist).^2;
    DoS = gamma*patchVar;
    im_y=imbilatfilt(im_y,DoS,gamma);

    im_ycbcr(:,:,1)=im_y;
    im_deg_new=ycbcr2rgb(im_ycbcr);

end