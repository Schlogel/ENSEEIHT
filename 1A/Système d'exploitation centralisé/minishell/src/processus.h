#ifndef PROCESSUS_H
#define PROCESSUS_H

#include <sys/wait.h>

#define MAX_NB_PROCE 200

/* Enumération des différents états */
typedef enum { ACTIF, SUSPENDU, TERMINE, INTERROMPU } ETAT ;

/* Structure d'un processus */
typedef struct {
    pid_t pid;          // Pid du processus
    ETAT etat;          // Etat du processus
    char action[256];   // Action du processus
} Processus;

/* Structure d'une liste de processus */
typedef struct {
    Processus liste[MAX_NB_PROCE];      // La position dans le tableau (i) correspond à l'identifiant du processus dans la liste (i+1)
    int taille;                         // Taille du tableau (case non vides)
} TabProcessus;

/* Ajouter un processus dans la liste */
void ajouterProcessus(TabProcessus *listeProcessus, pid_t pid, ETAT etat, char *action);

/* Retourne la chaine de caractère associé à un état */
char* etatAffichage(ETAT etat);

/* Supprime un processus de la liste */
void supprimerProcessus(TabProcessus *listeProcessus, int id);

/* Afficher la liste des processus */
void afficherProcessus(TabProcessus *listeProcessus);

/* Changer l'état d'un processus */
void changerEtatProcessus(TabProcessus *listeProcessus, int id, ETAT nouvelEtat);

/* Obtenir l'identifiant d'un processus en fonction d'un PID */
int getID(TabProcessus *listeProcessus, pid_t pid);

/* Obtenir le PID d'un processus en fonction d'un identifiant */
pid_t getPID(TabProcessus *listeProcessus, int id);

/* Obtenir le PID du processus actif si il y en à un */
pid_t getProcActif(TabProcessus *listeProcessus);

#endif // PROCESSUS_H