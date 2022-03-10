%minMax(NoeudPlateau, ScoreNoeud, 0, _, _):- ScoreNoeud is score(NoeudPlateau).
%minMax(NoeudPlateau, ScoreNoeud, _, _, _):- ScoreNoeud is score(NoeudPlateau), ScoreNoeud > 999. %Peu-être pas pertinent
%minMax(NoeudPlateau, ScoreNoeud, Profondeur, PieceAJouer, IndPiece):- Profondeur > 0, NouvelleProfondeur is Profondeur -1, creationNouveauNoeud(PieceAJouer, IndPiece, NoeudPlateau, NouveauPlateau), minMax(NouveauPlateau, ScoreNoeud, NouvelleProfondeur, PieceAJouer, IndPiece).
:- include('Utils.pl').

minMax(Plateau, PieceASelectionner, _):- listePiecesRestantes(Plateau, ListePiecesRestantes),length(ListePiecesRestantes, NbPiecesRestantes), premierEtage(Plateau, ListePiecesRestantes, PieceASelectionner, 0, 1, NbPiecesRestantes).
minMax(Plateau, PieceAPlacer, IndPieceAJouer):- listePiecesRestantes(Plateau, ListePiecesRestantes), substract(ListePiecesRestantes, [PieceAPlacer], ListesPiecesRestantesSansLaPieceAPlacer) , length(ListesPiecesRestantesSansLaPieceAPlacer, NbPiecesRestantes), premierEtage(Plateau, ListesPiecesRestantesSansLaPieceAPlacer, PieceAPlacer, IndPieceAJouer, 1).

%premierEtage(Plateau, ListePiecesRestantes, PieceASelectionner, 0, IndPieceRestante, NbPiecesRestantes):- nth1(IndPieceRestante, ListePiecesRestantes, PieceATester), creationNoeudDuNiveau().

% TODO: savoir s'il faut juste répeter vide(). ou importer Piece.pl
vide().

score(Plateau, Score) :-
    evaluerLignes(Plateau, ScoreLignes),
    evaluerColonnes(Plateau, ScoreColonnes),
    evaluerDiagonales(Plateau, ScoreDiagonales),
    Score is ScoreLignes+ScoreColonnes+ScoreDiagonales.

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

% Cas de victoire
evaluation([X, _, _, _], [X, _, _, _], [X, _, _, _], [X, _, _, _], 1000).
evaluation([_, X, _, _], [_, X, _, _], [_, X, _, _], [_, X, _, _], 1000).
evaluation([_, _, X, _], [_, _, X, _], [_, _, X, _], [_, _, X, _], 1000).
evaluation([_, _, _, X], [_, _, _, X], [_, _, _, X], [_, _, _, X], 1000).

% L'évaluation vaut 3
evaluation([X, _, _, _], [X, _, _, _], [X, _, _, _], vide(), 3).
evaluation([X, _, _, _], [X, _, _, _], vide(), [X, _, _, _], 3).
evaluation([X, _, _, _], vide(), [X, _, _, _], [X, _, _, _], 3).
evaluation(vide(), [X, _, _, _], [X, _, _, _], [X, _, _, _], 3).

evaluation([_, X, _, _], [_, X, _, _], [_, X, _, _], vide(), 3).
evaluation([_, X, _, _], [_, X, _, _], vide(), [_, X, _, _], 3).
evaluation([_, X, _, _], vide(), [_, X, _, _], [_, X, _, _], 3).
evaluation(vide(), [_, X, _, _], [_, X, _, _], [_, X, _, _], 3).

evaluation([_, _, X, _], [_, _, X, _], [_, _, X, _], vide(), 3).
evaluation([_, _, X, _], [_, _, X, _], vide(), [_, _, X, _], 3).
evaluation([_, _, X, _], vide(), [_, _, X, _], [_, _, X, _], 3).
evaluation(vide(), [_, _, X, _], [_, _, X, _], [_, _, X, _], 3).

