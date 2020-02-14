%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ IVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  ALGORITMUS K GUI

function algoritmus(varargin)

    % Naètení otisku prstu, uloí se název a cesta k souboru
    [jmeno, cesta] = uigetfile({'*.tif; *.bmp', 'Soubor otisku (*.tif, *.bmp)'}, 'Naèíst otisk');
    
    % Pokud má soubor název
    if jmeno ~= 0
        
        % Nalezení prvku v GUI
        popisek = findobj('Tag', 'hodnoceni_text');
        
        % Vıpis úplné cesty k souboru
        set(findobj('Tag', 'cesta_edit'), 'String', [cesta jmeno]);
        % Vypsat do vısledku detekce: Analyzuji...
        set(popisek, 'Visible', 'on', 'BackgroundColor', 'w', 'String', 'Analyzuji...');
        
        % Dle cesty se naète danı soubor
        obraz = imread([cesta jmeno]);
        % Zobrazení naèteného souboru
        imshow(obraz, [], 'Parent', gca);
        
        pause(0.1);
      
        %% Algoritmus
        % Pøevedení do double
        obraz = im2double(obraz);
        % Pøedzpracování obrazu
        [obraz_norm, maska, otisk] = predzpracovani_otisk(obraz);
        % Rozdìlení obrazu na bloky
        [v_vyska, v_sirka] = bloky_deleni(maska);
        % Segmentace dle blokù
        [maska_pole] = bloky_segmentace(v_vyska, v_sirka, maska);
        % Vıpoèet pole orientace
        [pole_orientace] = orientace(otisk, v_sirka, v_vyska, maska_pole);
        % Filtrace obrazu dolní propust
        obr_gaussfilter = gauss_filtr(obraz_norm);
        
        % Vytvoøení vektoru po uloení pøíznakù
        TestVstup = zeros(16, 1);
        
        % Vıpoèet 9 pøíznakù
        [FR_MSE, FR_PSNR, FR_SNR, FR_RAMD, FR_TED, FR_SME, FR_SPE,...
        FR_GME, FR_GPE] = priznaky_FR(obraz_norm, obr_gaussfilter, 10);
        
        TestVstup(1:9) = [FR_MSE, FR_PSNR, FR_SNR, FR_RAMD, FR_TED,...
            FR_SME, FR_SPE, FR_GME, FR_GPE]';
        
        % Vıpoèet dalších pøíznakù
        TestVstup(10) = priznak_gl1(otisk, maska);
        TestVstup(11) = priznak_gl2(otisk, maska);
        TestVstup(12) = priznak_qe(otisk);
        TestVstup(13) = priznak_qocl(otisk, v_vyska, v_sirka, maska_pole);
        TestVstup(14) = priznak_qloq(pole_orientace, maska_pole);
        TestVstup(15) = priznak_qmean(maska, otisk);
        TestVstup(16) = priznak_qstd(maska, otisk);
        
        % Dle velikosti se naète neuronová sí
        if size(obraz, 1) < 480
            % Naète se neuronová sí pro snímaè Biometrika
            load 'neuronka_biometrika.mat'
        elseif size(obraz, 1) == 480
            % Naète se neuronová sí pro snímaè CrossMatch
            load 'neuronka_crossmatch.mat'
        else
            % Naète se neuronová sí pro snímaè Identix
            load 'neuronka_identix.mat'
        end
        
        % Klasifikace otisku prstu pomocí neuronové sítì
        stav = net(TestVstup);
        stav = round(stav); % získání hodnoty 0 nebo 1
        
        % Pokud je stav = 1, jedná se pravı otisk
        if stav == 1
            % Vypíše se do vısledku detekce: Pravı
            set(popisek, 'Visible', 'on', 'BackgroundColor', 'g', 'String', 'Pravı');
            
        else
            % Vypíše se do vısledku detekce: Falešnı
            set(popisek, 'Visible', 'on', 'BackgroundColor', 'r', 'String', 'Falešnı');
        end
    end
end