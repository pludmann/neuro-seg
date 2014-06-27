function L = cusum_det(Y)

%L = cusum_det(Y) -- À partir d'un signal Y, on obtient les trois termes de
%la formule de CUSUM dans le cas 'both'. Ceci dans le but de visualiser de
%manière correcte l'évolution de chacun des termes.
%
%- L(:,1) est le terme constant N*log(std(Y))
%- L(:,2) est le terme prenant en compte les k-1 premiers points du signal
%- L(:,3) est le terme prenant en compte les N-k+1 derniers points du
%signal
%- L(:,4) est la somme de ces trois termes
    m = mean(Y);
    N = size(Y, 2);
    L = zeros((N-3), 4);
    for k = 3:(N-1)
           L((k-2), 1:3) = [N*log(std(Y)), -(k-1)*log(), -(N-k+1)*log(std(Y(1,k:N)))];
    end
    L(:,4) = L(:,1)+L(:,2)+L(:,3);
end