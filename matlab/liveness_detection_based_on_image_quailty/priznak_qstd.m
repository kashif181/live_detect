%% DIPLOMOV� PR�CE
%  BIOMETRICK� ROZPOZN�N� �IVOSTI PRSTU
%  BC. TOM�� V��A, 2015
%  P��ZNAK QSTD

function Q_STD = priznak_qstd(maska, otisk)

    % V�po�et Q_STD pouze z vysegmentovan�ho otisku prstu
    Q_STD = std2(otisk(maska == 1));

end