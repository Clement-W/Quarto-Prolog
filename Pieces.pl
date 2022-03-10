%Caractéristiques possibles des pièces
taille(grand).
taille(petit).

forme(carre).
forme(rond).

interieur(creux).
interieur(plein).

couleur(blanc).
couleur(noir).

% Définition d'un pièce, qui prend en entrée une liste de caractéristiques.
% On a choisit d'utiliser une liste pour faciliter la "validation" des pièces dans les emplacements. (Cf. def emplacement)
piece([W,X,Y,Z]):- taille(W),forme(X),interieur(Y),couleur(Z).

% Définition d'un vide, seconde possibilité pour un emplacement.
vide().
