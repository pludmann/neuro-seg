function score=simplescore(annot,coefs)

g=9.80665;
par={'std','std','std','both','both','both','std','std','std','both','both','both'};
mu=[0 0 g -1 -1 -1 0 0 g -1 -1 -1];
n=size(annot,1);

score=zeros(n,1);

for i=1:n

	exptimes=cell2mat(annot(i,2));
	k=length(exptimes);
	times=sort(cusum_seg_raw(annot(i,1),par,k,'mu',mu,'coef',coefs,'plt','n'));
	score(i)=sum((exptimes-times).^2)/k;

end

mean(score)

end