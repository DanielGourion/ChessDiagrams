function [Mr,nbpospion] = structurepub(A,B,C,D)

% on calcule les classes structures de pions d'un quadruplet à n-1 éléments à partir de celles
% des quadruplets à n éléments. Il y a besoin de 4 structures de pions "pères" au maximum pour
% calculer Mr=M_n-1_abcd :
% A=M_n_(a+1)bcd
% B=M_n_a(b+1)cd
% C=M_n_ab(c+1)d
% D=M_n_abc(d+1)
% les arguments A, B, C et/ou D peuvent être vides : []

% les classes sont des tableaux à 3 dimensions :
% - 6 lignes pour les rangées 2 à 7 de l'échiquier,
% - 8 colonnes pour les colonnes a à h,
% - k classes de la liste de classes de structures de pions

% les sorties sont 
% - la liste des classes de structures de pions de Mr 
% - le nombre de positions possibles pour tous les diagrammes de ces
% classes nbpospion

save matentree A B C D  % pour les éventuels problèmes de mémoire
clear B C D
tps=cputime;
fin=0;  %compteur du nombre de structure

%%%% calcule les structures de pion héritées de A, qui contient les
%%%% structures contenant une pièce blanche de plus que les structures de
%%%% Mr
[nA,mA,pA]=size(A);
if nA==6 && mA==8  % cette condition permet de ne pas entrer dans la boucle si A = []
    Mr(:,:,fin+1:fin+pA)=(A(:,:,1:pA)); % piece noire prend piece blanche
    fin=fin+pA;
    for i=1:pA
        deb=fin+1;
        [M,p] = pionprendpiece(A(:,:,i),0);  %pion noir prend piece blanche
        fin=fin+p;
        Mr(:,:,deb:fin)=(M(:,:,1:p));
        
        %%%%%%%%%% on supprime les classes listées plusieurs fois
        %%%%%%%%%% ceci est parfois fait à l'intérieur de la boucle pour des raisons de
        %%%%%%%%%% mémoire
        %     a=reshape(Mr,n,[],1);
        %     b=reshape(a(:),n*m,[])';            %optionnel : utile si problèmes de mémoire
        %     c=unique(b,'rows','stable')';
        %     Mr=reshape(c,n,m,[]);
        %     [n,m,p]=size(Mr);
        %     fin=p;
    end
    
    clear A  % on libère A de la mémoire
    
    %%%%%%%%%% on supprime les classes listées plusieurs fois
    %%%%%%%%%% ceci est parfois fait à l'intérieur de la boucle pour des raisons de
    %%%%%%%%%% mémoire
    [n,m,p]=size(Mr);
    a=reshape(Mr,n,[],1);
    b=reshape(a(:),n*m,[])';
    c=unique(b,'rows','stable')';
    Mr=reshape(c,n,m,[]);
    [n,m,p]=size(Mr);
    fin=p
end

%%%% calcule les structures de pion héritées de B, qui contient les
%%%% structures contenant une pièce noire de plus que les structures de
%%%% Mr

load matentree B
[nB,mB,pB]=size(B);
if nB==6 && mB==8
    for i=1:pB
        deb=fin+1;
        [M,p] = pionprendpiece(B(:,:,i),1);  %pion blanc prend piece noire
        fin=fin+p;
        Mr(:,:,deb:fin)=(M(:,:,1:p));
    end
    Mr(:,:,fin+1:fin+pB)=(B(:,:,1:pB)); % piece blanche prend piece noire
    fin=fin+pB;
    
    clear B
    [n,m,p]=size(Mr);
    a=reshape(Mr,n,[],1);
    b=reshape(a(:),n*m,[])';
    c=unique(b,'rows','stable')';
    Mr=reshape(c,n,m,[]);
    [n,m,p]=size(Mr);
    fin=p
end

%%%% calcule les structures de pion héritées de C, qui contient les
%%%% structures contenant un pion blanc de plus que les structures de
%%%% Mr
load matentree C
[nC,mC,pC]=size(C);
if nC==6 && mC==8
    for i=1:pC
        deb=fin+1;
        [M,p] = pionprendpion(C(:,:,i),0);  %pion noir prend pion blanc
        fin=fin+p;
        Mr(:,:,deb:fin)=(M(:,:,1:p));
    end
    
    for i=1:pC
        deb=fin+1;
        [M,p] = pieceprendpion(C(:,:,i),0);  %piece noire prend pion blanc
        fin=fin+p;
        Mr(:,:,deb:fin)=(M(:,:,1:p));
    end
    clear C
    [n,m,p]=size(Mr);
    a=reshape(Mr,n,[],1);
    b=reshape(a(:),n*m,[])';
    c=unique(b,'rows','stable')';
    Mr=reshape(c,n,m,[]);
    [n,m,p]=size(Mr);
   fin=p
end

%%%% calcule les structures de pion héritées de D, qui contient les
%%%% structures contenant un pion noir de plus que les structures de
%%%% Mr

load matentree D

[nD,mD,pD]=size(D);
if nD==6 && mD==8
    for i=1:pD
        deb=fin+1;
        [M,p] = pionprendpion(D(:,:,i),1);  %pion blanc prend pion noir
        fin=fin+p;
        Mr(:,:,deb:fin)=(M(:,:,1:p));
    end
    
    for i=1:pD
        deb=fin+1;
        [M,p] = pieceprendpion(D(:,:,i),1);  %piece blanche prend pion noir
        fin=fin+p;
        Mr(:,:,deb:fin)=(M(:,:,1:p));
    end
    
    clear D
    [n,m,p]=size(Mr);
    a=reshape(Mr,n,[],1);
    b=reshape(a(:),n*m,[])';
    c=unique(b,'rows','stable')';
    Mr=reshape(c,n,m,[]);
    [n,m,p]=size(Mr);
    fin=p
end


nbpospion=0; 
% on va calculer le nombre de positions possibles pour les pions pour
% toutes les classes de structure de pions de Mr

for k=1:p
    valeur=1;
    for j=1:8
        valeur=valeur*nchoosek(6,nnz(Mr(:,j,k)));
    end
    nbpospion=nbpospion+valeur;
end
tps=cputime-tps
end

