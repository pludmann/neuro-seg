clear all

%Génération de la liste des fichiers non-traités
cd('C:\Users\Clément\Documents\Cours\ENS\Première année\Second semestre\Stage\data_pd');
listing = dir;
n = length(listing);

cd('C:\Users\Clément\Documents\Cours\ENS\Première année\Second semestre\Stage\data_matlab'); %Utile pour plus tard !

for k = 1:(n-2)
    A = importdata(listing(k+2).name);
    L = A.colheaders;
    M = A.data;
    
    save(strrep(listing(k+2).name,'.txt','.mat'));
end