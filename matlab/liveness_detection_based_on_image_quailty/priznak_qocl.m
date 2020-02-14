%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ ŽIVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  PØÍZNAK QOCL

function [Q_OCL] = priznak_qocl(otisk, v_vyska, v_sirka, maska_pole)

    %% Nastavení parametrù, promìnných
    % Matice o velikosti poètu blokù, pro ukládání skóre kvality z blokù
    k_mat = zeros(length(v_vyska) - 1, length(v_sirka) - 1);
    % Konstanta pro vahovani
    q = 5;
    % Sobelova maska
    sobelX = [-1 0 1; -2 0 2; -1 0 1];
    sobelY = sobelX';

    %% Výpoèet
    % Projíždìní jednotlivých blokù pomocí cyklu FOR
    for i = 1:length(v_vyska) - 1
        for j = 1:length(v_sirka) - 1

            % Pokud se v bloku nachází otisk
            if maska_pole(i, j) == 1;

                % Blokový výøez z pøezpracovaného obrazu
                blok = otisk(v_vyska(i):v_vyska(i+1) - 1, v_sirka(j):v_sirka(j+1) - 1);

                % Výpoèet gradientù dle osy X a osy Y
                GX = conv2(blok, sobelX, 'same');
                GY = conv2(blok, sobelY, 'same');

                % Kovarianèní matice
                J = cov(GX, GY);

                % Výpoèet vlastních èísel kov. matice
                lambda1 = ((J(1,1) + J(2,2)) + sqrt(((J(1,1) + J(2,2)) ^ 2) - 4 * det(J))) / 2;
                lambda2 = ((J(1,1) + J(2,2)) - sqrt(((J(1,1) + J(2,2)) ^ 2) - 4 * det(J))) / 2;

                % Výpoèet kvality bloku
                k_mat(i, j) = ((lambda1 - lambda2) ^ 2) / ((lambda1 + lambda2) ^ 2);
            else
            end
        end
    end

    % Zjištìní souøadnic støedu otisku
    pom_stred = regionprops(maska_pole,'centroid');
    % Zaokrouhlování souøadnic na celé èíslo
    lc = round(pom_stred.Centroid);

    % Výpoèet hodnoty pøíznaku Q_OCL
    [x, y] = meshgrid(1:size(maska_pole, 2), 1:size(maska_pole, 1));
    Q_OCL = sum(sum(k_mat .* exp(-(((lc(2) - y) .^ 2) + ((lc(1) - x) .^ 2)) / (2 * q)))) / nnz(maska_pole);

end