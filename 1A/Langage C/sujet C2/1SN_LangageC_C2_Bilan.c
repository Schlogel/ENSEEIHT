#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>
#include <string.h>

// Consignes :
//      - Compléter les instructions pour réaliser les fonctions et
//        procédures de ce fichier de façon à exécuter les tests avec succès.
// Vous pouvez utiliser les sous-programmes de la bibliothèque string.h pour réaliser
// les principales opérations (copie, recherche, etc.)

struct string {
    char *str; // tableau de caracteres. Doit se terminer par `\0`.
    int N; // nombre de caractères, `\0` inclus.
};
typedef struct string string;

/**
 * \brief Initialiser à partir d’une chaîne de caractères classique
 * (tableau de caractères terminé par le caractère nul)
 * \param[out] chaine_dest string initialisé
 * \param[in] chaine_src chaine conventionnelle
 */
void create(string *chaine_dest, char *chaine_src){
   
    // Allocation de la mémoire nécessaire
    char* tableau = calloc(*chaine_src, sizeof(char));
   
    // Vérification du succès de l'allocation
    if (tableau) {
        chaine_dest->str = tableau; // Récupération du nouveau tableau
        chaine_dest->N = strlen(chaine_src) + 1 ; // Définition de la taille du tableau
    }
   
    // Copie de la chaine de caractères dans notre type string
    strcpy(chaine_dest->str, chaine_src);
   
    // Ajout du caractère "\0" à la fin du notre string
    char *carac_fin = "\0";
    chaine_dest->str += *carac_fin;
   
}

/**
 * \brief obtenir le nombre de caractères de la chaîne
 * \param[in] str chaine
 */
int length(string chaine){
   
    // Renvoie de la longueur du string sans compter le caractère "\0"
    return chaine.N - 1;
}

/**
 * \brief ajouter un nouveau caractère à la fin de la chaîne. Sa longueur est donc augmentée de 1.
 * \param[inout] chaine
 * \param[in] c le caractère à ajouter en fin de chaine.
*/
void add(string *chaine, char c){
   
    // Réallocation de la mémoire nécessaire pour l'ajout d'un caractère
    char* nouveau_add = realloc(chaine->str, ((chaine->N) + 1)*sizeof(char));
   
    // Vérification du succès de la réallocation
    if (nouveau_add) {
            chaine->str = nouveau_add;
            chaine->N += 1;
    }
   
    // Ajout du dernier carcatère
    chaine->str[chaine->N - 2] = c ;
}


/**
 * \brief supprimer le caractère à la position i.
 * \param[inout] chaine
 * \param[in] i position du caractere dans la chaine
 * (attention à la precondition).
*/
void delete(string *chaine, int i){
    
    // Réallocation de la mémoire nécessaire pour la suppression d'un caractère
    char* nouveau = realloc(chaine->str, (chaine->N - 1)*sizeof(char));
   
    // Vérification du succès de la réallocation
    if (nouveau) {
        
        // Disjonction de cas
        if (i == 0) { // Si on enlève le premier caractère

            // Ajout caractère par caractère du 2ème au dernier caractère
            for (int index = 1; index <= chaine->N - 1; index++) {
                nouveau[index-1] = chaine->str[index];
            }
            // Remplacement de la nouvelle chaine de caractère créée
            chaine->str = nouveau;
            // Modification de sa taille en conséquence
            chaine->N -= 1;

        } else if (i == chaine->N - 2) { // Si on enlève le dernier caractère

            // Ajout caractère par caractère du 1er à l'avant dernier caractère
            for (int index = 0; index <= chaine->N - 3; index++) {
                nouveau[index] = chaine->str[index];
            }
            // Remplacement de la nouvelle chaine de caractère créée
            chaine->str = nouveau;
            // Modification de sa taille en conséquence
            chaine->N -= 1;

        } else { // Si on enlève le caractère à un autre endroit 

            // Ajout caractère par caractère du 1er à l'avant ième
            for (int index = 0; index <= i - 1; index++) {
                nouveau[index] = chaine->str[index];
            }

            // Ajout caractère par caractère du i+1ème au dernier
            for (int index = i + 1; index <= chaine->N - 1; index++) {
                nouveau[index - 1] = chaine->str[index];
            }
            // Remplacement de la nouvelle chaine de caractère créée
            chaine->str = nouveau;
            // Modification de sa taille en conséquence
            chaine->N -= 1;

        }
        
    }
    
}

/**
 * \brief détruire, elle ne pourra plus être utilisée (sauf à être de nouveau initialisée)
 * \param[in] chaine chaine à détruire
*/
void destroy(string *chaine){
   
    // Libération de la chaine de caractère
    free(chaine->str);
   
    // Mis à null
    chaine->str = NULL;
   
    // Mis de la taille à 0
    chaine->N = 0;
}



void test_create(){
    string ch, ch1, ch2;
    create(&ch, "UN");
    assert(ch.N == 3);
    assert(ch.str[0] == 'U');
    create(&ch1, "DEUX");
    assert(ch1.N == 5);
    assert(ch1.str[4] == '\0');
    create(&ch2, "");
    assert(ch2.N == 1);
    assert(ch2.str[0] == '\0');
   
    destroy(&ch);
    destroy(&ch1);
    destroy(&ch2);
}


void test_length(){
    string ch, ch1;
    create(&ch, "UN");
    assert(strlen("UN")==length(ch));
    create(&ch1, "");
    assert(length(ch1)==strlen(""));
    destroy(&ch);
    destroy(&ch1);
}

void test_add(){
    string ch1;
    create(&ch1, "TROI");
    add(&ch1, 'S');
    assert(length(ch1) == 5);
    assert(ch1.str[4] == 'S');
    add(&ch1, '+');
    assert(length(ch1) == 6);
    assert(ch1.str[5] == '+');
    destroy(&ch1);
}


void test_delete(){
    string ch1;
    create(&ch1, "TROIS");
    delete(&ch1, 0); //ROIS
    assert(length(ch1) == 4);
    assert(ch1.str[0] == 'R');
    delete(&ch1, 2); //ROS
    assert(length(ch1) == 3);
    assert(ch1.str[2] == 'S');
    delete(&ch1, 2); //RO
    assert(length(ch1) == 2);
    assert(ch1.str[1] == 'O');
    delete(&ch1, 0); //O
    delete(&ch1, 0); //_
    assert(length(ch1) == 0);
   
    destroy(&ch1);
}


void test_destroy(){
    string ch, ch1;
    create(&ch, "UN");
    destroy(&ch);
    assert(ch.str == NULL);
   
    create(&ch1, "TROI");
    add(&ch1, 'S');
    destroy(&ch1);
    assert(ch1.str == NULL);
}

int main(){
    test_create();
    test_length();
    test_add();
    test_delete();
    test_destroy();
   
    printf("%s", "\n Bravo ! Tous les tests passent.\n");
    return EXIT_SUCCESS;
}
