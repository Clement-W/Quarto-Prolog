% Tout ce qui est en rapport avce l'affichage visuel du plateau.

% Affiche le plateau de jeu (on utilise un indice ind pour ne pas écrire 4 fois cette règle)
afficherPlateau(Plateau, 3) :-
    write(" | "),
    nth1(13, Plateau, P1),
    afficherCase(P1),
    write(" | "),
    nth1(14, Plateau, P2),
    afficherCase(P2),
    write(" | "),
    nth1(15, Plateau, P3),
    afficherCase(P3),
    write(" | "),
    nth1(16, Plateau, P4),
    afficherCase(P4),
    write(" | ").

afficherPlateau(Plateau, Ind) :-
    write(" | "),
    Case1 is Ind*4+1,
    nth1(Case1, Plateau, P1),
    afficherCase(P1),
    write(" | "),
    Case2 is Ind*4+2,
    nth1(Case2, Plateau, P2),
    afficherCase(P2),
    write(" | "),
    Case3 is Ind*4+3,
    nth1(Case3, Plateau, P3),
    afficherCase(P3),
    write(" | "),
    Case4 is Ind*4+4,
    nth1(Case4, Plateau, P4),
    afficherCase(P4),
    write(" | "),
    nl,
    write(" ----------------------------- "),
    nl,
    Ind2 is Ind+1,
    afficherPlateau(Plateau, Ind2).

% Permet d'afficher le contenu de chaque case possible du plateau
afficherCase(vide()) :-
    write("    ").
afficherCase([grand, carre, creux, blanc]) :-
    write("gccb").
afficherCase([grand, carre, creux, noir]) :-
    write("gccn").
afficherCase([grand, carre, plein, blanc]) :-
    write("gcpb").
afficherCase([grand, carre, plein, noir]) :-
    write("gcpn").
afficherCase([grand, rond, creux, blanc]) :-
    write("grcb").
afficherCase([grand, rond, creux, noir]) :-
    write("grcn").
afficherCase([grand, rond, plein, blanc]) :-
    write("grpb").
afficherCase([grand, rond, plein, noir]) :-
    write("grpn").
afficherCase([petit, carre, creux, blanc]) :-
    write("pccb").
afficherCase([petit, carre, creux, noir]) :-
    write("pccn").
afficherCase([petit, carre, plein, blanc]) :-
    write("pcpb").
afficherCase([petit, carre, plein, noir]) :-
    write("pcpn").
afficherCase([petit, rond, creux, blanc]) :-
    write("prcb").
afficherCase([petit, rond, creux, noir]) :-
    write("prcn").
afficherCase([petit, rond, plein, blanc]) :-
    write("prpb").
afficherCase([petit, rond, plein, noir]) :-
    write("prpn").