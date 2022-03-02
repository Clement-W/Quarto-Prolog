:- include('Pieces.pl').

%emplacement(X):- piece(X).
%emplacement(X):- functor(X,vide,0).

installerJeu():- jouer([vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide(),vide()]).

jouer(Plateau):-selectPiece(P,Plateau),placerPiece(P,Plateau,NouveauPlateau),verifVictoire(NouveauPlateau).

selectPiece(P,Plateau):- repeat,write("Sélectionnez une pièce pour votre adversaire"),read(P),pieceSelectionnable(P,Plateau).
pieceSelectionnable(P,Plateau):- piece(P), not(memberchk(P, Plateau)).

placerPiece(P,Plateau,NouveauPlateau):- repeat,write("Choisissez la ligne"),read(X),write("Choisissez la colonne"),read(Y), Ind is (X-1)*4+Y, nth1(Ind,Plateau,vide()),changerElemListe(Ind,P,Plateau,NouveauPlateau).

changerElemListe(1,Elem,[_|Q],[Elem|Q]).
changerElemListe(Ind,Elem,[T|Q],L2):- append([T],L1,L2),Ind2 is Ind-1,changerElemListe(Ind2,Elem,Q,L1).

%Vérifie que les 4 entrées sont bien des pièces
quatuorDePieces(P1,P2,P3,P4):- piece(P1),piece(P2),piece(P3),piece(P4).

%TODO: Optimiser verifAlignement 
verifAlignement(P1,P2,P3,P4,Ind):- quatuorDePieces(P1,P2,P3,P4),nth1(Ind,P1,Carac),nth1(Ind,P2,Carac),nth1(Ind,P3,Carac),nth1(Ind,P4,Carac).%, NewInd is Ind+1, verifAlignement(P1,P2,P3,P4,NewInd).

%ÉCRIRE TOUS LES CAS DE VICTOIRE ICI
verifVictoire(Plateau):- verifAlignement(nth1(1,Plateau,P1),nth1(2,Plateau,P1),nth1(3,Plateau,P1),nth1(4,Plateau,P1),1)
verifVictoire(Plateau):- write("Pas de victoire"),jouer(Plateau). %dernier cas, il n'y a pas de victoire

