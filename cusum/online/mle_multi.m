function L=mle_multi(y,par,varargin)

[N, P] = size(y) ;

p = inputParser ;
addRequired(p, 'y') ;
addRequired(p, 'par', @iscellstr) ;
addParameter(p, 'mu', mean(y, 1), @isnumeric) ;
addParameter(p, 'sigma', std(y, 1), @isnumeric) ;
addParameter(p, 'coef', ones(1, P), @isnumeric) ;

parse(p, y, par, varargin{:});

mutilde = p.Results.mu ;
sigmatilde = p.Results.sigma ;
coef = p.Results.coef ;

ym = y(:, strcmp(par, 'mean')) ;
sigmatilde = sigmatilde(strcmp(par, 'mean')) ;
coefm = coef(strcmp(par, 'mean')) ;
ys = y(:, strcmp(par, 'std')) ;
mutilde = mutilde(strcmp(par, 'std')) ;
coefs = coef(strcmp(par, 'std')) ;
yb = y(:, strcmp(par, 'both')) ;
coefb = coef(strcmp(par, 'both')) ;

L = zeros(N, 1) ;

for j=1:size(ym, 2)
    
    L = L + coefm(j)*gauss_mle_lin(ym(:, j), 'mean', 'sigma', sigmatilde(j)) ;
    
end

for j=1:size(ys, 2)
    
    L = L + coefs(j)*gauss_mle_lin(ys(:, j), 'std', 'mu', mutilde(j)) ;
    
end

for j=1:size(yb, 2)
    
    L = L + coefb(j)*gauss_mle_lin(yb(:, j), 'both') ;
    
end

end