evaluation([_, _, _, X], [_, _, _, X], [_, _, _, X], vide(), 3).
evaluation([_, _, _, X], [_, _, _, X], vide(), [_, _, _, X], 3).
evaluation([_, _, _, X], vide(), [_, _, _, X], [_, _, _, X], 3).
evaluation(vide(), [_, _, _, X], [_, _, _, X], [_, _, _, X], 3).

% L'évaluation vaut 2
evaluation([X, _, _, _], [X, _, _, _], vide(), vide(), 2).
evaluation([X, _, _, _], vide(), [X, _, _, _], vide(), 2).
evaluation(vide(), [X, _, _, _], [X, _, _, _], vide(), 2).
evaluation([X, _, _, _], vide(), vide(), [X, _, _, _], 2).
evaluation(vide(), [X, _, _, _], vide(), [X, _, _, _], 2).
evaluation(vide(), vide(), [X, _, _, _], [X, _, _, _], 2).

evaluation([_, X, _, _], [_, X, _, _], vide(), vide(), 2).
evaluation([_, X, _, _], vide(), [_, X, _, _], vide(), 2).
evaluation(vide(), [_, X, _, _], [_, X, _, _], vide(), 2).
evaluation([_, X, _, _], vide(), vide(), [_, X, _, _], 2).
evaluation(vide(), [_, X, _, _], vide(), [_, X, _, _], 2).
evaluation(vide(), vide(), [_, X, _, _], [_, X, _, _], 2).

evaluation([_, _, X, _], [_, _, X, _], vide(), vide(), 2).
evaluation([_, _, X, _], vide(), [_, _, X, _], vide(), 2).
evaluation(vide(), [_, _, X, _], [_, _, X, _], vide(), 2).
evaluation([_, _, X, _], vide(), vide(), [_, _, X, _], 2).
evaluation(vide(), [_, _, X, _], vide(), [_, _, X, _], 2).
evaluation(vide(), vide(), [_, _, X, _], [_, _, X, _], 2).

evaluation([_, _, _, X], [_, _, _, X], vide(), vide(), 2).
evaluation([_, _, _, X], vide(), [_, _, _, X], vide(), 2).
evaluation(vide(), [_, _, _, X], [_, _, _, X], vide(), 2).
evaluation([_, _, _, X], vide(), vide(), [_, _, _, X], 2).
evaluation(vide(), [_, _, _, X], vide(), [_, _, _, X], 2).
evaluation(vide(), vide(), [_, _, _, X], [_, _, _, X], 2).

% Cas où il est impossible de gagner avec l'alignement des 4 emplacements évalués
evaluation(_, _, _, _, 0).


% Cas d'arrêt : profondeur maximale et fin de niveau
creationNoeudDuNiveau(NoeudPlateau, _, ScoreNoeudPrecedent, _, _, _, _, ProfondeurMax, ProfondeurMax, NumeroMax, NumeroMax):- score(NoeudPlateau,ScoreNoeudPrecedent).

