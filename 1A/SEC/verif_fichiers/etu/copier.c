#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>

#define BUFSIZZE 100

void tester(int nombre, const char *message) { // fonction qui teste si le nombre est différent de -1, si c'est le cas, elle affiche le message d'erreur
    if (nombre == -1) {
        perror(message);
    }

}

int main(int argc, char *argv[]) {
    int int_source, int_destination, int_lu;
    char buf[BUFSIZZE];

    if (argc != 3) { // si le nombre d'arguments est différent de 3, on affiche le message d'erreur et on quitte le programme
        printf("Usage: ./copier source.txt destination.txt\n");
        exit(1);
    }

    int_source = open(argv[1], O_RDONLY, 0);
    tester(int_source, "Erreur du : open source"); // on teste si l'ouverture du fichier source s'est bien passée

    int_destination = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0644);
    tester(int_destination, "Erreur du : open destination"); // on teste si l'ouverture du fichier destination s'est bien passée

    while ((int_lu = read(int_source, buf, BUFSIZZE)) > 0) { // on lit le fichier source tant qu'il y a des caractères à lire
        tester(write(int_destination, buf, int_lu), "Erreur du : write destination");
    }

    // on ferme les fichiers source et destination
    tester(close(int_source), "erreur du : close source"); 
    tester(close(int_destination), "erreur du : close destination");

    return EXIT_SUCCESS;

}