function [times,values]=dikt_cusum(y,par,nstep,varargin)

% According to a signal 'y', compute his gaussian_likelihood_ratio with
% the parameter 'par'. Then start again twice on both side of the reached
% max point. Doing this 'nstep' times.

p=inputParser;
addRequired(p,'y');
addRequired(p,'par',@(par) ismember(par,{'mean','std','both'}));
addRequired(p,'nstep');
addParameter(p,'mu',mean(y,1),@isnumeric);
addParameter(p,'sigma',std(y,1),@isnumeric);

parse(p,y,par,nstep,varargin{:});
mu=p.Results.mu;
sigma=p.Results.sigma;

times=[1,size(y,1)+1];
values=[0,0];

if strcmp(par,'mean')
        
    for i=1:nstep
        
        for j=1:length(times)-1
            
            if times(j+1)-times(j)>2
                
                [g,t]=max(gauss_mle(y(times(j):times(j+1)-1,:),par,'sigma',sigma));
                values=[values,g];
                times=[times,times(j)+t-1];
                
            end
            
        end
        
        [times, ix]=sort(times);
        values=values(ix);
        
    end
    
elseif strcmp(par,'std')
    
    for i=1:nstep
        
        for j=1:length(times)-1
            
            if times(j+1)-times(j)>2
                
                [g,t]=max(gauss_mle(y(times(j):times(j+1)-1,:),par,'mu',mu));
                values=[values,g];
                times=[times,times(j)+t-1];
                
            end
            
        end
        
        [times, ix]=sort(times);
        values=values(ix);
        
    end

else
    
    
    for i=1:nstep
        
        for j=1:length(times)-1
            
            if times(j+1)-times(j)>2
                
                [g,t]=max(gauss_mle(y(times(j):times(j+1)-1,:),par));
                values=[values,g];
                times=[times,times(j)+t-1];
                
            end
            
        end
        
        [times, ix]=sort(times);
        values=values(ix);
        
    end

end

times=times(2:length(times)-1);
values=values(2:length(values)-1);

end