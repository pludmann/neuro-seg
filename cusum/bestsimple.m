function bestcoef=bestsimple(annot)

bestscore=Inf;
bestcoefs=zeros(1,12);

for i=1:2^12-1

	b=str2num(dec2bin(i,12));
	coefs=zeros(1,12);
	for k=1:12

		coefs(k)=mod(b,10);
		b=floor(b/10);

	end
	
	coefs

	score=mean(simplescore(annot,coefs));

	if score<bestscore
		
		bestscore=score;
		bestcoefs=coefs

	end

end

end