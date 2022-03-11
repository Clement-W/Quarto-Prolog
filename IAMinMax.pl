:- ['Utils.pl'].
:- ['Pieces.pl'].

% IA de niveau moyen
selectionnerPieceIADifficile(P, Plateau) :-
    listePiecesRestantes(Plateau, ListePiecesRestantes),
    length(ListePiecesRestantes, NbPiecesRestantes),
    listeCasesRestantes(Plateau, [], 1, ListeCasesRestantes),
    pieceASelectionner(P,
                       Plateau,
                       ListePiecesRestantes,
                       1,
                       NbPiecesRestantes,
                       ListeCasesRestantes,
                       _).


placerPieceIADifficile(P, Plateau, NouveauPlateau) :-
    listeCasesRestantes(Plateau, [], 1, ListeCasesRestantes),
    write("on a listé les cases restantes"),
    nl,
    length(ListeCasesRestantes, NbCasesRestantes),
    placeASelectionner(P,
                       Plateau,
                       ListeCasesRestantes,
                       1,
                       NbCasesRestantes,
                       [_, PlaceASelectionner]),
    write("place à sélectoinner est terminé"),
    nl,
    changerElemListe(PlaceASelectionner, P, Plateau, NouveauPlateau).


pieceASelectionner([ScorePieceTestee,PieceTestee], Plateau, ListePiecesRestantes, IndListesPiecesRestantes, NbPiecesRestantes, ListeCasesRestantes) :-
    nth1(IndListesPiecesRestantes, ListePiecesRestantes, PieceTestee),
    placeASelectionner(PieceTestee,
                       Plateau,
                       ListeCasesRestantes,
                       1,
                       NbPiecesRestantes,
                       [ScorePieceTestee, _]).

pieceASelectionner(ScoreEtPiece, Plateau, ListePiecesRestantes, IndListesPiecesRestantes, NbPiecesRestantes, ListeCasesRestantes) :-
    nth1(IndListesPiecesRestantes, ListePiecesRestantes, PieceTestee),
    placeASelectionner(PieceTestee,
                       Plateau,
                       ListeCasesRestantes,
                       1,
                       NbPiecesRestantes,
                       [ScorePieceTestee, _]),
    IndListesPiecesRestantesSuivant is IndListesPiecesRestantes+1,
    pieceASelectionner(ScoreEtPieceSuivante,
                       Plateau,
                       ListePiecesRestantes,
                       IndListesPiecesRestantesSuivant,
                       NbPiecesRestantes,
                       ListeCasesRestantes),
    bonScoreEtObjet(0, ScoreEtPieceSuivante, [ScorePieceTestee, PieceTestee], ScoreEtPiece).


placeASelectionner(P, Plateau, ListeCasesRestantes, NbCasesRestantes, NbCasesRestantes, [Score, IndPiece]) :-
    write("on passe dans le cas d'arret"),
    nth1(NbCasesRestantes, ListeCasesRestantes, IndPiece),
    changerElemListe(IndPiece, P, Plateau, NouveauPlateau),
    score(NouveauPlateau, Score).

placeASelectionner(P, Plateau, ListeCasesRestantes, IndListeCasesRestantes, NbCasesRestantes, ScoreEtIndice) :-
    write("on passe dans le cas ou la nouvelle place est meilleure"),
    nth1(IndListeCasesRestantes, ListeCasesRestantes, IndPiece),
    changerElemListe(IndPiece, P, Plateau, NouveauPlateau),
    score(NouveauPlateau, ScoreActuel),
    IndListeCasesRestantesSuivant is IndListeCasesRestantes+1,
    placeASelectionner(P,
                       Plateau,
                       ListeCasesRestantes,
                       IndListeCasesRestantesSuivant,
                       NbCasesRestantes,
                       ScoreEtIndiceSuivant),
    bonScoreEtObjet(1, ScoreEtIndiceSuivant, [ScoreActuel, IndPiece], ScoreEtIndice).


% 0 pour sortir la liste avec le pire score
bonScoreEtObjet(0, [Score1, Objet1], [Score2, _], [Score1, Objet1]) :-
    min_list([Score1, Score2], Score1). 
bonScoreEtObjet(0, [Score1, _], [Score2, Objet2], [Score2, Objet2]) :-
    min_list([Score1, Score2], Score2). 
