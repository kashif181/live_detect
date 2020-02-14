%% DIPLOMOV� PR�CE
%  BIOMETRICK� ROZPOZN�N� �IVOSTI PRSTU
%  BC. TOM�� V��A, 2015
%  BLOKY VYSEGMENTOVANOHO OTISKU

function [maska_pole] = bloky_segmentace(v_vyska, v_sirka, maska)

    %% Nastaven� parametr�, prom�nn�ch
    % Matice o velikosti po�tu blok�, pro ur�en�, zda blok pat�� vysegmentovan�
    % ��sti obrazu
    maska_pole = zeros(length(v_vyska) - 1, length(v_sirka) - 1);

    %% V�po�et
    % Proj�d�n� jednotliv�ch blok� pomoc� cyklu FOR
    for i = 1:length(v_vyska) - 1
        for j = 1:length(v_sirka) - 1

            % Z kolika procent je blok zastoupen vysegmentovanou ��st�
            pom_maska = sum(sum(maska(v_vyska(i):v_vyska(i+1) - 1, v_sirka(j):v_sirka(j+1) - 1))) /...
                ((v_vyska(2) - v_vyska(1)) ^ 2);

            % Pokud je blok z v�ce jak 75 % zastoupen vysegmentovanou ��st�,
            % bude tento blok vyhodnocen
            if pom_maska > 0.75

                maska_pole(i,j) = 1;    % Ulo�eni hodnoty 1 na danou pozici bloku

            else
            end
        end
    end

end