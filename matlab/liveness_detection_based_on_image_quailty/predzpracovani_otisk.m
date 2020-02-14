%% DIPLOMOV� PR�CE
%  BIOMETRICK� ROZPOZN�N� �IVOSTI PRSTU
%  BC. TOM�� V��A, 2015
%  P�EDZPRACOV�N� OBRAZU (NORMALIZACE, SEGMENTACE, NATO�EN�)

function [obraz_norm, maska, otisk] = predzpracovani_otisk(obraz)

    %% Normalizace obrazu
    obraz_norm = imadjust(obraz);

    %% Segmentace otisku
    % Stanoven� prahu pomoc� metody OTSU
    prah = graythresh(obraz_norm);
    % Vytvo�en� matice nul o velikosti "obraz_norm"
    segmentace_maska = zeros(size(obraz));
    % Vysegmentovan� podrahov�ch oblast�
    segmentace_maska(imclose((obraz_norm < prah), strel('disk', 10))) = 1;
    % Ulo�en� vysegmentovan�ch oblast�
    regiony = bwconncomp(segmentace_maska);
    % Vytvo�en� vektoru pro zji�t�ni velikosti jednotliv�ch oblast�
    velikosti = zeros(1, length(regiony.PixelIdxList));
    % Zji�t�n� velikosti oblasti
    for i = 1:length(regiony.PixelIdxList)
        velikosti(i) = length(regiony.PixelIdxList{i});
    end
    % Oblast o nejv�t�� velikosti odpov�d� otisku
    [~, id_region] = max(velikosti);
    segmentace_maska = zeros(size(obraz));

    % Bin�rn� maska vysegmentovan� oblasti
    segmentace_maska(regiony.PixelIdxList{id_region}) = 1;

    % Aproximace elipsou
    % Zji�t�n� sou�adnic st�edu + velikosti hlavn� a vedlej�� osy
    elipsa = regionprops(segmentace_maska, 'Orientation', 'MajorAxisLength', ...
        'MinorAxisLength', 'Eccentricity', 'Centroid');

    % Vzorkov�n� �hlu pro vykreslen�
    phi = linspace(0, 2 * pi, 3000);
    % Hodnoty goniometrick�ch funkc� p�i dan�m �hlu
    cosphi = cos(phi);
    sinphi = sin(phi);

    % Sou�adnice st�edu otisku
    stredX= elipsa.Centroid(1);
    stredY = elipsa.Centroid(2);

    % Velikosti hlavn� a vedlej�� poloosy
    a = elipsa.MajorAxisLength / 2;
    b = elipsa.MinorAxisLength / 2;

    % �hel nato�en� elipsy (otisku)
    theta = pi * elipsa.Orientation / 180;
    % Matice pro sto�eni elipsy
    R = [cos(theta), sin(theta); -sin(theta), cos(theta)];
    % V�po�ty sou�adnic elipsy x,y pro dan� �hel "phi"
    xy = [a * cosphi; b * sinphi];
    % Sto�en� elipsy o �hel "theta"
    xy = R * xy;
    % Um�st�n� elipsy na dan� st�ed otisku
    x = uint32(xy(1, :) + stredX);
    y = uint32(xy(2, :) + stredY);

    % O�et�en� pro vykreslen�, pokud se dostane elipsa mimo zobrazovac� okno
    x = min(x, size(obraz_norm, 2));
    y = min(y, size(obraz_norm, 1));
    x = max(x, 1);
    y = max(y, 1);

    % Sou�adnice k vykreslen�
    souradnice = sub2ind(size(obraz_norm), y, x);
    % Maska elipsy
    elipsa_maska = zeros(size(obraz));
    elipsa_maska(souradnice) = 1;
    elipsa_maska = imfill(elipsa_maska);

    % Aplikace elipsy na otisk prstu
    [indXY] = find(elipsa_maska == 1);
    elipsa_otisk = zeros(size(obraz_norm));
    elipsa_otisk(indXY) = obraz_norm(indXY);

    %% Korekce nato�en�
    % V�po�et 20% velikosti hlavn� osy
    prah_delka = elipsa.MajorAxisLength * 0.2;
    % Elipsa se bude rotovat, pokud je rozd�l d�lek os v�t�� ne� pr�h
    if elipsa.MajorAxisLength - elipsa.MinorAxisLength > prah_delka

        % Pokud je uhel nato�en� nula nebo kladn�
        if elipsa.Orientation >= 0
            % V�po�et �hlu pro korekci nato�en�
            uhel_otoc = 90 - elipsa.Orientation;
        else    % Pokud je �hel z�porn�
            % V�po�et �hlu pro korekci nato�en�
            uhel_otoc = -90 + abs(elipsa.Orientation);
        end

    else
        % Nebude se rotovat, mohlo by doj�t k chybn�mu nato�en�
        uhel_otoc = 0;
    end

    % Rotace otisku o dan� �hel
    elipsa_otisk = imrotate(elipsa_otisk, uhel_otoc);
    elipsa_maska = imrotate(elipsa_maska, uhel_otoc);

    %% Um�st�n� vysegmentovan�ho a spr�vn� nato�en�ho otisku do st�edu obrazu
    % Nalezen� sou�adnic odpov�daj�� masce
    [Y_index, X_index, ~] = find(elipsa_maska == 1);

    % Detekov�n� okraj� elipsy
    elipsa_X_min = min(X_index);
    elipsa_X_max = max(X_index);
    elipsa_Y_min = min(Y_index);
    elipsa_Y_max = max(Y_index);

    % Vyjmut� elipsy
    maska_vyrez = elipsa_maska(elipsa_Y_min:elipsa_Y_max, elipsa_X_min:elipsa_X_max);
    otisk_vyrez = elipsa_otisk(elipsa_Y_min:elipsa_Y_max, elipsa_X_min:elipsa_X_max);

    % Velikost elipsy dle osy X
    elipsa_X_vel = size(maska_vyrez, 2);
    % Velikost elipsy dle osy Y
    elipsa_Y_vel = size(maska_vyrez, 1);

    % Nalezen� st�edu obrazu dle osy X
    if mod(size(obraz, 2), 2) == 1
        obr_stred_X = floor(size(obraz, 2)/2) + 1;
        obr_delka_X = obr_stred_X - 1;
    else
        obr_stred_X = size(obraz, 2)/2;
        obr_delka_X = obr_stred_X - 1;
    end

    % Nalezen� st�edu obrazu dle osy Y
    if mod(size(obraz, 1), 2) == 1
        obr_stred_Y = floor(size(obraz, 1)/2) + 1;
        obr_delka_Y = obr_stred_Y - 1;
    else
        obr_stred_Y = size(obraz, 1)/2;
        obr_delka_Y = obr_stred_Y - 1;
    end

    % Pokud je v��ez v�t�� ne� obraz dle osy X
    if elipsa_X_vel > size(obraz, 2)

        % Podm�nka lichost, sudost
        if mod(elipsa_X_vel, 2) == 1    % Jedn� se o lich� ��slo
            vyrez_stred_X = floor(elipsa_X_vel/2) + 1;
            elipsa_X_min = vyrez_stred_X - obr_delka_X;
            elipsa_X_max = vyrez_stred_X + obr_delka_X;
            delta_X = 0;
        else                            % Jedna se o sud� ��slo
            vyrez_stred_X = elipsa_X_vel/2;
            elipsa_X_min = vyrez_stred_X - obr_delka_X;
            elipsa_X_max = vyrez_stred_X + obr_delka_X + 1;
            delta_X = 0;
        end

    elseif elipsa_X_vel == size(obraz, 2)
        % Pokud je v��ez stejn� jako obraz dle osy X
        elipsa_X_min = 1;
        elipsa_X_max = size(maska_vyrez, 2);
        delta_X = 0;
    else    % Pokud je v��ez men�� ne� obraz dle osy X
        elipsa_X_min = 1;
        elipsa_X_max = size(maska_vyrez, 2);
        delta_X = floor((size(obraz, 2) - elipsa_X_vel)/2);    
    end

    % Pokud je v��ez v�t�� ne� obraz dle osy Y
    if elipsa_Y_vel > size(obraz, 1)

        % Podm�nka lichost, sudost
        if mod(elipsa_Y_vel, 2) == 1    % Jedn� se o lich� ��slo
            vyrez_stred_Y = floor(elipsa_Y_vel/2) + 1;
            elipsa_Y_min = vyrez_stred_Y - obr_delka_Y;
            elipsa_Y_max = vyrez_stred_Y + obr_delka_Y;
            delta_Y = 0;
        else                            % Jedn� se o sud� ��slo
            vyrez_stred_Y = elipsa_Y_vel/2;
            elipsa_Y_min = vyrez_stred_Y - obr_delka_Y;
            elipsa_Y_max = vyrez_stred_Y + obr_delka_Y + 1;
            delta_Y = 0;
        end
    elseif elipsa_Y_vel == size(obraz, 1)
        % Pokud je v��ez stejn� jako obraz dle osy Y
        elipsa_Y_min = 1;
        elipsa_Y_max = size(maska_vyrez, 1);
        delta_Y = 0;
    else    % Pokud je v��ez men�� ne� obraz dle osy X
        elipsa_Y_min = 1;
        elipsa_Y_max = size(maska_vyrez, 1);
        delta_Y = floor((size(obraz, 1) - elipsa_Y_vel)/2);
    end

    % Vyjmut� elipsy
    maska_vyrez2 = maska_vyrez(elipsa_Y_min:elipsa_Y_max, elipsa_X_min:elipsa_X_max);
    otisk_vyrez2 = otisk_vyrez(elipsa_Y_min:elipsa_Y_max, elipsa_X_min:elipsa_X_max);

    % Matice pro masku a otisk
    maska_pom = zeros(size(obraz, 1), size(obraz, 2));
    otisk_pom = maska_pom;

    % Ulo�en� masky a otisku do lev�ho horn�ho rohu matic
    maska_pom(1:size(maska_vyrez2, 1), 1:size(maska_vyrez2, 2)) = maska_vyrez2;
    otisk_pom(1:size(maska_vyrez2, 1), 1:size(maska_vyrez2, 2)) = otisk_vyrez2;

    % Posunut� masky a elipsy do st�edu obrazu
    maska = circshift(maska_pom,[delta_Y, delta_X]);
    otisk = circshift(otisk_pom,[delta_Y, delta_X]);

end