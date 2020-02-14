%% DIPLOMOV� PR�CE
%  BIOMETRICK� ROZPOZN�N� �IVOSTI PRSTU
%  BC. TOM�� V��A, 2015
%  V�PO�ET POLE ORIENTAC�

function [pole_orientace] = orientace(otisk, v_sirka, v_vyska, maska_pole)

    %% Nastaven� parametr�, prom�nn�ch
    % Definov�n� pole orientac� dle po�t� blok�
    pole_orientace = ones(length(v_vyska) - 1, length(v_sirka) - 1) * NaN;
    % Sobel�v oper�tor
    sobelX = [-1 0 1; -2 0 2; -1 0 1];
    sobelY = sobelX';

    %% V�po�et
    % Proj�d�n� jednotliv�ch blok� pomoc� cyklu FOR
    for i = 1:length(v_vyska) - 1
        for j = 1:length(v_sirka) - 1

            % Pokud se v bloku nach�z� otisk
            if maska_pole(i, j) == 1

                % Indexace bloku
                blok = otisk(v_vyska(i):v_vyska(i+1) - 1, v_sirka(j):v_sirka(j+1) - 1);

                % V�po�et gradient� dle osy X a osy Y
                GX = conv2(blok, sobelX, 'same');
                GY = conv2(blok, sobelY, 'same');

                % Gradienty bloku dle osy x a dle osy y
                Vx = sum(sum(2 .* GX .* GY));
                Vy = sum(sum(GX .^ 2 - GY .^ 2));

                % V�po�et sm�ru orientace
                theta = atan2(Vx, Vy) / 2;
                pole_orientace(i, j) = theta + pi / 2;

                % Pokud je �hel orientace v�t�� nebo rovno ne� PI, 
                % tak ode��st PI od hodnoty (uhly v�t�� jak PI, prevedeny do
                % prvn�ho a druh�ho kvadrantu
                if pole_orientace(i, j) >= pi
                    pole_orientace(i, j) = pole_orientace(i, j) - pi;
                else
                end
            else
            end

        end
    end

end