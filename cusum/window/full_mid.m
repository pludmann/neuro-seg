function  L = full_mid(y, par, alpha, varargin)

[N,P]=size(y);

p = inputParser ;
addRequired(p, 'y') ;
addRequired(p, 'par', @iscellstr) ;
addParameter(p, 'mu', mean(y),...
    @isnumeric) ;
addParameter(p, 'sigma', std(y), @isnumeric) ;
addParameter(p, 'coef', ones(1, P), @isnumeric) ;

parse(p, y, par, varargin{:}) ;
mu = p.Results.mu ;
sigma = p.Results.sigma ;
coef = p.Results.coef ;

L = -Inf*ones(N, 1) ;

for k = alpha + 1 : N - alpha
    
    L(k) = mid_mle(y(k-alpha:k+alpha-1,:), par, 'mu', mu, 'sigma', sigma,...
        'coef', coef) ;
    
end

end