-- Programme Routeur Simple
-- Projet, équipe 1, groupe AB
with Table_Routage;             use Table_Routage;
with Adresse_IP;                use Adresse_IP;
with Ada.Strings;               use Ada.Strings;	
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;          use Ada.Command_Line;
with Ada.Calendar;              use Ada.Calendar;
with Routeur_exception;         use Routeur_exception;
with Ada.IO_Exceptions;

procedure routeur_simple is

    -- -- -- Variables -- -- --

    -- -- Variables pour la musre du temps -- --
    Debut: Time;         -- heure de début de l'opération
	Fin: Time;           -- heure de fin de l'opération
	Duree : Duration;    -- durée de l'opération

    -- -- Variables de parcours -- --

    Forced_exit : boolean := False;
    Ligne : integer := 1;
    Nb_lignes_paquets : integer;
    Nb_lignes_route : integer;
    Ligne_unb_str : Unbounded_String;

    -- -- Variables liées aux fichiers -- --

    -- Liens avec la table de routage
    Table_Routage_txt : Unbounded_String;
    Table_Routage : T_Table_Routage;
    Table_routage_file : File_Type;
    Ligne_table : Unbounded_String;
    -- Liens avec les paquets
    Paquets_txt : Unbounded_String;
    Paquets_file : File_Type;
    -- Liens avec les résultats
    Resultat_txt : Unbounded_String;
    Resultat_file : File_Type;
    -- Liens avec la recherche dans la table de routage --
    Destination : T_Adresse_IP;
    Masque : T_Adresse_IP;
    Masque_Copie : T_Adresse_IP;
    Inter_face: Unbounded_String;
    Masque_Prev : T_Adresse_IP := 0;
    Inter_Face_Prev : Unbounded_String;
    Vecteur : T_vecteur;
    IP_paquet : T_Adresse_IP;

    -- -- -- Fonctions/Procédures -- -- --

    -- Procédure qui lit les entrées dans le terminal et les stocke dans les variables correspondantes
    procedure Lec_terminal(Table_txt : out Unbounded_String; Paquets_txt : out Unbounded_String; Resultat_txt : out Unbounded_String) is
        Cur_Argument : Unbounded_String;
    begin
        -- Définition des noms par défaut
        Table_txt := To_Unbounded_String("table.txt");
        Paquets_txt := To_Unbounded_String("paquets.txt");
        Resultat_txt := To_Unbounded_String("resultats.txt");

        -- Récupération des arguments
        for i in 1..Argument_Count loop
            Cur_Argument := To_Unbounded_String(Argument(i)); 
            if Cur_Argument = "-t" then
                begin
                    Table_txt := To_Unbounded_String(Argument(i+1));
                    if To_string(Table_txt)((Length(Table_txt)-3)..(Length(Table_txt))) /= ".txt" then
                        raise Nom_fichier;
                    else
                        null;
                    end if;
                exception
                    when others => 
                        raise Nom_fichier;
                end;
            elsif Cur_Argument = "-p" then 
                Paquets_txt := To_Unbounded_String(Argument(i+1));
                begin
                    Table_txt := To_Unbounded_String(Argument(i+1));
                    if To_string(Paquets_txt)((Length(Paquets_txt)-3)..(Length(Paquets_txt))) /= ".txt" then
                        raise Nom_fichier;
                    else
                        null;
                    end if;
                exception
                    when others => 
                        raise Nom_fichier;
                end;
            elsif Cur_Argument = "-r" then
                Resultat_txt := To_Unbounded_String(Argument(i+1));
                begin
                    Table_txt := To_Unbounded_String(Argument(i+1));
                    if To_string(Resultat_txt)((Length(Resultat_txt)-3)..(Length(Resultat_txt))) /= ".txt" then
                        raise Nom_fichier;
                    else
                        null;
                    end if;
                exception
                    when others => 
                        raise Nom_fichier;
                end;
            else
                null;
            end if;
        end loop;
    exception
        when CONSTRAINT_ERROR => 
            Put_Line("Il manque des arguments dans votre ligne de commande.");
        when others =>
            Put_Line("Erreur inconnue");
    end Lec_terminal;

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

