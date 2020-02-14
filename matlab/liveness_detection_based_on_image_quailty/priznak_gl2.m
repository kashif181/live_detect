%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ ŽIVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  PØÍZNAK GL2

function GL2 = priznak_gl2(otisk, maska)

    % Výpoèet histogramu, poèet pixelù v jednotlivých tøídach
    [counts, ~] = imhist(otisk(maska == 1));

    % Výpoèet GL1 dle rovnice, podíl poètu pixelù v daných intervalech
    GL2 = sum(counts(246:256)) / sum(counts(1:245));

end