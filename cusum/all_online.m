function times=all_online(y,par,thresh,varargin)

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

times=[];
lastime=1;
while 1
    newtime=find_online(y(lastime:N,:),par,thresh,'mu',mu,'sigma',sigma,'coef',coef);
    if newtime==0
        return
    end
    lastime=newtime+lastime;
    times=[times,lastime];
end