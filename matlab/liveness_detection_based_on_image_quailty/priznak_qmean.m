%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ ŽIVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  PØÍZNAK QMEAN

function Q_MEAN = priznak_qmean(maska, otisk)

    % Výpoèet Q_MEAN pouze z vysegmentovaného otisku prstu
    Q_MEAN = mean2(otisk(maska == 1));

end
