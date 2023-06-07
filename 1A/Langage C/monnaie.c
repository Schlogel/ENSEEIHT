// Online C compiler to run C program online
#include <stdlib.h> 
#include <stdio.h>
#include <assert.h>
#include <stdbool.h>

#define NOMBRE 5


// Definition du type monnaie 
struct monnaie {
    float valeur;
    char devise;
};

typedef struct monnaie monnaie;


/**
 * \brief Initialiser une monnaie 
 * \param[out] une monnaie 
 * \param[in] une valeur et une devise
 * \pre valeur >= 0
 */ 
void initialiser(monnaie *monnaie, float valeur, char devise){
    assert(valeur >= 0.0);
    monnaie -> valeur = valeur;
    monnaie -> devise = devise;
}


/**
 * \brief Ajouter une monnaie m2 à une monnaie m1 
 * \param[in] une monnaie mon_1
 * \param[in out] une monnaie mon_2 qui aura sa devise additionner avec celle de mon_1 si elles ont la même devise
 */ 
bool ajouter(monnaie *mon_1, monnaie *mon_2){
    //assert( devise == (*ptr_monnaie).devise )
    if (mon_1->devise == mon_2->devise){
        mon_2->valeur = mon_2->valeur + mon_1->valeur;
        return true;
    }
    else {
    return false;
    }
}


/**
 * \brief Tester Initialiser 
 * \param[]
 */ 
void tester_initialiser(){
    monnaie monnaie_test;
    initialiser(&monnaie_test, 1.5, 'e');
    assert(monnaie_test.valeur == 1.5);
    assert(monnaie_test.devise == 'e');
}

/**
 * \brief Tester Ajouter 
 * \param[]
 */ 
void tester_ajouter(){
    monnaie mon_1;
    monnaie mon_2;
    monnaie mon_3;
    initialiser(&mon_1, 1.5, 'e');
    initialiser(&mon_2, 2.0, 'e');
    initialiser(&mon_3, 2.0, '$');
    ajouter(&mon_1, &mon_2);
    assert(mon_1.valeur == 1.5);
    assert(mon_1.devise == 'e');
    assert(mon_2.valeur == 3.5);
    assert(mon_2.devise == 'e');
 
    ajouter(&mon_1, &mon_3);
    assert(mon_3.valeur == 2.0);
    assert(mon_3.devise == '$');
}



int main(void){
    void tester_ajouter(void);
    void tester_initialiser(void);
    // Un tableau de 5 monnaies
    typedef monnaie porte_monnaie[NOMBRE];
    porte_monnaie ptr_monnaie;

    //Initialiser les monnaies
    float valeur;
    char devise;
    printf("Enregistrement de 5 monnaie\n");
    for (int index = 0; index <= NOMBRE - 1; index++) {
    printf("Monnaie %d est\n", index+1);
    printf("Valeur : ");
    scanf("%f", &valeur);
    printf("Devise : ");
    scanf(" %c", &devise);
    initialiser(&ptr_monnaie[index], valeur, devise);}
 
    // Afficher la somme des toutes les monnaies qui sont dans une devise entrée par l'utilisateur.
    char devise_somme;
    printf("Devise à sommer : ");
    scanf(" %c", &devise_somme);
    monnaie monnaie_somme;
    initialiser(&monnaie_somme, 0.0, devise_somme);
    for (int numero = 0; numero <= NOMBRE - 1; numero++) {
    if ((ptr_monnaie[numero]).devise == devise_somme) {
    ajouter(&ptr_monnaie[numero], &monnaie_somme);}
    }
    
    printf("La somme de votre argent pour la devise choisie est de %1.2f%c",monnaie_somme.valeur,devise_somme);

    return EXIT_SUCCESS;
}
