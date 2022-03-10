:- include('Utils.pl').

% IA qui choisit ses coups aléatoirements
selectionnerPieceIAFacile(P, Plateau) :-
    listePiecesRestantes(Plateau, ListePiecesRestantes),
    random_member(P, ListePiecesRestantes).

placerPieceIAFacile(P, Plateau, NouveauPlateau) :-
    listeCasesRestantes(Plateau, [], 1, ListeCasesRestantes),
    random_member(IndicePosition, ListeCasesRestantes),
    changerElemListe(IndicePosition, P, Plateau, NouveauPlateau).

