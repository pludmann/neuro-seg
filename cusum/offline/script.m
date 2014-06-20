sumdiff = zeros(1, 150);
N = zeros(1, 150);

for k = 1:150
    [sumdiff(1,k), N(1,k)] = efficiency_test(6, k, 2, false);
end

figure;
plot(N);
title('N');
figure;
plot(sumdiff);
title('sumdiff');