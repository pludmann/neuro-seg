function time=find_online(y,par,thresh,varargin)

N=size(y,1);

p=inputParser;
addRequired(p,'y');
addRequired(p,'par',@iscellstr);
addRequired(p,'thresh');
addParameter(p,'mu',mean(y,1),@isnumeric);
addParameter(p,'sigma',std(y,1),@isnumeric);
addParameter(p, 'coef', ones(N, 1), @isnumeric) ;

parse(p,y,par,thresh,varargin{:});

score=0;
n=1;

while (score<thresh && n<N)
    
    [score,time]=max(mle_multi(y(1:n,:),par,varargin{:})) ;
    
    n=n+1;
    
end

if n==N
   
    time=0;
    
end

end