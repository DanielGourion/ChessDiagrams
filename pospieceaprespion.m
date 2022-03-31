function nbpos = pospieceaprespion(nB,nN,nc)
% calcule le nombre de positions possibles pour les pièces en fonction
% - du nombre de pièces blanches nB
% - du nombre de pièces noires nN
% - du nombre de cases libres nc

load repartitionpieces
% ce fichier contient les 54 = 2 x 3 x 3 x 3 possibilités pour le nombre de
% dame/tour/fou/cavalier sur l'échiquier pour chaque couleur. 
% PB contient les pièces blanches :
% 54 lignes : répartition possible des pièces, 5 colonnes : nombre de
% pièces de chaque type (dame/tour/fou/cavalier), nombre total de pièces sauf roi en 5e colonne
% idem pour PN avec les pièces noires

indB = PB(:,5) == nB-1; % indB indices des lignes correspondant aux répartitions avec nB pieces blanches (nB-1 à cause du roi)
AB = PB(indB,:);        %AB contenu de ces lignes
indN = PN(:,5) == nN-1; %idem pour les pièces noires
AN = PN(indN,:);

nbpos=0;    %compteur du nombre de positions possibles pour les pièces
tailleB=size(AB);   
tailleN=size(AN);
nbcasB=tailleB(1);      % nombre de répartitions possibles entre les différents types de pièces pour nB pièces blanches au total
nbcasN=tailleN(1);

for i=1:nbcasB
    for j=1:nbcasN    % pour toutes les répartitions blanches et noires possibles de types de pièces
        calc=1;
        % on commence par les fous à cause de la paire de fous
        if AB(i,3)==2 && AN(j,3)==2 % les blancs et les noirs ont la paire de fous
            if mod(nc,2)==0 %calcul des positions possibles des fous si le nombre de cases libres après placement des pions est pair
                calc=calc*(nc/2)^2*(nc/2-1)^2;  % nombre de façons de placer les 4 fous
            else  %calcul des positions possibles des fous si le nombre de cases libres après placement des pions est impair
                calc=calc*(nc+1)*(nc-1)^2*(nc-3)/16; % nombre de façons de placer les 4 fous
            end
        elseif AB(i,3)==2 % les blancs ont la paire de fous mais pas les noirs
             if mod(nc,2)==0    % on place les fous blancs comme ci-dessus
                calc=calc*(nc/2)^2;
            else
                calc=calc*(nc+1)*(nc-1)/4;
             end
            calc=calc*nchoosek(nc-2,AN(j,3));   % on place le fou noir (s'il existe)
        elseif AN(j,3)==2 % les noirs ont la paire de fous mais pas les blancs
            if mod(nc,2)==0 % on place les fous noirs comme ci-dessus
                calc=calc*(nc/2)^2;
            else
                calc=calc*(nc+1)*(nc-1)/4;
             end
            calc=calc*nchoosek(nc-2,AB(i,3)); % on place le fou blanc (s'il existe)
        else  % aucun camp n'a pas la paire de fous
            calc=calc*nchoosek(nc,AB(i,3))*nchoosek(nc-AB(i,3),AN(j,3));   % on place le fou blanc et le fou noir (s'ils existent)
        end
        ncl=nc-AB(i,3)-AN(j,3);   % ncl : nombre de cases libres après placement (des pions et) des fous
        duosblancs=nnz(AB(i,[2 4])==2);  % on compte le nombre de duos de cavaliers et de tours chez les blancs
        duosnoirs=nnz(AN(j,[2 4])==2);  % idem chez les noirs
        calc=calc*factorial(ncl)/(factorial(ncl-(2+AB(i,1)+AB(i,2)+AB(i,4)+AN(j,1)+AN(j,2)+AN(j,4)))*2^(duosblancs+duosnoirs)); % on prend en compte le nombre de façons de placer roi/dame/tour/cavalier des deux camps
        nbpos=nbpos+calc;   % on ajoute calc qui contient le nombre de positions possibles de la répartition de pièces en cours de traitement
    end
end

        
          