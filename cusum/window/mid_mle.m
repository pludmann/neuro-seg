function val = mid_mle(y, par, varargin)

[N, P] = size(y) ;
k = floor(N/2) + 1 ;

p = inputParser ;
addRequired(p, 'y') ;
addRequired(p, 'par', @iscellstr) ;
addParameter(p, 'mu', ( (k-1)*mean(y(1:k-1)) + (N-k+1)*mean(y(k:N)) )/N,...
    @isnumeric) ;
addParameter(p, 'sigma', std(y), @isnumeric) ;
addParameter(p, 'coef', ones(1, P), @isnumeric) ;

parse(p, y, par, varargin{:}) ;
mu = p.Results.mu ;
sigma = p.Results.sigma ;
coef = p.Results.coef ;


if P > 1
    Val = zeros(1, P) ;
    for j = 1 : P
        Val(:, j) = coef(j)*mid_mle(y(:, j), par(j), 'mu', mu(j), 'sigma', sigma(j)) ;
    end
    
    val = sum(Val) ;
    
else
    
    if strcmp(par, 'mean')
        
        val = ( (k-1)*mean(y(1:k-1))^2 ...
            + (N-k+1)*mean(y(k:N))^2 ...
            - N*mean(y)^2  )...
            / (2*sigma^2) ;
        
    elseif strcmp(par, 'std')
        
        val = .5*N*log( mean( (y - mu).^2 ) )...
            - .5*(k-1)*log( mean( (y(1:k-1) - mu).^2 ) )...
            - .5*(N-k+1)*log( mean( (y(k:N) - mu).^2 ) ) ;
        
    elseif strcmp(par, 'both')
        
        val = N*log(std(y))...
            - (k-1)*log(std(y(1:k-1)))...
            - (N-k+1)*log(std(y(k:N))) ;
        
    end
    
end

end