with Ada.Unchecked_Deallocation;
with cache_exception;           use cache_exception;


package body Cache_Liste is

    procedure Free is
        new Ada.Unchecked_Deallocation (Object => T_Route, Name => T_Cache_Liste);

    procedure Initialiser(Cache: out T_Cache_Liste) is
    begin
        Cache := Null;
    end;

    function Est_Vide(Cache: in T_Cache_Liste) return Boolean is
    begin
        return Cache = Null;
    end;

    function Taille(Cache: in T_Cache_Liste) return Integer is
    begin
        if Cache = Null then
            return 0;
        else
            return Taille(Cache.all.Suivant) + 1;
        end if;
    end;

    function Index_Destination(Cache : in T_Cache_Liste; Destination : in T_Adresse_IP) return Integer is
    begin
        if Cache = Null then
            raise Destination_Absente;
        elsif Cache.All.Destination = Destination then
            return 1;
        else
            return 1 + Index_Destination(Cache.All.Suivant, Destination);
        end if;
    end;

    procedure Incrementer_Utilisation(Cache : in out T_Cache_Liste; Index : in Integer) is 
    begin
        if Cache = Null then
            Null;
        elsif Index = 1 then
            Cache.All.Nbr_Utilisation := Cache.All.Nbr_Utilisation + 1;
        else
            Incrementer_Utilisation(Cache.All.Suivant, Index - 1);
        end if;
    end;


    procedure Est_Presente(Cache: in T_Cache_Liste; Paquet : in T_Adresse_IP; Dans_Cache : out Boolean; Index : out Integer) is 
    
        -- Variables qui enregistre la meilleure route possible
        M_Masque : T_Adresse_IP := 0;

        -- Variables qui décrivent la route n°I
        I_Destination : T_Adresse_IP;
        I_Masque : T_Adresse_IP;
        I_Interf : Unbounded_String;
        I_Utilisation : Integer;

        -- Autres variables
        Taille_Cache : Integer;
    
    begin
        Taille_Cache := Taille(Cache);
        Index := 0;
        if Taille_Cache = 0 then
            Dans_Cache := False;
        else
            for i in 1..Taille(Cache) loop
                Lire(Cache,I_Destination,I_Masque,I_Interf,I_Utilisation,I); -- Lecture de la route n°i
                if Comparer_bin(Paquet,I_Destination,I_Masque) then -- Regarder si la route n°i est valide
                    if Taille_Masque(I_Masque)>=Taille_Masque(M_Masque) then -- Est ce que la route n°i est la plus précise 
                        M_Masque := I_Masque;
                        Index := I;
                        Dans_Cache := True;
                    else
                        Null;
                    end if;
                else 
                    Null;
                end if;
            end loop;
        end if;
    end;

    procedure Enregistrer(Cache : in out T_Cache_Liste; Destination : in T_Adresse_IP; Masque : in T_Adresse_IP; Interf : in Unbounded_String; Utilisation : in Integer) is
    begin
        if Cache = Null then
            Cache := New T_Route'(Destination,Masque,Interf,Utilisation,Null);
        elsif Cache.all.Destination = Destination then
            Null;
        else
            Enregistrer(Cache.all.Suivant,Destination,Masque,Interf,Utilisation);
        end if;
    end;

    procedure Supprimer(Cache: in out T_Cache_Liste; Index : in Integer) is

        -- Permet de détruire la route
        A_Detruire : T_Cache_Liste;

    begin
        if Cache = Null or Index < 1 then
            Null;
        elsif Index = 1 then
            A_Detruire := Cache;
            Cache := Cache.all.Suivant;
            Free (A_Detruire);
        else
            Supprimer(Cache.All.Suivant,Index - 1);
        end if;
    end;

    procedure Vider(Cache: in out T_Cache_Liste) is
    begin
        if Cache = Null then
            Null;
        else
            Vider(Cache.all.Suivant);
            Free(Cache);
        end if;
    end;

    procedure Pour_Chaque_Cache(Cache : in T_Cache_Liste) is
    begin
        if Cache = Null then
            Null;
        else
            begin
                Traiter(Cache.all.Destination,Cache.all.Masque,Cache.all.Interf,Cache.all.Nbr_Utilisation);
            exception
                when others =>
                    null; -- Si le traitement échoue sur un couple, on continue pour les suivants
            end;
            Pour_Chaque_Cache(Cache.all.Suivant);
        end if;
    end;

    procedure Lire(Cache: in T_Cache_Liste; Destination : out T_Adresse_IP; Masque: out T_Adresse_IP; Interf: out Unbounded_String; Utilisation : out Integer; Index: in Integer) is

        Route : T_Cache_Liste;
        i : Integer;
        Trouver : Boolean;

    begin
        Route := Cache;
        i := 1;
        Trouver := False;

        loop
            if index = i or Taille(Cache) = i then
                Destination := Route.all.Destination;
                Masque := Route.all.Masque;
                Interf := Route.all.Interf;
                Utilisation := Route.all.Nbr_Utilisation;
                Trouver := True;
            else
                Route := Route.all.Suivant;
                i := i + 1;
            end if;
        exit when Trouver; -- Je suis certain de sortir de la boucle car j'ai comme précondition index < Taille(Cache)
        end loop;
    end;


    procedure Supprimer_Une_Route(Cache : in out T_Cache_Liste; Politique : in String) is
 
    -- Variables qui enregistre la route la moins utilisée
    Min_LRU : Integer;
    Index_LRU : Integer;

    Route : T_Cache_Liste;

    begin
        if Cache = Null then
            Null;
        else
            if Politique = "FIFO" then
                Supprimer(Cache,1); -- On supprime la dernière route, donc celle qui a été ajouté en premier

            elsif Politique = "LFU" then
                -- On regarde la route la moins utilisée 
                Route := Cache;
                Index_LRU := 1;
                Min_LRU := Route.All.Nbr_Utilisation;
                for i in 1..Taille(Cache) loop
                    if Route.All.Nbr_Utilisation < Min_LRU then
                        Index_LRU := i;
                        Min_LRU := Route.All.Nbr_Utilisation;
                    else
                        Null;
                    end if;
                    Route := Route.All.Suivant;                    
                end loop;

                -- Ensuite on la supprime
                Supprimer(Cache,Index_LRU);

            elsif politique = "LRU" then
                Supprimer(Cache,1); -- Une fois qu'une route est utilisée, elle est remis au début du cache
                -- donc la route la moins récémment utilisée est la première

            else
                Null;
            end if;
        end if;
    end;

    function Coherence_Cache(Destination : in T_Adresse_IP; Masque_Max : in T_Adresse_IP) return T_Adresse_IP is 

        POIDS_FORT : constant T_Adresse_IP  := 2 ** 31;
        Nouvelle_Adresse : T_Adresse_IP := 0;

    begin

        -- Adapter la destination au masque
        -- Si pour un bit donné le masque est à 1 et que la destination est à 1 alors on rajoute le bit
        for i in 0..31 loop
            if (Masque_Max and (POIDS_FORT/(2**i))) /= 0 then
                if (Destination and (POIDS_FORT/(2**i))) /= 0 then 
                    Nouvelle_Adresse := Nouvelle_Adresse + POIDS_FORT/(2**i);
                else
                    Null;
                end if;
            else
                Null;
            end if;
        end loop;

        return Nouvelle_Adresse;
    end;

    procedure Mise_A_Jour(Cache : in out T_Cache_Liste ; Destination : in T_Adresse_IP ; Masque : in T_Adresse_IP ; Interf : in Unbounded_String ; Politique : in String; Dans_Cache : in Boolean) is

        Index : Integer;

    begin
        if Politique = "FIFO" then 
            if Dans_Cache then 
                Null;
            else
                Enregistrer(Cache,Destination,Masque,Interf,0);   -- Attention, le 0 en argument est le Nbr d'utilistion, mais comme on s'en sert pas avec cette politique on met 0
            end if;
        elsif Politique =  "LRU" then
            if Dans_Cache then
                Index := Index_Destination(Cache,Destination);
                Supprimer(Cache,Index);
                Enregistrer(Cache,Destination,Masque,Interf,0);   -- Attention, le 0 en argument est le Nbr d'utilistion, mais comme on s'en sert pas avec cette politique on met 0
            else
                Enregistrer(Cache,Destination,Masque,Interf,0);   -- Attention, le 0 en argument est le Nbr d'utilistion, mais comme on s'en sert pas avec cette politique on met 0
            end if;
        elsif Politique = "LFU" then
            if Dans_Cache then -- Il faut trouver la route utilisée et incrémenter le nbr d'utilisation de 1
                Index := Index_Destination(Cache,Destination);
                Incrementer_Utilisation(Cache,Index);
            else
                Enregistrer(Cache,Destination,Masque,Interf,1);
            end if;
        else
            Null;
        end if;
    end;


end Cache_Liste;
