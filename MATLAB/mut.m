function m=mut(s,t,varargin)
% mut mutate the input multi-signal according to the type t :
%   'std' for standard deviation
%   'amp' for peak-to-peak amplitude
%   'pap' for 5-perctile-to-95-perctile amplitude
%   'moy' for mean
%   'var' for variance
%   'skw' for skewness
%   'kur' for kurtosis
% This mutation is done on a moving window of length 'w' (100 by default)   
% with an overlap 'o' (0.75 by default)
p=inputParser;
addRequired(p,'s');
addParameter(p,'w',100,@isnumeric);
addParameter(p,'o',.75,@isnumeric);
addParameter(p,'L',[]);
addRequired(p,'t',@(x) any(validatestring(x,...
    {'std','amp','moy','pap','var','skw','cor','kur'})));

parse(p,s,t,varargin{:});
w=p.Results.w;
o=p.Results.o;
L=p.Results.L;

offset=floor(w*(1-o));
n=floor((length(s(:,1))-w)/offset);	% Number of std to do
p=length(s(1,:))-1;	% Because s can be/is a multi-signal
			%(-1 for the 'sample' column)
m=zeros(n,p);	% Outcome to be

for i=1:n
    m(i,1)=mean(s(1+(i-1)*offset:1+(i-1)*offset+w,1));
end
for j=2:p
    for i=1:n
        if t=='moy'
            m(i,j)=mean(s(1+(i-1)*offset:1+(i-1)*offset+w,j+1));
        elseif t=='amp'
            m(i,j)=peak2peak(s(1+(i-1)*offset:1+(i-1)*offset+w,j+1));
        elseif t=='std'
            m(i,j)=std(s(1+(i-1)*offset:1+(i-1)*offset+w,j+1));
        elseif t=='pap'
            m(i,j)=prctile(s(1+(i-1)*offset:1+(i-1)*offset+w,j+1),95)...
                -prctile(s(1+(i-1)*offset:1+(i-1)*offset+w,j+1),5);
        elseif t=='var'
             m(i,j)=var(s(1+(i-1)*offset:1+(i-1)*offset+w,j+1));
        elseif t=='skw'
            m(i,j)=skewness(s(1+(i-1)*offset:1+(i-1)*offset+w,j+1));
        elseif t=='kur'
            m(i,j)=kurtosis(s(1+(i-1)*offset:1+(i-1)*offset+w,j+1));
        elseif t=='cor'
            m(i,j)=corr(s(1+(i-1)*offset:1+(i-1)*offset+w,j+1));
        end
    end
end