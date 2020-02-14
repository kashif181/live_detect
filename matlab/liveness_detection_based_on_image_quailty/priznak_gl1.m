%% DIPLOMOV� PR�CE
%  BIOMETRICK� ROZPOZN�N� �IVOSTI PRSTU
%  BC. TOM�� V��A, 2015
%  P��ZNAK GL1

function GL1 = priznak_gl1(otisk, maska)

    % V�po�et histogramu, po�et pixel� v jednotliv�ch t��dach
    [counts, ~] = imhist(otisk(maska == 1));

    % V�po�et GL1 dle rovnice, pod�l po�tu pixel� v dan�ch intervalech
    GL1 = sum(counts(150:253)) / sum(counts(1:149));

end