% 1 pour sortir la liste avec le meilleur score
bonScoreEtObjet(1, [Score1, Objet1], [Score2, _], [Score1, Objet1]) :-
    max_list([Score1, Score2], Score1). 
bonScoreEtObjet(1, [Score1, _], [Score2, Objet2], [Score2, Objet2]) :-
    max_list([Score1, Score2], Score2). 


% Les deux prédicats suivants sont appelés dans JouervsIADifficile dans Jeu.pl, nous avons décidé de fixer arbitrairement la profondeur de l'arbre d'exploration de l'algorithme à 4
%selectionnerPieceIADifficile(P, Plateau) :-
%    minMax(Plateau, P, 4).
%placerPieceIADifficile(P, Plateau, NouveauPlateau) :-
%    minMax(Plateau, P, IndPiece, 4),
%    changerElemListe(IndPiece, P, Plateau, NouveauPlateau).

% minMax enclenche l'exécution de l'algorithme de l'IA pour :
    % sélectionner la pire pièce possible pour l'adversaire
minMax(Plateau, PieceASelectionner, ProfondeurMax) :-
    listePiecesRestantes(Plateau, ListePiecesRestantes),
    length(ListePiecesRestantes, NbPiecesRestantes),
    premierEtage(Plateau,
                 ListePiecesRestantes,
                 PieceASelectionner,
                 1,
                 NbPiecesRestantes,
                 ProfondeurMax,
                 _).
    % placer à la meilleur place la pièce choisie par l'adversaire
minMax(Plateau, PieceAPlacer, IndPieceAJouer, ProfondeurMax) :-
    listePiecesRestantes(Plateau, ListePiecesRestantes),
    subtract(ListePiecesRestantes, [PieceAPlacer], ListesPiecesRestantesSansLaPieceAPlacer),
    length(ListesPiecesRestantesSansLaPieceAPlacer, NbPiecesRestantes),
    premierEtage(Plateau,
                 PieceAPlacer,
                 IndPieceAJouer,
                 _,
                 NbPiecesRestantes,
                 ProfondeurMax).

% premierEtage construit le premier niveau de l'arbre d'exloration.
% Cas où l'IA doit sélectionner une pièce pour son adversaire
    % Cas d'arrêt : on arrive au bout du niveau et on remonte le score correspondant au choix de la dernière pièce possible à placer
premierEtage(Plateau, ListePiecesRestantes, PieceATester, NbPiecesRestantes, NbPiecesRestantes, ProfondeurMax, ScorePiece) :-
    nth1(NbPiecesRestantes, ListePiecesRestantes, PieceATester),
    listeCasesRestantes(Plateau, [], 1, ListeCasesRestantes),
    nth1(IndPiece, Plateau, PieceATester),
    creationNoeudDuNiveau(Plateau,
                          PieceATester,
                          ScorePiece,
                          0,
                          ListeCasesRestantes,
                          1,
                          IndPiece,
                          1,
                          ProfondeurMax,
                          1,
                          NbPiecesRestantes).

    % Cas où la pièce testée donne un score plus mauvais que le score enregistré, et donc on garde cette pièce et ce score
premierEtage(Plateau, ListePiecesRestantes, PieceATester, IndPieceRestante, NbPiecesRestantes, ProfondeurMax, ScorePiece) :-
    nth1(IndPieceRestante, ListePiecesRestantes, PieceATester),
    listeCasesRestantes(Plateau, [], 1, ListeCasesRestantes),
    nth1(IndPiece, Plateau, PieceATester),
    creationNoeudDuNiveau(Plateau,
                          PieceATester,
                          ScorePiece,
                          0,
                          ListeCasesRestantes,
                          1,
                          IndPiece,
                          1,
                          ProfondeurMax,
                          1,
                          NbPiecesRestantes), %Remarque : le nombre de pièces restantes est égal au nombre de cases encore vides
    IndPieceRestanteSuivant is IndPieceRestante+1,
    premierEtage(Plateau,
                 ListePiecesRestantes,
                 _,
                 IndPieceRestanteSuivant,
                 NbPiecesRestantes,
                 ProfondeurMax,
                 ScorePieceSuivante),
    ScorePieceSuivante>ScorePiece.

    % Cas où la pièce testée donne un score meilleur que le score enregistré, et donc ne la considère pas
