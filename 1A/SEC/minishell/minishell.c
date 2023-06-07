#include "readcmd.h"    /* pour readcmd */
#include "processus.h"  /* pour les processus */

#include <string.h>     /* pour strtok */
#include <stdbool.h>    /* pour bool */
#include <stdio.h>      /* entrées/sorties */
#include <unistd.h>     /* primitives de base : fork, ...*/
#include <stdlib.h>     /* exit */
#include <signal.h>     /* pour les signaux */
#include <sys/wait.h>   /* pour wait */
#include <fcntl.h>      /* pour open */
#include <sys/stat.h>   /* pour les droits */
#include <sys/types.h>  /* pour les types */

#define tailleEnsCmdPers 6

/************************ Variables globales ************************/

// Ensemble des commandes personnalisées
const char ensCmdPersonnelles[tailleEnsCmdPers][5] = {"exit", "cd", "lj", "sj", "fg", "bg"};
// Liste des processus
TabProcessus *listeProcessus;
// Booléen pour savoir si on doit quitter le minishell
bool exitBool;

/************************ Fonctions ************************/

/* Affiche un message d'erreur et tue le processus si il y a une erreur */
void testerKill(bool errorBool, const char *message) {
    if (errorBool) {
        perror(message);
        exit(1);
    }
}

/* Affiche un message d'erreur si il y a une erreur */
void testerNotKill(bool errorBool, const char *message) {
    if (errorBool) {
        printf("%s\n",message);
    }
}

/* Traitant du signal SIGCHLD */
void traitant_SIGCHLD() {
    int status, id;

    // On récupère le pid du fils qui a changé d'état
    pid_t pidFils = waitpid(-1, &status, WUNTRACED | WCONTINUED | WNOHANG);
    testerKill(pidFils == -1, "Erreur waitpid hanlder SIGCHLD");

    // On récupère l'id du processus dans la liste et on change son état
    if((id = getID(listeProcessus, pidFils)) != 0) {
        if (WIFSIGNALED(status)) {
            changerEtatProcessus(listeProcessus, id, INTERROMPU);
        }
        if (WIFSTOPPED(status)) {
            changerEtatProcessus(listeProcessus, id, SUSPENDU);
        }
        if (WIFCONTINUED(status)) {
            changerEtatProcessus(listeProcessus, id, ACTIF);
        }
        if (WIFEXITED(status)) {
            supprimerProcessus(listeProcessus, id);
        }
    }
}

/* Traitant du signal SIGINT */
void traitant_SIGINT() {
    pid_t pidAvantPlan;
    if ((pidAvantPlan = getProcActif(listeProcessus)) != -1) {
        kill(pidAvantPlan, SIGKILL);
    } else {
        printf("\nPas de processus en avant plan\n");
    }
}

/* Changement de répertoire */
void changeDirectory(struct cmdline* commande) {
    // Si aucun dossier n'est spécifié, on va dans le dossier HOME
    if (commande->seq[0][1] == NULL) { 
        testerKill(chdir(getenv("HOME")) != 0, "Erreur d'éxécution de chdir vers : HOME"); 
    } else { // Sinon on va dans le dossier spécifié
        testerNotKill(chdir(commande->seq[0][1]) != 0, "Dossier demandé introuvable"); 
    }
}

/* Redirections des flux avec les fichiers */
void redirections(char *nom_fichier, int canal) {
    int fichier;
    int mode = -1;
    mode_t droits = -1;

    // Si le nom du fichier est spécifié, on redirige le flux
    if (nom_fichier != NULL) {
        // On détermine le mode et les droits
        switch(canal) {
        
            case 0 :    /* canal d'entré */
                mode = O_RDONLY;
                droits = 0;
                break;

            case 1 :    /* canal de sortie */
                mode = O_WRONLY | O_CREAT | O_TRUNC;
                droits = 0644;
                break;
            
            default :   /* mauvais canal */
                perror("Mauvais canal séléctionné");
                break;
        }

        // On redirige le flux
        testerKill((fichier = open(nom_fichier, mode, droits)) == -1, "Erreur de l'ouverture du fichier");
        testerKill(dup2(fichier, canal) == -1, "Erreur du dup2");
        testerKill(close(fichier) == -1, "Erreur de la fermeture du fichier");
    }
}

