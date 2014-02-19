function greatplot(m,varargin)
p=inputParser;
addParameter(p,'L',[]);
parse(p,varargin{:});
L=p.Results.L;

p=length(m(1,:));

figure
l=ceil(p/3);
for j=2:p
   subplot(l,3,j-1);
   plot(m(:,1),m(:,j))
end
if length(L)>0
    for j=2:p
       subplot(l,3,j-1);
       title(L(j+1));
    end
end