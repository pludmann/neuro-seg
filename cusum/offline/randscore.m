function [diktlinscore, midscore] = randscore(iternb, spacemean, minspace)

y = [] ;
space = zeros(1, iternb) ;

for i = 1 : iternb
    
    space(i) = floor(2*(spacemean-minspace)*rand) + minspace ;
    
    y = [y; rand*randn(space(i), 1) + rand] ;
    
end

space = space(1 : iternb-1) ;
rupt = cumsum(space) ;

diktlinrupt = sort(dikt_cusum_lin(y, {'both'}, iternb-1)) ;
diktlinscore = sqrt(sum((diktlinrupt - rupt).^2)) ;

midrupt = sort(split_mid(full_mid(y, {'both'}, minspace), minspace, iternb-1)) ;
midscore = sqrt(sum(( midrupt - rupt).^2)) ;

end