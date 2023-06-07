with Adresse_IP;                use Adresse_IP;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;


-- Définition de la structure de données contenant la table de routage
-- Nous avons choisi de faire une LCA pour la table

package Table_Routage is 

    type T_Table_Routage is limited private;

    -- Nom : Initialiser
    -- Sémantique : Permet d'initialiser une table de routage , il sera alors vide
    -- Paramètres : Table
    procedure Initialiser(Table: out T_Table_Routage) with 
    -- Contrat :
        Post => Est_Vide(Table);
    
    -- Nom : Est_Vide
    -- Sémantique : Retourne vrai si la table mise en entrée est vide
    -- Paramètres : Table
    function Est_Vide(Table: in T_Table_Routage) return Boolean;

    -- Nom : Taille
    -- Sémantique : retourne le nombre d'éléments de la Table 
    -- Paramètres : Table
    function Taille(Table: in T_Table_Routage) return Integer with
    -- Contrat :
        Post => Taille'Result >= 0
            and (Taille'Result = 0) = Est_Vide(Table);
    
    -- Nom : Enregistrer
    -- Sémantique : Enregistrer une nouvelle route dans la table
    -- Paramètres : 
        -- Table 
        -- Destination
        -- Masque
        -- Interf
    procedure Enregistrer(Table : in out T_Table_Routage; Destination : in T_Adresse_IP; Masque : in T_Adresse_IP; Interf : in Unbounded_String) with
    -- Contrat : 
        Post => Taille(Table) = Taille(Table)'Old + 1;
    
    -- Nom : Vider
    -- Sémantique : Supprimer toutes les routes de la table de routage -> C'est pour libérer l'espace mémoire occupé par la table
    -- Paramètres : 
        -- Table
    procedure Vider(Table : in out T_Table_Routage) with
    -- Contrat : 
        Post => Est_Vide(Table);
    
   -- Nom : Pour_Chaque_Table
    -- Sémantique : Appliquer un traitement (Traiter) Pour chaque route de la table
    -- Paramètres : 
        -- Cache
    generic
        with procedure Traiter(Destination : in T_Adresse_IP; Masque : in T_Adresse_IP; Interf : in Unbounded_String);
    procedure Pour_Chaque_Table(Table: T_Table_Routage);

    -- Nom : Lire 
    -- Sémantique : Permet de lire les données de la Route n°index de la table
    -- Paramètres :
        -- Cache
        -- Destination
        -- Masque
        -- Interf
        -- Index 
    procedure Lire(Table: in T_Table_Routage; Destination : out T_Adresse_IP; Masque: out T_Adresse_IP; Interf: out Unbounded_String; Index: in Integer) with
        Pre => Index >= 1 and Index <= Taille(Table) and not(Est_Vide(Table));

    -- Nom : Enregistrement
    -- Sémantique : A partir d'un fichier texte contenant la table de routage, cette procédure construit une table de routage sous la forme d'une liste chainée
    -- Paramètres : 
        -- Table
        -- Nom_Fichier
    procedure Enregistrement(Table: in out T_Table_Routage; Nom_Fichier : in Unbounded_String);

    -- Nom : Masque_Plus_Precis
    -- Sémantique : Retourne le masque le plus précis de la table de routage, cela nous sert pour la cohérence du cache
    -- Paramètres : 
        -- Table
    function Masque_Plus_Precis(Table : in T_Table_Routage) return T_Adresse_IP;

    
private

    type T_Route;

    type T_Table_Routage is access T_Route;

    type T_Route is
        record
            Destination : T_Adresse_IP;
            Masque : T_Adresse_IP;
            Interf : Unbounded_String;
            Suivant : T_Table_Routage;
        end record;

end Table_Routage;