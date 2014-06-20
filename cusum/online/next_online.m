function time=next_online(y,par,thresh,varargin)

N=size(y,1);

p=inputParser;
addRequired(p,'y');
addRequired(p,'par',@iscellstr);
addRequired(p,'thresh');
addParameter(p,'mu',mean(y,1),@isnumeric);
addParameter(p,'sigma',std(y,1),@isnumeric);
addParameter(p, 'coef', ones(N, 1), @isnumeric) ;

parse(p,y,par,thresh,varargin{:});
sigma=p.Results.sigma;
mu=p.Results.mu;
coef=p.Results.coef;

score=0;
n=1;

while (score<thresh && n<N)
    
    [score,time]=max(mle_multi(y(1:n,:),par,'mu',mu,'sigma',sigma,'coef',coef)) ;
    
    n=n+10;
    
end

if n==N
   
    time=0;
    
end

end