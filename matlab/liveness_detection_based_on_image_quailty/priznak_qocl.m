%% DIPLOMOV� PR�CE
%  BIOMETRICK� ROZPOZN�N� �IVOSTI PRSTU
%  BC. TOM�� V��A, 2015
%  P��ZNAK QOCL

function [Q_OCL] = priznak_qocl(otisk, v_vyska, v_sirka, maska_pole)

    %% Nastaven� parametr�, prom�nn�ch
    % Matice o velikosti po�tu blok�, pro ukl�d�n� sk�re kvality z blok�
    k_mat = zeros(length(v_vyska) - 1, length(v_sirka) - 1);
    % Konstanta pro vahovani
    q = 5;
    % Sobelova maska
    sobelX = [-1 0 1; -2 0 2; -1 0 1];
    sobelY = sobelX';

    %% V�po�et
    % Proj�d�n� jednotliv�ch blok� pomoc� cyklu FOR
    for i = 1:length(v_vyska) - 1
        for j = 1:length(v_sirka) - 1

            % Pokud se v bloku nach�z� otisk
            if maska_pole(i, j) == 1;

                % Blokov� v��ez z p�ezpracovan�ho obrazu
                blok = otisk(v_vyska(i):v_vyska(i+1) - 1, v_sirka(j):v_sirka(j+1) - 1);

                % V�po�et gradient� dle osy X a osy Y
                GX = conv2(blok, sobelX, 'same');
                GY = conv2(blok, sobelY, 'same');

                % Kovarian�n� matice
                J = cov(GX, GY);

                % V�po�et vlastn�ch ��sel kov. matice
                lambda1 = ((J(1,1) + J(2,2)) + sqrt(((J(1,1) + J(2,2)) ^ 2) - 4 * det(J))) / 2;
                lambda2 = ((J(1,1) + J(2,2)) - sqrt(((J(1,1) + J(2,2)) ^ 2) - 4 * det(J))) / 2;

                % V�po�et kvality bloku
                k_mat(i, j) = ((lambda1 - lambda2) ^ 2) / ((lambda1 + lambda2) ^ 2);
            else
            end
        end
    end

    % Zji�t�n� sou�adnic st�edu otisku
    pom_stred = regionprops(maska_pole,'centroid');
    % Zaokrouhlov�n� sou�adnic na cel� ��slo
    lc = round(pom_stred.Centroid);

    % V�po�et hodnoty p��znaku Q_OCL
    [x, y] = meshgrid(1:size(maska_pole, 2), 1:size(maska_pole, 1));
    Q_OCL = sum(sum(k_mat .* exp(-(((lc(2) - y) .^ 2) + ((lc(1) - x) .^ 2)) / (2 * q)))) / nnz(maska_pole);

end