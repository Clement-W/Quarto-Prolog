:- include('Pieces.pl').
:- include('AffichagePlateau.pl').
:- include('AffichageAccueil.pl').

demarrer():- afficherTexteAccueil(), nl, repeat, write("Choisissez vote mode de jeu en entrant (1)"), nl, write("[1] : Humain contre Humain"), nl, read(ChoixMode), lancerMode(ChoixMode).

lancerMode(1):- jouerHvsH([vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide()]).

% Initialise le plateau de jeu, et lance le premier tour de jeu
%installerJeu():- jouer([vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide()]).

% Fait un tour de jeu : sélection de pièce par J1, placement de la pièce par J2 et vérification s'il y a victoire ou non
jouerHvsH(Plateau):- nl, afficherPlateau(Plateau,0), nl, selectPiece(P,Plateau),placerPiece(P,Plateau,NouveauPlateau),verifVictoire(NouveauPlateau).

% Sélection de la pièce par J1
selectPiece(P,Plateau):- repeat, nl, write("Selectionnez une piece pour votre adversaire :"), nl, read(P), pieceSelectionnable(P,Plateau).
% Vérifie que la sélection correspond à une pièce, qui n'est pas déjà sur le plateau. 
pieceSelectionnable(P,Plateau):- piece(P), not(memberchk(P, Plateau)).

% Placement d'une pièce par J2 sur le plateau (donne lieu à un nouveau plateau)
placerPiece(P,Plateau,NouveauPlateau):- repeat,write("Choisissez la ligne"), nl, read(X), write("Choisissez la colonne"), nl, read(Y), Ind is (X-1)*4+Y, nth1(Ind,Plateau,vide()),changerElemListe(Ind,P,Plateau,NouveauPlateau).

% Change l'élément placé à l'indice Ind dans la liste [T|Q] en Elem
changerElemListe(1,Elem,[_|Q],[Elem|Q]).
changerElemListe(Ind,Elem,[T|Q],L2):- append([T],L1,L2),Ind2 is Ind-1,changerElemListe(Ind2,Elem,Q,L1).

%Vérifie que les 4 entrées sont bien des pièces
quatuorDePieces(P1,P2,P3,P4):- piece(P1),piece(P2),piece(P3),piece(P4).

% Vérifie que les 4 entrées sont bien des pièces et ont une caractéristique en commun
%TODO: Optimiser verifAlignement 
%verifAlignement(P1,P2,P3,P4,Ind):- quatuorDePieces(P1,P2,P3,P4),nth1(Ind,P1,Carac),nth1(Ind,P2,Carac),nth1(Ind,P3,Carac),nth1(Ind,P4,Carac).%, NewInd is Ind+1, verifAlignement(P1,P2,P3,P4,NewInd).
verifAlignement(P1,P2,P3,P4):- quatuorDePieces(P1,P2,P3,P4),nth1(1,P1,Taille),nth1(1,P2,Taille),nth1(1,P3,Taille),nth1(1,P4,Taille).
verifAlignement(P1,P2,P3,P4):- quatuorDePieces(P1,P2,P3,P4),nth1(2,P1,Forme),nth1(2,P2,Forme),nth1(2,P3,Forme),nth1(2,P4,Forme).
verifAlignement(P1,P2,P3,P4):- quatuorDePieces(P1,P2,P3,P4),nth1(3,P1,Interieur),nth1(3,P2,Interieur),nth1(3,P3,Interieur),nth1(3,P4,Interieur).
verifAlignement(P1,P2,P3,P4):- quatuorDePieces(P1,P2,P3,P4),nth1(4,P1,Couleur),nth1(4,P2,Couleur),nth1(4,P3,Couleur),nth1(4,P4,Couleur).

% Vérifie si il y a 4 pièces en ligne avec une caractéristique commune
verifLignes(Plateau):- nth1(1,Plateau,P1),nth1(2,Plateau,P2),nth1(3,Plateau,P3),nth1(4,Plateau,P4),verifAlignement(P1,P2,P3,P4).
verifLignes(Plateau):- nth1(5,Plateau,P1),nth1(6,Plateau,P2),nth1(7,Plateau,P3),nth1(8,Plateau,P4),verifAlignement(P1,P2,P3,P4).
verifLignes(Plateau):- nth1(9,Plateau,P1),nth1(10,Plateau,P2),nth1(11,Plateau,P3),nth1(12,Plateau,P4),verifAlignement(P1,P2,P3,P4).
verifLignes(Plateau):- nth1(13,Plateau,P1),nth1(14,Plateau,P2),nth1(15,Plateau,P3),nth1(16,Plateau,P4),verifAlignement(P1,P2,P3,P4).

% Vérifie si il y a 4 pièces en colonne avec une caractéristique commune
verifColonnes(Plateau):- nth1(1,Plateau,P1),nth1(5,Plateau,P2),nth1(9,Plateau,P3),nth1(13,Plateau,P4),verifAlignement(P1,P2,P3,P4).
verifColonnes(Plateau):- nth1(2,Plateau,P1),nth1(6,Plateau,P2),nth1(10,Plateau,P3),nth1(14,Plateau,P4),verifAlignement(P1,P2,P3,P4).
verifColonnes(Plateau):- nth1(3,Plateau,P1),nth1(7,Plateau,P2),nth1(11,Plateau,P3),nth1(15,Plateau,P4),verifAlignement(P1,P2,P3,P4).
verifColonnes(Plateau):- nth1(4,Plateau,P1),nth1(8,Plateau,P2),nth1(12,Plateau,P3),nth1(16,Plateau,P4),verifAlignement(P1,P2,P3,P4).

% Vérifie si il y a 4 pièces en diagonale avec une caractéristique commune
verifDiagonales(Plateau):- nth1(1,Plateau,P1),nth1(6,Plateau,P2),nth1(11,Plateau,P3),nth1(16,Plateau,P4),verifAlignement(P1,P2,P3,P4).
verifDiagonales(Plateau):- nth1(4,Plateau,P1),nth1(7,Plateau,P2),nth1(10,Plateau,P3),nth1(13,Plateau,P4),verifAlignement(P1,P2,P3,P4).

% Vérifie si il y a une condition de victoire remplie sur le plateau, et relance un tour de jeu si ce n'est pas le cas
verifVictoire(Plateau):- verifLignes(Plateau), nl, write("Victoire sur la ligne !").
verifVictoire(Plateau):- verifColonnes(Plateau), nl, write("Victoire sur la colonne !").
verifVictoire(Plateau):- verifDiagonales(Plateau), nl, write("Victoire sur la diagonale !").
verifVictoire(Plateau):- write("Pas de victoire"),jouer(Plateau). %dernier cas, il n'y a pas de victoire

