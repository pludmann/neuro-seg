clear all

%G�n�ration de la liste des fichiers non-trait�s
cd('/home/grossemassue/Documents/1A0.5/S2/Stage CMLA/data');
listing = dir;
n = length(listing);


%Boucle principale - extrait le tableau des donn�es et l'enregistre
for k = 1:(n-2)
    cd('/home/grossemassue/Documents/1A0.5/S2/Stage CMLA/data');
    A = importdata(listing(k+2).name);
    
    %Rep�rage du d�but des donn�es num�riques
    p = length(A);
    i = 1;
    verif = true;
    while(i <= p & verif)
        B = cell2mat(regexp(A(i),'\[time\]'));
        if (length(B) > 0)
            verif = false;
        else
            i = i+1;
        end
    end
    
    %Extraction du header int�ressant sous forme de tableau
    B = cell2mat(regexp(A(i),'\t'));
    q = length(B); %Utile : nombre de colonnes - 1
    L = cell(1,q+1);
    L{1} = A{i}(1:B(1)-1);
    L{q+1} = A{i}(B(q)+1:(length(A{i})));
    for j = 1:(q-1)
        L{j+1} = A{i}((B(j)+1):(B(j+1)-1));
    end
    
    %Extraction des donn�es num�riques
    A = strrep(A,',','.'); %Mise en forme plus rep�rable par Matlab
    M = zeros(p-i,q+1);
    for j = 1:(p-i)
        M(j,:) = (cell2mat(textscan(A{j+i},'%f')))';
    end
    cd('/home/grossemassue/Documents/1A0.5/S2/Stage CMLA/data_matlab'); %Utile pour plus tard !

    %Sauvegarde dans un fichier .mat
    save(strrep(listing(k+2).name,'.txt','.mat'),'L','M');
end
    