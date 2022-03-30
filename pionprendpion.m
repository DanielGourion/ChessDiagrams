function [M,p] = pionprendpion(S,couleur)
% effet sur une classe de structures de pions d'une prise d'un pion par
% une pion
% 1 les blancs prennent, 0 les noirs prennent
% S la classe d'entrée
% M la liste des classes possibles en sortie
% p le nombre de clases dans la liste

M=int8(zeros(6,8,0));

if couleur==0    % cas où un pion noir prend une pion blanc
    [in,jn]=find(S==-1);    %indices des pions noirs
    [ib,jb]=find(S==1);     %indices des pions blancs
    compteur=1;     % compte le nombre de structures pouvant résulter de la prise

    for k=1:length(in)       % pour chaque pion noir
        if jn(k)==1         %pion preneur noir colonne a
            indcolcap=find (jb==2);     %on cherche les pions blancs colonne b
            for i=1:length(indcolcap)   %pour chacun de ces pions blancs
                M(:,:,compteur)=S;      % on recopie l'ancienne structure 
                M(ib(indcolcap(i)),2,compteur)=-1;   %on remplace le pion blanc par un pion noir
                M(in(k):5,1,compteur)=M(in(k)+1:6,1,compteur);    % on décale le contenu du bas de la colonne d'origine du pion noir au-delà de la position initiale pion  
                M(6,1,compteur)=0;    % on complète la fin de la colonne avec un 0 (car il y a au maximum 5 pions dans la colonne après la prise)
                compteur=compteur+1;    % on passe à la structure issue de la prise suivante
            end
            
        elseif jn(k)==8     %pion preneur noir colonne h
            indcolcap=find (jb==7);
            for i=1:length(indcolcap)
                M(:,:,compteur)=S;
                M(ib(indcolcap(i)),7,compteur)=-1;                
                M(in(k):5,8,compteur)=M(in(k)+1:6,8,compteur);
                M(6,8,compteur)=0;
                compteur=compteur+1;
            end
            
        else    % si le pion preneur n'est ni sur la colonne a ni sur la colonne h
            indcolcap=find (jb==(jn(k)-1));     % on prend la colonne à "gauche" de ce pion et on fait pareil
            for i=1:length(indcolcap)
                M(:,:,compteur)=S;
                M(ib(indcolcap(i)),jn(k)-1,compteur)=-1;                
                M(in(k):5,jn(k),compteur)=M(in(k)+1:6,jn(k),compteur);
                M(6,jn(k),compteur)=0;
                compteur=compteur+1;
            end
            indcolcap=find (jb==(jn(k)+1));     % on prend la colonne à "droite" de ce pion et on fait pareil
            for i=1:length(indcolcap)
                M(:,:,compteur)=S;
                M(ib(indcolcap(i)),jn(k)+1,compteur)=-1;               
                M(in(k):5,jn(k),compteur)=M(in(k)+1:6,jn(k),compteur);
                M(6,jn(k),compteur)=0;
                compteur=compteur+1;
            end           
        end
    end
    
elseif couleur==1       %même chose si le pion preneur est un pion blanc
    [in,jn]=find(S==-1);
    [ib,jb]=find(S==1);
    compteur=1;
    for k=1:length(ib)
        if jb(k)==1
            indcolcap=find (jn==2);
            for i=1:length(indcolcap)
                M(:,:,compteur)=S;
                M(in(indcolcap(i)),2,compteur)=1;              
                M(ib(k):5,1,compteur)=M(ib(k)+1:6,1,compteur);
                M(6,1,compteur)=0;
                compteur=compteur+1;
            end
            
        elseif jb(k)==8
            indcolcap=find (jn==7);
            for i=1:length(indcolcap)
                M(:,:,compteur)=S;
                M(in(indcolcap(i)),7,compteur)=1;              
                M(ib(k):5,8,compteur)=M(ib(k)+1:6,8,compteur);
                M(6,8,compteur)=0;
                compteur=compteur+1;
            end
            
        else
            indcolcap=find (jn==(jb(k)-1));
            for i=1:length(indcolcap)
                M(:,:,compteur)=S;
                M(in(indcolcap(i)),jb(k)-1,compteur)=1;                
                M(ib(k):5,jb(k),compteur)=M(ib(k)+1:6,jb(k),compteur);
                M(6,jb(k),compteur)=0;
                compteur=compteur+1;
            end
            indcolcap=find (jn==(jb(k)+1));
            for i=1:length(indcolcap)
                M(:,:,compteur)=S;
                M(in(indcolcap(i)),jb(k)+1,compteur)=1;                
                M(ib(k):5,jb(k),compteur)=M(ib(k)+1:6,jb(k),compteur);
                M(6,jb(k),compteur)=0;
                compteur=compteur+1;
            end
        end
    end
end

% on enlève les doublons
[n,m,p]=size(M);
a=reshape(M,n,[],1);
b=reshape(a(:),n*m,[])';
c=unique(b,'rows','stable')';
M=reshape(c,n,m,[]);
[n,m,p]=size(M);



