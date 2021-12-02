%constraints / corresponding equations

%déterminer K sous les contraintes : 
% - 2 vanishing points orthogonaux
% - point principal connu  p = (x0,y0) 
% - square pixels
function K = K_principalpoint(u,v,p) 
% - u,v vanishing points corresponding to orthogonal lines
% 1 contrainte associée 
%  - known principal point p
% 2 contraintes associées
% square pixels + zero skew ; 2 contraintes
M = zeros(5,6);
M(1,:) = [ v(1)*u(1), v(1)*u(2) + v(2)*u(1) , v(2)*u(2) , v(1)*u(3)+v(3)*u(1) , v(2)*u(3)+v(3)*u(2), v(3)*u(3) ];
M(2,:) =  [ p(1), p(2) , 0 , 1 ,0 ,0];
M(3,:)  =  [0, p(1), p(2), 0 ,1 ,0 ];
M(4,:) = [0 , 1 ,0 ,0, 0 ,0]; 
M(5,:)  = [ 1, 0, -1, 0, 0 ,0];

[U,S,V] = svd(M);
w=V(:,6); %o != 0 ; est dans le noyau de M
omega= [ w(1) w(2) w(4) ; w(2) w(3) w(5) ; w(4) w(5) w(6) ];
disp(omega);
K_inv = chol(omega);
K = inv(K_inv);

end