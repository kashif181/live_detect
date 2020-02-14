%% DIPLOMOV� PR�CE
%  BIOMETRICK� ROZPOZN�N� �IVOSTI PRSTU
%  BC. TOM�� V��A, 2015
%  P��ZNAK QOCL

function [Q_LOQ] = priznak_qloq(pole_orientace, maska_pole)

    %% Nastaven� parametr�, prom�nn�ch
    % Matice o velikosti po�tu blok�, pro ukl�d�n� sk�re kvality z blok�
    LOQ = zeros(size(pole_orientace, 1), size(pole_orientace, 2));
    LOQS = LOQ;

    %% V�po�et
    % Proj�d�n� jednotliv�ch blok� pomoc� cyklu FOR
    for i = 1:size(pole_orientace, 1)
        for j = 1:size(pole_orientace, 2)

            % Pokud se v bloku nach�z� otisk
            if maska_pole(i,j) == 1;

                % N�sleduj� podm�nky, kdy se podle index� index� blok�,
                % bere k v�po�tu po�et okoln�ch blok� a jejich pozice
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

                % Zji�t�n� po�tu sousedn�ch blok�, s kter�mi nelze po��tat
                pz = find(isnan(blok_pom));
                odpocet = length(pz);
                blok_pom(pz) = blok_pom(2 ,2);

                % V�po�et sk�re LOQ dle rovnice
                LOQ(i, j) = sum(sum(abs(blok_pom(2, 2) - blok_pom))) / (okoli - odpocet);

                % V�poc�et sk�re LOQS dle rovnice
                if rad2deg(LOQ(i, j)) <= 8
                    LOQS(i, j) = 0;
                else
                    LOQS(i, j) = (rad2deg(LOQ(i, j)) - 8) / (90 - 8);
                end
            else
            end

        end
    end
    % V�po�et sk�re Q_LOQ, jako pr�m�rn� hodnota ze v�ech blok�
    poz_GOQS = find(maska_pole == 1);
    Q_LOQ = sum(sum(LOQS(poz_GOQS))) / length(poz_GOQS);

end