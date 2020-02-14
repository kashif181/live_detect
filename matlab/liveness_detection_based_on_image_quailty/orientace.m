%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ ŽIVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  VÝPOÈET POLE ORIENTACÍ

function [pole_orientace] = orientace(otisk, v_sirka, v_vyska, maska_pole)

    %% Nastavení parametrù, promìnných
    % Definování pole orientací dle poètù blokù
    pole_orientace = ones(length(v_vyska) - 1, length(v_sirka) - 1) * NaN;
    % Sobelùv operátor
    sobelX = [-1 0 1; -2 0 2; -1 0 1];
    sobelY = sobelX';

    %% Výpoèet
    % Projíždìní jednotlivých blokù pomocí cyklu FOR
    for i = 1:length(v_vyska) - 1
        for j = 1:length(v_sirka) - 1

            % Pokud se v bloku nachází otisk
            if maska_pole(i, j) == 1

                % Indexace bloku
                blok = otisk(v_vyska(i):v_vyska(i+1) - 1, v_sirka(j):v_sirka(j+1) - 1);

                % Výpoèet gradientù dle osy X a osy Y
                GX = conv2(blok, sobelX, 'same');
                GY = conv2(blok, sobelY, 'same');

                % Gradienty bloku dle osy x a dle osy y
                Vx = sum(sum(2 .* GX .* GY));
                Vy = sum(sum(GX .^ 2 - GY .^ 2));

                % Výpoèet smìru orientace
                theta = atan2(Vx, Vy) / 2;
                pole_orientace(i, j) = theta + pi / 2;

                % Pokud je úhel orientace vìtší nebo rovno než PI, 
                % tak odeèíst PI od hodnoty (uhly vìtší jak PI, prevedeny do
                % prvního a druhého kvadrantu
                if pole_orientace(i, j) >= pi
                    pole_orientace(i, j) = pole_orientace(i, j) - pi;
                else
                end
            else
            end

        end
    end

end