premierEtage(Plateau, ListePiecesRestantes, PieceASelectionner, IndPieceRestante, NbPiecesRestantes, ProfondeurMax, ScorePieceSuivante) :-
    nth1(IndPieceRestante, ListePiecesRestantes, PieceATester),
    listeCasesRestantes(Plateau, [], 1, ListeCasesRestantes),
    nth1(IndPiece, Plateau, PieceATester),
    creationNoeudDuNiveau(Plateau,
                          PieceATester,
                          ScorePiece,
                          0,
                          ListeCasesRestantes,
                          1,
                          IndPiece,
                          1,
                          ProfondeurMax,
                          1,
                          NbPiecesRestantes), %Remarque : le nombre de pièces restantes est égal au nombre de cases encore vides
    IndPieceRestanteSuivant is IndPieceRestante+1,
    premierEtage(Plateau,
                 ListePiecesRestantes,
                 PieceASelectionner,
                 IndPieceRestanteSuivant,
                 NbPiecesRestantes,
                 ProfondeurMax,
                 ScorePieceSuivante),
    ScorePieceSuivante<ScorePiece.

%Cas où l'IA doit placer une pièce sélectionnée par l'adversaire
    % Cas d'arrêt : on arrive au bout du niveau et on remonte le score correspondant au choix de la dernière place possible pour la pièce à placer
premierEtage(Plateau, PieceAPlacer, IndTeste, ScorePlace, 1, ProfondeurMax) :-
    listeCasesRestantes(Plateau, [], 1, ListeCasesRestantes),
    nth1(1, ListeCasesRestantes, IndTeste),
    changerElemListe(IndTeste, PieceAPlacer, Plateau, PlateauAvecPiece),
    creationNoeudDuNiveau(PlateauAvecPiece,
                          _,
                          ScorePlace,
                          1,
                          _,
                          _,
                          _,
                          1,
                          ProfondeurMax,
                          1,
                          1).

    % Cas où la place testée est moins bonne que la place enregistrée, donc on ne la considère pas
premierEtage(Plateau, PieceAPlacer, IndPieceAPlacer, ScorePlaceSuivante, NbCasesNonTestees, ProfondeurMax) :-
    listeCasesRestantes(Plateau, [], 1, ListeCasesRestantes),
    nth1(NbCasesNonTestees, ListeCasesRestantes, IndTeste),
    changerElemListe(IndTeste, PieceAPlacer, Plateau, PlateauAvecPiece),
    creationNoeudDuNiveau(PlateauAvecPiece,
                          _,
                          ScorePlace,
                          1,
                          _,
                          _,
                          _,
                          1,
                          ProfondeurMax,
                          NbCasesNonTestees,
                          NbCasesNonTestees),
    NbCasesNonTesteActualise is NbCasesNonTestees-1,
    premierEtage(Plateau,
                 PieceAPlacer,
                 IndPieceAPlacer,
                 ScorePlaceSuivante,
                 1,
                 NbCasesNonTesteActualise,
                 ProfondeurMax),
    ScorePlaceSuivante>ScorePlace.

    % Cas où la place testée est meilleur que la place enregistrée, donc on l'enregistre
premierEtage(Plateau, PieceAPlacer, IndTeste, ScorePlace, NbCasesNonTestees, ProfondeurMax) :-
    listeCasesRestantes(Plateau, [], 1, ListeCasesRestantes),
    nth1(NbCasesNonTestees, ListeCasesRestantes, IndTeste),
    changerElemListe(IndTeste, PieceAPlacer, Plateau, PlateauAvecPiece),
    creationNoeudDuNiveau(PlateauAvecPiece,
                          _,
                          ScorePlace,
                          1,
                          _,
                          _,
                          _,
                          1,
                          ProfondeurMax,
                          NbCasesNonTestees,
                          NbCasesNonTestees),
    NbCasesNonTesteActualise is NbCasesNonTestees-1,
    premierEtage(Plateau,
                 PieceAPlacer,
                 _,
                 ScorePlaceSuivante,
                 1,
                 NbCasesNonTesteActualise,
                 ProfondeurMax),
    ScorePlaceSuivante<ScorePlace.

% Évalue un état du plateau, en fonction du nombre de caractéristiques en commun des pièces alignées
score(Plateau, Score) :-
    evaluerLignes(Plateau, ScoreLignes),
    evaluerColonnes(Plateau, ScoreColonnes),
    evaluerDiagonales(Plateau, ScoreDiagonales),
    Score is ScoreLignes+ScoreColonnes+ScoreDiagonales.

