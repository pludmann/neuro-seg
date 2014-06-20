function [N, P, diff, sumdiff, np] = offline_efficiency_test(n, p, c, plt)

%[N, P, diff, sumdiff, np] = offline_efficiency_test(n,p,c,plt) génère un
%signal aléatoire à n ruptures à partir de (n+1) lois normales centrées,
%avec p points entre deux ruptures, où une rupture correspond à une
%augmentation de c de l'écart-type. On obtient alors une figure
%représentant en bleu le signal, en vert les ruptures théoriques, et en
%rouge les ruptures détectées par l'algorithme CUSUM récursif.  Le
%paramètre plt est booléen et permet de dire si l'on veut ou non visualiser
%les résultats de segmentation. En sortie : sumdiff est le RMSD, N est le
%nombre de double-ruptures détectées par CUSUM (point de vue offline), P
%est le nombre de bonnes ruptures.
%
%Deux ruptures détectées sont considérées comme doubles ssi l'écart entre
%les deux est plus petit que p/5. Une rupture détetée est considérée comme
%bonne ssi elle se trouve à +/-10% d'une rupture théorique.

    Y = zeros((n+1)*p,1);
    nt = zeros(1, n);
    diff = zeros(1, n);
    N = 0;
    P = 0;
    isokay = false;
    isdouble = false;
    
    for k = 1:(n+1)
        Y((p*(k-1)+1):p*k,1) = (c^k)*randn(p,1);
    end
    
    times = dikt_cusum_lin(Y, {'std'}, n);
    np = sort(times, 'ascend');
    
    if (plt == true)
        figure;
        plot(Y);
        hold on
    end
    
    for k = 1:n
        nt(k) = p*k;
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