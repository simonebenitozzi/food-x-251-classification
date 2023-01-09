function [im] = applica_gamma(im,gamma_value)

    im=im2double(im);
    im = gamma_correction(im,gamma_value);
    im=im2uint8(im);

end