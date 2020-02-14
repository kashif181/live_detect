%% DIPLOMOV� PR�CE
%  BIOMETRICK� ROZPOZN�N� �IVOSTI PRSTU
%  BC. TOM�� V��A, 2015
%  P��ZNAK QE

function [Q_E] = priznak_qe(otisk)
    
    %% Nastaven� parametr�, prom�nn�ch
    % Parametr filtru
    n = 20;
    % Po�et filtr�
    T = 15;
    t = 0:T - 1;

    % Velikost obrazu a pomocn� indexy
    [M, N] = size(otisk);
    a_ind = floor(M/2);
    b_ind = floor(N/2);

    %% V�po�et
    % Fourierova transformace
    OBRAZ = fft2(otisk);
    % P�erovn�n� spektra
    OBRAZ = fftshift(OBRAZ);
    % V�po�et v�konov� spektra
    vykon_spektrum = (abs(OBRAZ)) .^ 2;
    % Definov�n� matice Et, dle po�tu p�smov�ch propust�
    Et = zeros(1,T-1);
    % V�po�et p�smov�ch propust�
    Rt = pp_filtry(n, T, t, M, N, a_ind, b_ind);
        % V�po�et mno�sv� energie v ka�d�m p�smu dan�m propust�
    for i = 1:T-1
        Et(i) = sum(sum(Rt{i} .* vykon_spektrum));
    end

    % Normalizov�n� energie dle rovnice
    Pt = Et ./ sum(Et);
    % V�po�et mno�stv� energie pomoc� entropie
    E =  - sum(Pt .* log10(Pt));
    % V�po�et sk�re kvality Q_E
    Q_E = log10(T) - E;

end