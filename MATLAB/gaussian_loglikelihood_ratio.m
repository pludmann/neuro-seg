function S=gaussian_loglikelihood_ratio(y,par)
%
%   Giving a matrix y such as the k lines y_i are observations of p
% independent variables (at time i).
% 
%   This function returns the log-likelihoood ratio, a row vector S such as
%
%   [\ S_j=\sum_{i=j}^k \ln\frac{p_\theta_1(y_i)}{p_\theta_0(y_i)} \]
%
% where k is the number of observations and p_\theta the gaussian density
% function parametered by \theta.
%   And theta_0, theta_1 the gaussian distribution parameters resp. before 
% and after the rupture at time j. That is to say the mean, the standard
% deviation or both from 1 to j-1 and from j to k.
%
%   If the second argument is mean or std, the missing parameters is
% computed on the whole signal.

if not(ismember(par,{'mean','std','both'}))
    error('The second argument needs to be the string : mean, std or both');
elseif strcmp(par,'mean')
    start=2; % Cause 1 to 0 is a non-sens
else
    start=3; % Cause no std on 1 point signal
end

[k,p]=size(y);

S=zeros(1,k);

mu_0=mean(y,1);
mu_1=mean(y,1);
sigma_0=std(y,1);
sigma_1=std(y,1);

for j=start:k
    if strcmp(par,'both')
        sigma_0=std(y(1:j-1,:),1);
        mu_0=mean(y(1:j-1,:),1);
        sigma_1=std(y(j:k,:),1);
        mu_1=mean(y(j:k,:),1);
    elseif strcmp(par,'mean')
        mu_0=mean(y(1:j-1,:),1);
        mu_1=mean(y(j:k,:),1);
    elseif strcmp(par,'std')
        sigma_0=std(y(1:j-1,:),1);
        sigma_1=std(y(j:k,:),1);
    end
    % This is an already simplified expression
    S(j)=(k-j+1)*sum(log(sigma_0 ./ sigma_1)) ...
        -.5*sum(sum( ...
        ( (y(j:k,:) - repmat(mu_1,k-j+1,1)) ./ repmat(sigma_1,k-j+1,1) ).^2 ...
        - ( (y(j:k,:) - repmat(mu_0,k-j+1,1)) ./ repmat(sigma_0,k-j+1,1) ).^2 ...
        , 2),1);

end