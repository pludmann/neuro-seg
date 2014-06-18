function [sumdiff, N, P] = recursive_efficiency_test(mode, param1, param2, n)
    sumdiff = zeros(1, 1000);
    N = zeros(1, 1000);
    P = zeros(1, 1000);
    if (mode == 'rupt')
        for k = 1:n
            [sumdiff(1,k), N(1,k), P(1,k)] = efficiency_test(k, param1, param2, false);
        end
    else if (mode == 'pts')
            for k = 1:n
                [sumdiff(1,k), N(1,k), P(1,k)] = efficiency_test(param1, k, param2, false);
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