%% DIPLOMOV� PR�CE
%  BIOMETRICK� ROZPOZN�N� �IVOSTI PRSTU
%  BC. TOM�� V��A, 2015
%  ALGORITMUS K GUI

function algoritmus(varargin)

    % Na�ten� otisku prstu, ulo�� se n�zev a cesta k souboru
    [jmeno, cesta] = uigetfile({'*.tif; *.bmp', 'Soubor otisku (*.tif, *.bmp)'}, 'Na��st otisk');
    
    % Pokud m� soubor n�zev
    if jmeno ~= 0
        
        % Nalezen� prvku v GUI
        popisek = findobj('Tag', 'hodnoceni_text');
        
        % V�pis �pln� cesty k souboru
        set(findobj('Tag', 'cesta_edit'), 'String', [cesta jmeno]);
        % Vypsat do v�sledku detekce: Analyzuji...
        set(popisek, 'Visible', 'on', 'BackgroundColor', 'w', 'String', 'Analyzuji...');
        
        % Dle cesty se na�te dan� soubor
        obraz = imread([cesta jmeno]);
        % Zobrazen� na�ten�ho souboru
        imshow(obraz, [], 'Parent', gca);
        
        pause(0.1);
      
        %% Algoritmus
        % P�eveden� do double
        obraz = im2double(obraz);
        % P�edzpracov�n� obrazu
        [obraz_norm, maska, otisk] = predzpracovani_otisk(obraz);
        % Rozd�len� obrazu na bloky
        [v_vyska, v_sirka] = bloky_deleni(maska);
        % Segmentace dle blok�
        [maska_pole] = bloky_segmentace(v_vyska, v_sirka, maska);
        % V�po�et pole orientace
        [pole_orientace] = orientace(otisk, v_sirka, v_vyska, maska_pole);
        % Filtrace obrazu doln� propust
        obr_gaussfilter = gauss_filtr(obraz_norm);
        
        % Vytvo�en� vektoru po ulo�en� p��znak�
        TestVstup = zeros(16, 1);
        
        % V�po�et 9 p��znak�
        [FR_MSE, FR_PSNR, FR_SNR, FR_RAMD, FR_TED, FR_SME, FR_SPE,...
        FR_GME, FR_GPE] = priznaky_FR(obraz_norm, obr_gaussfilter, 10);
        
        TestVstup(1:9) = [FR_MSE, FR_PSNR, FR_SNR, FR_RAMD, FR_TED,...
            FR_SME, FR_SPE, FR_GME, FR_GPE]';
        
        % V�po�et dal��ch p��znak�
        TestVstup(10) = priznak_gl1(otisk, maska);
        TestVstup(11) = priznak_gl2(otisk, maska);
        TestVstup(12) = priznak_qe(otisk);
        TestVstup(13) = priznak_qocl(otisk, v_vyska, v_sirka, maska_pole);
        TestVstup(14) = priznak_qloq(pole_orientace, maska_pole);
        TestVstup(15) = priznak_qmean(maska, otisk);
        TestVstup(16) = priznak_qstd(maska, otisk);
        
        % Dle velikosti se na�te neuronov� s�
        if size(obraz, 1) < 480
            % Na�te se neuronov� s� pro sn�ma� Biometrika
            load 'neuronka_biometrika.mat'
        elseif size(obraz, 1) == 480
            % Na�te se neuronov� s� pro sn�ma� CrossMatch
            load 'neuronka_crossmatch.mat'
        else
            % Na�te se neuronov� s� pro sn�ma� Identix
            load 'neuronka_identix.mat'
        end
        
        % Klasifikace otisku prstu pomoc� neuronov� s�t�
        stav = net(TestVstup);
        stav = round(stav); % z�sk�n� hodnoty 0 nebo 1
        
        % Pokud je stav = 1, jedn� se prav� otisk
        if stav == 1
            % Vyp�e se do v�sledku detekce: Prav�
            set(popisek, 'Visible', 'on', 'BackgroundColor', 'g', 'String', 'Prav�');
            
        else
            % Vyp�e se do v�sledku detekce: Fale�n�
            set(popisek, 'Visible', 'on', 'BackgroundColor', 'r', 'String', 'Fale�n�');
        end
    end
end