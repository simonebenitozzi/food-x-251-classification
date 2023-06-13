function [im] = applica_white_balance(im,wR,wG,wB)

    im = double(im);
    im(:,:,1) = im(:,:,1)*(wR*sqrt(3));
    im(:,:,2) = im(:,:,2)*(wG*sqrt(3));
    im(:,:,3) = im(:,:,3)*(wB*sqrt(3));
    im = uint8(im);

end