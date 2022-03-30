function [M,p] = pionprendpiece(S,couleur)
% effet sur une classe de structures de pions d'une prise d'une piece par
% une pion
% 1 les blancs prennent, 0 les noirs prennent
% S la classe d'entrée
% M la liste des classes possibles en sortie
% p le nombre de clases dans la liste

M=int8(zeros(6,8,0));

if couleur==0  % cas où un pion noir prend une pièce blanche
    [in,jn]=find(S==-1);    % on cherche tous les pions noirs
    compteur=1;             % compte le nombre de structures pouvant résulter de la prise
    for k=1:length(in)      % pour chaque pion noir
        if jn(k)==1             %si le pion qui prend se trouve dans la colonne a
            ncolvois=nnz(S(:,2)); %ncolvois = nombre de pions dans la colonne b
            if ncolvois~=6         % si ce nombre vaut 6 on ne peut pas y prendre une pièce (promotions non autorisées)
                for i=1:ncolvois+1  % cette prise peut amener à insérer le pion à ncolvois+1 endroits distincts dans la colonne b
                    M(:,:,compteur)=S;  % on recopie l'ancienne structure
                    M(i+1:6,2,compteur)=M(i:5,2,compteur); % on décale les pions du i eme au 5e ; quand i = ncolvois+1 on ne décale rien et ceci fonctionne même quand ncolvois=5 (rien ne se passe)
                    M(i,2,compteur)=-1;                   % on met un -1 dans le trou
                    M(in(k):5,1,compteur)=M(in(k)+1:6,1,compteur);  % on décale la colonne de départ du pion
                    M(6,1,compteur)=0;   % la fin de la colonne de départ ne comporte pas de pion
                    compteur=compteur+1;   % on passe à la structure issue de la prise suivante
                end
            end
            
        elseif jn(k)==8  % même chose lorsque le pion preneur est sur la colonne h
            ncolvois=nnz(S(:,7));
            if ncolvois~=6
                for i=1:ncolvois+1
                    M(:,:,compteur)=S;
                    M(i+1:6,7,compteur)=M(i:5,7,compteur);
                    M(i,7,compteur)=-1;
                    M(in(k):5,8,compteur)=M(in(k)+1:6,8,compteur);
                    M(6,8,compteur)=0;
                    compteur=compteur+1;
                end
            end
            
        else   % si le pion preneur n'est ni sur la colonne a ni sur la colonne h
            ncolvois=nnz(S(:,jn(k)-1));   % on prend la colonne à "gauche" de ce pion et on fait pareil
            if ncolvois~=6
                for i=1:ncolvois+1
                    M(:,:,compteur)=S;
                    M(i+1:6,jn(k)-1,compteur)=M(i:5,jn(k)-1,compteur);
                    M(i,jn(k)-1,compteur)=-1;
                    M(in(k):5,jn(k),compteur)=M(in(k)+1:6,jn(k),compteur);
                    M(6,jn(k),compteur)=0;
                    compteur=compteur+1;
                end
            end
            ncolvois=nnz(S(:,jn(k)+1));    % on prend la colonne à "droite" de ce pion et on fait pareil
            if ncolvois~=6
                for i=1:ncolvois+1
                    M(:,:,compteur)=S;
                    M(i+1:6,jn(k)+1,compteur)=M(i:5,jn(k)+1,compteur);
                    M(i,jn(k)+1,compteur)=-1;
                    M(in(k):5,jn(k),compteur)=M(in(k)+1:6,jn(k),compteur);
                    M(6,jn(k),compteur)=0;
                    compteur=compteur+1;
                end
            end
            
        end
    end
    
elseif couleur==1  % si le pion qui prend est blanc
    S=-S;    % on transforme les pions blancs en pions noirs et inversement dans la structure de départ
    [M,nbpospion] = pionprendpiece(S,0);   % on fait appel à la prise par un pion noir (qui en fait est blanc mais représenté par -1)
    M=-M;   % on transforme de nouveau les pions blancs en pions noirs et inversement
end

% on enlève les doublons
[n,m,p]=size(M);
a=reshape(M,n,[],1);
b=reshape(a(:),n*m,[])';
c=unique(b,'rows','stable')';
M=reshape(c,n,m,[]);
[n,m,p]=size(M);


