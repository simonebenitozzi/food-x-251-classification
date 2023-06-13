function [im1,im2] = color_transfer(im1,im2)

    % conversione in double
    im1 = im2double(im1);
    im2 = im2double(im2);
    
    % dimensioni delle immagini
    S1 = size(im1);
    S2 = size(im2);

    % converto in ycbcr
    im1_ycbcr = rgb2ycbcr(im1);
    im2_ycbcr = rgb2ycbcr(im2);

    % estrazione statistiche
    im1_ycbcr = reshape(im1_ycbcr,[],3);
    im2_ycbcr = reshape(im2_ycbcr,[],3);
    mean_im1 = mean(im1_ycbcr);
    mean_im2 = mean(im2_ycbcr);
    std_im1 = std(im1_ycbcr);
    std_im2 = std(im2_ycbcr);

    % trasferimento colori (in cb e cr) da im2_ycbcr a im1_ycbcr
    for ch = 2:3
        im1_ycbcr(:,ch) = im1_ycbcr(:,ch) - mean_im1(ch);
        im1_ycbcr(:,ch) = im1_ycbcr(:,ch) * (std_im2(ch) / std_im1(ch));
        im1_ycbcr(:,ch) = im1_ycbcr(:,ch) + mean_im2(ch);
    end
   
    % ricompongo le immagini
    im1_ycbcr = reshape(im1_ycbcr, S1);
    im2_ycbcr = reshape(im2_ycbcr, S2);

    % le trasformo in rgb
    im1_rgb = ycbcr2rgb(im1_ycbcr);
    im2_rgb = ycbcr2rgb(im2_ycbcr);

    % trasformo in uint8
    im1_rgb = im2uint8(im1_rgb);
    im2_rgb = im2uint8(im2_rgb);

    im1 = im1_rgb;
    im2 = im2_rgb;

end