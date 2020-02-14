%% DIPLOMOV� PR�CE
%  BIOMETRICK� ROZPOZN�N� �IVOSTI PRSTU
%  BC. TOM�� V��A, 2015
%  GAUSS FILTR - DOLN� PROPUST

function obr_gaussfilter = gauss_filtr(obraz_norm)
    
    %% Nastaven� parametr�, prom�nn�ch
    % Velikost masky filtru
    vel_maska = [3, 3];
    % smerodatn�ch odchylka Gauss. k�ivky
    sigma = 0.5;
    
    %% V�po�et
    % Tvorba filtru
    h = fspecial('gaussian', vel_maska, sigma);
    % Filtrace obrazu
    obr_gaussfilter = imfilter(obraz_norm, h);

end