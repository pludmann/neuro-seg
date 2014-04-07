function S=MLEt0hat(y,par)
%
%   Giving a matrix y such as the N lines y_i are observations of p
% independent variables (at time i).
% 
%   This function returns the log-likelihoood ratio, a row vector S such as
%
%   [\ \sum_{i=1}^{k-1}\ln(p_{\theta_0}(y_i))
%    + \sum_{i=k}^N\ln(p_{\theta_1}(y_i))
%    - \sum_{i=1}^N\ln(p_{\tilde\theta_0}(y_i)) \]
%
% where N is the number of observations and p_\theta the gaussian density
% function parametered by \theta.
%   And theta_0, theta_1 the gaussian distribution parameters resp. before 
% and after the rupture at time k. That is to say the mean, the standard
% deviation or both from 1 to k-1 and from k to N.
%
%   If the second argument is mean or std, the missing parameters are
% computed on the whole signal.

if not(ismember(par,{'mean','std','both'}))
    error('The second argument needs to be the string : mean, std or both');
end

[N,p]=size(y);

S=zeros(1,N);

mutilde=mean(y,1);
sigmatilde=std(y,1);
normcst=sum( sum( log( normpdf(y, repmat(mutilde,N,1) , repmat(sigmatilde,N,1) ) ) ) );

mu_0=mutilde;
mu_1=mutilde;
sigma_0=sigmatilde;
sigma_1=sigmatilde;

for k=1:N
    
    if k==1         % Handle prod from 1 to 0
        
        if strcmp(par,'both')
            sigma_1=std(y(k:N,:),1);
            mu_1=mean(y(k:N,:),1);
        elseif strcmp(par,'mean')
            mu_1=mean(y(k:N,:),1);
        elseif strcmp(par,'std')
            sigma_1=std(y(k:N,:),1);
        end
        
        S(k) = sum( sum( log( normpdf( y(k:N,:) , repmat(mu_1,N-k+1,1) , repmat(sigma_1,N-k+1,1) ) ) ) );
        
    elseif k==2     % Handle odd on 1 point : set to 1
        
        if strcmp(par,'both')
            sigma_1=std(y(k:N,:),1);
            mu_1=mean(y(k:N,:),1);
        elseif strcmp(par,'mean')
            mu_1=mean(y(k:N,:),1);
        elseif strcmp(par,'std')
            sigma_1=std(y(k:N,:),1);
        end
        
        S(k) = sum( sum( log( normpdf( y(k:N,:) , repmat(mu_1,N-k+1,1) , repmat(sigma_1,N-k+1,1) ) ) ) );
        
    elseif k==N     % Handle odd on 1 point : set to 1
        
        if strcmp(par,'both')
            sigma_0=std(y(1:k-1,:),1);
            mu_0=mean(y(1:k-1,:),1);
        elseif strcmp(par,'mean')
            mu_0=mean(y(1:k-1,:),1);
        elseif strcmp(par,'std')
            sigma_0=std(y(1:k-1,:),1);
        end
        
        S(k)= sum( sum( log( normpdf( y(1:(k-1),:) , repmat(mu_0,k-1,1) , repmat(sigma_0,k-1,1) ) ) ) );
        
    else
        
        if strcmp(par,'both')
            sigma_0=std(y(1:k-1,:),1);
            mu_0=mean(y(1:k-1,:),1);
            sigma_1=std(y(k:N,:),1);
            mu_1=mean(y(k:N,:),1);
        elseif strcmp(par,'mean')
            mu_0=mean(y(1:k-1,:),1);
            mu_1=mean(y(k:N,:),1);
        elseif strcmp(par,'std')
            sigma_0=std(y(1:k-1,:),1);
            sigma_1=std(y(k:N,:),1);
        end
        
        S(k)= sum( sum( log( normpdf( y(1:(k-1),:) , repmat(mu_0,k-1,1) , repmat(sigma_0,k-1,1) ) ) ) )...
            + sum( sum( log( normpdf( y(k:N,:) , repmat(mu_1,N-k+1,1) , repmat(sigma_1,N-k+1,1) ) ) ) );

    end
    
end

S=S-normcst;

end