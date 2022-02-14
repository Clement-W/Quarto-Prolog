:- include('Pieces.pl').

plateau([_]).

appartenance(X, [X|_]).
appartenance(X, [_|Q]):- appartenance(X,Q).

conc([],L,L).
conc([T|Q],L,[T|LC]):- conc(Q,L,LC).

% ajouter(X,L1,L2) :- conc(L1,[X],L2).

ajouterPiece(X,Y,Piece) 