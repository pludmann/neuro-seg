function [sumdiff, N, times, values] = efficiency_test(n,p,c,plt)

%[sumdiff, N] = efficiency_test(n,p,c) génère un signal aléatoire à n
%ruptures à partir de (n+1) lois normales centrées, avec p points entre 
%deux ruptures, où une rupture correspond à une augmentation de c de
%l'écart-type. On obtient alors une figure représentant en bleu le signal, 
%en vert les ruptures théoriques, et en rouge les ruptures détectées par
%l'algorithme CUSUM récursif. En sortie : sumdiff est le RMSD, N est le 
%nombre de double-ruptures détectées par CUSUM
%
%Deux ruptures sont considérées comme doubles ssi l'écart entre les deux
%est plus petit que p/100.
%Une rupture est considérée comme valide ssi l'écart théorie/CUSUM est
%inférieur à p/10.
    Y = zeros((n+1)*p,1);
    nt = zeros(1, n);
    diff = zeros(1, n);
    N = 0;
    
    for k = 1:(n+1)
        Y((p*(k-1)+1):p*k,1) = (c^k)*randn(p,1);
    end
    
    [times, values] = dikt_cusum_lin(Y, {'both'}, n);
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
            line([times(k), times(k)], [min(Y), max(Y)], 'Color', 'r');     
        end
        if (k == 1)
            diff(k) = (nt(k) - np(k))^2;
        else
            diff(k) = (nt(k) - np(k))^2;
            if (abs(np(k-1) - np(k)) <= p/10)
                N = N+1;
            end
        end
    end
    if (plt == true)
        hold off
    end
    sumdiff = sqrt(sum(diff)/(n^2));
end