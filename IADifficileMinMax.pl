:- ['Utils.pl'].
:- ['Pieces.pl'].
:- ['EvaluationScore.pl'].


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