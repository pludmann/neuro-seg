function L=gauss_mle_lin(y,par,varargin)
%
%   Giving a matrix y such as the N lines y_i are observations of p
% independent variables (at time i).
%
%   This function returns the sequence of maximum log-likelihoood ratio
% estimated, a row vector L such as
%
%   \[L_k=\ln\left[\frac
%         {\sup_{\theta_0}\left\{\prod_{i=1}^{k-1}p_{\theta_0}(y_i)\right\}
%        \cdot\sup_{\theta_1}\left\{\prod_{i=k}^Np_{\theta_1}(y_i)\right\}}
%           {\sup_{\tilde\theta}p_{\tilde\theta}(y_i)}\right]\]
%
% where N is the number of observations and p_\theta the gaussian density
% function parametered by \theta.
%   And theta_0, theta_1 the gaussian distribution parameters resp. before
% and after the rupture at time k. That is to say the mean, the standard
% deviation or both from 1 to k-1 and from k to N.
%
%   If the second argument is mean or std, the missing parameters are
% computed on the whole signal but it is better -- you must -- to input
% them.
%
%   Note if the mean is the parameter, the formula is simplified into
%
%   \[L_k=\frac 1{2\sigma^2}\left[(k-1)\mu_0^2+(N-k+1)\mu_1^2
%           -N\tilde\mu^2\right]\]
%
%   Otherwise
%
%   \[L_k=N\ln(\tilde\sigma)-(k-1)\ln(\sigma_0)-(N-k+1)\ln(\sigma_1)\]

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