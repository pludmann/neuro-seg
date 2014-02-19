function [features,T] = compute_features(acc_AP,acc_ML,acc_V,N_sample,N_hop)

[N1]=length(acc_AP);

%  acc_AP=medfilt1(acc_AP); 
%  acc_ML=medfilt1(acc_ML); 
%  acc_V=medfilt1(acc_V);


Fs=100;
N_overlap=N_sample-N_hop;

N_col = fix((N1-N_overlap)/(N_sample-N_overlap));

T=(N_sample/2+[0:N_col-1]*N_hop)/Fs;



colindex = 1 + (0:(N_col-1))*(N_sample-N_overlap);
rowindex = (1:N_sample)';
globalindex=rowindex(:,ones(1,N_col))+colindex(ones(N_sample,1),:)-1;



a_ML = zeros(N_sample,N_col);
a_V = zeros(N_sample,N_col);
a_AP = zeros(N_sample,N_col);


a_ML(:)= acc_ML(globalindex);
a_V(:)= acc_V(globalindex);
a_AP(:)= acc_AP(globalindex);






N_features=12;

features=zeros(N_features,N_col);


features(1,:)=min(a_ML+a_V);
features(2,:)=std(a_AP+a_V);


features(3,:)=mean(a_AP);
features(4,:)=mean(a_V);
features(5,:)=median(a_V);
features(6,:)=std(a_ML);
features(7,:)=quantile(a_ML,0.95);

s=sign(a_ML-mean(acc_ML));
t=filter([1 1],1,s);
features(8,:)=sum(t==0);

s=sign(a_V-mean(acc_V));
t=filter([1 1],1,s);
features(9,:)=sum(t==0);


for i=1:N_col
    features(10,i)=max(abs(xcorr(a_ML(:,i),a_V(:,i),'coeff')));
    features(11,i)=max(abs(xcorr(a_ML(:,i),a_AP(:,i),'coeff')));
    features(12,i)=max(abs(xcorr(a_V(:,i),a_AP(:,i),'coeff')));
end


% 
% 
% Y = abs(fft(a_ML));
% Y_max= max(Y);
% Y_mean=(sum(Y)-Y_max)/N_sample;
% features(13,:)=Y_max./Y_mean;
% 
% Y = abs(fft(a_V));
% Y_max= max(Y);
% Y_mean=(sum(Y)-Y_max)/N_sample;
% features(14,:)=Y_max./Y_mean;

