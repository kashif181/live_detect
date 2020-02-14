%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ ŽIVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  PØEDZPRACOVÁNÍ OBRAZU (NORMALIZACE, SEGMENTACE, NATOÈENÍ)

function [obraz_norm, maska, otisk] = predzpracovani_otisk(obraz)

    %% Normalizace obrazu
    obraz_norm = imadjust(obraz);

    %% Segmentace otisku
    % Stanovení prahu pomocí metody OTSU
    prah = graythresh(obraz_norm);
    % Vytvoøení matice nul o velikosti "obraz_norm"
    segmentace_maska = zeros(size(obraz));
    % Vysegmentovaní podrahových oblastí
    segmentace_maska(imclose((obraz_norm < prah), strel('disk', 10))) = 1;
    % Uložení vysegmentovanách oblastí
    regiony = bwconncomp(segmentace_maska);
    % Vytvoøení vektoru pro zjištìni velikosti jednotlivých oblastí
    velikosti = zeros(1, length(regiony.PixelIdxList));
    % Zjištìní velikosti oblasti
    for i = 1:length(regiony.PixelIdxList)
        velikosti(i) = length(regiony.PixelIdxList{i});
    end
    % Oblast o nejvìtší velikosti odpovídá otisku
    [~, id_region] = max(velikosti);
    segmentace_maska = zeros(size(obraz));

    % Binární maska vysegmentované oblasti
    segmentace_maska(regiony.PixelIdxList{id_region}) = 1;

    % Aproximace elipsou
    % Zjištìní souøadnic støedu + velikosti hlavní a vedlejší osy
    elipsa = regionprops(segmentace_maska, 'Orientation', 'MajorAxisLength', ...
        'MinorAxisLength', 'Eccentricity', 'Centroid');

    % Vzorkování úhlu pro vykreslení
    phi = linspace(0, 2 * pi, 3000);
    % Hodnoty goniometrických funkcí pøi daném úhlu
    cosphi = cos(phi);
    sinphi = sin(phi);

    % Souøadnice støedu otisku
    stredX= elipsa.Centroid(1);
    stredY = elipsa.Centroid(2);

    % Velikosti hlavní a vedlejší poloosy
    a = elipsa.MajorAxisLength / 2;
    b = elipsa.MinorAxisLength / 2;

    % Úhel natoèení elipsy (otisku)
    theta = pi * elipsa.Orientation / 180;
    % Matice pro stoèeni elipsy
    R = [cos(theta), sin(theta); -sin(theta), cos(theta)];
    % Výpoèty souøadnic elipsy x,y pro daný úhel "phi"
    xy = [a * cosphi; b * sinphi];
    % Stoèení elipsy o úhel "theta"
    xy = R * xy;
    % Umístìní elipsy na daný støed otisku
    x = uint32(xy(1, :) + stredX);
    y = uint32(xy(2, :) + stredY);

    % Ošetøení pro vykreslení, pokud se dostane elipsa mimo zobrazovací okno
    x = min(x, size(obraz_norm, 2));
    y = min(y, size(obraz_norm, 1));
    x = max(x, 1);
    y = max(y, 1);

    % Souøadnice k vykreslení
    souradnice = sub2ind(size(obraz_norm), y, x);
    % Maska elipsy
    elipsa_maska = zeros(size(obraz));
    elipsa_maska(souradnice) = 1;
    elipsa_maska = imfill(elipsa_maska);

    % Aplikace elipsy na otisk prstu
    [indXY] = find(elipsa_maska == 1);
    elipsa_otisk = zeros(size(obraz_norm));
    elipsa_otisk(indXY) = obraz_norm(indXY);

    %% Korekce natoèení
    % Výpoèet 20% velikosti hlavní osy
    prah_delka = elipsa.MajorAxisLength * 0.2;
    % Elipsa se bude rotovat, pokud je rozdíl délek os vìtší než práh
    if elipsa.MajorAxisLength - elipsa.MinorAxisLength > prah_delka

        % Pokud je uhel natoèení nula nebo kladný
        if elipsa.Orientation >= 0
            % Výpoèet úhlu pro korekci natoèení
            uhel_otoc = 90 - elipsa.Orientation;
        else    % Pokud je úhel záporný
            % Výpoèet úhlu pro korekci natoèení
            uhel_otoc = -90 + abs(elipsa.Orientation);
        end

    else
        % Nebude se rotovat, mohlo by dojít k chybnému natoèení
        uhel_otoc = 0;
    end

    % Rotace otisku o daný úhel
    elipsa_otisk = imrotate(elipsa_otisk, uhel_otoc);
    elipsa_maska = imrotate(elipsa_maska, uhel_otoc);

    %% Umístìní vysegmentovaného a správnì natoèeného otisku do støedu obrazu
    % Nalezení souøadnic odpovídajíí masce
    [Y_index, X_index, ~] = find(elipsa_maska == 1);

    % Detekování okrajù elipsy
    elipsa_X_min = min(X_index);
    elipsa_X_max = max(X_index);
    elipsa_Y_min = min(Y_index);
    elipsa_Y_max = max(Y_index);

    % Vyjmutí elipsy
    maska_vyrez = elipsa_maska(elipsa_Y_min:elipsa_Y_max, elipsa_X_min:elipsa_X_max);
    otisk_vyrez = elipsa_otisk(elipsa_Y_min:elipsa_Y_max, elipsa_X_min:elipsa_X_max);

    % Velikost elipsy dle osy X
    elipsa_X_vel = size(maska_vyrez, 2);
    % Velikost elipsy dle osy Y
    elipsa_Y_vel = size(maska_vyrez, 1);

    % Nalezení støedu obrazu dle osy X
    if mod(size(obraz, 2), 2) == 1
        obr_stred_X = floor(size(obraz, 2)/2) + 1;
        obr_delka_X = obr_stred_X - 1;
    else
        obr_stred_X = size(obraz, 2)/2;
        obr_delka_X = obr_stred_X - 1;
    end

    % Nalezení støedu obrazu dle osy Y
    if mod(size(obraz, 1), 2) == 1
        obr_stred_Y = floor(size(obraz, 1)/2) + 1;
        obr_delka_Y = obr_stred_Y - 1;
    else
        obr_stred_Y = size(obraz, 1)/2;
        obr_delka_Y = obr_stred_Y - 1;
    end

    % Pokud je výøez vìtší než obraz dle osy X
    if elipsa_X_vel > size(obraz, 2)

        % Podmínka lichost, sudost
        if mod(elipsa_X_vel, 2) == 1    % Jedná se o liché èíslo
            vyrez_stred_X = floor(elipsa_X_vel/2) + 1;
            elipsa_X_min = vyrez_stred_X - obr_delka_X;
            elipsa_X_max = vyrez_stred_X + obr_delka_X;
            delta_X = 0;
        else                            % Jedna se o sudé èíslo
            vyrez_stred_X = elipsa_X_vel/2;
            elipsa_X_min = vyrez_stred_X - obr_delka_X;
            elipsa_X_max = vyrez_stred_X + obr_delka_X + 1;
            delta_X = 0;
        end

    elseif elipsa_X_vel == size(obraz, 2)
        % Pokud je výøez stejný jako obraz dle osy X
        elipsa_X_min = 1;
        elipsa_X_max = size(maska_vyrez, 2);
        delta_X = 0;
    else    % Pokud je výøez menší než obraz dle osy X
        elipsa_X_min = 1;
        elipsa_X_max = size(maska_vyrez, 2);
        delta_X = floor((size(obraz, 2) - elipsa_X_vel)/2);    
    end

    % Pokud je výøez vìtší než obraz dle osy Y
    if elipsa_Y_vel > size(obraz, 1)

        % Podmínka lichost, sudost
        if mod(elipsa_Y_vel, 2) == 1    % Jedná se o liché èíslo
            vyrez_stred_Y = floor(elipsa_Y_vel/2) + 1;
            elipsa_Y_min = vyrez_stred_Y - obr_delka_Y;
            elipsa_Y_max = vyrez_stred_Y + obr_delka_Y;
            delta_Y = 0;
        else                            % Jedná se o sudé èíslo
            vyrez_stred_Y = elipsa_Y_vel/2;
            elipsa_Y_min = vyrez_stred_Y - obr_delka_Y;
            elipsa_Y_max = vyrez_stred_Y + obr_delka_Y + 1;
            delta_Y = 0;
        end
    elseif elipsa_Y_vel == size(obraz, 1)
        % Pokud je výøez stejný jako obraz dle osy Y
        elipsa_Y_min = 1;
        elipsa_Y_max = size(maska_vyrez, 1);
        delta_Y = 0;
    else    % Pokud je výøez menší než obraz dle osy X
        elipsa_Y_min = 1;
        elipsa_Y_max = size(maska_vyrez, 1);
        delta_Y = floor((size(obraz, 1) - elipsa_Y_vel)/2);
    end

    % Vyjmutí elipsy
    maska_vyrez2 = maska_vyrez(elipsa_Y_min:elipsa_Y_max, elipsa_X_min:elipsa_X_max);
    otisk_vyrez2 = otisk_vyrez(elipsa_Y_min:elipsa_Y_max, elipsa_X_min:elipsa_X_max);

    % Matice pro masku a otisk
    maska_pom = zeros(size(obraz, 1), size(obraz, 2));
    otisk_pom = maska_pom;

    % Uložení masky a otisku do levého horního rohu matic
    maska_pom(1:size(maska_vyrez2, 1), 1:size(maska_vyrez2, 2)) = maska_vyrez2;
    otisk_pom(1:size(maska_vyrez2, 1), 1:size(maska_vyrez2, 2)) = otisk_vyrez2;

    % Posunutí masky a elipsy do støedu obrazu
    maska = circshift(maska_pom,[delta_Y, delta_X]);
    otisk = circshift(otisk_pom,[delta_Y, delta_X]);

end