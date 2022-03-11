:- ['EvaluationScore.pl'].
:- ['Utils.pl'].

% IA de niveau moyen
selectionnerPieceIAMoyen(P, Plateau) :-
    listePiecesRestantes(Plateau, ListePiecesRestantes),
    length(ListePiecesRestantes, NbPiecesRestantes),
    listeCasesRestantes(Plateau, [], 1, ListeCasesRestantes),
    pieceASelectionner([_, P],
                       Plateau,
                       ListePiecesRestantes,
                       1,
                       NbPiecesRestantes,
                       ListeCasesRestantes).


placerPieceIAMoyen(P, Plateau, NouveauPlateau) :-
    listeCasesRestantes(Plateau, [], 1, ListeCasesRestantes),
    nl,
    length(ListeCasesRestantes, NbCasesRestantes),
    placeAChoisir(P,
                  Plateau,
                  ListeCasesRestantes,
                  1,
                  NbCasesRestantes,
                  [_, placeAChoisir]),
    nl,
    changerElemListe(placeAChoisir, P, Plateau, NouveauPlateau).


pieceASelectionner([ScorePieceTestee, PieceTestee], Plateau, ListePiecesRestantes, IndListesPiecesRestantes, NbPiecesRestantes, ListeCasesRestantes) :-
    nth1(IndListesPiecesRestantes, ListePiecesRestantes, PieceTestee),
    placeAChoisir(PieceTestee,
                  Plateau,
                  ListeCasesRestantes,
                  1,
                  NbPiecesRestantes,
                  [ScorePieceTestee, _]).

pieceASelectionner(ScoreEtPiece, Plateau, ListePiecesRestantes, IndListesPiecesRestantes, NbPiecesRestantes, ListeCasesRestantes) :-
    nth1(IndListesPiecesRestantes, ListePiecesRestantes, PieceTestee),
    placeAChoisir(PieceTestee,
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


placeAChoisir(P, Plateau, ListeCasesRestantes, NbCasesRestantes, NbCasesRestantes, [Score, IndPiece]) :-
    nth1(NbCasesRestantes, ListeCasesRestantes, IndPiece),
    changerElemListe(IndPiece, P, Plateau, NouveauPlateau),
    score(NouveauPlateau, Score).

placeAChoisir(P, Plateau, ListeCasesRestantes, IndListeCasesRestantes, NbCasesRestantes, ScoreEtIndice) :-
    nth1(IndListeCasesRestantes, ListeCasesRestantes, IndPiece),
    changerElemListe(IndPiece, P, Plateau, NouveauPlateau),
    score(NouveauPlateau, ScoreActuel),
    IndListeCasesRestantesSuivant is IndListeCasesRestantes+1,
    placeAChoisir(P, Plateau, ListeCasesRestantes, IndListeCasesRestantesSuivant, NbCasesRestantes, ScoreEtIndiceSuivant),
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
