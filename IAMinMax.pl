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

%score4
evaluation([X, _, _, _], [X, _, _, _], [X, _, _, _], [X, _, _, _], 4).
evaluation([_, X, _, _], [_, X, _, _], [_, X, _, _], [_, X, _, _], 4).
evaluation([_, _, X, _], [_, _, X, _], [_, _, X, _], [_, _, X, _], 4).
evaluation([_, _, _, X], [_, _, _, X], [_, _, _, X], [_, _, _, X], 4).

%score3
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

%score2 avec 2 vides
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

%score0
evaluation(_, _, _, _, 0).