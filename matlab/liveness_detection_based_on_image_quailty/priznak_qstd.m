%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ ŽIVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  PØÍZNAK QSTD

function Q_STD = priznak_qstd(maska, otisk)

    % Výpoèet Q_STD pouze z vysegmentovaného otisku prstu
    Q_STD = std2(otisk(maska == 1));

end