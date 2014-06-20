function [sumdiff, N, P] = recursive_efficiency_test(mode, param1, param2, n1, n2)
    sumdiff = zeros(1, n2-n1+1);
    N = zeros(1, n2-n1+1);
    P = zeros(1, n2-n1+1);
    if (strcmp(mode,'rupt'))
        for k = n1:n2
            [sumdiff(1,k), N(1,k), P(1,k)] = offline_efficiency_test(k, param1, param2, false);
        end
    else if (strcmp(mode,'pts'))
            for k = n1:n2
                [sumdiff(1,k), N(1,k), P(1,k)] = offline_efficiency_test(param1, k, param2, false);
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