% Donne le score du plateau en fonction des lignes uniquement
evaluerLignes(Plateau, ScoreLignes) :-
    nth1(1, Plateau, E1),
    nth1(2, Plateau, E2),
    nth1(3, Plateau, E3),
    nth1(4, Plateau, E4),
    evaluation(E1, E2, E3, E4, Score1),
    nth1(5, Plateau, E5),
    nth1(6, Plateau, E6),
    nth1(7, Plateau, E7),
    nth1(8, Plateau, E8),
    evaluation(E5, E6, E7, E8, Score2),
    nth1(9, Plateau, E9),
    nth1(10, Plateau, E10),
    nth1(11, Plateau, E11),
    nth1(12, Plateau, E12),
    evaluation(E9, E10, E11, E12, Score3),
    nth1(13, Plateau, E13),
    nth1(14, Plateau, E14),
    nth1(15, Plateau, E15),
    nth1(16, Plateau, E16),
    evaluation(E13, E14, E15, E16, Score4),
    ScoreLignes is Score1+Score2+Score3+Score4.

% Donne le score du plateau en fonction des colonnes uniquement
evaluerColonnes(Plateau, ScoreColonnes) :-
    nth1(1, Plateau, E1),
    nth1(5, Plateau, E5),
    nth1(9, Plateau, E9),
    nth1(13, Plateau, E13),
    evaluation(E1, E5, E9, E13, Score1),
    nth1(2, Plateau, E2),
    nth1(6, Plateau, E6),
    nth1(10, Plateau, E10),
    nth1(14, Plateau, E14),
    evaluation(E2, E6, E10, E14, Score2),
    nth1(3, Plateau, E3),
    nth1(7, Plateau, E7),
    nth1(11, Plateau, E11),
    nth1(15, Plateau, E15),
    evaluation(E3, E7, E11, E15, Score3),
    nth1(4, Plateau, E4),
    nth1(8, Plateau, E8),
    nth1(12, Plateau, E12),
    nth1(16, Plateau, E16),
    evaluation(E4, E8, E12, E16, Score4),
    ScoreColonnes is Score1+Score2+Score3+Score4.

% Donne le score du plateau en fonction des diagonales uniquement
evaluerDiagonales(Plateau, ScoreDiagonales) :-
    nth1(1, Plateau, E1),
    nth1(6, Plateau, E6),
    nth1(11, Plateau, E11),
    nth1(16, Plateau, E16),
    evaluation(E1, E6, E11, E16, Score1),
    nth1(4, Plateau, E4),
    nth1(7, Plateau, E7),
    nth1(10, Plateau, E10),
    nth1(13, Plateau, E13),
    evaluation(E4, E7, E10, E13, Score2),
    ScoreDiagonales is Score1+Score2.

% evaluation est vrai pour chaque alignement de 4 pièces pouvant aboutir à la victoire, et donne un score selon la proximité du cas de victoire

% Cas de victoire
evaluation([X, _, _, _], [X, _, _, _], [X, _, _, _], [X, _, _, _], 1000).
evaluation([_, X, _, _], [_, X, _, _], [_, X, _, _], [_, X, _, _], 1000).
evaluation([_, _, X, _], [_, _, X, _], [_, _, X, _], [_, _, X, _], 1000).
evaluation([_, _, _, X], [_, _, _, X], [_, _, _, X], [_, _, _, X], 1000).

% L'évaluation vaut 3
evaluation([X, _, _, _], [X, _, _, _], [X, _, _, _], vide, 3).
evaluation([X, _, _, _], [X, _, _, _], vide, [X, _, _, _], 3).
evaluation([X, _, _, _], vide, [X, _, _, _], [X, _, _, _], 3).
evaluation(vide, [X, _, _, _], [X, _, _, _], [X, _, _, _], 3).

evaluation([_, X, _, _], [_, X, _, _], [_, X, _, _], vide, 3).
evaluation([_, X, _, _], [_, X, _, _], vide, [_, X, _, _], 3).
evaluation([_, X, _, _], vide, [_, X, _, _], [_, X, _, _], 3).
evaluation(vide, [_, X, _, _], [_, X, _, _], [_, X, _, _], 3).

evaluation([_, _, X, _], [_, _, X, _], [_, _, X, _], vide, 3).
evaluation([_, _, X, _], [_, _, X, _], vide, [_, _, X, _], 3).
evaluation([_, _, X, _], vide, [_, _, X, _], [_, _, X, _], 3).
evaluation(vide, [_, _, X, _], [_, _, X, _], [_, _, X, _], 3).

