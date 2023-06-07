#include "processus.h"
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

/* Ajouter un processus dans la liste */
void ajouterProcessus(TabProcessus *listeProcessus, pid_t pid, ETAT etat, char *action) {
    int taille = listeProcessus->taille;
    listeProcessus->liste[taille].pid = pid;
    listeProcessus->liste[taille].etat = etat;
    strcpy(listeProcessus->liste[taille].action, action);
    listeProcessus->taille++;
}

/* Obtenir l'identifiant d'un processus en fonction d'un PID */
int getID(TabProcessus *listeProcessus, pid_t pid) {
    for (int position = 0; listeProcessus->taille > position; position++) {
        if (listeProcessus->liste[position].pid == pid) {
            return position + 1;
        }
    }
    return 0;
}

/* Obtenir le PID d'un processus en fonction d'un identifiant */
pid_t getPID(TabProcessus *listeProcessus, int id) {
    if (id > listeProcessus->taille) {
        return -1;
    }
    return listeProcessus->liste[id-1].pid;
}

pid_t getProcActif(TabProcessus *listeProcessus) {
    for (int position = 0; listeProcessus->taille > position; position++) {
        if (listeProcessus->liste[position].etat == ACTIF) {
            return listeProcessus->liste[position].pid;
        }
    }
    return -1;
}

/* Retourne la chaine de caractère associé à un état */
char *etatAffichage(ETAT etat) {
    switch (etat) {
        case ACTIF:
            return "ACTIF     ";
            break;
        case SUSPENDU:
            return "SUSPENDU  ";
            break;
        case TERMINE:
            return "TERMINE   ";
            break;
        case INTERROMPU:
            return "INTERROMPU";
            break;
        default:
            return "ERREUR    ";
            break;
    }
}

/* Supprime un processus de la liste */
void supprimerProcessus(TabProcessus *listeProcessus, int id) {
    if (id == -1) {                         //tuer tout les processus
        free(listeProcessus->liste);
        free(listeProcessus);
        listeProcessus = NULL;
    } else if (listeProcessus->liste[id - 1].pid != 0) {  //tuer le processus id
        while (listeProcessus->taille > id) {   //décaler les processus suivants
            listeProcessus->liste[id - 1] = listeProcessus->liste[id];
            id++;
        }
        listeProcessus->taille--;
    } else {
        perror("Le processus demandé n'existe pas\n");
    }
    
}

/* Affiche la liste des processus */
void afficherProcessus(TabProcessus *listeProcessus) {
    printf("------------------------Liste des processus------------------------\n");
    printf("  ID              PID                 ETAT              ACTION\n");
    for (int position = 0; listeProcessus->taille > position; position++) {
        if (listeProcessus->liste[position].etat != TERMINE) {
            printf("  %d               %u                 %s        %s\n", position + 1, listeProcessus->liste[position].pid, etatAffichage(listeProcessus->liste[position].etat), listeProcessus->liste[position].action);
        }
    }
    printf("-------------------------------------------------------------------\n");
}

/* Change l'état d'un processus */
void changerEtatProcessus(TabProcessus *listeProcessus, int id, ETAT nouvelEtat) {
    if (listeProcessus->liste[id-1].pid == 0) {
        perror("Le processus n'existe pas\n");
    }
    listeProcessus->liste[id-1].etat = nouvelEtat;
}
