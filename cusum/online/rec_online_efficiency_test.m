function [m, N, P, sumdiff] = rec_online_efficiency_test(mode, param1, param2, thresh, n)

%[m, N, P, sumdiff] = rec_online_efficiency_test(mode, param1, param2,
%thresh, n) a pour entr�es un mode (soit 'rupt', soit 'pts'), deux
%param�tres param1 et param2, un seuil thresh, et un nombre de tests n. Si
%mode == 'rupt', param1 est le nombre de points d'intervalle ; si mode ==
%'pts', param1 est le nombre de ruptures. param2 est la raison de la suite
%g�om�trique des
%�carts-types.
%La proc�dure fait alors varier le nombre de ruptures (si mode == 'rupt')
%ou de points (si mode == 'pts') de 1 � n en lan�ant des
%online_efficiency_test. En sortie, on obtient le triplet (N, P, sumdiff)
%o� N(k) est le nombre de double-ruptures au k-i�me test, P(k) est le
%nombre de bonnes ruptures au k-i�me test, sumdiff(k) est le RMSD du k-i�me
%test.

    m = zeros(1, n);
    sumdiff = zeros(1, n);
    N = zeros(1, n);
    P = zeros(1, n);
    if (strcmp(mode,'rupt'))
        for k = 1:n
            [m(1,k), N(1,k), P(1,k), sumdiff(1,k)] = online_efficiency_test(k, param1, param2, thresh, false);
        end
    else if (strcmp(mode,'pts'))
            for k = 1:n
                [m(1,k), N(1,k), P(1,k), sumdiff(1,k)] = online_efficiency_test(param1, k, param2, thresh, false);
            end
        end
    end
    
    figure;
    plot(N);
    title('N');
    figure;
    plot(sumdiff);
    title('sumdiff');
end