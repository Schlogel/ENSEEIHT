with adresse_ip;                use adresse_ip;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;


-- Définition de la structure de données du cache
-- Nous avons choisi de faire une LCA pour le cache

package Cache_Liste is 

    type T_Cache_Liste is limited private;

    -- Nom : Initialiser
    -- Sémantique : Permet d'initialiser un Cache, il sera alors vide
    -- Paramètres : Cache
    procedure Initialiser(Cache: out T_Cache_Liste) with
    -- Contrat : 
        Post => Est_Vide(Cache);
    
    -- Nom : Est_Vide
    -- Sémantique : Retourne vrai si le Cache mis en entrée est vide
    -- Paramètres : Cache
    function Est_Vide(Cache: in T_Cache_Liste) return Boolean;

    -- Nom : Taille
    -- Sémantique : retourne le nombre d'éléments du cache
    -- Paramètres : Cache
    function Taille(Cache: in T_Cache_Liste) return Integer with
    -- Contrat : 
        Post => Taille'Result >= 0
            and (Taille'Result = 0) = Est_Vide(Cache);
    
    -- Nom : Index_Destination
    -- Sémantique : Retourne un entier qui est la position de Destination dans un cache
    -- Paramètres : 
        -- Cache
        -- Destination
    function Index_Destination(Cache : in T_Cache_Liste; Destination : in T_Adresse_IP) return Integer with
    -- Contrat :
        Pre => not(Est_Vide(Cache));

    -- Nom : Incrementer_Utilisation
    -- Sémantique : Incrémente le nombre d'utilisation de 1 de la destination n°Index
    -- Paramètres :
        -- Cache
        -- Index -> Correspond à la place dans la liste de la destination où l'on veut incrémenter l'utilisation de 1  
    procedure Incrementer_Utilisation(Cache : in out T_Cache_Liste; Index : in Integer) with
    -- Contrat :
        Pre => Not(Est_Vide(Cache)) and Index > 0 and Index <= Taille(Cache);

    -- Nom : Est_Presente
    -- Sémantique : Savoir si il y a une route valide dans le cache pour le paquet.
        -- La procédure indique si une route est valide à l'aide du booléan Dans_Cache, et l'index de la meilleure route possible
    -- Paramètres : 
        -- Cache
        -- Paquet
        -- Dans_Cache
        -- Index
    procedure Est_Presente(Cache: in T_Cache_Liste; Paquet : in T_Adresse_IP; Dans_Cache : out Boolean; Index : out Integer);

    -- Nom : Enregistrer
    -- Sémantique : Enregistrer une nouvelle route dans le cache
    -- Paramètres : 
        -- Cache 
        -- Destination
        -- Masque
        -- Interf
        -- Utilisation
    procedure Enregistrer(Cache : in out T_Cache_Liste; Destination : in T_Adresse_IP; Masque : in T_Adresse_IP; Interf : in Unbounded_String; Utilisation : in Integer) with
    -- Contrat :
        Post => Taille(Cache) = Taille(Cache)'Old + 1;
    
    -- Nom : Supprimer
    -- Sémantique : Suprimer la route n°Index du cache
    -- Paramètres : 
        -- Cache
        -- Index
    procedure Supprimer(Cache: in out T_Cache_Liste; Index : in Integer) with
    -- Contrat : 
        Pre => Index >= 1 and Index <= Taille(Cache) and not(Est_Vide(Cache)),
        Post =>  Taille (Cache) = Taille (Cache)'Old - 1; 

    -- Nom : Vider
    -- Sémantique : Supprimer toutes les routes du cache -> C'est pour libérer l'espace mémoire occupé par le cache
    -- Paramètres : 
        -- Cache
    procedure Vider(Cache : in out T_Cache_Liste) with
    -- Contrat : 
        Post => Est_Vide(Cache);
    
    -- Nom : Pour_Chaque_Cache
    -- Sémantique : Appliquer un traitement (Traiter) Pour chaque route du cache
    -- Paramètres : 
        -- Cache
    generic
        with procedure Traiter(Destination : in T_Adresse_IP; Masque : in T_Adresse_IP; Interf : in Unbounded_String; Utilisation : in Integer);
    procedure Pour_Chaque_Cache(Cache: T_Cache_Liste);

    -- Nom : Lire 
    -- Sémantique : Permet de lire les données de la Route n°index du cache
    -- Paramètres :
        -- Cache
        -- Destination
        -- Masque
        -- Interf
        -- Utilisation
        -- Index 
    procedure Lire(Cache: in T_Cache_Liste; Destination : out T_Adresse_IP; Masque: out T_Adresse_IP; Interf: out Unbounded_String;Utilisation : out Integer; Index: in Integer) with
    -- Contrat :  
        Pre => Index >= 1 and Index <= Taille(Cache) and not(Est_Vide(Cache)),
        Post => not(Est_Vide(Cache));

    -- Nom : Supprimer_Une_Route
    -- Sémantique : Supprime une route en fonction de la politique. Cette fonction est utilisée lorsque la taille maximum du cache est atteinte. 
    -- Paramètres :
        -- Cache
        -- Politique
    procedure Supprimer_Une_Route(Cache : in out T_Cache_Liste; Politique : in String) with
    -- Contrat :
        Post =>  Taille (Cache) = Taille (Cache)'Old - 1;

    -- Nom : Coherence_Cache
    -- Sémantique : Gère la cohérence du cache. Cette fonction retourne une adresse_IP qui est Destination adapté en fonction du Masque_Max. Masque_Max est calculé en début du programme.
    -- Paramètres :
        -- Destination
        -- Masque_Max
    function Coherence_Cache(Destination : in T_Adresse_IP; Masque_Max : in T_Adresse_IP) return T_Adresse_IP;

    -- Nom : Mise_A_Jour
    -- Sémantique : Met à jour le cache en fonction de la politique
    -- Paramètres :
        -- Cache
        -- Destination
        -- Masque
        -- Interf
        -- Politique
        -- Dans_Cache
    -- Précision : Pour cette procédure, on distingue deux cas : le cas où on à trouver une route valide dans le cache pour notre Paquet_IP (ca se représente par Dans_Cache = True) et l'autre 
        -- C'est si il n'y avait pas de route valide dans notre cache (Dans_Cache = False).
        -- Dans le cas ou Dans_Cache = True, nous n'ajoutons pas de nouvelle route, il faut juste mettre à jour la route qu'on utilise en fonction de la politique (Par exemple incrémenter
        -- le nombre d'utilisation de 1)
        -- Dans le cas ou Dans_Cache = False, il faut ajouter une nouvelle route dans le cache toujours en fonction de la politique.
        --
        -- Pour la politique : LRU, je traite mon cache à la façon d'une file, si j'utilise une route, je la supprime dans le cache pour la rajouter au début. Comme ça, quand je dois
            -- Supprimer une route, c'est celle en bout de la file (donc la première)
    procedure Mise_A_Jour(Cache : in out T_Cache_Liste ; Destination : in T_Adresse_IP ; Masque : in T_Adresse_IP ; Interf : in Unbounded_String ; Politique : in String; Dans_Cache : in Boolean);


private

    type T_Route;

    type T_Cache_Liste is access T_Route;

    type T_Route is
        record
            Destination : T_Adresse_IP;
            Masque : T_Adresse_IP;
            Interf : Unbounded_String;
            Nbr_Utilisation : Integer;
            Suivant : T_Cache_Liste;
        end record;

end Cache_Liste;