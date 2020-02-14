%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ ŽIVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  PØÍZNAK GL1

function GL1 = priznak_gl1(otisk, maska)

    % Výpoèet histogramu, poèet pixelù v jednotlivých tøídach
    [counts, ~] = imhist(otisk(maska == 1));

    % Výpoèet GL1 dle rovnice, podíl poètu pixelù v daných intervalech
    GL1 = sum(counts(150:253)) / sum(counts(1:149));

end