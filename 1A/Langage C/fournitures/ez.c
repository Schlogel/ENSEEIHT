#include <stdio.h>
#include <unistd.h>
#include <stdlib.h> /* exit */

int main(int argc, char *argv[]) {
    int tempsPere, tempsFils;
    int v=5; /* utile pour la section 2.3 */
    pid_t pidFils;

    tempsPere=120;
    tempsFils=60;
    pidFils=fork();
    /* bonne pratique : tester systématiquement le retour des appels système */
    if (pidFils == -1) {
        printf("Erreur fork\n");
        exit(1);
        /* par convention, renvoyer une valeur > 0 en cas d'erreur,
         * différente pour chaque cause d'erreur
         */
    }
    if (pidFils == 0) {		/* fils */
        printf("processus %d (fils), de père %d\n", getpid(), getppid());
        sleep(tempsFils);
        printf("fin du fils\n");
        exit(EXIT_SUCCESS); /* 	bonne pratique : 
        						terminer les processus par un exit explicite */
    }
    else {		/* père */
        printf("processus %d (père), de père %d\n", getpid(), getppid());
        sleep(tempsPere);
        printf("fin du père\n");        
    }
    return EXIT_SUCCESS; /* -> exit(EXIT_SUCCESS); pour le père */
}