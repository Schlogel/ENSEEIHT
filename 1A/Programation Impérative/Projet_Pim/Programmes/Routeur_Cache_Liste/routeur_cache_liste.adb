-- Programme Routeur Cache Liste
-- Projet, équipe 1, groupe AB
with table_routage;             use table_routage;
with cache_liste;               use cache_liste;
with adresse_IP;                use adresse_IP;
with Ada.Strings;               use Ada.Strings;	
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;          use Ada.Command_Line;
with Ada.Calendar;              use Ada.Calendar;
with cache_exception;           use cache_exception;
with Ada.IO_Exceptions;

procedure routeur_cache_liste is

    -- -- -- Variables -- -- --

    -- -- Variables pour les statistiques -- --
    Utilisation_Cache : Integer := 0;
    Suppression_Cache : Integer := 0;
    Utilisation_Totale : Integer := 0;
    Debut: Time;         -- heure de début de l'opération
	Fin: Time;           -- heure de fin de l'opération
	Duree : Duration;    -- durée de l'opération
    Pourcentage_Utilisation : Integer;
    Defaut_Table : Integer := 0;

    -- -- Variables de parcours -- --
    Forced_exit : boolean := False;
    Ligne : integer := 1;
    Nb_lignes_paquets : integer;
    Nb_lignes_route : integer;
    Ligne_unb_str : Unbounded_String;

    -- -- Variables liées aux fichiers -- --

    -- Liens avec le cache
    Cache : T_Cache_Liste;
    Taille_Cache : Integer;
    Politique : Unbounded_String;
    Statistique : Boolean;
    Index_Cache : Integer;
    Dans_Cache : Boolean := False;
    Nbr_Utilisation : Integer;
    Masque_Max : T_Adresse_IP := 0;

    -- Liens avec la table de routage
    Table_Routage_txt : Unbounded_String;
    Table_Routage : T_Table_Routage;
    -- Ligne_table : Unbounded_String;

    -- Liens avec les paquets
    Paquets_txt : Unbounded_String;
    Paquets_file : File_Type;

    -- Liens avec les résultats
    Resultat_txt : Unbounded_String;
    Resultat_file : File_Type;

    -- Liens avec la recherche dans la table de routage --
    Destination : T_Adresse_IP;
    Masque: T_Adresse_IP;
    Interf: Unbounded_String;
    Masque_Prev : T_Adresse_IP := 0;
    Destination_Prev : T_Adresse_IP := 0;
    Inter_Face_Prev : Unbounded_String := Null_Unbounded_String;
    Vecteur : T_vecteur;
    Paquet_IP : T_Adresse_IP;

    -- -- -- Fonctions/Procédures -- -- --

    -- Procédure qui lit les entrées dans le terminal et les stocke dans les variables correspondantes
    procedure Lecture_Terminal(Taille_Cache : out Integer; Politique : out Unbounded_String; Statistique : out Boolean; Table_txt : out Unbounded_String; Paquets_txt : out Unbounded_String; Resultat_txt : out Unbounded_String) is
        Cur_Argument : Unbounded_String;
    begin
        -- Définition des variables par défaut
        Taille_Cache := 10;
        Politique := To_Unbounded_String("FIFO");
        Statistique := True;
        Table_txt := To_Unbounded_String("table.txt");
        Paquets_txt := To_Unbounded_String("paquets.txt");
        Resultat_txt := To_Unbounded_String("resultats.txt");

        -- Récupération des arguments
        for i in 1..Argument_Count loop
            Cur_Argument := To_Unbounded_String(Argument(i));
            if Cur_Argument = "-c" then 
                begin
                    Taille_Cache := Integer'Value(Argument(i+1));
                    if Taille_Cache < 0 then
                        raise Taille_Not_Integer;
                    else
                        Null;
                    end if;
                exception
                    when others  => 
                        raise Taille_Not_Integer;
                end;
            elsif Cur_Argument = "-P" then
                begin
                    Politique := To_Unbounded_String(Argument(i+1));
                    if To_String(Politique) /= "FIFO" and To_String(Politique) /= "LRU" and To_String(Politique) /= "LFU" then
                        raise Politique_Pas_Valide;
                    else 
                        Null;
                    end if;
                exception
                    when others => 
                        raise Politique_Pas_Valide;
                end;
            elsif Cur_Argument = "-S" then
                Statistique := False;
            elsif Cur_Argument = "-t" then
                Table_txt := To_Unbounded_String(Argument(i+1));
            elsif Cur_Argument = "-p" then 
                Paquets_txt := To_Unbounded_String(Argument(i+1));
            elsif Cur_Argument = "-r" then
                Resultat_txt := To_Unbounded_String(Argument(i+1));
            else
                Null;
            end if;
        end loop;
    end Lecture_Terminal;

    -- Fonction qui prend en argument le nom d'un fichier texte et retourne son nombre de ligne
    function Taille_txt(Fichier_txt : in Unbounded_String) return integer is 
        File : File_Type;	-- Le descripteur du ficher d'entrée
        Nb_lignes : integer := 0;
        Texte_inutile : Unbounded_String;
    begin
        -- Ouverture du fichier
        Open (File, In_File, To_String (Fichier_txt));
        -- Parcours du fichier jusqu'à la fin
        loop
            Nb_lignes := Integer (Line (File));
            Texte_inutile := Get_Line(File);    -- Problème : la variable Texte_inutile n'est pas utilisée (elle sert juste à avancer dans le fichier)
            exit when End_Of_File (File);
        end loop;
        Close (File);
        return Nb_lignes;
    end Taille_txt;

    -- Fonction qui permet d'afficher une route
    procedure Afficher_Cache(Destination : in T_Adresse_IP; Masque : in T_Adresse_IP; Interf : in Unbounded_String; Utilisation : in Integer) is
    begin
        Put(convert_IP_Bin(Destination) & " ");
        Put(convert_IP_Bin(Masque) & " ");
        Put(Integer'Image(Utilisation) & " ");
        Put(To_String(Interf));
        New_Line;
    end;

    procedure Afficher(Destination : in T_Adresse_IP; Masque : in T_Adresse_IP; Interf : in Unbounded_String) is
    begin
        Put(convert_IP_Bin(Destination) & " ");
        Put(convert_IP_Bin(Masque) & " ");
        Put(Interf);
        New_Line;
    end;

    -- Généricité de la fonction Pour_Chaque_Cache pour afficher le cache
    procedure Affichage_Cache is new Pour_Chaque_Cache(Afficher_Cache);

    -- Généricité de la fonction Pour_Chaque_Table pour afficher la table
    procedure Affichage_Table is new Pour_Chaque_Table(Afficher);


begin
    -- récupérer l'heure (heure de début)
	Debut := Clock;	

    -- Lecture des entrées dans le terminal
    Lecture_Terminal(Taille_Cache,Politique,Statistique,Table_Routage_txt, Paquets_txt, Resultat_txt);

    -- Conversion de la table de routage (.txt) en LCA dans Table_Routage
    Initialiser(Table_Routage);

    -- Enregistre la table de routage dans une LCA 
    Enregistrement(Table_Routage, Table_Routage_txt); --(Type LCA, Type Unbounded_string)

    -- Calcul du masque le plus précis de la table pour la cohérence du cache
    Masque_Max := Masque_Plus_Precis(Table_Routage);

    -- On initialise le cache 
    Initialiser(Cache);

    -- Récupération des différentes tailles des fichiers.
    Nb_lignes_route := Taille(Table_Routage);
    Nb_lignes_paquets := Taille_txt(Paquets_txt);

    -- Création du fichier pour les résultats
    Create (Resultat_file, Out_File, To_String(Resultat_txt));

    -- Ouverture du fichier contenant les paquets, si le nom donnée est mauvais, on a alors une erreur. 
    begin
        Open (Paquets_file, In_File, To_String(Paquets_txt));
    exception
        when others =>
            raise Fichier_Paquet;
    end;

    --Parcours du fichier texte (chaque ligne) contenant les paquets 
    while not(Forced_exit) and (Ligne <= Nb_lignes_paquets) loop

        -- Récupération de la ligne
        Ligne_unb_str := Get_Line (Paquets_file);
		Trim (Ligne_unb_str, Both);	        -- supprimer les blancs du début et de la fin de Texte

        -- On supprime le retour à la ligne sauf pour la dernière ligne
        if Ligne < Nb_lignes_paquets then
            Ligne_unb_str := To_Unbounded_String(To_string(Ligne_unb_str)(1..(Length(Ligne_unb_str)-1)));  
        else
            Null;   
        end if;
        
        --  On regarde si la ligne est une commande ou un paquet
        if Ligne_unb_str = To_Unbounded_String("fin") then

            -- On affche "fin" dans le terminal et on quitte le processus (Forced_exit := True)
            Put_Line("fin (ligne" & Integer'Image(Ligne) & ")");
            Forced_exit := True;
            New_Line;

        elsif Ligne_unb_str = To_Unbounded_String("table") then

            -- On affiche "table" dans le terminal et la table de routage 
            Put_Line("table (ligne" & Integer'Image(Ligne) & ")");
            Affichage_Table(Table_Routage);

        elsif Ligne_unb_str = To_Unbounded_String("cache") then

            -- On affiche "cache" dans le terminal et le cache
            Put_Line("cache (ligne" & Integer'Image(Ligne) & ")");
            Affichage_Cache(Cache);

        elsif Ligne_unb_str = To_Unbounded_String("stat") then

            -- On affiche "statistique" dans le terminal et les statistiques relatives au cache
            Put_Line("statistique (ligne" & Integer'Image(Ligne) & ")");
            Put_Line("Type de cache utilisé : " & To_String(Politique));
            Put_Line("Nombre de paquets triés : " & Integer'Image(Utilisation_Totale));
            Put_Line("Nombre de fois que l'on a pas trouvé une route valide pour un paquet : " & Integer'Image(Defaut_Table));
            Put_Line("Nombre de fois que le cache a été utilisée : " & Integer'Image(Utilisation_Cache));
            Put_Line("Taille du cache : " & Integer'Image(Taille_Cache) & ". Places restantes : " & Integer'Image(Taille_Cache - Taille(Cache)));
            Put_Line("Nombre de fois qu'une route a du être supprimée : " & Integer'Image(Suppression_Cache));
            Put_Line("Pourcentage d'utilisation du cache " & Integer'Image((Utilisation_Totale/Utilisation_Cache)*100));

        else
            -- Ligne_unb_str est une adresse IP

            -- On convertit la ligne en un T_Adresse_IP
            -- D'abord on récupère les 4 entiers 
            begin
                Vecteur := nombres(Ligne_unb_str);
            exception 
                when others =>
                    raise Mauvaise_Adresse_IP;
            end;
            Paquet_IP := 0;
            -- Puis on convertit ces entiers en une adresse IP
            convert_IP_Int(Paquet_IP, Vecteur(1), Vecteur(2), Vecteur(3), Vecteur(4)); -- On ultilise IP_Paquet par la suite

            -- On regarde d'abord si il y a une route valide dans le cache si il existe (ie la taille du cache est différent de 0)
            Est_Presente(Cache,Paquet_IP,Dans_Cache,Index_Cache);

            -- Si une adressse est valide dans le cache on la prend
            -- Par défaut Dans_Cache est faux, donc si la taille du cache est à 0 alors ça reste à faux et on rentre pas dans la boucle
            if Dans_Cache then
                Lire(Cache,Destination,Masque,Interf,Nbr_Utilisation,Index_Cache);
                Utilisation_Cache := Utilisation_Cache + 1;
            
            -- Permet de dire que j'ai trouvé une route et que je ne suis pas dans le cas d'un défaut de table
            Inter_Face_Prev := Interf;
            
            else
                -- Sinon on recherche la route correspondante dans la table de routage
                for Index_Table in 1..Nb_lignes_route loop

                    -- On lit notre triplet (Destination, Masque, Interface) dans la table de routage (LCA)
                    Lire(Table_Routage, Destination, Masque, Interf, Index_Table); --(Type LCA, Type T_Adresse_IP, Type T_Adresse_IP, Type Unbounded_String, Type Integer)

                    -- On regarder si l'adresse IP du paquet correspond à l'adresse IP de la table de routage par rapport au masque
                    -- On recupère le masque et l'interface si le masque est le plus grand
                    if Comparer_bin(Paquet_IP, Destination, Masque) and then Taille_Masque(Masque)>=Taille_Masque(Masque_Prev) then
                        Masque_Prev := Masque;
                        Inter_face_Prev := Interf;
                        Destination_Prev := Destination;
                    else
                        null;
                    end if;
                end loop;

                -- On associe les valeurs trouvées à nos variables
                Interf := Inter_face_Prev;
                Masque := Masque_Prev;
                Destination := Destination_Prev;

                Masque_Prev := 0;

            end if;

            -- si on a trouvé une route qui correspond alors on peut poursuivre notre programme
            if Inter_Face_Prev /= Null_Unbounded_String then

                -- On écrit dans le fichier texte les résultats trouvés
                Put (Resultat_file, Ligne_unb_str & " " & Interf);
                New_Line (Resultat_file);

                -- Ensuite on traite le cache

                -- D'abord on supprime une route si la taille max est atteinte et qu'on doit ajouté
                -- une route qui n'est pas dans le cache 
                if Taille(Cache) = Taille_Cache and not(Dans_Cache) and Taille_Cache /= 0 then
                    Supprimer_Une_Route(Cache, To_String(Politique));
                    Suppression_Cache := Suppression_Cache + 1;
                else
                    Null;
                end if;
            
                -- On modifie le paquet IP pour la cohérence du cache si la route n'est pas dans le cache
                if not(Dans_Cache) then
                    Destination := Coherence_Cache(Paquet_IP,Masque_Max);
                else 
                    Null;
                end if;

                -- Ensuite on met à jour le cache si le cache n'est pas nul
                if Taille_Cache /= 0 then
                    Mise_A_Jour(Cache,Destination,Masque_Max,Interf,To_String(Politique),Dans_Cache);
                else
                    Null;
                end if;

                -- On a trouvé une route correspondante, donc on incrémente de 1
                Utilisation_Totale := Utilisation_Totale + 1;

                -- On réinitialise l'interface prev (ca va nous servier à trouver les paquets qui ne sont pas dans la table)
                Inter_Face_Prev := Null_Unbounded_String;

            -- Sinon on a pas trouvé une route valide dans la table, on a alors un défaut de table, et on 
            -- incrémente la variable qui compte les défauts de 1 
            else 
                Defaut_Table := Defaut_Table +1;
            end if;
                   
        end if;

        -- On passe à la ligne suivante
        Ligne := Ligne + 1;

    end loop;

    -- récupérer l'heure (heure de fin)
	Fin := Clock;

    -- calculer la durée de l'opération
	Duree := Fin - Debut;

    -- On affiche les statistiques
    if Statistique then
       	-- Afficher la durée de opération
	    Put_Line ("Durée de l'opération:" & Duration'Image(Duree));
        Put_Line("Type de cache utilisé : " & To_String(Politique));
        Put_Line("Nombre de paquets triés : " & Integer'Image(Utilisation_Totale));
        Put_Line("Nombre de fois que l'on a pas trouvé une route valide pour un paquet : " & Integer'Image(Defaut_Table));
        Put_Line("Nombre de fois que le cache a été utilisée : " & Integer'Image(Utilisation_Cache));
        Put_Line("Taille du cache : " & Integer'Image(Taille_Cache) & ". Places restantes : " & Integer'Image(Taille_Cache - Taille(Cache)));
        Put_Line("Nombre de fois qu'une route a du être supprimée : " & Integer'Image(Suppression_Cache));
        Pourcentage_Utilisation := Integer((Float(Utilisation_Cache)/Float(Utilisation_Totale))*100.0);
        Put_Line("Pourcentage d'utilisation du cache " & Integer'Image(Pourcentage_Utilisation) & " %");

    else
        Null;
    end if;

    -- Fermeture des fichier textes
    Close (Paquets_file);
    Close (Resultat_file);

    -- On libère la mémoire occupée par la table de routage
    Vider(Table_Routage);

    -- On libère la mémoire occupée par le cache
    Vider(Cache);

-- Les différentes exceptions

exception
    when CONSTRAINT_ERROR => 
        Put_Line("Veuillez ne pas mettre de retour à la ligne à la fin du fichier des paquets a router");
    when Cache_exception.Mauvaise_Ecriture_Table =>
        Put_Line("Problème d'écriture dans le fichier contenant la table de routage");
        Put_Line("Veuillez écrire pour chaque ligne comme suit : 0.0.0.0 0.0.0.0 eth0");
    when Cache_exception.Mauvaise_Adresse_IP =>
        Put_Line("Erreur d'écriture d'une adresse IP dans le fichier des paquets");
        Put_Line("Veuillez écrire sous la forme 0.0.0.0");
    when Cache_exception.Taille_Not_Integer =>
        Put_Line("Taille du cache invalide, veuillez rentrer un nombre entier supérieur ou égal à 0");
        Put_Line("Voici le format de la commande : ");
        Put_Line("./Routeur_Cache_Liste -c <Entier> -P <Politique> -S -t <fichier table> -p <fichier paquet> -r <fichier resultat>");
    when Cache_exception.Politique_Pas_Valide =>
        Put_Line("Politique pas valide, veuillez choisir entre FIFO,LFU et LRU");
        Put_Line("Voici le format de la commande : ");
        Put_Line("./Routeur_Cache_Liste -c <Entier> -P <Politique> -S -t <fichier table> -p <fichier paquet> -r <fichier resultat>");
    when Cache_exception.Fichier_Table =>
        Put_Line("Le nom du fichier contenant la table doit être erroné.");
        Put_Line("Voici le format de la commande : ");
        Put_Line("./Routeur_Cache_Liste -c <Entier> -P <Politique> -S -t <fichier table> -p <fichier paquet> -r <fichier resultat>");
    when Cache_exception.Fichier_Paquet =>
        Put_Line("Le nom du fichier contenant les paquets doit être erroné.");
        Put_Line("Voici le format de la commande : ");
        Put_Line("./Routeur_Cache_Liste -c <Entier> -P <Politique> -S -t <fichier table> -p <fichier paquet> -r <fichier resultat>");

end routeur_cache_liste;