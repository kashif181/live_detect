%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ ŽIVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  ROZDÌLENÍ OBRAZU DO BLOKÙ

function [v_vyska, v_sirka] = bloky_deleni(maska)

    %% Nastavení parametrù, promìnných
    % Velikost bloku
    okno = 16;

    %% Výpoèet
    % Zjištìni souøadnic støedu obrazu z velikosti obrazu
    stred_obr_ind1 = floor(size(maska, 1) / 2);  % osa X, zaokrohlení na cele èíslo
    stred_obr_ind2 = floor(size(maska, 2) / 2);  % osa Y, zaokrohlení na cele èíslo

    % Indexy hranic bloku
    % Podmínka pro výpoèty indexu, rozpoznání vel. okna (liché nebo sudé èíslo)
    if mod(okno, 2) == 1    % Jedná se o liché èíslo
        okno_vel = floor(okno / 2);
    else                    % Jedná se o sudé èíslo
        okno_vel = (okno / 2) - 1;
    end

    % Vypoøítané indexy hranic bloku pro osu X a pro osu Y
    v_vyska = [fliplr(stred_obr_ind1 - okno_vel:-okno:1), stred_obr_ind1 + ... 
        floor(okno / 2) + 1:okno:size(maska, 1)];
    v_sirka = [fliplr(stred_obr_ind2 - okno_vel:-okno:1), stred_obr_ind2 + ...
        floor(okno / 2) + 1:okno:size(maska, 2)];

    % Ošetøení prvního indexu na ose X
    if size(maska, 1) - v_vyska(end) == okno - 1
        v_vyska = [v_vyska, size(maska, 1)];
    else
    end

    % Ošetøeni prvního indexu na ose Y
    if size(maska, 2) - v_sirka(end) == okno - 1
        v_sirka = [v_sirka, size(maska, 2)];
    else
    end

end