evaluation([_, _, _, X], [_, _, _, X], [_, _, _, X], vide, 3).
evaluation([_, _, _, X], [_, _, _, X], vide, [_, _, _, X], 3).
evaluation([_, _, _, X], vide, [_, _, _, X], [_, _, _, X], 3).
evaluation(vide, [_, _, _, X], [_, _, _, X], [_, _, _, X], 3).

% L'évaluation vaut 2
evaluation([X, _, _, _], [X, _, _, _], vide, vide, 2).
evaluation([X, _, _, _], vide, [X, _, _, _], vide, 2).
evaluation(vide, [X, _, _, _], [X, _, _, _], vide, 2).
evaluation([X, _, _, _], vide, vide, [X, _, _, _], 2).
evaluation(vide, [X, _, _, _], vide, [X, _, _, _], 2).
evaluation(vide, vide, [X, _, _, _], [X, _, _, _], 2).

evaluation([_, X, _, _], [_, X, _, _], vide, vide, 2).
evaluation([_, X, _, _], vide, [_, X, _, _], vide, 2).
evaluation(vide, [_, X, _, _], [_, X, _, _], vide, 2).
evaluation([_, X, _, _], vide, vide, [_, X, _, _], 2).
evaluation(vide, [_, X, _, _], vide, [_, X, _, _], 2).
evaluation(vide, vide, [_, X, _, _], [_, X, _, _], 2).

evaluation([_, _, X, _], [_, _, X, _], vide, vide, 2).
evaluation([_, _, X, _], vide, [_, _, X, _], vide, 2).
evaluation(vide, [_, _, X, _], [_, _, X, _], vide, 2).
evaluation([_, _, X, _], vide, vide, [_, _, X, _], 2).
evaluation(vide, [_, _, X, _], vide, [_, _, X, _], 2).
evaluation(vide, vide, [_, _, X, _], [_, _, X, _], 2).

evaluation([_, _, _, X], [_, _, _, X], vide, vide, 2).
evaluation([_, _, _, X], vide, [_, _, _, X], vide, 2).
evaluation(vide, [_, _, _, X], [_, _, _, X], vide, 2).
evaluation([_, _, _, X], vide, vide, [_, _, _, X], 2).
evaluation(vide, [_, _, _, X], vide, [_, _, _, X], 2).
evaluation(vide, vide, [_, _, _, X], [_, _, _, X], 2).

% Cas où il est impossible de gagner avec l'alignement des 4 emplacements évalués
evaluation(_, _, _, _, 0).


%creationNoeudDuNiveau crée les noeuds suivant de l'arbre d'exploration à partir du noeud traité

% Cas d'arrêt : profondeur maximale et fin de niveau
creationNoeudDuNiveau(NoeudPlateau, _, ScoreNoeudPrecedent, _, _, _, _, ProfondeurMax, ProfondeurMax, NumeroMax, NumeroMax) :-
    score(NoeudPlateau, ScoreNoeudPrecedent).

