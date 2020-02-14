%% DIPLOMOVÁ PRÁCE
%  BIOMETRICKÉ ROZPOZNÁNÍ ŽIVOSTI PRSTU
%  BC. TOMÁŠ VÁÒA, 2015
%  FILTRY K PØÍZNAKU QE

function Rt = pp_filtry(n, T, t, M, N, a_ind, b_ind)

    % Buòkové pole pro dolní propusti a pásmové propusti dle poètu filtrù
    H = cell(1, T);
    Rt = cell(1, T-1);
    
    % Vytoøení dolních propustí
    for i = 1:T
        m = 0.06 + t(i) * ((0.5 - 0.06) / T);
        for k = 1:M
            for l = 1:N
                H{i}(k,l) = 1 / (1 + (1 / m ^ (2 * n)) * (((k - a_ind) / M) ^ 2 ...
                + ((l - b_ind) / N) ^ 2) ^ n);
            end
        end
    end

    % Výpoèet pásmových propustí
    for i = 1:T - 1
        Rt{i} = H{i+1} - H{i};
    end
end