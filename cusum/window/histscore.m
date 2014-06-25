function data = histscore(iternb, spacemean, minspace, datanb)

data = zeros(2, datanb) ;

for i = 1 : datanb
    
    [data(1, i), data(2, i)] = randscore(iternb, spacemean, minspace) ;
    
    % indic
    
    if mod(i,10)==0
        i
    end
    
end

figure ;
hist(data(1, :), ceil(datanb/10)) ;
title('Hist of diktlinscore') ;

figure ;
hist(data(2, :), ceil(datanb/10)) ;
title('Hist of midscore') ;

figure ;
plot(data') ;
hold on
plot(data(1, :) - data(2, :), 'linewidth', 2, 'color', 'r') ;
hold off

end