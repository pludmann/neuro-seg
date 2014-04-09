function [times,values]=dikt_cusum(y,par,nstep)

% According to a signal 'y', compute his gaussian_likelihood_ratio with
% the parameter 'par'. Then start again twice on both side of the reached
% max point. Doing this 'nstep' times.

times=[1,size(y,1)];
values=[0,0];

for i=1:nstep
    
   for j=1:length(times)-1
       
       if times(j+1)-times(j)>2
           
           [g,t]=max(gauss_mle(y(times(j):times(j+1),:),par));
           values=[values,g];
           times=[times,times(j)+t-1];
           
       end
       
   end
   
   [times, ix]=sort(times);
   values=values(ix);

end

times=times(2:length(times)-1);
values=values(2:length(values)-1);

end