function [times,values]=dikt_cusum(y,par,nstep,fs,weigth)

% % According to a signal 'y', compute his gaussian_likelihood_ratio with
% the parameter 'par'. There's a % weight ('none', '0-1', 'gauss') so that
% the boudaries are put down. Mixed them % up and take the max. Then start
% again twice on both side of the reached % max point. Doing this 'nstep'
% times.

times=[1,size(y,1)];
values=[0,0];

for i=1:nstep
    
   for j=1:length(times)-1
       
       if strcmp(weigth,'0-1')
           
           if times(j+1)-times(j)>2*fs+1
               
               S=gaussian_loglikelihood_ratio(y(times(j):times(j+1),:),par);
               [g,t]=max(S(fs:length(S)-fs));
               t=t+fs;
               
           end
           
       elseif strcmp(weigth,'gauss')
           
           if times(j+1)-times(j)>2
               
               S=gaussian_loglikelihood_ratio(y(times(j):times(j+1),:),par);
               T=times(j):times(j+1);
               [g,t]=max(S.*normpdf(T,mean(T),std(T)));
               
           end
       
       elseif strcmp(weight,'none')
           
           if times(j+1)-times(j)>2
              
               [g,t]=gaussian_loglikelihood_ratio(y(times(j):times(j+1),:),par);
               
           end
           
       end
       
       values=[values,g];
       times=[times,times(j)+t-1];
       
   end
   
   [times, ix]=sort(times);
   values=values(ix);

end

times=times(2:length(times)-1);
values=values(2:length(values)-1);

% start=1;
% 
% times=0;
% values=[];
% nb=0;
% if strcmp(par,'mean')
%     k=2;
% else
%     k=3;
% end
% 
% while k<size(y,1)+1
%     [g,t_0]=max(gaussian_loglikelihood_ratio(y(start:k,:),par));
%     if g>h
%         times=[times, times(nb+1)+t_0];
%         values=[values, g];
%         nb=nb+1;
%         start=times(nb+1)
%         if strcmp(par,'mean')
%             k=start+1;
%         else
%             k=start+2;
%         end
%     else
%         k=k+1;
%     end
% end
% 
% times=times(2:nb+1);

end