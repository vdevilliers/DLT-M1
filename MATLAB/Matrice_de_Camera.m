clear all;
close all;
%détermination d'une matrice de caméra associée à 6 correspondances de
%points monde réel 3D <-> image 2D

% I : déterminer U,T pour la normalisation


% test façade :
X_pic =   1.0e+03 *[1.8500  ,  1.2950, 1,
    1.8290 ,   0.8120, 1,
    2.0390  ,  0.8330, 1,
    2.0600  ,  1.2920, 1,
    1.8403    1.0507, 1,
        2.0523    1.0478 1,]';
    


X_world = [ 0 10 120 1, 
    0 50 240 1, 
    60 0 240 1, 
    60 0 120 1, 
    0 30 180 1, 
    60 0 180 1]';



% i) on normalise les points de l'image (R^2)
%centroid : moyenne des coordonnées 
O_1 = mean(X_pic(1:2,:))';
% translation de O1 (centre de gravité) vers (0,0)
N = zeros(3,6);
for i=1:length(X_pic)
        N(1,i) = X_pic(1,i)-O_1(1);
        N(2,i) = X_pic(2,i)-O_1(2);
        N(3,i) = 1
end
Origin_1 = [0 0]';
% on détermine la distance des points à l'origine après translation
d_init_pic = norm(N(1,1));
% donc le scalaire associé à l'homotétie
% qui ramène les points à une distance de sqrt(2) de l'origine, est :
L_pic =  sqrt(2)/d_init_pic ;
% la composition de la translation et de l'homotétie nous donne l'application recherchée
T_pic =  [ L_pic 0 -L_pic*O_1(1) ;
        0 L_pic -L_pic*O_1(2);
        0 0 1];
%donc les données normalisées associées à l'image sont
Xpic_n = T_pic*X_pic;

% ii) on normalise les points de l'espace (R^3)
%centroid
O_2 = mean(X_world(1:3,:))';
M = zeros(4,6);
for i=1:length(X_world)
        M(1,i) = X_world(1,i)-O_2(1);
        M(2,i) = X_world(2,i)-O_2(2);
        M(3,i) = X_world(3,i)-O_2(3);
        M(4,i) = 1

end
Origin_2 = [0 0 0]';
% on détermine la distance des points à l'origine après translation
d_init_world = norm(M(1,1));
% donc le scalaire associé à l'homotétie
% qui ramène les points à une distance de sqrt(3) de l'origine, est :
L_world =  sqrt(3)/d_init_world ;
% la composition de la translation et de l'homotétie nous donne l'application recherchée
T_world =  [ L_world 0 0 -L_world*O_2(1) ;
        0 L_world 0 -L_world*O_2(2);
        0 0 L_world -L_world*O_2(3);
        0 0 0 1];
%donc les données normalisées associées à l'image sont
Xworld_n = T_world*X_world;


% II : DLT appliqué à la matrice 2n*12

P_linear_estimate = DLT_2_3d(Xworld_n,Xpic_n);
P_double = double(P_linear_estimate);

% III on minimise l'erreur géométrique, méthode choisie : Levemberg-marquardt
f_arg = @(x,xdata) x*xdata;
% LSQCURVEFIT
options = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt');
%le point de départ de l'estimation est le résultat obtenu via DLT
P_estimate = lsqcurvefit(f_arg, P_double, Xworld_n , Xpic_n);
%on repasse en coordonnées initiales
Camera_matrix = inv(T_pic)*P_estimate*T_world;
disp(Camera_matrix);