/* Savoir si la commande est propre à ce minishell */
bool estCmdPersonnelle(char *cmd) {
    for (int i = 0; i < tailleEnsCmdPers; i++) {
        if (strcmp(cmd, ensCmdPersonnelles[i]) == 0) {
            return true;
        }
    }
    return false;
}

/* Exécution d'une commande personnalisé */
bool commandePersonnelle(struct cmdline* commande) {
    
    if (strcmp(commande->seq[0][0],"exit") == 0) { /* si la commande est exit */
        return true;

    } else if (strcmp(commande->seq[0][0],"cd") == 0) { /* si la commande est changedirectory */
        changeDirectory(commande);

    } else if (strcmp(commande->seq[0][0],"lj") == 0) { /* si la commande est listejob */
        afficherProcessus(listeProcessus);

    } else if (strcmp(commande->seq[0][0],"sj") == 0) { /* si la commande est stopjob */
        pid_t pidProcessus = getPID(listeProcessus, atoi(commande->seq[0][1]));
        if (pidProcessus != -1) {
            kill(pidProcessus, SIGSTOP);
        } else {
            printf("Processus introuvable\n");
        }

    } else if (strcmp(commande->seq[0][0],"bg") == 0) { /* si la commande est background */
        pid_t pidProcessus = getPID(listeProcessus, atoi(commande->seq[0][1]));
        if (pidProcessus != -1) {
            kill(pidProcessus, SIGCONT);
        } else {
            printf("Processus introuvable\n");
        }

    } else if (strcmp(commande->seq[0][0],"fg") == 0) { /* si la commande est foreground */
        pid_t pidProcessus = getPID(listeProcessus, atoi(commande->seq[0][1]));
        if (pidProcessus != -1) {
            kill(pidProcessus, SIGCONT);
        } else {
            printf("Processus introuvable\n");
        }

    }
    return false;
}

/* Fermeture des tubes inutiles */
void closePiplines(int Tubes[][2], int nbFork, int nbTubes) {
    for (int index = 0; index <= nbTubes - 1; index++) {
        if ((index != nbFork) && (index != nbFork - 1)) { // on ferme tout les tubes sauf ceux du fork
            testerKill(close(Tubes[index][0]) == -1, "Erreur du close");
            testerKill(close(Tubes[index][1]) == -1, "Erreur du close");
        }
    }
}

/* Exécute les commandes chainées et non-chainées */
void pipelines(struct cmdline* commande) {
    int nbTubes = 0;

    // On compte le nombre de tubes
    while (commande->seq[nbTubes + 1] != NULL) {
        nbTubes ++;
    }

    int Tubes[nbTubes][2];

    // On crée les tubes
    for (int i = 0; i <= nbTubes - 1; i++) {
        testerKill(pipe(Tubes[i]) == -1, "Erreur création tube");
    }

    // On crée les processus sauf le dernier
    for (int nbFork = 0; nbFork <= nbTubes - 1; nbFork++) {

        switch(fork()) {

            case -1 :

                perror("Erreur du fork du tube\n");
                break;

            case 0 : /* Enfant */

                // On ignore le signal SIGINT
                struct sigaction struct_sigint_ignore;
                struct_sigint_ignore.sa_handler = SIG_IGN;
                sigaction(SIGINT, &struct_sigint_ignore, NULL); 

                // On ferme tout les tubes sauf ceux du fork (i.e. nbFork et nbFork - 1)
                closePiplines(Tubes, nbFork, nbTubes);

                // Redirection du flux sortant
                testerKill(dup2(Tubes[nbFork][1], 1) == -1, "Erreur du dup2");
                testerKill(close(Tubes[nbFork][0]) == -1, "Erreur du close");
                testerKill(close(Tubes[nbFork][1]) == -1, "Erreur du close");
                
                // Redirection du flux entrant
                if (nbFork > 0) { 
                    testerKill(dup2(Tubes[nbFork - 1][0], 0) == -1, "Erreur du dup2");
                    testerKill(close(Tubes[nbFork - 1][1]) == -1, "Erreur du close");
                    testerKill(close(Tubes[nbFork - 1][0]) == -1, "Erreur du close");
                }

                testerKill(execvp(commande->seq[nbFork][0], commande->seq[nbFork]) == -1, "Erreur du execvp");
                
                exit(1);
                break;

            default : /* Parent */
                break;
        }
    }

    // On ferme tout les tubes sauf le dernier
    for (int index = 0; index < nbTubes - 1; index++) {
        testerKill(close(Tubes[index][0]) == -1, "Erreur du close");
        testerKill(close(Tubes[index][1]) == -1, "Erreur du close");
    }

    // Redirection du flux entrant
    dup2(Tubes[nbTubes-1][0], 0);
    close(Tubes[nbTubes-1][1]);
    close(Tubes[nbTubes-1][0]);

    // Création du dernier processus pour éxécuter la dernière commande
    switch (fork()) {
        case -1 :
            perror("Erreur du fork du tube\n");
            break;

        case 0 : /* Enfant */

            // On ignore le signal SIGINT
            struct sigaction struct_sigint_ignore;
            struct_sigint_ignore.sa_handler = SIG_IGN;
            sigaction(SIGINT, &struct_sigint_ignore, NULL);

            testerKill(execvp(commande->seq[nbTubes][0], commande->seq[nbTubes]) == -1, "Erreur du execvp");
            exit(1);
            break;

        default : /* Parent */
            break;
    }

    // On attend la fin de tout les processus
    for (int index = 0; index <= nbTubes ; index++) {
        wait(NULL);
    }
}

