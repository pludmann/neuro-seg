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

N=size(y,1);

times=zeros(2^(nstep)-1,1);
values=-Inf*ones(2^(nstep)-1,1);

if strcmp(par,'mean')
    
    [g,t]=max(gauss_mle_lin(y(1:N,:),par,'sigma',sigma));
    values(1)=g;
    times(1)=t;
    
    for n=2:nstep
        
        fstrw=2^(n-1);
        
        for k=0:(fstrw-1)

            if k==0 && times(fstrw/2)>3
                [g,t]=max(gauss_mle_lin(y(1:times(fstrw/2) -1,:),par,'sigma',sigma));
                values(fstrw+k)=g;
                times(fstrw+k)=t;
            elseif k==fstrw-1 && N-2>times(fstrw-1) && times(fstrw-1)>1
                [g,t]=max(gauss_mle_lin(y(times(fstrw-1):N,:),par,'sigma',sigma));
                values(fstrw+k)=g;
                times(fstrw+k)=times(fstrw-1) +t -1;
            elseif n>2 && mod(k,2)==0 && times(fstrw/2+k/2)-times(fstrw/4+floor(k/4))>2 && times(fstrw/4+floor(k/4))>0
                [g,t]=max(gauss_mle_lin(y(times(fstrw/4+floor(k/4)):times(fstrw/2+k/2) -1,:),par,'sigma',sigma));
                values(fstrw+k)=g;
                times(fstrw+k)=times(fstrw/2+floor(k/4)) +t -1;
            elseif n>2 && mod(k,2)==1 && -times(fstrw/2+floor(k/2))+times(fstrw/4+floor(k/4))>2 && times(fstrw/2+floor(k/2))>0
                [g,t]=max(gauss_mle_lin(y(times(fstrw/2+floor(k/2)):times(fstrw/4+floor(k/4)) -1,:),par,'sigma',sigma));
                values(fstrw+k)=g;
                times(fstrw+k)=times(fstrw+floor(k/2)) +t -1;
            end
            
        end
        
    end    
    
elseif strcmp(par,'std')
    
    [g,t]=max(gauss_mle_lin(y(1:N,:),par,'mu',mu));
    values(1)=g;
    times(1)=t;
    
    for n=2:nstep
        
        fstrw=2^(n-1);
        
        for k=0:(fstrw-1)

            if k==0 && times(fstrw/2)>3
                [g,t]=max(gauss_mle_lin(y(1:times(fstrw/2) -1,:),par,'mu',mu));
                values(fstrw+k)=g;
                times(fstrw+k)=t;
            elseif k==fstrw-1 && N-2>times(fstrw-1) && times(fstrw-1)>1
                [g,t]=max(gauss_mle_lin(y(times(fstrw-1):N,:),par,'mu',mu));
                values(fstrw+k)=g;
                times(fstrw+k)=times(fstrw-1) +t -1;
            elseif n>2 && mod(k,2)==0 && times(fstrw/2+k/2)-times(fstrw/4+floor(k/4))>2 && times(fstrw/4+floor(k/4))>0
                [g,t]=max(gauss_mle_lin(y(times(fstrw/4+floor(k/4)):times(fstrw/2+k/2) -1,:),par,'mu',mu));
                values(fstrw+k)=g;
                times(fstrw+k)=times(fstrw/2+floor(k/4)) +t -1;
            elseif n>2 && mod(k,2)==1 && -times(fstrw/2+floor(k/2))+times(fstrw/4+floor(k/4))>2 && times(fstrw/2+floor(k/2))>0
                [g,t]=max(gauss_mle_lin(y(times(fstrw/2+floor(k/2)):times(fstrw/4+floor(k/4)) -1,:),par,'mu',mu));
                values(fstrw+k)=g;
                times(fstrw+k)=times(fstrw+floor(k/2)) +t -1;
            end
            
        end
        
    end
    
elseif strcmp(par,'both')
    
    [g,t]=max(gauss_mle_lin(y(1:N,:),par));
    values(1)=g;
    times(1)=t;
    
    for n=2:nstep
        
        fstrw=2^(n-1);
        
        for k=0:(fstrw-1)

            if k==0 && times(fstrw/2)>3
                [g,t]=max(gauss_mle_lin(y(1:times(fstrw/2) -1,:),par));
                values(fstrw+k)=g;
                times(fstrw+k)=t;
            elseif k==fstrw-1 && N-2>times(fstrw-1) && times(fstrw-1)>1
                [g,t]=max(gauss_mle_lin(y(times(fstrw-1):N,:),par));
                values(fstrw+k)=g;
                times(fstrw+k)=times(fstrw-1) +t -1;
            elseif n>2 && mod(k,2)==0 && times(fstrw/2+k/2)-times(fstrw/4+floor(k/4))>2 && times(fstrw/4+floor(k/4))>0
                [g,t]=max(gauss_mle_lin(y(times(fstrw/4+floor(k/4)):times(fstrw/2+k/2) -1,:),par));
                values(fstrw+k)=g;
                times(fstrw+k)=times(fstrw/2+floor(k/4)) +t -1;
            elseif n>2 && mod(k,2)==1 && -times(fstrw/2+floor(k/2))+times(fstrw/4+floor(k/4))>2 && times(fstrw/2+floor(k/2))>0
                [g,t]=max(gauss_mle_lin(y(times(fstrw/2+floor(k/2)):times(fstrw/4+floor(k/4)) -1,:),par));
                values(fstrw+k)=g;
                times(fstrw+k)=times(fstrw+floor(k/2)) +t -1;
            end
            
        end
        
    end
    
end

end