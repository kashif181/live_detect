%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ ŽIVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  PØÍZNAK QE

function [Q_E] = priznak_qe(otisk)
    
    %% Nastavení parametrù, promìnných
    % Parametr filtru
    n = 20;
    % Poèet filtrù
    T = 15;
    t = 0:T - 1;

    % Velikost obrazu a pomocné indexy
    [M, N] = size(otisk);
    a_ind = floor(M/2);
    b_ind = floor(N/2);

    %% Výpoèet
    % Fourierova transformace
    OBRAZ = fft2(otisk);
    % Pøerovnání spektra
    OBRAZ = fftshift(OBRAZ);
    % Výpoèet výkonové spektra
    vykon_spektrum = (abs(OBRAZ)) .^ 2;
    % Definování matice Et, dle poètu pásmových propustí
    Et = zeros(1,T-1);
    % Výpoèet pásmových propustí
    Rt = pp_filtry(n, T, t, M, N, a_ind, b_ind);
        % Výpoèet množsví energie v každém pásmu daném propustí
    for i = 1:T-1
        Et(i) = sum(sum(Rt{i} .* vykon_spektrum));
    end

    % Normalizování energie dle rovnice
    Pt = Et ./ sum(Et);
    % Výpoèet množství energie pomocí entropie
    E =  - sum(Pt .* log10(Pt));
    % Výpoèet skóre kvality Q_E
    Q_E = log10(T) - E;

end