/* Exécution d'un commande générale aux minishells */
void commandeGenerale(struct cmdline* commande) { 
    pid_t pidFils; 

    switch(pidFils = fork()) {

        case -1 :       /* erreur fork */

            perror("Erreur du fork\n");
            break;

        case 0 :        /* fils */

            // On ignore le signal SIGINT
            struct sigaction struct_sigint_ignore;
            struct_sigint_ignore.sa_handler = SIG_IGN;
            sigaction(SIGINT, &struct_sigint_ignore, NULL);   

            // Redirections (des fichiers)
            redirections(commande->in, 0);
            redirections(commande->out, 1);

            // Exécution de la commande
            pipelines(commande);

            exit(9);
            break;

        default :       /* père */

            // On ajoute le processus à la liste
            ajouterProcessus(listeProcessus, pidFils, ACTIF, commande->seq[0][0]);

            // On vérifie si la commande est en background
            if (commande->backgrounded == NULL) { 
                pause(); // La commande n'est pas en tache de fond, on attend que le processus fils se termine
            }
            break;
    }
}



/************************ Main ************************/

int main () {
    struct cmdline* commande; /* structure de la commande saisie au clavier */
    exitBool = false;

    // On défini le traitant du signal SIGCHLD
    struct sigaction struct_sigchld;
	struct_sigchld.sa_handler = traitant_SIGCHLD;
    sigemptyset(&struct_sigchld.sa_mask);
    struct_sigchld.sa_flags = 0;
	sigaction(SIGCHLD, &struct_sigchld, NULL);  

    // On défini le traitant du signal SIGINT
    struct sigaction struct_sigint;
	struct_sigint.sa_handler = traitant_SIGINT;
    sigemptyset(&struct_sigint.sa_mask);
    struct_sigint.sa_flags = 0;
	sigaction(SIGINT, &struct_sigint, NULL); 


    char current_directory[1000];

    // On initialise la liste des processus
    testerKill((listeProcessus = malloc(sizeof(TabProcessus))) == NULL, "Erreur d'allocation de mémoire pour TabProcessus");

    // Boucle principale pour proposer de saisir une commande
    while(!exitBool) {

        testerNotKill(getcwd(current_directory, sizeof(current_directory)) == NULL, "Erreur de la récupération du chemin du répertoire\n");

        do {
            printf("MINISHELL %s$ ", current_directory);
            commande = readcmd(); /* récupère la commande saisie au clavier */
        } while (*commande->seq == NULL);
        
        testerKill(commande->err != NULL, "Erreur de commande");

        if (!exitBool) {
            if (estCmdPersonnelle(commande->seq[0][0])) {
                exitBool = commandePersonnelle(commande);
            } else if (commande->seq[0][0] != NULL) {
                commandeGenerale(commande);
            }
        }
        
        
    } //end while
    
    printf("\nFin du minishell\n");
    return EXIT_SUCCESS;

}