% Cas profondeur maximale : 
    % on veut maximiser le score du noeud précédent (MinOrMax == 1) et ce noeud a un score plus grand 
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeud, 1, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, ProfondeurMax, ProfondeurMax, Numero, NumeroMax) :-
    score(NoeudPlateau, ScoreNoeud),
    NumeroSuivant is Numero+1,
    changerElemListe(IndPiece, vide, NoeudPlateau, NoeudPlateauIntermediaire),
    IndSuivantListeCasesRestantes is IndListeCasesRestantes+1,
    nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece),
    changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant),
    creationNoeudDuNiveau(NoeudPlateauSuivant,
                          PieceTestee,
                          ScoreNoeudPrecedentActuellement,
                          1,
                          ListeCasesRestantes,
                          IndSuivantListeCasesRestantes,
                          IndSuivantPiece,
                          ProfondeurMax,
                          ProfondeurMax,
                          NumeroSuivant,
                          NumeroMax),
    ScoreNoeud>ScoreNoeudPrecedentActuellement.
    % on veut maximiser le score du noeud précédent (MinOrMax == 1) et ce noeud a un score plus petit 
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeudPrecedentActuellement, 1, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, ProfondeurMax, ProfondeurMax, Numero, NumeroMax) :-
    score(NoeudPlateau, ScoreNoeud),
    NumeroSuivant is Numero+1,
    changerElemListe(IndPiece, vide, NoeudPlateau, NoeudPlateauIntermediaire),
    IndSuivantListeCasesRestantes is IndListeCasesRestantes+1,
    nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece),
    changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant),
    creationNoeudDuNiveau(NoeudPlateauSuivant,
                          PieceTestee,
                          ScoreNoeudPrecedentActuellement,
                          1,
                          ListeCasesRestantes,
                          IndSuivantListeCasesRestantes,
                          IndSuivantPiece,
                          ProfondeurMax,
                          ProfondeurMax,
                          NumeroSuivant,
                          NumeroMax),
    ScoreNoeud<ScoreNoeudPrecedentActuellement.
    % on veut minimiser le score du noeud précédent (MinOrMax == 0) et ce noeud a un score plus petit 
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeud, 0, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, ProfondeurMax, ProfondeurMax, Numero, NumeroMax) :-
    score(NoeudPlateau, ScoreNoeud),
    NumeroSuivant is Numero+1,
    changerElemListe(IndPiece, vide, NoeudPlateau, NoeudPlateauIntermediaire),
    IndSuivantListeCasesRestantes is IndListeCasesRestantes+1,
    nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece),
    changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant),
    creationNoeudDuNiveau(NoeudPlateauSuivant,
                          PieceTestee,
                          ScoreNoeudPrecedentActuellement,
                          0,
                          ListeCasesRestantes,
                          IndSuivantListeCasesRestantes,
                          IndSuivantPiece,
                          ProfondeurMax,
                          ProfondeurMax,
                          NumeroSuivant,
                          NumeroMax),
    ScoreNoeud<ScoreNoeudPrecedentActuellement.
    % on veut minimiser le score du noeud précédent (MinOrMax == 0) et ce noeud a un score plus grand 
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeudPrecedentActuellement, 0, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, ProfondeurMax, ProfondeurMax, Numero, NumeroMax) :-
    score(NoeudPlateau, ScoreNoeud),
    NumeroSuivant is Numero+1,
    changerElemListe(IndPiece, vide, NoeudPlateau, NoeudPlateauIntermediaire),
    IndSuivantListeCasesRestantes is IndListeCasesRestantes+1,
    nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece),
    changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant),
    creationNoeudDuNiveau(NoeudPlateauSuivant,
                          PieceTestee,
                          ScoreNoeudPrecedentActuellement,
                          0,
                          ListeCasesRestantes,
                          IndSuivantListeCasesRestantes,
                          IndSuivantPiece,
                          ProfondeurMax,
                          ProfondeurMax,
                          NumeroSuivant,
                          NumeroMax),
    ScoreNoeud>ScoreNoeudPrecedentActuellement.


% Cas de profondeur non maximale et fin de niveau
    % on veut maximiser le score du noeud précédent (MinOrMax == 1) 
creationNoeudDuNiveau(NoeudPlateau, _, ScoreNoeud, 1, _, _, _, Profondeur, ProfondeurMax, NumeroMax, NumeroMax) :-
    NouvelleProfondeur is Profondeur+1,
    listePiecesRestantes(NoeudPlateau, ListePiecesRestantes),
    nth1(1, ListePiecesRestantes, NouvellePieceTestee),
    listeCasesRestantes(NoeudPlateau, [], 1, NouvelleListeCasesRestantes),
    length(NouvelleListeCasesRestantes, NumeroMaxNiveauSuivant),
    nth1(1, NouvelleListeCasesRestantes, IndNouvellePiece),
    changerElemListe(IndNouvellePiece, NouvellePieceTestee, NoeudPlateau, NoeudPlateauNiveauSuivant),
    creationNoeudDuNiveau(NoeudPlateauNiveauSuivant,
                          NouvellePieceTestee,
                          ScoreNoeud,
                          0,
                          NouvelleListeCasesRestantes,
                          1,
                          IndNouvellePiece,
                          NouvelleProfondeur,
                          ProfondeurMax,
                          1,
                          NumeroMaxNiveauSuivant).
    % on veut minimiser le score du noeud précédent (MinOrMax == 0) 
