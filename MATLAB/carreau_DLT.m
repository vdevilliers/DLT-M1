clear all
close all
%on load l'image 
img = imread('Carreau.jpg');
img = rgb2gray(img); %passage au gris

[lignes colonnes] = size(img); % on récupère la "taille" du plan
%axes respectifs
x = (1:colonnes)'; 
y = (1:lignes)';

%on affiche l'image pour choisir manuellement les points
imshow(img);

% coordonnées récupérées au préalable avec ginput()
a =   [ 457.0117,  853.6330,
  146.6737 , 571.7801,
  451.0149 , 352.8944,
  756.8552  ,549.2919];
Points_depart =   a';

%coordonnées fixées manuellement
 b =  [ 340 ,  740,
  340 , 440,
    640  ,440,
    640,  740];
Points_arrivee = b'  ;

X1 = zeros(3,4);%les colonnes de X1 sont les coordonnées homogènes des points
X1 = [Points_depart ; ones(1,4)];

X2 = zeros(3,4);%les colonnes de X2 sont les coordonnées homogènes des points
X2 = [Points_arrivee ; ones(1,4)];


% 1ère étape de normalisation : normalisation par rapport à la 1ère image 

O1 = zeros(2,1);
O1(1) = ( X1(1,1)+X1(1,4))/2 ;
O1(2) = (X1(1,2) + X1(2,2))/2 ;
% translation de O1 (centre de gravité) vers (0,0);
N = zeros(2,4);
for i=1:length(X1)
        N(1,i) = X1(1,i)-O1(1);
        N(2,i) = X1(2,i)-O1(2);
        N(3,i) = 1
end
Origin = [0 0]';
% on détermine la distance des points à l'origine après translation
d_init = norm(N(1:2,1:2) - Origin);
% donc le scalaire associé à l'homotétie
% qui ramène les points à une distance de sqrt(2) de l'origine, est :
L_1 =  sqrt(2)/d_init ;
% la composition de la translation et de l'homotétie nous donne l'application recherchée
T_1 =  [ L_1 0 -L_1*O1(1) ;
        0 L_1 -L_1*O1(2);
        0 0 1];
%donc les données normalisées associées à la première image sont
X1_n = T_1*X1;
    
% 2ère étape de normalisation : normalisation par rapport à la 1ère image 
% on réitère pour les points dans l'image d'arrivée
% translation de O2 (centre de gravité) vers (0,0)
O2 = zeros(2,1);
O2(1) = ( X2(1,1)+X2(1,4))/2 ;
O2(2) = (X2(1,2) + X2(2,2))/2 ;
N = zeros(2,4);
for i=1:length(X2)
        N(1,i) = X2(1,i)-O2(1);
        N(2,i) = X2(2,i)-O2(2);
        N(3,i) = 1
end
% on détermine la distance des points à l'origine après translation
d_init2 = norm(N(1:2,1:2) - Origin);
% donc le scalaire associé à l'homotétie
% qui ramène les points à une distance de sqrt(2) de l'origine, est :
L_2 =  sqrt(2)/d_init2 ;
% la composition de la translation et de l'homotétie nous donne l'application recherchée
T_2 =  [ L_2  0 -L_2 *O2(1) ;
        0 L_2  -L_2 *O2(2);
        0 0 1];
T_2_inv = inv(T_2);
%les données normalisées associées à la deuxième image sont
X2_n = T_2*X2;

%3ème étape : DLT pour obtenir l'homographie liées aux données normalisées
H_n = Dlt_s(X1_n, X2_n); 
%4ème et dernière étape : "denormalization" ; l'homographie finale est
H = T_2_inv*H_n*T_1;

%on en revient à l'imagerie
imagesc(x,y,img); %on indique le "coin" de l'image grâce à x et y
colormap gray; %on se ramène au colormap gris prédéfini dans matlab

%les axes sont x et y, proportionnés
axis square;
axis xy;

% on récupère une grille de coordonnés 2D 
[XI, YI] = meshgrid(x,y); %les lignes sont des copies de x, les col _ de y

XI_size = length(XI(:));
x_prime = H*[XI(:) YI(:) ones(XI_size,1)]'; %on applique l'homographie

%on divise par la 3ème coordonnée homogène pour avoir les "vraies"
%coordonnées
X = x_prime(1,:) ./ x_prime(3,:); % ./ divise chaque composante
Y = x_prime(2,:) ./ x_prime(3,:);



%on crée la nouvelle image
new_img_vector = griddata(X,Y,double(img(:)),XI(:),YI(:) ); 
%grid data fais passer un plan par l'ensemble des données X,Y qui sont
%ensuite stockées dans XI, YI
%double parce que les valeurs utilisées ~ 10^-3, 10^-4, cf éxécution


new_img = reshape(new_img_vector, lignes ,colonnes);
%on redimensionne pour que le plan ait la même taille dans les deux images

%on affiche la nouvelle image avec les axes
figure ;
imagesc(XI(:),YI(:), new_img);
colormap gray
%axis equal pour les proportions
axis equal;
axis on ;
