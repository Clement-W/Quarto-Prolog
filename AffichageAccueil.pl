% Affiche quatro dans la console
afficherTitre() :-
    write(" ________   ___  ___   ________   ________   _________   ________     "),
    nl,
    write("|\\   __  \\ |\\  \\|\\  \\ |\\   __  \\ |\\   __  \\ |\\___   ___\\|\\   __  \\    "),
    nl,
    write("\\ \\  \\|\\  \\\\ \\  \\\\\\  \\\\ \\  \\|\\  \\\\ \\  \\|\\  \\\\|___ \\  \\_|\\ \\  \\|\\  \\   "),
    nl,
    write(" \\ \\  \\\\\\  \\\\ \\  \\\\\\  \\\\ \\   __  \\\\ \\   _  _\\    \\ \\  \\  \\ \\  \\\\\\  \\  "),
    nl,
    write("  \\ \\  \\\\\\  \\\\ \\  \\\\\\  \\\\ \\  \\ \\  \\\\ \\  \\\\  \\|    \\ \\  \\  \\ \\  \\\\\\  \\ "),
    nl,
    write("   \\ \\_____  \\\\ \\_______\\\\ \\__\\ \\__\\\\ \\__\\\\ _\\     \\ \\__\\  \\ \\_______\\"),
    nl,
    write("    \\|___| \\__\\\\|_______| \\|__|\\|__| \\|__|\\|__|     \\|__|   \\|_______|"),
    nl,
    write("          \\|__| ").

% Affiche des informations sur le jeu
afficherTexteAccueil() :-
    write("Objectif du jeu Quarto : "),
    nl,
    write("Aligner 4 pieces ayant au moins un point commun entre elles. Mais attention, ce n'est pas vous qui choisissez votre piece, c'est l'adversaire ! A chaque tour, choisissez une piece pour votre adversaire, puis placez la piece qu'il a choisi pour vous."),
    nl,
    nl,
    write("* grand ou petit"),
    nl,
    write("* carre ou rond"),
    nl,
    write("* creux ou plein"),
    nl,
    write("* blanc ou noir"),
    nl,
    nl,
    write("Pour choisir une piece, il faut par exemple rentrer [grand,carre,creux,blanc] dans la console.").