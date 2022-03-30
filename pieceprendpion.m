function [M,p] = pieceprendpion(S,couleur)
% effet sur une classe de structures de pions d'une prise d'un pion par  une piece
% 1 les blancs prennent, 0 les noirs prennent
% S la classe d'entrée
% M la liste des classes possibles en sortie
% p le nombre de clases dans la liste

M=int8(zeros(6,8,0));   % la classe comprend des 1 pour les pions blancs et -1 pour les pions noirs

if couleur==0   % cas où une pièce noire prend un pion blanc
    [i,j]=find(S==1);   % calcul les indices de lignes et de colonnes de tous les pions blancs
    for k=1:length(i)   % pour chaque pion blanc on calcule la classe qui résulte de sa prise
        M(:,:,k)=S;     % on copie l'ancienne structure
        M(i(k):5,j(k),k)=M(i(k)+1:6,j(k),k);    % on enlève le pion pris et on décale le contenu du bas de la colonne au-delà de ce pion 
        M(6,j(k),k)=0;   % on complète la fin de la colonne avec un 0 (car il y a au maximum 5 pions dans la colonne après la prise)
    end
elseif couleur==1   % cas où une pièce blanche prend un pion noir
    [i,j]=find(S==-1);
    for k=1:length(i)
        M(:,:,k)=S;
        M(i(k):5,j(k),k)=M(i(k)+1:6,j(k),k);
        M(6,j(k),k)=0;
    end
end

% on enlève les doublons
[n,m,p]=size(M);
a=reshape(M,n,[],1);
b=reshape(a(:),n*m,[])';
c=unique(b,'rows','stable')';
M=reshape(c,n,m,[]);
[n,m,p]=size(M);


