%% DIPLOMOV� PR�CE
%  BIOMETRICK� ROZPOZN�N� �IVOSTI PRSTU
%  BC. TOM�� V��A, 2015
%  ROZD�LEN� OBRAZU DO BLOK�

function [v_vyska, v_sirka] = bloky_deleni(maska)

    %% Nastaven� parametr�, prom�nn�ch
    % Velikost bloku
    okno = 16;

    %% V�po�et
    % Zji�t�ni sou�adnic st�edu obrazu z velikosti obrazu
    stred_obr_ind1 = floor(size(maska, 1) / 2);  % osa X, zaokrohlen� na cele ��slo
    stred_obr_ind2 = floor(size(maska, 2) / 2);  % osa Y, zaokrohlen� na cele ��slo

    % Indexy hranic bloku
    % Podm�nka pro v�po�ty indexu, rozpozn�n� vel. okna (lich� nebo sud� ��slo)
    if mod(okno, 2) == 1    % Jedn� se o lich� ��slo
        okno_vel = floor(okno / 2);
    else                    % Jedn� se o sud� ��slo
        okno_vel = (okno / 2) - 1;
    end

    % Vypo��tan� indexy hranic bloku pro osu X a pro osu Y
    v_vyska = [fliplr(stred_obr_ind1 - okno_vel:-okno:1), stred_obr_ind1 + ... 
        floor(okno / 2) + 1:okno:size(maska, 1)];
    v_sirka = [fliplr(stred_obr_ind2 - okno_vel:-okno:1), stred_obr_ind2 + ...
        floor(okno / 2) + 1:okno:size(maska, 2)];

    % O�et�en� prvn�ho indexu na ose X
    if size(maska, 1) - v_vyska(end) == okno - 1
        v_vyska = [v_vyska, size(maska, 1)];
    else
    end

    % O�et�eni prvn�ho indexu na ose Y
    if size(maska, 2) - v_sirka(end) == okno - 1
        v_sirka = [v_sirka, size(maska, 2)];
    else
    end

end