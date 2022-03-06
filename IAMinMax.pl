minMax(NoeudPlateau, ScoreNoeud, 0, _, _):- ScoreNoeud is score(NoeudPlateau).
minMax(NoeudPlateau, ScoreNoeud, _, _, _):- ScoreNoeud is score(NoeudPlateau), ScoreNoeud > 999.
minMax(NoeudPlateau, ScoreNoeud, Profondeur, PieceAJouer, IndPiece):- Profondeur > 0, NouvelleProfondeur is Profondeur -1, creationNouveauNoeud(PieceAJouer, IndPiece, NoeudPlateau, NouveauPlateau), minMax(NouveauPlateau, ScoreNoeud, NouvelleProfondeur, PieceAJouer, IndPiece).

creationNouveauNoeud(P,Ind,Plateau,NouveauPlateau):- nth1(Ind,Plateau,vide()),changerElemListe(Ind,P,Plateau,NouveauPlateau).

% Change l'élément placé à l'indice Ind dans la liste [T|Q] en Elem
changerElemListe(1,Elem,[_|Q],[Elem|Q]).
changerElemListe(Ind,Elem,[T|Q],L2):- append([T],L1,L2),Ind2 is Ind-1,changerElemListe(Ind2,Elem,Q,L1).

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

%Ensemble des pièces
piece1(1,[grand, carre, creux, blanc]).
piece2(2,[grand, carre, creux, noir]).
piece3(3,[grand, carre, plein, blanc]).
piece4(4,[grand, carre, plein, noir]).
piece5(5,[grand, rond, creux, blanc]).
piece6(6,[grand, rond, creux, noir]).
piece7(7,[grand, rond, plein, blanc]).
piece8(8,[grand, rond, plein, noir]).
piece9(9,[petit, carre, creux, blanc]).
piece10(10,[petit, carre, creux, noir]).
piece11(11,[petit, carre, plein, blanc]).
piece12(12,[petit, carre, plein, noir]).
piece13(13,[petit, rond, creux, blanc]).
piece14(14,[petit, rond, creux, noir]).
piece15(15,[petit, rond, plein, blanc]).
piece16(16,[petit, rond, plein, noir]).

listeToutesLesPieces([[grand, carre, creux, blanc],[grand, carre, creux, noir],[grand, carre, plein, blanc],[grand, carre, plein, noir],[grand, rond, creux, blanc],[grand, rond, creux, noir],[grand, rond, plein, blanc],[grand, rond, plein, noir],[petit, carre, creux, blanc],[petit, carre, creux, noir],[petit, carre, plein, blanc],[petit, carre, plein, noir],[petit, rond, creux, blanc],[petit, rond, creux, noir],[petit, rond, plein, blanc],[petit, rond, plein, noir]]).

listePiecesRestantes(Plateau,ListeToutesLesPieces,ListePiecesRestantes):- listeToutesLesPieces(ListeToutesLesPieces),subtract(ListeToutesLesPieces,Plateau,ListePiecesRestantes).

listeCasesRestantes(Plateau,ListeCasesRestantes,16,ListeCasesRestantesComplete):- nth1(16,Plateau,vide()), append(ListeCasesRestantes,16,ListeCasesRestantesComplete).
listeCasesRestantes(Plateau,ListeCasesRestantes,16,ListeCasesRestantes).
listeCasesRestantes(Plateau,ListeCasesRestantes,Ind,ListeCasesRestantesComplete):- nth1(Ind,Plateau,vide()), append(ListeCasesRestantes,Ind,NouvelleListeCasesRestantes), Ind2 is Ind+1, ListeCasesRestantes(Plateau,NouvelleListeCasesRestantes,Ind2,ListeCasesRestantesComplete).
listeCasesRestantes(Plateau,ListeCasesRestantes,Ind,ListeCasesRestantesComplete):- Ind2 is Ind+1, ListeCasesRestantes(Plateau, ListeCasesRestantes,Ind2,ListeCasesRestantesComplete).
