-- Définition des exceptions
package Cache_exception is

	Taille_Not_Integer  : Exception; -- Lorsque la taille rentré n'est pas un entier
    Politique_Pas_Valide : Exception; -- Lorsque la politique rentré n'est pas valide
    Fichier_Table : Exception; -- Lorsque le fichier de la table n'est pas valide
    Fichier_Paquet : Exception; -- Lorsque le fichier paquet n'est pas valide
    Destination_Absente : exception; -- Lorsque qu'une destination est absente du cache 
    Mauvaise_Adresse_IP : Exception; -- Lorsque que dans un fichier une adresse IP est mal écrite
    Mauvaise_Ecriture_Table : Exception; -- Lorsqu'il y a un problème dans le fichier contenant la table

end Cache_exception;