:- ['Pieces.pl'].
:- ['AffichagePlateau.pl'].
:- ['AffichageAccueil.pl'].
:- ['Utils.pl'].
:- ['IAFacile.pl'].
:- ['JoueurHumain.pl'].
:- ['IAMinMax.pl'].

% démarre le jeu
demarrer() :-
    afficherTitre,
    nl,
    afficherTexteAccueil,
    nl,
    repeat,
    write("Choisissez vote mode de jeu en entrant le numéro du mode : "),
    nl,
    write("[1] : Humain contre Humain"),
    nl,
    write("[2] : Humain contre IA Facile"),
    nl,
    write("[3] : Humain contre IA Difficile"),
    nl,
    read(ChoixMode),
    lancerMode(ChoixMode).

% Mode Humain vs Humain
lancerMode(1) :-
    jouerHvsH(
              [ vide,
                vide,
                vide,
                vide,
                vide,
                vide,
                vide,
                vide,
                vide,
                vide,
                vide,
                vide,
                vide,
                vide,
                vide,
                vide
              ]).

% Mode Humain vs IA
lancerMode(2) :-
    jouerHvsIAFacile(
                     [ vide,
                       vide,
                       vide,
                       vide,
                       vide,
                       vide,
                       vide,
                       vide,
                       vide,
                       vide,
                       vide,
                       vide,
                       vide,
                       vide,
                       vide,
                       vide
                     ],
                     0).


lancerMode(3) :-
    jouerHvsIADifficile(
                        [ vide,
                          vide,
                          vide,
                          vide,
                          vide,
                          vide,
                          vide,
                          vide,
                          vide,
                          vide,
                          vide,
                          vide,
                          vide,
                          vide,
                          vide,
                          vide
                        ],
                        0).


% Fait un tour de jeu : sélection de pièce par J1, placement de la pièce par J2 et vérification s'il y a victoire ou non
jouerHvsH(Plateau) :-
    nl,
    afficherPlateau(Plateau, 0),
    nl,
    selectPiece(P, Plateau),
    informerPieceChoisie(P),
    afficherPlateau(Plateau, 0),
    nl,
    placerPiece(P, Plateau, NouveauPlateau),
    verifVictoire(NouveauPlateau, 1, _).

% IA Facile :
% Cas où c'est l'IA qui sélectionne la pièce, et le joueur qui la place
jouerHvsIAFacile(Plateau, 0) :-
    nl,
    afficherPlateau(Plateau, 0),
    nl,
    selectionnerPieceIAFacile(P, Plateau),
    informerPieceChoisie(P),
    placerPiece(P, Plateau, NouveauPlateau),
    verifVictoire(NouveauPlateau, 2, 0).

% Cas où c'est le joueur qui sélectionne la pièce, et le joueur qui la place
jouerHvsIAFacile(Plateau, 1) :-
    nl,
    afficherPlateau(Plateau, 0),
    nl,
    selectPiece(P, Plateau),
    informerPieceChoisie(P),
    placerPieceIAFacile(P, Plateau, NouveauPlateau),
    verifVictoire(NouveauPlateau, 2, 1).

% IA difficile :
% Cas où c'est l'IA qui sélectionne la pièce, et le joueur qui la place
jouerHvsIADifficile(Plateau, 0) :-
    nl,
    afficherPlateau(Plateau, 0),
    nl,
    selectionnerPieceIADifficile(P, Plateau),
    informerPieceChoisie(P),
    placerPiece(P, Plateau, NouveauPlateau),
    verifVictoire(NouveauPlateau, 3, 0).

% Cas où c'est le joueur qui sélectionne la pièce, et le joueur qui la place
jouerHvsIADifficile(Plateau, 1) :-
    nl,
    afficherPlateau(Plateau, 0),
    nl,
    selectPiece(P, Plateau),
    informerPieceChoisie(P),
    placerPieceIADifficile(P, Plateau, NouveauPlateau),
    verifVictoire(NouveauPlateau, 3, 1).


% affiche la pièce qui a été choisie
informerPieceChoisie(P) :-
    nl,
    write("La piece choisie est : "),
    afficherCase(P),
    nl.

% Vérifie que les 4 entrées sont bien des pièces (donc que ça ne comprte aucun vide)
quatuorDePieces(P1, P2, P3, P4) :-
    piece(P1),
    piece(P2),
    piece(P3),
    piece(P4).

% Vérifie que les 4 entrées sont bien des pièces et ont une caractéristique en commun
% verifAlignement(P1,P2,P3,P4,Ind):- quatuorDePieces(P1,P2,P3,P4),nth1(Ind,P1,Carac),nth1(Ind,P2,Carac),nth1(Ind,P3,Carac),nth1(Ind,P4,Carac).%, NewInd is Ind+1, verifAlignement(P1,P2,P3,P4,NewInd).
verifAlignement(P1, P2, P3, P4) :-
    quatuorDePieces(P1, P2, P3, P4),
    nth1(1, P1, Taille),
    nth1(1, P2, Taille),
    nth1(1, P3, Taille),
    nth1(1, P4, Taille).
