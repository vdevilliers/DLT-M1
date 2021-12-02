
L'image f0 correspond à la façade.
 Carreau )
_______________________________________________________________________
Les résultats de chaque fichier sont présents/commentés dans le TER, sous forme d'image ou comme matrice :
(dans l'ordre du PDF)
-DLT_s contient l'algorithme classique de DLT
- sous forme d'image pour façade/carreau_DLT qui contiennent exactement le même code à image/coordonnées de points près
 [façade_DLT met très longtemps à tourner à cause de la résolution de l'image]
___________________________________________________________________________________________________________________
- DLT_2_3d est nécessaire pour calculer la matrice de caméra, il s'agit du DLT adapté aux correspondances 3D<->2D
- Matrice_de_Camera correspond au calcul de P (matrice dans le TER)
_________________________________________________________________________________________________________________
- K_w_principalpoint correspond au calcul d'omega sous les contraintes indiquées dans le code/pdf
- Conique_et_K utilise K_w_principalpoint pour déduire K d'omega (matrice dans le TER)

