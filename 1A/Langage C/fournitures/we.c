#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h> /* wait */

int main(int argc, char *argv[]) {
  int tempsFils, codeTerm;
  pid_t pidFils, idFils;

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
  if (pidFils == 0) {  /* fils */
    printf("processus %d (fils), de père %d\n", getpid(), getppid());
    sleep(tempsFils);
    printf("fin du fils\n");
    exit(EXIT_SUCCESS);
  }
  else {   /* père */
    printf("processus %d (père), de père %d\n", getpid(), getppid());
    idFils=wait(&codeTerm);
    if (idFils == -1) {
      perror("wait ");
      exit(2);
    }
    if (WIFEXITED(codeTerm)) {
      printf("[%d] fin fils %d par exit %d\n",codeTerm,idFils,WEXITSTATUS(codeTerm));
    } else {
      printf("[%d] fin fils %d par signal %d\n",codeTerm,idFils,WTERMSIG(codeTerm));
    }
    printf("fin du père\n");
  }
  return EXIT_SUCCESS; /* -> exit(EXIT_SUCCESS); pour le père */
}