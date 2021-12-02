clear all;
%f0.jpg
img = imread('f0.jpg');
img = rgb2gray(img); %passage au gris
%normalisation des données


[h,l] = size(img);
m = mean(img,'all');
sd = 3.0551;
img = (img -mean(img,'all'))./sd;
%données centrées réduites ensuite


% ligne de fuite horizontale
 Hr = 1.0e+03*[1.8440    1.2980,
    1.8290    0.8090,
    2.4800    1.2710,
    2.4620    0.8750];
%normalisation rudimentaire
 H_n = (Hr(:,:)-m)/sd;
% ligne de fuite verticale
  Vr = 1.0e+03*[ 0.3680    1.9400,
    1.5920    1.7750,
    1.8290    1.3040,
    2.6900    1.2770];
%normalisation
V_n = (Vr(:,:)-m)/sd;

%on détermine l'intersection des droites sensées être parallèles


X(1,:) = V_n(1,:);
X(2,:) = V_n(2,:);
X(3,:) = V_n(3,:);
X(4,:) = V_n(4,:);


for i=1:2
    j=2*i;
c(i,:) = [[1; 1]  X(j-1:j,1)]\X(j-1:j,2);                        
slope(i) = c(i,2);
intercept(i) = c(i,1);                     

end
%
for k=1:1
    h=2*k;
    vx(k) = linsolve(slope(h-1) - slope(h),   intercept(h) - intercept(h-1));
  p(k,:)= [vx(k)*(slope(h-1)-slope(h)), vx(k)*(slope(h-1)-slope(h)) + intercept(h) - intercept(h-1) ,1]';
end



Y(1,:) = H_n(1,:);
Y(2,:) = H_n(2,:);
Y(3,:) = H_n(3,:);
Y(4,:) = H_n(4,:);

i=0;
for i=1:2
    j=2*i;
d(i,:) = [[1; 1]  Y(j-1:j,1)]\Y(j-1:j,2);                        
slop(i) = d(i,2);
intercep(i) = d(i,1);                     

end
%
k=0;
for k=1:1
    h=2*k;
    vy(k) = linsolve(slop(h-1) - slop(h),   intercep(h) - intercep(h-1));
  q(k,:)= [vy(k)*(slop(h-1)-slop(h)), vy(k)*(slop(h-1)-slop(h)) + intercep(h) - intercep(h-1) ,1]';
end


p_1 = p';
p_2 =q';
%on détermine la droite à l'infini
l_infty = cross(p,q)';


[lignes colonnes] = size(img); % on récupère la "taille" du plan pour avoir les coordonnées du point principal
%axes respectifs
x = (1:colonnes)'; 
y = (1:lignes)';
principal_p = ([length(x)/2 , length(y)/2]-[m,m])/sd;
K = K_w_principalpoint(p_1,p_2,principal_p);
display(K);
