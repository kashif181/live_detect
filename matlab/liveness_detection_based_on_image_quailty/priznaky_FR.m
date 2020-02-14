%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ ŽIVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  PØÍZNAKY MSE, PSNR, SNR, RAMD, TED, SME, SPE, GME, GPE

function [FR_MSE, FR_PSNR, FR_SNR, FR_RAMD, FR_TED, FR_SME, FR_SPE, FR_GME, FR_GPE] = ...
    priznaky_FR(obraz_norm, obr_gaussfilter, R)

    %% Nastavení parametrù, promìnných
    % Rozmìry obrazu
    M = size(obraz_norm, 1);
    N = size(obraz_norm, 2);
    
    %% VÝPOÈET    
    % Mean Squared Error
    FR_MSE = sum(sum((obraz_norm - obr_gaussfilter) .^ 2)) / (N * M);
    % Peak Signal to Noise Ratio
    FR_PSNR = 10 * log10(max(max(obraz_norm .^ 2)) / FR_MSE);
    % Signal to Noise Ratio
    FR_SNR = 10 * log10(sum(sum(obraz_norm .^ 2)) / (N * M * FR_MSE));
    % R-Averaged MD
    pom0 = abs(obraz_norm - obr_gaussfilter);
    seraz_prvky = sort(pom0(:));
    FR_RAMD = sum(seraz_prvky(end - R + 1:end)) / R;
    
    % Total Edge Difference
    IE = edge(obraz_norm, 'sobel', 0.15);
    IE_R = edge(obr_gaussfilter, 'sobel', 0.15);
    FR_TED = sum(sum(abs(IE - IE_R))) / (M * N);
    
    % Spectral Magnitute Error + Spectral Phase Error
    F = fft2(obraz_norm);
    F_R = fft2(obr_gaussfilter);
    FR_SME = sum(sum((abs(F) - abs(F_R)).^2)) / (M * N);
    FR_SPE = sum(sum(abs(angle(F) - angle(F_R)).^2)) / (M * N);
    
    % Gradient Magnitute Error + Gradient Phase Error
    [GX, GY] = gradient(obraz_norm);
    G = GX + 1i * GY;
    [GX_R, GY_R] = gradient(obr_gaussfilter);
    G_R = GX_R + 1i * GY_R;
    FR_GME = sum(sum((abs(G) - abs(G_R)).^2)) / (M * N);
    FR_GPE = sum(sum(abs(angle(G) - angle(G_R)).^2)) / (M * N);
    
end
    
    