function [im] = applica_gamma(im,gamma_value)

    im=im2double(im);
    im = im.^gamma_value;
    im=im2uint8(im);

end