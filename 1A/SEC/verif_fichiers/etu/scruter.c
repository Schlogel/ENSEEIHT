#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>

#define BUFSIZZE 1

void tester(int nombre, const char *message) {
    if (nombre == -1) {
        perror(message);
        exit(1);
    }
}

int main() {
    int int_fichier;
    char buf[BUFSIZZE];
    pid_t pidFils_1, pidFils_2;
    char entier[3];

    pidFils_1 = fork();
    tester(pidFils_1, "Erreur du fork pour le fils 1");

    if (pidFils_1 == 0) { // on est avec le fils 1
        int_fichier = open("temp.txt", O_WRONLY | O_CREAT | O_APPEND, 0644);
        tester(int_fichier, "Erreur de l'ouverture du fichier avec le fils 1");

        for (int index_3 = 1; index_3 <= 3; index_3++) {
            for (int index_10 = 1; index_10 <= 10; index_10++) {
                snprintf(entier, sizeof(entier), "%d\n", index_10 + index_3); // convertir l'entier en chaîne de caractères
                tester(write(int_fichier, entier, sizeof(entier) - 1), "Erreur de l'écriture dans le fichier avec le fils 1");
                sleep(1);
            }
            lseek(int_fichier, 0, SEEK_SET);
        }

        tester(close(int_fichier), "Erreur de la fermeture du fichier avec le fils 1");

    } else { // on est avec le père
        pidFils_2 = fork();
        tester(pidFils_2, "Erreur du fork pour le fils 2");

        if (pidFils_2 == 0) { // on est avec le fils 2
            int_fichier = open("temp.txt", O_RDONLY, 0);
            tester(int_fichier, "Erreur de l'ouverture du fichier avec le fils 2");

            while (1) {
                sleep(5);
                lseek(int_fichier, 0, SEEK_SET); // revenir au début du fichier avant de lire
                while (read(int_fichier, buf, BUFSIZZE) > 0) {
                    printf("%c", buf[0]); // afficher le caractère lu
                }
                printf("\n");
            }

            tester(close(int_fichier), "Erreur de la fermeture du fichier avec le fils 2");

        } else { // on est avec le père
        }
    }

    return EXIT_SUCCESS;
}