creationNoeudDuNiveau(NoeudPlateau, _, ScoreNoeud, 0, _, _, _, Profondeur, ProfondeurMax, NumeroMax, NumeroMax) :-
    NouvelleProfondeur is Profondeur+1,
    listePiecesRestantes(NoeudPlateau, ListePiecesRestantes),
    nth1(1, ListePiecesRestantes, NouvellePieceTestee),
    listeCasesRestantes(NoeudPlateau, [], 1, NouvelleListeCasesRestantes),
    length(NouvelleListeCasesRestantes, NumeroMaxNiveauSuivant),
    nth1(1, NouvelleListeCasesRestantes, IndNouvellePiece),
    changerElemListe(IndNouvellePiece, NouvellePieceTestee, NoeudPlateau, NoeudPlateauNiveauSuivant),
    creationNoeudDuNiveau(NoeudPlateauNiveauSuivant,
                          NouvellePieceTestee,
                          ScoreNoeud,
                          1,
                          NouvelleListeCasesRestantes,
                          1,
                          IndNouvellePiece,
                          NouvelleProfondeur,
                          ProfondeurMax,
                          1,
                          NumeroMaxNiveauSuivant).
  

% Cas de profondeur non maximale et non fin de niveau
    % on veut maximiser le score du noeud précédent (MinOrMax == 1) et ce noeud a un score plus grand 
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeud, 1, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, Profondeur, ProfondeurMax, Numero, NumeroMax) :-
    NumeroSuivant is Numero+1,
    changerElemListe(IndPiece, vide, NoeudPlateau, NoeudPlateauIntermediaire),
    IndSuivantListeCasesRestantes is IndListeCasesRestantes+1,
    nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece),
    changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant),
    creationNoeudDuNiveau(NoeudPlateauSuivant,
                          PieceTestee,
                          ScoreNoeudPrecedentActuellement,
                          1,
                          ListeCasesRestantes,
                          IndSuivantListeCasesRestantes,
                          IndSuivantPiece,
                          ProfondeurMax,
                          ProfondeurMax,
                          NumeroSuivant,
                          NumeroMax),
    ScoreNoeud>ScoreNoeudPrecedentActuellement,
    NouvelleProfondeur is Profondeur+1,
    listePiecesRestantes(NoeudPlateau, ListePiecesRestantes),
    nth1(1, ListePiecesRestantes, NouvellePieceTestee),
    listeCasesRestantes(NoeudPlateau, [], 1, NouvelleListeCasesRestantes),
    length(NouvelleListeCasesRestantes, NumeroMaxNiveauSuivant),
    nth1(1, NouvelleListeCasesRestantes, IndNouvellePiece),
    changerElemListe(IndNouvellePiece, NouvellePieceTestee, NoeudPlateau, NoeudPlateauNiveauSuivant),
    creationNoeudDuNiveau(NoeudPlateauNiveauSuivant,
                          NouvellePieceTestee,
                          ScoreNoeud,
                          0,
                          NouvelleListeCasesRestantes,
                          1,
                          IndNouvellePiece,
                          NouvelleProfondeur,
                          ProfondeurMax,
                          1,
                          NumeroMaxNiveauSuivant).
    % on veut maximiser le score du noeud précédent (MinOrMax == 1) et ce noeud a un score plus petit
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeudPrecedentActuellement, 1, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, Profondeur, ProfondeurMax, Numero, NumeroMax) :-
    NumeroSuivant is Numero+1,
    changerElemListe(IndPiece, vide, NoeudPlateau, NoeudPlateauIntermediaire),
    IndSuivantListeCasesRestantes is IndListeCasesRestantes+1,
    nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece),
    changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant),
    creationNoeudDuNiveau(NoeudPlateauSuivant,
                          PieceTestee,
                          ScoreNoeudPrecedentActuellement,
                          1,
                          ListeCasesRestantes,
                          IndSuivantListeCasesRestantes,
                          IndSuivantPiece,
                          ProfondeurMax,
                          ProfondeurMax,
                          NumeroSuivant,
                          NumeroMax),
    ScoreNoeud<ScoreNoeudPrecedentActuellement,
    NouvelleProfondeur is Profondeur+1,
    listePiecesRestantes(NoeudPlateau, ListePiecesRestantes),
    nth1(1, ListePiecesRestantes, NouvellePieceTestee),
    listeCasesRestantes(NoeudPlateau, [], 1, NouvelleListeCasesRestantes),
    length(NouvelleListeCasesRestantes, NumeroMaxNiveauSuivant),
    nth1(1, NouvelleListeCasesRestantes, IndNouvellePiece),
    changerElemListe(IndNouvellePiece, NouvellePieceTestee, NoeudPlateau, NoeudPlateauNiveauSuivant),
    creationNoeudDuNiveau(NoeudPlateauNiveauSuivant,
                          NouvellePieceTestee,
                          ScoreNoeud,
                          0,
                          NouvelleListeCasesRestantes,
                          1,
                          IndNouvellePiece,
                          NouvelleProfondeur,
                          ProfondeurMax,
                          1,
                          NumeroMaxNiveauSuivant).
    % on veut minimiser le score du noeud précédent (MinOrMax == 0) et ce noeud a un score plus petit
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeud, 0, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, Profondeur, ProfondeurMax, Numero, NumeroMax) :-
    NumeroSuivant is Numero+1,
    changerElemListe(IndPiece, vide, NoeudPlateau, NoeudPlateauIntermediaire),
    IndSuivantListeCasesRestantes is IndListeCasesRestantes+1,
    nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece),
    changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant),
    creationNoeudDuNiveau(NoeudPlateauSuivant,
                          PieceTestee,
                          ScoreNoeudPrecedentActuellement,
                          0,
                          ListeCasesRestantes,
                          IndSuivantListeCasesRestantes,
                          IndSuivantPiece,
                          ProfondeurMax,
                          ProfondeurMax,
                          NumeroSuivant,
                          NumeroMax),
    ScoreNoeud<ScoreNoeudPrecedentActuellement,
    NouvelleProfondeur is Profondeur+1,
    listePiecesRestantes(NoeudPlateau, ListePiecesRestantes),
    nth1(1, ListePiecesRestantes, NouvellePieceTestee),
    listeCasesRestantes(NoeudPlateau, [], 1, NouvelleListeCasesRestantes),
    length(NouvelleListeCasesRestantes, NumeroMaxNiveauSuivant),
    nth1(1, NouvelleListeCasesRestantes, IndNouvellePiece),
    changerElemListe(IndNouvellePiece, NouvellePieceTestee, NoeudPlateau, NoeudPlateauNiveauSuivant),
    creationNoeudDuNiveau(NoeudPlateauNiveauSuivant,
                          NouvellePieceTestee,
                          ScoreNoeud,
                          1,
                          NouvelleListeCasesRestantes,
                          1,
                          IndNouvellePiece,
                          NouvelleProfondeur,
                          ProfondeurMax,
                          1,
                          NumeroMaxNiveauSuivant).
    % on veut minimiser le score du noeud précédent (MinOrMax == 0) et ce noeud a un score plus grand
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeudPrecedentActuellement, 0, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, Profondeur, ProfondeurMax, Numero, NumeroMax) :-
    NumeroSuivant is Numero+1,
    changerElemListe(IndPiece, vide, NoeudPlateau, NoeudPlateauIntermediaire),
    IndSuivantListeCasesRestantes is IndListeCasesRestantes+1,
    nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece),
    changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant),
    creationNoeudDuNiveau(NoeudPlateauSuivant,
                          PieceTestee,
                          ScoreNoeudPrecedentActuellement,
                          0,
                          ListeCasesRestantes,
                          IndSuivantListeCasesRestantes,
                          IndSuivantPiece,
                          ProfondeurMax,
                          ProfondeurMax,
                          NumeroSuivant,
                          NumeroMax),
    ScoreNoeud>ScoreNoeudPrecedentActuellement,
    NouvelleProfondeur is Profondeur+1,
    listePiecesRestantes(NoeudPlateau, ListePiecesRestantes),
    nth1(1, ListePiecesRestantes, NouvellePieceTestee),
    listeCasesRestantes(NoeudPlateau, [], 1, NouvelleListeCasesRestantes),
    length(NouvelleListeCasesRestantes, NumeroMaxNiveauSuivant),
    nth1(1, NouvelleListeCasesRestantes, IndNouvellePiece),
    changerElemListe(IndNouvellePiece, NouvellePieceTestee, NoeudPlateau, NoeudPlateauNiveauSuivant),
    creationNoeudDuNiveau(NoeudPlateauNiveauSuivant,
                          NouvellePieceTestee,
                          ScoreNoeud,
                          1,
                          NouvelleListeCasesRestantes,
                          1,
                          IndNouvellePiece,
                          NouvelleProfondeur,
                          ProfondeurMax,
                          1,
                          NumeroMaxNiveauSuivant).