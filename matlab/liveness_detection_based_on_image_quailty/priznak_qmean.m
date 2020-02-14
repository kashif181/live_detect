%% DIPLOMOV� PR�CE
%  BIOMETRICK� ROZPOZN�N� �IVOSTI PRSTU
%  BC. TOM�� V��A, 2015
%  P��ZNAK QMEAN

function Q_MEAN = priznak_qmean(maska, otisk)

    % V�po�et Q_MEAN pouze z vysegmentovan�ho otisku prstu
    Q_MEAN = mean2(otisk(maska == 1));

end