% Cas profondeur maximale : 
    % on veut maximiser le score du noeud précédent (MinOrMax == 1) et ce noeud a un score plus grand 
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeud, 1, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, ProfondeurMax, ProfondeurMax, Numero, NumeroMax):- score(NoeudPlateau,ScoreNoeud), ScoreNoeud > ScoreNoeudPrecedentActuellement, NumeroSuivant is Numero+1, changerElemListe(IndPiece, vide(), NoeudPlateau, NoeudPlateauIntermediaire), IndSuivantListeCasesRestantes is IndListeCasesRestantes+1, nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece), changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant), creationNoeudDuNiveau(NoeudPlateauSuivant, PieceTestee, ScoreNoeudPrecedentActuellement, 1,ListeCasesRestantes, IndSuivantListeCasesRestantes, IndSuivantPiece, ProfondeurMax, ProfondeurMax, NumeroSuivant, NumeroMax).
    % on veut maximiser le score du noeud précédent (MinOrMax == 1) et ce noeud a un score plus petit 
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeudPrecedentActuellement, 1, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, ProfondeurMax, ProfondeurMax, Numero, NumeroMax):-  score(NoeudPlateau,ScoreNoeud), ScoreNoeud < ScoreNoeudPrecedentActuellement, NumeroSuivant is Numero+1, changerElemListe(IndPiece, vide(), NoeudPlateau, NoeudPlateauIntermediaire), IndSuivantListeCasesRestantes is IndListeCasesRestantes+1, nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece), changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant), creationNoeudDuNiveau(NoeudPlateauSuivant, PieceTestee, ScoreNoeudPrecedentActuellement, 1,ListeCasesRestantes, IndSuivantListeCasesRestantes, IndSuivantPiece, ProfondeurMax, ProfondeurMax, NumeroSuivant, NumeroMax).
    % on veut minimiser le score du noeud précédent (MinOrMax == 0) et ce noeud a un score plus petit 
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeud, 0, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, ProfondeurMax, ProfondeurMax, Numero, NumeroMax):- score(NoeudPlateau,ScoreNoeud), ScoreNoeud < ScoreNoeudPrecedentActuellement, NumeroSuivant is Numero+1, changerElemListe(IndPiece, vide(), NoeudPlateau, NoeudPlateauIntermediaire), IndSuivantListeCasesRestantes is IndListeCasesRestantes+1, nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece), changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant), creationNoeudDuNiveau(NoeudPlateauSuivant, PieceTestee, ScoreNoeudPrecedentActuellement, 0,ListeCasesRestantes, IndSuivantListeCasesRestantes, IndSuivantPiece, ProfondeurMax, ProfondeurMax, NumeroSuivant, NumeroMax).
    % on veut minimiser le score du noeud précédent (MinOrMax == 0) et ce noeud a un score plus grand 
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeudPrecedentActuellement, 0, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, ProfondeurMax, ProfondeurMax, Numero, NumeroMax):- score(NoeudPlateau,ScoreNoeud), ScoreNoeud > ScoreNoeudPrecedentActuellement, NumeroSuivant is Numero+1, changerElemListe(IndPiece, vide(), NoeudPlateau, NoeudPlateauIntermediaire), IndSuivantListeCasesRestantes is IndListeCasesRestantes+1, nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece), changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant), creationNoeudDuNiveau(NoeudPlateauSuivant, PieceTestee, ScoreNoeudPrecedentActuellement, 0,ListeCasesRestantes, IndSuivantListeCasesRestantes, IndSuivantPiece, ProfondeurMax, ProfondeurMax, NumeroSuivant, NumeroMax).


% Cas de profondeur non maximale et fin de niveau
    % on veut maximiser le score du noeud précédent (MinOrMax == 1) 
creationNoeudDuNiveau(NoeudPlateau, _, ScoreNoeud, 1, _, _, _, Profondeur, ProfondeurMax, NumeroMax, NumeroMax):-  NouvelleProfondeur is Profondeur+1, listePiecesRestantes(NoeudPlateau, ListePiecesRestantes), nth1(1, ListePiecesRestantes, NouvellePieceTestee), listeCasesRestantes(NoeudPlateau,[], 1, NouvelleListeCasesRestantes), length(NouvelleListeCasesRestantes, NumeroMaxNiveauSuivant), nth1(1, NouvelleListeCasesRestantes, IndNouvellePiece), changerElemListe(IndNouvellePiece, NouvellePieceTestee, NoeudPlateau, NoeudPlateauNiveauSuivant), creationNoeudDuNiveau(NoeudPlateauNiveauSuivant, NouvellePieceTestee, ScoreNoeud, 0, NouvelleListeCasesRestantes, 1, IndNouvellePiece, NouvelleProfondeur, ProfondeurMax, 1, NumeroMaxNiveauSuivant).
    % on veut minimiser le score du noeud précédent (MinOrMax == 0) 
