% En entrée : X1, X2 
% on part de n correspondances de deux points en coord. homogènes
% les points connus sont stockés séparément dans deux matrices
function H = Dlt_s(X1,X2)
% A va contenir le système à résoudre
%n = 4;
k=0;
A=zeros(8,9);
for i=1:2:7 %on incrémente 2 par 2 
    k = k+1;
    A(i,:)   = [zeros(1,3),  -X2(3,k)*X1(:,k)' , X2(2,k)*X1(:,k)'];
    A(i+1,:) = [X2(3,k)*X1(:,k)', zeros(1,3), -X2(1,k)*X1(:,k)']  
    %on complète A 2 lignes par 2 lignes, 2lignes = 1 correspondance
end    
[U,S,V] = svd(A);
h=V(:,9); %h != 0 solution de Ah = 0 ; est dans le noyau de A
H=reshape(h,3,3)' %on redimensionne h afin d'obtenir l'homographie
end