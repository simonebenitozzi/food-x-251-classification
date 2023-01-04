function [im] = applica_filtro_gaussiano(im,sigma_value)
    
    im = imgaussfilt(im,sigma_value);

end