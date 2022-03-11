:- ['Pieces.pl'].
:- ['AffichagePlateau.pl'].
:- ['AffichageAccueil.pl'].
:- ['Utils.pl'].
:- ['IAFacile.pl'].
:- ['JoueurHumain.pl'].
:- ['IAMoyen.pl'].

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
    write("[3] : Humain contre IA Moyen"),
    nl,
    write("[4] : IA Facile contre IA Facile"),
    nl,
    read(ChoixMode),
    lancerMode(ChoixMode).

% Mode Humain vs Humain
% On passe le plateau dans jouerHvsH, qui est constitué de 16 vide initiallement.
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
    jouerHvsIAMoyen(
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
                    1).


lancerMode(4) :-
    jouerIAFacilevsIAFacile(
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


% Fait un tour de jeu : sélection de pièce par J1, placement de la pièce par J2 et vérification s'il y a victoire ou non
jouerHvsH(Plateau) :-
    nl,
    afficherPlateau(Plateau, 0), % affichage du plateau dans la console
    nl,
    selectPiece(P, Plateau), % sélection de la pièce par le joueur humain
    informerPieceChoisie(P), % affichage de la pièce choisie dans la console
    afficherPlateau(Plateau, 0), % affichage du plateau dans la console 
    nl,
    placerPiece(P, Plateau, NouveauPlateau), % placement de la pièce dans le plateau par le joueur humain
    verifVictoire(NouveauPlateau, 1, _). % vérifie si un cas de victoire est valide

% IA Facile :
% Cas où c'est l'IA qui sélectionne la pièce, et le joueur qui la place
jouerHvsIAFacile(Plateau, 0) :-
    nl,
    afficherPlateau(Plateau, 0), % affichage du plateau dans la console
    nl,
    selectionnerPieceIAFacile(P, Plateau), % sélection de la pièce par l'IA Facile
    informerPieceChoisie(P), % affichage de la pièce choisie dans la console
    placerPiece(P, Plateau, NouveauPlateau),  % placement de la pièce dans le plateau par le joueur humain
    verifVictoire(NouveauPlateau, 2, 0). % vérifie si un cas de victoire est valide

% Cas où c'est le joueur qui sélectionne la pièce, et le joueur qui la place
jouerHvsIAFacile(Plateau, 1) :-
    nl,
    afficherPlateau(Plateau, 0),
    nl,
    selectPiece(P, Plateau), % sélection de la pièce par le joueur humain
    informerPieceChoisie(P),
    placerPieceIAFacile(P, Plateau, NouveauPlateau), % placement de la pièce dans le plateau par l'IA Facile
    verifVictoire(NouveauPlateau, 2, 1).

% IA Moyen :
% Cas où c'est l'IA qui sélectionne la pièce, et le joueur qui la place
jouerHvsIAMoyen(Plateau, 0) :-
    nl,
    afficherPlateau(Plateau, 0),
    nl,
    selectionnerPieceIAMoyen(P, Plateau), % sélection de la pièce par l'IA Moyen
    informerPieceChoisie(P),
    placerPiece(P, Plateau, NouveauPlateau), % placement de la pièce dans le plateau par le joueur humain
    verifVictoire(NouveauPlateau, 3, 0).

% Cas où c'est le joueur qui sélectionne la pièce, et le joueur qui la place
jouerHvsIAMoyen(Plateau, 1) :-
    nl,
    afficherPlateau(Plateau, 0),
    nl,
    selectPiece(P, Plateau), % sélection de la pièce par le joueur humain
    informerPieceChoisie(P),
    placerPieceIAMoyen(P, Plateau, NouveauPlateau), % placement de la pièce dans le plateau par l'IA Moyen
    verifVictoire(NouveauPlateau, 3, 1).


% IA Facile contre IA Facile : 
jouerIAFacilevsIAFacile(Plateau) :-
    nl,
    afficherPlateau(Plateau, 0),
    nl,
    selectionnerPieceIAFacile(P, Plateau), % sélection de la pièce par l'IA facile
    informerPieceChoisie(P),
    nl,
    placerPieceIAFacile(P, Plateau, NouveauPlateau), % placement de la pièce dans le plateau par l'IA facile
    verifVictoire(NouveauPlateau, 4, _).

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
% Ici on regarde la première caractéristique des pièces (la taille)
verifAlignement(P1, P2, P3, P4) :-
    quatuorDePieces(P1, P2, P3, P4),
    nth1(1, P1, Taille),
    nth1(1, P2, Taille),
    nth1(1, P3, Taille),
    nth1(1, P4, Taille).

% Ici on regarde la seconde caractéristique des pièces (la forme)
verifAlignement(P1, P2, P3, P4) :-
    quatuorDePieces(P1, P2, P3, P4),
    nth1(2, P1, Forme),
    nth1(2, P2, Forme),
    nth1(2, P3, Forme),
    nth1(2, P4, Forme).

% Ici on regarde la troisième caractéristique des pièces (l'intérieur)
verifAlignement(P1, P2, P3, P4) :-
    quatuorDePieces(P1, P2, P3, P4),
    nth1(3, P1, Interieur),
    nth1(3, P2, Interieur),
    nth1(3, P3, Interieur),
    nth1(3, P4, Interieur).

% Ici on regarde la première caractéristique des pièces (la couleur)
verifAlignement(P1, P2, P3, P4) :-
    quatuorDePieces(P1, P2, P3, P4),
    nth1(4, P1, Couleur),
    nth1(4, P2, Couleur),
    nth1(4, P3, Couleur),
    nth1(4, P4, Couleur).

% Vérifie si il y a 4 pièces en ligne avec une caractéristique commune
verifLignes(Plateau) :-
    % dans un premire temps on récpuère les 4 pièces sur la 1ère ligne
    nth1(1, Plateau, P1),
    nth1(2, Plateau, P2),
    nth1(3, Plateau, P3),
    nth1(4, Plateau, P4),
    % puis on vérifie l'alignement de ces 4 pièces
    verifAlignement(P1, P2, P3, P4).

verifLignes(Plateau) :-
    % idem sur la 2ème ligne
    nth1(5, Plateau, P1),
    nth1(6, Plateau, P2),
    nth1(7, Plateau, P3),
    nth1(8, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).

verifLignes(Plateau) :-
    % idem sur la 3ème ligne
    nth1(9, Plateau, P1),
    nth1(10, Plateau, P2),
    nth1(11, Plateau, P3),
    nth1(12, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).

verifLignes(Plateau) :-
    % idem sur la 4ème ligne
    nth1(13, Plateau, P1),
    nth1(14, Plateau, P2),
    nth1(15, Plateau, P3),
    nth1(16, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).

% Vérifie si il y a 4 pièces en colonne avec une caractéristique commune
verifColonnes(Plateau) :-
    % dans un premier tmeps on rècupère les 4 pièce ssur la 1ère colonne
    nth1(1, Plateau, P1),
    nth1(5, Plateau, P2),
    nth1(9, Plateau, P3),
    nth1(13, Plateau, P4),
    % puis on vérifie l'alignement de ces 4 pièces
    verifAlignement(P1, P2, P3, P4).

verifColonnes(Plateau) :-
    % idem sur la 1ère colonne
    nth1(2, Plateau, P1),
    nth1(6, Plateau, P2),
    nth1(10, Plateau, P3),
    nth1(14, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).

verifColonnes(Plateau) :-
    % idem sur la 2ème colonne
    nth1(3, Plateau, P1),
    nth1(7, Plateau, P2),
    nth1(11, Plateau, P3),
    nth1(15, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).

verifColonnes(Plateau) :-
    % idem sur la 3ème colonne
    nth1(4, Plateau, P1),
    nth1(8, Plateau, P2),
    nth1(12, Plateau, P3),
    nth1(16, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).

% Vérifie si il y a 4 pièces en diagonale avec une caractéristique commune
verifDiagonales(Plateau) :-
    % fait la même chose pour la 1ère diagonale
    nth1(1, Plateau, P1),
    nth1(6, Plateau, P2),
    nth1(11, Plateau, P3),
    nth1(16, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).
verifDiagonales(Plateau) :-
    % idem pour la seconde diagonale
    nth1(4, Plateau, P1),
    nth1(7, Plateau, P2),
    nth1(10, Plateau, P3),
    nth1(13, Plateau, P4),
    verifAlignement(P1, P2, P3, P4).

% Vérifie si il y a une condition de victoire remplie sur le plateau, si oui le jeu s'arrête ici
% vérifie la victoire par alignement sur les lignes
verifVictoire(Plateau, _, _) :-
    verifLignes(Plateau),
    nl,
    write("Victoire sur la ligne !"),
    nl,
    afficherPlateau(Plateau, 0).

% vérifie la victoire par alignement sur les colonnes
verifVictoire(Plateau, _, _) :-
    verifColonnes(Plateau),
    nl,
    write("Victoire sur la colonne !"),
    nl,
    afficherPlateau(Plateau, 0).

% vérifie la victoire par alignement sur les diagonales
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

%Cas où il n'y a pas de victoire, on rappelle donc la règle de jeu correspondant au mode de jeu :
% Le premier integer attendu correspond au mode de jeu
% le second integer attendu correspond au cas ou deux joueurs de nature différentes jouent l'un contre l'autre (humain contre IA)
% le but étant d'échanger le rôle de chaque joueur à chaque tour


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


% Cas où le mode de jeu est Humain contre IA Moyen :

% Cas où l'humain vient de placer, pas de victoire, c'est au tour de l'IA de placer
verifVictoire(Plateau, 3, 0) :-
    write("Pas de victoire"),
    nl,
    jouerHvsIAMoyen(Plateau, 1). 

% Cas où l'IA vient de placer, pas de victoire, c'est au tour de l'humain de placer 
verifVictoire(Plateau, 3, 1) :-
    write("Pas de victoire"),
    nl,
    jouerHvsIAMoyen(Plateau, 0). 


% Cas où l'IA Facile joue contre une autre IA Facile :
verifVictoire(Plateau, 4, _) :-
    write("Pas de victoire"),
    nl,
    jouerIAFacilevsIAFacile(Plateau). 