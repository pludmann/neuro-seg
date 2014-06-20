function [m, N, P, diff, sumdiff, np] = online_efficiency_test(n, p, c, thresh, plt)

%[sumdiff, N, p, diff] = online_efficiency_test(n,p,c,thresh,plt) génère un signal
%à n ruptures à partir de (n+1) lois normales centrées, avec p points entre 
%deux ruptures, où une rupture correspond à une augmentation de c de
%l'écart-type. On obtient alors une figure représentant en bleu le signal, 
%en vert les ruptures théoriques, et en rouge les ruptures détectées par
%l'algorithme CUSUM récursif. En sortie : sumdiff est le RMSD, N est le 
%nombre de double-ruptures détectées par CUSUM (point de vue online, avec un seuil thresh). Le paramètre plt est
%booléen et permet de dire si l'on veut ou non visualiser les résultats de
%segmentation.
%
%Deux ruptures sont considérées comme doubles ssi l'écart entre les deux
%est plus petit que p/100.

    Y = zeros((n+1)*p,1);
    N = 0;
    P = 0;
    isokay = false;
    isdouble = false;
    
    for k = 1:(n+1)
        Y((p*(k-1)+1):p*k,1) = (c^k)*randn(p,1);
    end
    
    times = all_online(Y, {'std'}, thresh);
    m = size(times,2);
    np(1, 1:m) = sort(times, 'ascend');
    nt = floor(np/p)*p;
    diff = zeros(1, m);
    
    if (plt == true)
        figure;
        plot(Y);
        hold on
    end
    
    for k = 1:m
        if (plt == true)
            line([nt(k), nt(k)], [min(Y), max(Y)], 'Color', [0; 0.8; 0]);
            line([np(k), np(k)], [min(Y), max(Y)], 'Color', 'r');     
        end
        diff(k) = (nt(k) - np(k))^2;
        if (k > 1)
            if (abs(np(k-1) - np(k)) <= p/5)
                N = N+1;
                isdouble = true;
            else
                isdouble = false;
            end
        end
        if (isdouble == false) || (isokay == false)
            if (((abs(mod(np(k),p) - p) <= p/10) || ((abs(mod(np(k),p)) <= p/10))) && ((np(k) > p/10) && (np(k) < (n+1)*p-p/10)))
                P = P+1;
                isokay = true;
            else
                isokay = false;
            end
        else
            isokay = false;
        end
    end
    if (plt == true)
        hold off
    end
    sumdiff = sqrt(sum(diff)/(n^2));
end