function L=gauss_mle(y,par)
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
% computed on the whole signal.
%
%   Note if the mean is the parameter, the formula is simplified into
%
%   \[L_k=\frac 1{2\sigma^2}\left[(k-1)\mu_0^2+(N-k+1)\mu_1^2
%           -N\tilde\mu^2\right]\]
%
%   Otherwise
%
%   \[L_k=N\ln(\tilde\sigma)-(k-1)\ln(\sigma_0)-(N-k+1)\ln(\sigma_1)\]

if not(ismember(par,{'mean','std','both'}))
    error('The second argument needs to be the string : mean, std or both');
end


[N,p]=size(y);

L=zeros(1,N);

mutilde=mean(y,1);

sigmatilde=std(y,1);


for k=2:N
    
    if strcmp(par,'mean')
        mu_0=mean(y(1:k-1,:),1);
        mu_1=mean(y(k:N,:),1);
        L(k)=sum( ((k-1)*mu_0.^2 + (N-k+1)*mu_1.^2 - N*mutilde.^2) ./ (2*sigmatilde.^2) );
    elseif strcmp(par,'std')
        sigma_0=sqrt(mean((y(1:k-1,:)-repmat(mutilde,k-1,1)).^2,1));
        sigma_1=sqrt(mean((y(k:N,:)-repmat(mutilde,N-k+1,1)).^2,1));
        L(k)=sum( N*log(sigmatilde) - (k-1)*log(sigma_0) - (N-k+1)*log(sigma_1) );
    else
        sigma_0=std(y(1:k-1,:),1);
        sigma_1=std(y(k:N,:),1);
        L(k)=sum( N*log(sigmatilde) - (k-1)*log(sigma_0) - (N-k+1)*log(sigma_1) );
    end
    
end

end