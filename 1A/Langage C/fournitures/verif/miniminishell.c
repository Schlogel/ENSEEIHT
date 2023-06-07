#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <string.h>

int main () {
    pid_t pidFils, idFils; 
    char buf [31] ; /* contient la commande saisie au clavier */
    buf[31] = '\0';
    int ret ; /* valeur de retour de scanf */

    while(ret != EOF){

        printf(">>>");
        ret = scanf ("%30s" , buf ) ; /* lit et range dans buf la chaine entrée au clavier */

        if (strcmp(buf,"exit") == 0) {
            ret = EOF;
            printf("\nSalut\n");
            exit(2);
        }

        if (ret != EOF) {

            pidFils = fork();
            if (pidFils == -1) {
                printf("Erreur fork\n");        
                exit(1);
            }

            if (pidFils == 0) {		/* fils */
                execlp(buf,buf,NULL);
                exit(9);

            } else {		/* père */
                int codeTerm;
                idFils = wait(&codeTerm);
                if (idFils == -1) {
                    perror ( " wait " );
                    exit (2);
                }
                if (WEXITSTATUS(codeTerm) == 9){
                    printf("ECHEC\n");
                } else {
                    printf("SUCCESS\n");
                }
            }
            
        } else {
            printf("\n");
        }// endif EOF
        
    } //end while
    printf("Salut\n");
    return EXIT_SUCCESS;

}


