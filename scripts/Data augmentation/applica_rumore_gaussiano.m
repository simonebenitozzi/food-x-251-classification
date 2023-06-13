function [im] = applica_rumore_gaussiano(im,gauss_var)
    
    im = imnoise(im,'gaussian',0.0,gauss_var);

end