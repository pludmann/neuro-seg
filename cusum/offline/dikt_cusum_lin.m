function [times,values]=dikt_cusum_lin(y,par,rupt,varargin)

% According to a signal 'y', compute his gaussian_likelihood_ratio with
% the parameter 'par'. Then start again twice on both side of the reached
% max point. Doing this 'nstep' times.

N=size(y,1);

p=inputParser;
addRequired(p,'y');
addRequired(p,'par',@iscellstr);
addRequired(p,'rupt');
addParameter(p,'mu',mean(y,1),@isnumeric);
addParameter(p,'sigma',std(y,1),@isnumeric);
addParameter(p, 'coef', ones(N, 1), @isnumeric) ;

parse(p,y,par,rupt,varargin{:});

times = zeros(1, 2*rupt-1) ;
values = zeros(1, 2*rupt-1) ;

lowbd = ones(1, 2*rupt-1) ;
upbd = N*ones(1, 2*rupt-1) ;

picked = zeros(1, 2*rupt-1) ;
pickable = zeros(1, 2*rupt-1) ;

pickable(1)=1;
[values(1),times(1)] = max(mle_multi(y, par, varargin{:})) ;

for n=1:rupt
    
    valval = values ;
    valval(pickable==0) = 0 ;
    [v,i] = max(valval) ;
    pickable(i) = 0 ;
    picked(i) = 1 ;
    
    if n~=rupt
        
        [v,lsi] = min(times) ; % It gives the first index available (next is too)
        lowbd(lsi) = lowbd(i) ;
        upbd(lsi) = times(i)-1 ;
        [values(lsi),times(lsi)] = max(mle_multi(y(lowbd(lsi):upbd(lsi), :), par, varargin{:})) ;
        times(lsi) = times(lsi) + lowbd(lsi) - 1 ;
        pickable(lsi) = 1 ;
        
        rsi = lsi+1 ;
        lowbd(rsi) = times(i) ;
        upbd(rsi) = upbd(i) ;
        [values(rsi),times(rsi)] = max(mle_multi(y(lowbd(rsi):upbd(rsi), :), par, varargin{:})) ;
        times(rsi) = times(rsi) + lowbd(rsi) - 1 ;
        pickable(rsi) = 1 ;
        
    end
    
end

times = times(picked==1) ;
values = values(picked==1) ;



end