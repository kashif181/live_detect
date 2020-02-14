%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ ŽIVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  BLOKY VYSEGMENTOVANOHO OTISKU

function [maska_pole] = bloky_segmentace(v_vyska, v_sirka, maska)

    %% Nastavení parametrù, promìnných
    % Matice o velikosti poètu blokù, pro urèení, zda blok patøí vysegmentované
    % èásti obrazu
    maska_pole = zeros(length(v_vyska) - 1, length(v_sirka) - 1);

    %% Výpoèet
    % Projíždìní jednotlivých blokù pomocí cyklu FOR
    for i = 1:length(v_vyska) - 1
        for j = 1:length(v_sirka) - 1

            % Z kolika procent je blok zastoupen vysegmentovanou èástí
            pom_maska = sum(sum(maska(v_vyska(i):v_vyska(i+1) - 1, v_sirka(j):v_sirka(j+1) - 1))) /...
                ((v_vyska(2) - v_vyska(1)) ^ 2);

            % Pokud je blok z více jak 75 % zastoupen vysegmentovanou èástí,
            % bude tento blok vyhodnocen
            if pom_maska > 0.75

                maska_pole(i,j) = 1;    % Uloženi hodnoty 1 na danou pozici bloku

            else
            end
        end
    end

end