with Ada.Strings;               use Ada.Strings;	-- pour Both utilisé par Trim
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with cache_exception;           use cache_exception;
with Ada.Unchecked_Deallocation;


package body Table_Routage is

    procedure Free is
        new Ada.Unchecked_Deallocation (Object => T_Route, Name => T_Table_Routage);

    procedure Initialiser(Table: out T_Table_Routage) is
    begin
        Table := Null;
    end;

    function Est_Vide(Table: in T_Table_Routage) return Boolean is
    begin
        return Table = Null;
    end;

    function Taille(Table: in T_Table_Routage) return Integer is
    begin
        if Table = Null then
            return 0;
        else
            return Taille(Table.all.Suivant) + 1;
        end if;
    end;

    procedure Enregistrer(Table : in out T_Table_Routage; Destination : in T_Adresse_IP; Masque : in T_Adresse_IP; Interf : in Unbounded_String) is
    begin
        if Table = Null then
            Table := New T_Route'(Destination,Masque,Interf,Null);
        elsif Table.all.Destination = Destination then
            Null;
        else
            Enregistrer(Table.all.Suivant,Destination,Masque,Interf);
        end if;
    end;

    procedure Vider(Table: in out T_Table_Routage) is
    begin
        if Table = Null then
            Null;
        else
            Vider(Table.all.Suivant);
            Free(Table);
        end if;
    end;

    procedure Pour_Chaque_Table(Table : in T_Table_Routage) is
    begin
        if Table = Null then
            Null;
        else
            begin
                Traiter(Table.all.Destination,Table.all.Masque,Table.all.Interf);
            exception
                when others =>
                    null; -- Si le traitement échoue sur un couple, on continue pour les suivants
            end;
            Pour_Chaque_Table(Table.all.Suivant);
        end if;
    end;

    procedure Lire(Table: in T_Table_Routage; Destination : out T_Adresse_IP; Masque: out T_Adresse_IP; Interf: out Unbounded_String; Index: in Integer) is

        Route : T_Table_Routage;
        i : Integer;
        Trouver : Boolean;

    begin
        Route := Table;
        i := 1;
        Trouver := False;

        loop
            if index = i or Taille(Table) = i then
                Destination := Route.all.Destination;
                Masque := Route.all.Masque;
                Interf := Route.all.Interf;
                Trouver := True;
            else
                Route := Route.all.Suivant;
                i := i + 1;
            end if;
        exit when Trouver; -- Je suis certain de sortir de la boucle car j'ai comme précondition index < Taille(Table)
        end loop;
    end;

    procedure Enregistrement(Table: in out T_Table_Routage; Nom_Fichier : in Unbounded_String) is

        type T_Vecteur is array (1..4) of Integer;

        ABCD : T_Vecteur;
        Poubelle : Character;
        Destination : T_Adresse_IP := 0;
        Masque : T_Adresse_IP := 0;
        Interf : Unbounded_String;
        Entree : File_Type;

    begin
        -- Exception pour gérer si le nom du fichier est bien valide
        begin
            Open (Entree, In_File, To_String(Nom_Fichier));
        exception   
            when others =>
                raise Fichier_Table;
        end;

        begin
        loop      
            -- Récupération de la Destination
            for i in 1..4 loop
                Get(Entree,ABCD(i)); -- Récupérer un chiffre
                Get(Entree,Poubelle); -- Enlever les charactères entres les 2 chiffres
            end loop;
            convert_IP_Int(Destination,ABCD(1),ABCD(2),ABCD(3),ABCD(4));

            -- Récupération du masque
            for i in 1..3 loop
                Get(Entree,ABCD(i));
                Get(Entree,Poubelle);
            end loop;
            Get(Entree,ABCD(4)); -- Ici si on utilise la poubelle, alors l'interface disparait
            convert_IP_Int(Masque,ABCD(1),ABCD(2),ABCD(3),ABCD(4));

            -- Récupération de l'interface
            Interf := Get_Line (Entree);
            Trim (Interf, Both);

            -- Une fois qu'on a lu une ligne, il faut l'enregistrer dans la Table
            Enregistrer(Table,Destination,Masque,Interf);

        exit when End_Of_File (Entree);
        end loop;
        exception
            when others =>
                raise Mauvaise_Ecriture_Table;
        end;
        Close(Entree);
    end;

    function Masque_Plus_Precis(Table : in T_Table_Routage) return T_Adresse_IP is 

        Route : T_Table_Routage;
        Masque_Max : T_Adresse_IP;
        Taille_Max : Integer;

    begin
        if Table = Null then
            return 0;
        else
            -- Trouver le masque le plus précis
            Route := Table;
            Masque_Max := Route.All.Masque;
            Taille_Max := Taille_Masque(Masque_Max);
            for i in 2..Taille(Table) loop
                Route := Route.All.Suivant;
                if Taille_Max < Taille_Masque(Route.All.Masque) then
                    Masque_Max := Route.All.Masque;
                    Taille_Max := Taille_Masque(Route.All.Masque);
                else
                    Null;
                end if;
            end loop;
            return Masque_Max;
        end if;
    end;



end Table_Routage;
