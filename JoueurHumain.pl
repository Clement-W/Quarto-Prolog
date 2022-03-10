:- ['Pieces.pl'].
:- ['Utils.pl'].

% Sélection de la pièce par J1
selectPiece(P, Plateau) :-
    repeat,
    nl,
    write("Selectionnez une piece pour votre adversaire :"),
    nl,
    read(P),
    pieceSelectionnable(P, Plateau).

% Vérifie que la sélection correspond à une pièce, qui n'est pas déjà sur le plateau. 
pieceSelectionnable(P, Plateau) :-
    piece(P),
    not(memberchk(P, Plateau)).

% Placement d'une pièce par J2 sur le plateau (donne lieu à un nouveau plateau)
placerPiece(P, Plateau, NouveauPlateau) :-
    nl,
    write("X l'autre joueur de jouer."),
    nl,
    nl,
    repeat,
    write("Choisissez la ligne"),
    nl,
    read(X),
    X>0,
    X<5,
    write("Choisissez la colonne"),
    nl,
    read(Y),
    Y>0,
    Y<5,
    Ind is (X-1)*4+Y,
    nth1(Ind, Plateau, vide()),
    changerElemListe(Ind, P, Plateau, NouveauPlateau).
