function threshold(m,varargin)
p=inputParser;
addRequired(p,'m');
addParameter(p,'h',.7);
addParameter(p,'L',[]);

parse(p,m,varargin{:});
h=p.Results.h;
L=p.Results.L;

p=length(m(1,:));
n=length(m(:,1))-1;
d=zeros(n,p);
t=zeros(n,p);

t(:,1)=(m(1:n,1)+m(2:n+1,1))/2;
d(:,1)=(m(1:n,1)+m(2:n+1,1))/2;
for j=2:p
	d(:,j)=abs(diff(m(:,j)));
    %d(:,j)=abs(m(1:n)./m(2:n+1));
    pmax=prctile(d(:,j),95);
	for i=1:n
		if (d(i,j)>h*pmax)% | 1/d(i,j)>pmax*h)
			t(i,j)=1;
		end
	end
end


figure
l=ceil(p/3);
for j=2:p
   subplot(l,3,j-1);
   pmax=prctile(d(:,j),95);
   plot(m(:,1),m(:,j),t(:,1),pmax*t(:,j))
end
if length(L)>0
    for j=2:p
       subplot(l,3,j-1);
       title(L(j+1));
    end
end

figure
plot(t(:,1),sum(t(:,2:p),2))

end