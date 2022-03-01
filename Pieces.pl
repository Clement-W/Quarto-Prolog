%Caractéristiques possibles des pièces
taille(grande).
taille(petite).

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

% Définition d'un emplacement.
% L'ensemble des emplacements définissent le plateau de jeu.

% Emplacement est valide dès qu'on rentre "piece" pour Z, peu importe si cette pièce est valide ou non.
% emplacement(X,Y,Z):- X>=1, X=<4, Y>=1, Y=<4, functor(Z, piece, 4).

% autre solution qui permet de bien vérifier que la pièce est valide, mais on doit passer une liste à pièce du coup :
%emplacement(X,Y,Z):- X>=1, X=<4, Y>=1, Y=<4, piece(Z). %functor(Z, piece, 4), arg(1, Z, grande), arg(2, Z, carre), arg(3, Z, creux), arg(4, Z, noir). 
%emplacement(X,Y,Z):- X>=1, X=<4, Y>=1, Y=<4, functor(Z, vide, 0).

