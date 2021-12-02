% En entrée : X1, X2
% on part de n correspondances de deux points en coord. homogènes
% on stock séparément dans deux matrices les points connus
function H = Dlt_3d(X1,X2)
% A va contenir le système à résoudre
k=0;
A=zeros(11,12);
for i=1:2:8 %on incrémente 2 par 2 
    k = k+1;
    A(i,:)   = [zeros(1,4),  -X2(3,k)*X1(:,k)' , X2(2,k)*X1(:,k)'];
    A(i+1,:) = [X2(3,k)*X1(:,k)', zeros(1,4), -X2(1,k)*X1(:,k)']  
    %on complète A 2 lignes par 2 lignes, 2lignes = 2 correspondances
    %on a seulement besoin d'une des coordonnées du 6eme point
    A(11,:) =  [zeros(1,4),  -X2(3,6)*X1(:,6)' , X2(2,6)*X1(:,6)']
end    
[U,S,V] = svd(A);
h=V(:,12); %h != 0 ; est dans le noyau de A
H=reshape(h,4,3)' %on redimensionne h afin d'obtenir l'homographie





end