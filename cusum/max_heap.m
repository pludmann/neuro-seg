function [times,values]=max_heap(t,v,n)

N=length(t);
times=zeros(1,n);
values=zeros(1,n);
indice=zeros(1,N);

values(1)=v(1);
times(1)=t(1);
indice(2:3)=1;

for step=2:n
    
    frontval=v;
    frontval(indice==0)=0;
    [m,i]=max(frontval);
    values(step)=m;
    times(step)=t(i);
    indice(i)=0;
    indice(2*i:2*i+1)=1;
    
end

end