creationNoeudDuNiveau(NoeudPlateau, _, ScoreNoeud, 0, _, _, _, Profondeur, ProfondeurMax, NumeroMax, NumeroMax):- NouvelleProfondeur is Profondeur+1, listePiecesRestantes(NoeudPlateau, ListePiecesRestantes), nth1(1, ListePiecesRestantes, NouvellePieceTestee), listeCasesRestantes(NoeudPlateau,[], 1, NouvelleListeCasesRestantes), length(NouvelleListeCasesRestantes, NumeroMaxNiveauSuivant), nth1(1, NouvelleListeCasesRestantes, IndNouvellePiece), changerElemListe(IndNouvellePiece, NouvellePieceTestee, NoeudPlateau, NoeudPlateauNiveauSuivant), creationNoeudDuNiveau(NoeudPlateauNiveauSuivant, NouvellePieceTestee, ScoreNoeud, 1, NouvelleListeCasesRestantes, 1, IndNouvellePiece, NouvelleProfondeur, ProfondeurMax, 1, NumeroMaxNiveauSuivant).
  

% Cas de profondeur non maximale et non fin de niveau
    % on veut maximiser le score du noeud précédent (MinOrMax == 1) et ce noeud a un score plus grand 
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeud, 1, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, Profondeur, ProfondeurMax, Numero, NumeroMax):- ScoreNoeud > ScoreNoeudPrecedentActuellement, NumeroSuivant is Numero+1, changerElemListe(IndPiece, vide(), NoeudPlateau, NoeudPlateauIntermediaire), IndSuivantListeCasesRestantes is IndListeCasesRestantes+1, nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece), changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant), creationNoeudDuNiveau(NoeudPlateauSuivant, PieceTestee, ScoreNoeudPrecedentActuellement, 1,ListeCasesRestantes, IndSuivantListeCasesRestantes, IndSuivantPiece, ProfondeurMax, ProfondeurMax, NumeroSuivant, NumeroMax), NouvelleProfondeur is Profondeur+1, listePiecesRestantes(NoeudPlateau, ListePiecesRestantes), nth1(1, ListePiecesRestantes, NouvellePieceTestee), listeCasesRestantes(NoeudPlateau,[], 1, NouvelleListeCasesRestantes), length(NouvelleListeCasesRestantes, NumeroMaxNiveauSuivant), nth1(1, NouvelleListeCasesRestantes, IndNouvellePiece), changerElemListe(IndNouvellePiece, NouvellePieceTestee, NoeudPlateau, NoeudPlateauNiveauSuivant), creationNoeudDuNiveau(NoeudPlateauNiveauSuivant, NouvellePieceTestee, ScoreNoeud, 0, NouvelleListeCasesRestantes, 1, IndNouvellePiece, NouvelleProfondeur, ProfondeurMax, 1, NumeroMaxNiveauSuivant).
    % on veut maximiser le score du noeud précédent (MinOrMax == 1) et ce noeud a un score plus petit
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeudPrecedentActuellement, 1, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, Profondeur, ProfondeurMax, Numero, NumeroMax):- ScoreNoeud < ScoreNoeudPrecedentActuellement, NumeroSuivant is Numero+1, changerElemListe(IndPiece, vide(), NoeudPlateau, NoeudPlateauIntermediaire), IndSuivantListeCasesRestantes is IndListeCasesRestantes+1, nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece), changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant), creationNoeudDuNiveau(NoeudPlateauSuivant, PieceTestee, ScoreNoeudPrecedentActuellement, 1,ListeCasesRestantes, IndSuivantListeCasesRestantes, IndSuivantPiece, ProfondeurMax, ProfondeurMax, NumeroSuivant, NumeroMax), NouvelleProfondeur is Profondeur+1, listePiecesRestantes(NoeudPlateau, ListePiecesRestantes), nth1(1, ListePiecesRestantes, NouvellePieceTestee), listeCasesRestantes(NoeudPlateau,[], 1, NouvelleListeCasesRestantes), length(NouvelleListeCasesRestantes, NumeroMaxNiveauSuivant), nth1(1, NouvelleListeCasesRestantes, IndNouvellePiece), changerElemListe(IndNouvellePiece, NouvellePieceTestee, NoeudPlateau, NoeudPlateauNiveauSuivant), creationNoeudDuNiveau(NoeudPlateauNiveauSuivant, NouvellePieceTestee, ScoreNoeud, 0, NouvelleListeCasesRestantes, 1, IndNouvellePiece, NouvelleProfondeur, ProfondeurMax, 1, NumeroMaxNiveauSuivant).
    % on veut minimiser le score du noeud précédent (MinOrMax == 0) et ce noeud a un score plus petit
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeud, 0, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, Profondeur, ProfondeurMax, Numero, NumeroMax):- ScoreNoeud < ScoreNoeudPrecedentActuellement, NumeroSuivant is Numero+1, changerElemListe(IndPiece, vide(), NoeudPlateau, NoeudPlateauIntermediaire), IndSuivantListeCasesRestantes is IndListeCasesRestantes+1, nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece), changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant), creationNoeudDuNiveau(NoeudPlateauSuivant, PieceTestee, ScoreNoeudPrecedentActuellement, 0,ListeCasesRestantes, IndSuivantListeCasesRestantes, IndSuivantPiece, ProfondeurMax, ProfondeurMax, NumeroSuivant, NumeroMax), NouvelleProfondeur is Profondeur+1, listePiecesRestantes(NoeudPlateau, ListePiecesRestantes), nth1(1, ListePiecesRestantes, NouvellePieceTestee), listeCasesRestantes(NoeudPlateau,[], 1, NouvelleListeCasesRestantes), length(NouvelleListeCasesRestantes, NumeroMaxNiveauSuivant), nth1(1, NouvelleListeCasesRestantes, IndNouvellePiece), changerElemListe(IndNouvellePiece, NouvellePieceTestee, NoeudPlateau, NoeudPlateauNiveauSuivant), creationNoeudDuNiveau(NoeudPlateauNiveauSuivant, NouvellePieceTestee, ScoreNoeud, 1, NouvelleListeCasesRestantes, 1, IndNouvellePiece, NouvelleProfondeur, ProfondeurMax, 1, NumeroMaxNiveauSuivant).
    % on veut minimiser le score du noeud précédent (MinOrMax == 0) et ce noeud a un score plus grand
