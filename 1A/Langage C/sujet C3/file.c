/**
 *  \author Xavier Cr�gut <nom@n7.fr>
 *  \file file.c
 *
 *  Objectif :
 *	Implantation des op�rations de la file
*/

#include <malloc.h>
#include <assert.h>

#include "file.h"


void initialiser(File *f)
{
    // Allocation de l'espace m�moire requis
    Cellule *new_head = malloc(sizeof(Cellule));
    
    // V�rification du fonctionnement de l'allocation
    if (new_head) {
        f->tete = new_head;
        f->tete = NULL;
    }
    f->queue = NULL;
    
    //Post-condition
    assert(est_vide(*f));
}


void detruire(File *f)
{
    // Lib�ration de la m�moire occup�e par la file
    if (f->tete != NULL) {
        free(f->tete);
        f->tete = NULL;
    }
    
}


char tete(File f)
{
    //Pr�-condition
    assert(! est_vide(f));

    // Renvoie de la valeur de la cellule t�te
    return f.tete->valeur;
}


bool est_vide(File f)
{
    // Renvoie un bool�en indiquant si la file est vide ou non
    return f.tete == NULL && f.queue == NULL;
}

/**
 * Obtenir une nouvelle cellule allou�e dynamiquement
 * initialis�e avec la valeur et la cellule suivante pr�cis� en param�tre.
 */
static Cellule * cellule(char valeur, Cellule *suivante)
{
    // Allocation de l'espace m�moire requis
    Cellule* nouvelle_cell = malloc(sizeof(char)+sizeof(suivante));
    
    // V�rification du fonctionnement de l'allocation
    if (nouvelle_cell) {
        nouvelle_cell->valeur = valeur;
        nouvelle_cell->suivante = suivante;
    }
    
    // Renvoie de la nouvelle cellule
    return nouvelle_cell;
}


void inserer(File *f, char v)
{
    // Pr�-condition
    assert(f != NULL);
    
    // Disjonction de cas
    if (f->tete == NULL) { // Si la file est vide
        f->tete = cellule (v, NULL);
        f->queue = f->tete;
    } else { // Si elle n'est pas vide
        f->queue->suivante = cellule(v, NULL);
        f->queue = f->queue->suivante;
    }
    
}

void extraire(File *f, char *v)
{
    // Pr�-conditions
    assert(f != NULL);
    assert(! est_vide(*f));

    // R�cup�ration de la valeur � la t�te
    *v = f->tete->valeur;
    
    // Racourcissement de la taille de la cellule
    Cellule *shorter_cell = f->tete->suivante;
    free(f->tete);
    f->tete = NULL;
    f->tete = shorter_cell;
}


int longueur(File f)
{
    // Disjonctions de cas
    if (f.tete != NULL) { // Si la file n'est pas vide
        File f_del;
        f_del.tete = f.tete->suivante;
        return 1 + longueur(f_del);
        detruire(&f_del);
        
    } else { // Si la file est vide
        return 0;
    }

}