begin
    -- récupérer l'heure (heure de début)
	Debut := Clock;

    -- Lecture des entrées dans le terminal
    Lec_terminal(Table_Routage_txt, Paquets_txt, Resultat_txt);
    Nb_lignes_paquets := Taille_txt(Paquets_txt);
    Nb_lignes_route := Taille_txt(Table_routage_txt);

    -- Conversion de la table de routage (.txt) en LCA dans Table_Routage
    Initialiser(Table_Routage);
    Enregistrement(Table_Routage, Table_Routage_txt); --(Type LCA, Type Unbounded_string)

    -- Création du fichier pour les résultats
    Create (Resultat_file, Out_File, To_String (Resultat_txt));

    -- Ouverture du fichier contenant les paquets
    Open (Paquets_file, In_File, To_String (Paquets_txt));

    --Parcours du fichier texte (chaque ligne) contenant les paquets 
    while not(Forced_exit) and (Ligne <= Nb_lignes_paquets) loop

        -- Récupération de la ligne
        Ligne_unb_str := Get_Line (Paquets_file);
		Trim (Ligne_unb_str, Both);	        -- supprimer les blancs du début et de la fin de Texte

        -- On supprime le retour à la ligne sauf pour la dernière ligne
        if Ligne < Nb_lignes_paquets then
            Ligne_unb_str := To_Unbounded_String(To_string(Ligne_unb_str)(1..(Length(Ligne_unb_str)-1)));  
        else
            null;   
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
            Open (Table_routage_file, In_File, To_String (Table_Routage_txt));
            loop
                Ligne_table := Get_Line(Table_routage_file);
                Trim (Ligne_table, Both);
                Put_Line(Ligne_table);
                exit when End_Of_File (Table_routage_file);
            end loop;
            Close (Table_Routage_file);
            New_Line;

        else
            -- Ligne_unb_str est une adresse IP

            -- On convertit la ligne en un T_Adresse_IP
            Vecteur := nombres(Ligne_unb_str); 
            IP_paquet := 0;
            convert_IP_Int(IP_Paquet, Vecteur(1), Vecteur(2), Vecteur(3), Vecteur(4)); -- On ultilise IP_Paquet par la suite

            -- On recherche la route correspondante dans la table de routage
            for Index_Table in 1..Nb_lignes_route loop
                
                -- On lit notre triplet (Destination, Masque, Interface) dans la table de routage (LCA)
                Lire(Table_Routage, Destination, Masque, Inter_face, Index_Table); --(Type LCA, Type T_Adresse_IP, Type T_Adresse_IP, Type Unbounded_String, Type Integer)
                
                Masque_Copie := Masque;
                -- On regarder si l'adresse IP du paquet correspond à l'adresse IP de la table de routage par rapport au masque
                -- On recupère le masque et l'interface si le masque est le plus grand
                if Comparer_bin(IP_paquet, Destination, Masque) and then (Taille_Masque(Masque)>=Taille_Masque(Masque_Prev)) then
                    Masque_Prev := Masque_Copie;
                    Inter_face_Prev := Inter_face;
                else
                    null;
                end if;

            end loop;

            -- On écrit dans le fichier texte les résultats trouvés
            Put (Resultat_file, Ligne_unb_str & " " & Inter_Face_Prev);
            New_Line (Resultat_file);
            
        end if;
        -- On réinitialise le masque
        Masque_Prev := 0;

        -- On passe à la ligne suivante
        Ligne := Ligne + 1;

    end loop;

    -- récupérer l'heure (heure de fin)
	Fin := Clock;

    -- calculer la durée de l'opération
	Duree := Fin - Debut;

    -- Afficher la durée de opération
	Put_Line ("Durée de l'opération:" & Duration'Image(Duree));

    -- Fermeture des fichier textes
    Close (Paquets_file);
    Close (Resultat_file);

    -- On libère la mémoire occupée par la table de routage
    Vider(Table_Routage);



end routeur_simple;