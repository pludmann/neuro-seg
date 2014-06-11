function L=gauss_mle_lin(y,par,varargin)

%   Give it an univariate signal (as a column double vector), a parameter (as a
% string among 'mean', 'std', 'both').
%
%   Optionnal parameter (varargin) :
%
% If 'mean' was given then to follow
% 	'sigma',sigmavalue
% where 'sigma' is actually the string 'sigma' and sigmavalue is the (assumed or
% not) standard deviation (as a double value).
%
% If 'std' was given then to follow
% 	'mu',muvalue
% where 'mu' is actually the string 'mu' and muvalue is the (assumed or not)
% mean (as a double value).

p = inputParser ;
addRequired(p, 'y') ;
addRequired(p, 'par', @(par) ismember(par,{'mean','std','both'})) ;
addParameter(p, 'mu', mean(y), @isnumeric) ;
addParameter(p, 'sigma', std(y), @isnumeric) ;

parse(p, y, par, varargin{:});

if size(y,2)>1
    
    L=zeros(size(y));
    for j=1:size(y,2)
        L(:,j)=gauss_mle_lin(y(:,j),par,varargin{:});
    end
    
else
    
    N = length(y) ;
    L = zeros(size(y)) ;
    mutilde = p.Results.mu ;
    sigmatilde = p.Results.sigma ;
    mu_0 = 0 ;
    mu_1 = mutilde ;
    var_0 = 0 ;
    var_1 = sigmatilde^2 ;
    mom2_0 = 0 ;
    mom2_1 = mean(y.^2) ;
    
    for k = 2:N
        
        if strcmp(par,'mean')
            
            mu_0 = ((k-2)*mu_0 + y(k-1)) / (k-1) ;
            mu_1 = ((N-k+2)*mu_1 - y(k-1)) / (N-k+1) ;
            
            L(k) = ( (k-1)*mu_0^2 ...
                + (N-k+1)*mu_1^2 ...
                - N*mutilde^2  )...
                / (2*sigmatilde^2) ;
            
        elseif strcmp(par,'std')
            
            var_0 = ((k-2)*var_0 + (y(k-1) - mutilde)^2)/(k-1) ;
            var_1 = ((N-k+2)*var_1 - (y(k-1) - mutilde)^2)/(N-k+1) ;
            
            if var_0==0 && k==2       % Taking one point as a line is pointless
                
                L(k) = N*log(sigmatilde)...
                    + .5 + .5*log(2*pi)...
                    - .5*(N-k+1)*log(var_1) ;
                
            elseif var_1==0 && k==N   % Taking one point as a line is pointless
                
                L(k) = N*log(sigmatilde)...
                    - .5*(k-1)*log(var_0)...
                    + .5 + .5*log(2*pi) ;
                
            else
                
                L(k) = N*log(sigmatilde)...
                    - .5*(k-1)*log(var_0)...
                    - .5*(N-k+1)*log(var_1) ;
                
            end
            
        else
            
            mom2_0 = ((k-2)*(mom2_0) + y(k-1)^2)/(k-1) ;
            mom2_1 = ((N-k+2)*(mom2_1) - y(k-1)^2)/(N-k+1) ;
            mu_0 = ((k-2)*mu_0 + y(k-1)) / (k-1) ;
            mu_1 = ((N-k+2)*mu_1 - y(k-1)) / (N-k+1) ;
            var_0 = mom2_0 - mu_0^2 ;
            var_1 = mom2_1 - mu_1^2 ;
            
            if k==2     % Cause sigma_0 cancels and spoils the result
                
                L(k) = N*log(sigmatilde)...
                    + .5 + .5*log(2*pi)...
                    - .5*(N-k+1)*log(var_1) ;
                
            elseif k==N % Cause sigma_1 cancels and spoils the result
                
                L(k) = N*log(sigmatilde)...
                    - .5*(k-1)*log(var_0)...
                    + .5 + .5*log(2*pi) ;
                
            else
                
                L(k)= N*log(sigmatilde)...
                    - .5*(k-1)*log(var_0)...
                    - .5*(N-k+1)*log(var_1) ;
                
            end
            
        end
        
    end
    
end

end