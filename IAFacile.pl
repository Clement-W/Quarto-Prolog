:- ['Utils.pl'].

% IA qui choisit ses coups aléatoirements

% Sélection d'une pièce aléatoirement dans la liste de pièces restantes
selectionnerPieceIAFacile(P, Plateau) :-
    listePiecesRestantes(Plateau, ListePiecesRestantes),
    random_member(P, ListePiecesRestantes).

% Placement aléatoire d'une pièce sur le plateau
placerPieceIAFacile(P, Plateau, NouveauPlateau) :-
    listeCasesRestantes(Plateau, [], 1, ListeCasesRestantes),
    random_member(IndicePosition, ListeCasesRestantes),
    changerElemListe(IndicePosition, P, Plateau, NouveauPlateau).

