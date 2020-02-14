%% DIPLOMOV� PR�CE
%  BIOMETRICK� ROZPOZN�N� �IVOSTI PRSTU
%  BC. TOM�� V��A, 2015
%  P��ZNAK GL2

function GL2 = priznak_gl2(otisk, maska)

    % V�po�et histogramu, po�et pixel� v jednotliv�ch t��dach
    [counts, ~] = imhist(otisk(maska == 1));

    % V�po�et GL1 dle rovnice, pod�l po�tu pixel� v dan�ch intervalech
    GL2 = sum(counts(246:256)) / sum(counts(1:245));

end