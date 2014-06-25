function [res, val, Lwork] = split_mid(L, alpha, n)

res = zeros(1, n) ;
val = zeros(1, n) ;
Lwork = L ;

for i = 1 : n

	[v, t] = max(Lwork) ;
	if v == -Inf
		exit
	end
	res(i) = t ;
	val(i) = v ;
	
	Lwork(t-alpha+1 : t+alpha-1) = -Inf ;
    k = t - alpha ;
    while L(k) < L(k+1)
        Lwork(k) = -Inf ;
        k = k - 1 ;
    end
    k = t + alpha ;
    while L(k) < L(k-1)
        Lwork(k) = -Inf ;
        k = k + 1 ;
    end
    
end

end