%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ ŽIVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  GAUSS FILTR - DOLNÍ PROPUST

function obr_gaussfilter = gauss_filtr(obraz_norm)
    
    %% Nastavení parametrù, promìnných
    % Velikost masky filtru
    vel_maska = [3, 3];
    % smerodatnách odchylka Gauss. køivky
    sigma = 0.5;
    
    %% Výpoèet
    % Tvorba filtru
    h = fspecial('gaussian', vel_maska, sigma);
    % Filtrace obrazu
    obr_gaussfilter = imfilter(obraz_norm, h);

end