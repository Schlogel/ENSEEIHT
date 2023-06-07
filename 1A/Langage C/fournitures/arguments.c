#include <stdio.h>    /* printf */
#include <stdlib.h>   /* EXIT_SUCCESS */

int main(int argc,char *argv[]) {
  int i; 

  printf("argc = %d\n",argc);  
  for (i=0; i<argc; i++) {
    printf("argv[%d]=\"%s\"\n",i,argv[i]);
  }
  
  return EXIT_SUCCESS;
}

/* une variante un peu plus acrobatique (mais parfaitement légale)
int main(int argc,char *argv[]) {
  int i; 

  printf("argc = %d,\n",argc);
  for (i=0; argv[i] != NULL; i++) {
    printf("argv[%d]=\"%s\"\n",i,argv[i]);
  }
  return EXIT_SUCCESS;
} */

/* une variante encore plus acrobatique (mais toujours légale)
int main(int argc,char *argv[]) {
  char **parg;
  int i=0;

  parg = argv;
  printf("argc = %d\n",argc);
  while (*parg != NULL) {
    printf("argv[%d]=\"%s\"\n",i,*parg);
    parg++;
    i++;
  }
  return EXIT_SUCCESS;
} */

/* toujours plus hardi (mais toujours légal)
int main(int argc,char *argv[]) {
  int i=0;
  
  printf("argc = %d\n",argc);
  while (*argv != NULL) {
    printf("argv[%d]=\"%s\"\n",i,*argv);
    argv++;
    i++;
  }
  return EXIT_SUCCESS;
}
*/
