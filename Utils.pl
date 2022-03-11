% Liste des 16 pièces possibles
listeToutesLesPieces([[grand, carre, creux, blanc], [grand, carre, creux, noir], [grand, carre, plein, blanc], [grand, carre, plein, noir], [grand, rond, creux, blanc], [grand, rond, creux, noir], [grand, rond, plein, blanc], [grand, rond, plein, noir], [petit, carre, creux, blanc], [petit, carre, creux, noir], [petit, carre, plein, blanc], [petit, carre, plein, noir], [petit, rond, creux, blanc], [petit, rond, creux, noir], [petit, rond, plein, blanc], [petit, rond, plein, noir]]).

% Retourne les pieces restantes dans ListePiecesRestantes
listePiecesRestantes(Plateau, ListePiecesRestantes) :-
    listeToutesLesPieces(ListeToutesLesPieces),
    subtract(ListeToutesLesPieces, Plateau, ListePiecesRestantes).

% Retourne la liste des cases restantes sur le plateau dans ListeCasesRestanteComplete
% Doit toujours être appelé comme suit : listeCasesRestantes(Plateau, [], 1, ListeRetournée)
% La liste retournée est sous la forme [1,2,3, ... , 16] 
    % Cas d'arrêt : on arrive à l'étuide de la 16ème case du plateau
        % la 16ème case est vide et on l'ajoute à la liste des cases restantes
listeCasesRestantes(Plateau, ListeCasesRestantes, 16, ListeCasesRestantesComplete) :-
    nth1(16, Plateau, vide),
    append(ListeCasesRestantes, [16], ListeCasesRestantesComplete).

        % la 16ème case n'est pas vide
listeCasesRestantes(_, ListeCasesRestantes, 16, ListeCasesRestantes).

    % Cas général
        % case vide
listeCasesRestantes(Plateau, ListeCasesRestantes, Ind, ListeCasesRestantesComplete) :-
    nth1(Ind, Plateau, vide),
    append(ListeCasesRestantes, [Ind], NouvelleListeCasesRestantes),
    Ind2 is Ind+1,
    listeCasesRestantes(Plateau, NouvelleListeCasesRestantes, Ind2, ListeCasesRestantesComplete).

        % case pas vide
listeCasesRestantes(Plateau, ListeCasesRestantes, Ind, ListeCasesRestantesComplete) :-
    Ind2 is Ind+1,
    listeCasesRestantes(Plateau, ListeCasesRestantes, Ind2, ListeCasesRestantesComplete).


% Change l'élément placé à l'indice Ind dans la liste [T|Q] en Elem
changerElemListe(1, Elem, [_|Q], [Elem|Q]).
changerElemListe(Ind, Elem, [T|Q], L2) :-
    append([T], L1, L2),
    Ind2 is Ind-1,
    changerElemListe(Ind2, Elem, Q, L1).