creationNoeudDuNiveau(NoeudPlateau, PieceTestee, ScoreNoeudPrecedentActuellement, 0, ListeCasesRestantes, IndListeCasesRestantes, IndPiece, Profondeur, ProfondeurMax, Numero, NumeroMax):- ScoreNoeud > ScoreNoeudPrecedentActuellement, NumeroSuivant is Numero+1, changerElemListe(IndPiece, vide(), NoeudPlateau, NoeudPlateauIntermediaire), IndSuivantListeCasesRestantes is IndListeCasesRestantes+1, nth1(IndSuivantListeCasesRestantes, ListeCasesRestantes, IndSuivantPiece), changerElemListe(IndSuivantPiece, PieceTestee, NoeudPlateauIntermediaire, NoeudPlateauSuivant), creationNoeudDuNiveau(NoeudPlateauSuivant, PieceTestee, ScoreNoeudPrecedentActuellement, 0,ListeCasesRestantes, IndSuivantListeCasesRestantes, IndSuivantPiece, ProfondeurMax, ProfondeurMax, NumeroSuivant, NumeroMax), NouvelleProfondeur is Profondeur+1, listePiecesRestantes(NoeudPlateau, ListePiecesRestantes), nth1(1, ListePiecesRestantes, NouvellePieceTestee), listeCasesRestantes(NoeudPlateau,[], 1, NouvelleListeCasesRestantes), length(NouvelleListeCasesRestantes, NumeroMaxNiveauSuivant), nth1(1, NouvelleListeCasesRestantes, IndNouvellePiece), changerElemListe(IndNouvellePiece, NouvellePieceTestee, NoeudPlateau, NoeudPlateauNiveauSuivant), creationNoeudDuNiveau(NoeudPlateauNiveauSuivant, NouvellePieceTestee, ScoreNoeud, 1, NouvelleListeCasesRestantes, 1, IndNouvellePiece, NouvelleProfondeur, ProfondeurMax, 1, NumeroMaxNiveauSuivant).

%creationNoeudDuNiveau(Plateau, MeilleurPieceASelectionner, _, 1, ListeCasesRestantes, _, IndPiece, 0, ProfondeurMax, 1, 1):-