verifAlignement(P1, P2, P3, P4) :-
    quatuorDePieces(P1, P2, P3, P4),
    nth1(2, P1, Forme),
    nth1(2, P2, Forme),
    nth1(2, P3, Forme),
    nth1(2, P4, Forme).
verifAlignement(P1, P2, P3, P4) :-
    quatuorDePieces(P1, P2, P3, P4),
    nth1(3, P1, Interieur),
    nth1(3, P2, Interieur),
    nth1(3, P3, Interieur),
    nth1(3, P4, Interieur).
verifAlignement(P1, P2, P3, P4) :-
    quatuorDePieces(P1, P2, P3, P4),
    nth1(4, P1, Couleur),
    nth1(4, P2, Couleur),
    nth1(4, P3, Couleur),
    nth1(4, P4, Couleur).

% Vérifie si il y a 4 pièces en ligne avec une caractéristique commune
verifLignes(Plateau) :-
    nth1(1, Plateau, P1),
    nth1(2, Plateau, P2),
    nth1(3, Plateau, P3),
    nth1(4, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).
verifLignes(Plateau) :-
    nth1(5, Plateau, P1),
    nth1(6, Plateau, P2),
    nth1(7, Plateau, P3),
    nth1(8, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).
verifLignes(Plateau) :-
    nth1(9, Plateau, P1),
    nth1(10, Plateau, P2),
    nth1(11, Plateau, P3),
    nth1(12, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).
verifLignes(Plateau) :-
    nth1(13, Plateau, P1),
    nth1(14, Plateau, P2),
    nth1(15, Plateau, P3),
    nth1(16, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).

% Vérifie si il y a 4 pièces en colonne avec une caractéristique commune
verifColonnes(Plateau) :-
    nth1(1, Plateau, P1),
    nth1(5, Plateau, P2),
    nth1(9, Plateau, P3),
    nth1(13, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).
verifColonnes(Plateau) :-
    nth1(2, Plateau, P1),
    nth1(6, Plateau, P2),
    nth1(10, Plateau, P3),
    nth1(14, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).
verifColonnes(Plateau) :-
    nth1(3, Plateau, P1),
    nth1(7, Plateau, P2),
    nth1(11, Plateau, P3),
    nth1(15, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).
verifColonnes(Plateau) :-
    nth1(4, Plateau, P1),
    nth1(8, Plateau, P2),
    nth1(12, Plateau, P3),
    nth1(16, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).

% Vérifie si il y a 4 pièces en diagonale avec une caractéristique commune
verifDiagonales(Plateau) :-
    nth1(1, Plateau, P1),
    nth1(6, Plateau, P2),
    nth1(11, Plateau, P3),
    nth1(16, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).
verifDiagonales(Plateau) :-
    nth1(4, Plateau, P1),
    nth1(7, Plateau, P2),
    nth1(10, Plateau, P3),
    nth1(13, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).

% Vérifie si il y a une condition de victoire remplie sur le plateau, si oui le jeu s'arrête ici
verifVictoire(Plateau, _, _) :-
    verifLignes(Plateau),
    nl,
    write("Victoire sur la ligne !"),
    nl,
    afficherPlateau(Plateau, 0).
verifVictoire(Plateau, _, _) :-
    verifColonnes(Plateau),
    nl,
    write("Victoire sur la colonne !"),
    nl,
    afficherPlateau(Plateau, 0).
verifVictoire(Plateau, _, _) :-
    verifDiagonales(Plateau),
    nl,
    write("Victoire sur la diagonale !"),
    nl,
    afficherPlateau(Plateau, 0).

% Vérifie si toutes les pièces ont été sélectionnées, si oui fin du jeu 
verifVictoire(Plateau, _, _) :-
    listePiecesRestantes(Plateau, []),
    nl,
    write("Fin de partie, égalité, plus de pièces disponibles..."),
    nl,
    afficherPlateau(Plateau, 0).

%Cas où il n'y a pas de victoire :

%Cas où le mode de jeu est Humain contre Humain, pas de victoire :
verifVictoire(Plateau, 1, _) :-
    write("Pas de victoire"),
    nl,
    jouerHvsH(Plateau). 

% Cas où le mode de jeu est Humain contre IA facile :

% Cas où l'humain vient de placer, pas de victoire, c'est au tour de l'IA de placer
verifVictoire(Plateau, 2, 0) :-
    write("Pas de victoire"),
    nl,
    jouerHvsIAFacile(Plateau, 1). 

% Cas où l'IA vient de placer, pas de victoire, c'est au tour de l'humain de placer 
verifVictoire(Plateau, 2, 1) :-
    write("Pas de victoire"),
    nl,
    jouerHvsIAFacile(Plateau, 0). 


% Cas où le mode de jeu est Humain contre IA Difficile :

% Cas où l'humain vient de placer, pas de victoire, c'est au tour de l'IA de placer
verifVictoire(Plateau, 3, 0) :-
    write("Pas de victoire"),
    nl,
    jouerHvsIADifficile(Plateau, 1). 

% Cas où l'IA vient de placer, pas de victoire, c'est au tour de l'humain de placer 
verifVictoire(Plateau, 3, 1) :-
    write("Pas de victoire"),
    nl,
    jouerHvsIADifficile(Plateau, 0). 