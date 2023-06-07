#include "processus.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    TabProcessus *listeProcessus;
    listeProcessus = malloc(sizeof(TabProcessus));
    ajouterProcessus(listeProcessus, fork(), ACTIF, "fork 1");
    ajouterProcessus(listeProcessus, fork(), ACTIF, "fork 2");

    if (listeProcessus->liste[0].pid == 0) { // processus fils 1
        printf("Je suis le processus fils 1\n");
        sleep(5);
        exit(0);
    } else if (listeProcessus->liste[1].pid == 0) { // processus fils 2
        printf("Je suis le processus fils 2\n");
        sleep(3);
        exit(0);
    } else { // processus parent
        printf("Je suis le processus parent\n");
        afficherProcessus(listeProcessus);

        sleep(2);
        changerEtatProcessus(listeProcessus, 1, SUSPENDU);
        printf("Processus 1 suspendu\n");
        afficherProcessus(listeProcessus);

        sleep(2);
        supprimerProcessus(listeProcessus, 2);
        printf("Processus 2 supprimé\n");
        afficherProcessus(listeProcessus);

        int status;
        waitpid(listeProcessus->liste[0].pid, &status, 0);
        changerEtatProcessus(listeProcessus, 1, TERMINE);
        printf("Processus 1 terminé\n");
        afficherProcessus(listeProcessus);

        sleep(2);
        supprimerProcessus(listeProcessus, -1);
        printf("Tous les processus supprimés\n");
        afficherProcessus(listeProcessus);
    }

    return 0;
}
