%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ ŽIVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  PØÍZNAK QOCL

function [Q_LOQ] = priznak_qloq(pole_orientace, maska_pole)

    %% Nastavení parametrù, promìnných
    % Matice o velikosti poètu blokù, pro ukládání skóre kvality z blokù
    LOQ = zeros(size(pole_orientace, 1), size(pole_orientace, 2));
    LOQS = LOQ;

    %% Výpoèet
    % Projíždìní jednotlivých blokù pomocí cyklu FOR
    for i = 1:size(pole_orientace, 1)
        for j = 1:size(pole_orientace, 2)

            % Pokud se v bloku nachází otisk
            if maska_pole(i,j) == 1;

                % Následují podmínky, kdy se podle indexù indexù blokù,
                % bere k výpoètu poèet okolních blokù a jejich pozice
                if i == 1 && j == 1

                    blok_pom = pole_orientace(i:i + 1, j:j + 1);
                    okoli = 3;

                elseif i == 1 && j == size(pole_orientace, 2)

                    blok_pom = pole_orientace(i:i + 1, j - 1:j);
                    okoli = 3;

                elseif i == size(pole_orientace, 1) && j == 1

                    blok_pom = pole_orientace(i - 1:i, j:j + 1);
                    okoli = 3;

                elseif i == size(pole_orientace, 1) && j == size(pole_orientace, 2)

                    blok_pom = pole_orientace(i - 1:i, j - 1:j);
                    okoli = 3;

                elseif i == 1 && j > 1 && j < size(pole_orientace, 2)

                    blok_pom = pole_orientace(i:i + 1, j - 1:j + 1);
                    okoli = 5;

                elseif i == size(pole_orientace, 1) && j > 1 && j < size(pole_orientace, 2)

                    blok_pom = pole_orientace(i - 1:i, j - 1:j + 1);
                    okoli = 5;

                elseif i > 1 && i < size(pole_orientace, 1) && j == 1

                    blok_pom = pole_orientace(i - 1:i + 1, j:j + 1);
                    okoli = 5;

                elseif i > 1 && i < size(pole_orientace, 1) && j == size(pole_orientace, 2)

                    blok_pom = pole_orientace(i - 1:i + 1, j - 1 : j);
                    okoli = 5;

                else

                    blok_pom = pole_orientace(i - 1:i + 1, j - 1:j + 1);
                    okoli = 8;

                end

                % Zjištìní poètu sousedních blokù, s kterými nelze poèítat
                pz = find(isnan(blok_pom));
                odpocet = length(pz);
                blok_pom(pz) = blok_pom(2 ,2);

                % Výpoèet skóre LOQ dle rovnice
                LOQ(i, j) = sum(sum(abs(blok_pom(2, 2) - blok_pom))) / (okoli - odpocet);

                % Výpocèet skóre LOQS dle rovnice
                if rad2deg(LOQ(i, j)) <= 8
                    LOQS(i, j) = 0;
                else
                    LOQS(i, j) = (rad2deg(LOQ(i, j)) - 8) / (90 - 8);
                end
            else
            end

        end
    end
    % Výpoèet skóre Q_LOQ, jako prùmìrná hodnota ze všech blokù
    poz_GOQS = find(maska_pole == 1);
    Q_LOQ = sum(sum(LOQS(poz_GOQS))) / length(poz_GOQS);

end