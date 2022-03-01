:- include('Pieces.pl').

%emplacement(X):- piece(X).
%emplacement(X):- functor(X,vide,0).

%installerJeu():- length(Plateau, 16),jouer(Plateau).

jouer(Plateau):-selectPiece(P,Plateau),placerPiece(X,Y,P,Plateau,NouveauPlateau),verifVictoire(NouveauPlateau)).

selectPiece(P,Plateau):- repeat,read(P),pieceValide(P,Plateau).
pieceValide(P,Plateau):- piece(P), not(memberchk(P, Plateau)).

placerPiece(X,Y,P,Plateau,NouveauPlateau):- repeat, Ind is (X-1)*4+Y, nth1(Ind,Plateau,vide()),changerElemListe(Ind,P,Plateau,NouveauPlateau).

changerElemListe(1,Elem,[_|Q],[Elem|Q]).
changerElemListe(Ind,Elem,[T|Q],L2):- append([T],L1,L2),Ind2 is Ind-1,changerElemListe(Ind2,Elem,Q,L1).

%ÉCRIRE TOUS LES CAS DE VICTOIRE ICI
verifVictoire(Plateau):-jouer(Plateau). %dernier cas, il n'y a pas de victoire

