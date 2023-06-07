with cache_liste;               use cache_liste;
with adresse_IP;                use adresse_IP;
with Ada.Strings;               use Ada.Strings;	
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;

procedure test_cache is

    Cache_FIFO : T_Cache_Liste;
    Cache_LRU : T_Cache_Liste;
    Cache_LFU : T_Cache_Liste;
    Taille_Cache : Integer := 2;
    Adresse_1 : T_Adresse_IP := 0;
    Masque_1 : T_Adresse_IP := 0;
    Interf_1 : Unbounded_String;
    Adresse_2 : T_Adresse_IP := 0;
    Masque_2 : T_Adresse_IP := 0;
    Interf_2 : Unbounded_String;
    Adresse_3 : T_Adresse_IP := 0;
    Masque_3 : T_Adresse_IP := 0;
    Interf_3 : Unbounded_String;
    Dans_Cache : Boolean := False;
    Index : Integer := 0;


begin

    -- Initialisation des caches
    Initialiser(Cache_FIFO);
    Initialiser(Cache_LRU);
    Initialiser(Cache_LFU);

    -- Test de la fonction est vide
    pragma Assert(Est_Vide(Cache_FIFO) = True);

    -- Création d'une route
    convert_IP_Int(Adresse_1,1,1,1,1);
    convert_IP_Int(Masque_1,255,255,255,255);
    Interf_1 := To_Unbounded_String("eth0");

    -- Ajouter une route
    Enregistrer(Cache_FIFO,Adresse_1, Masque_1, Interf_1, 0);
    Enregistrer(Cache_LRU,Adresse_1, Masque_1, Interf_1, 0);
    Enregistrer(Cache_LFU,Adresse_1, Masque_1, Interf_1, 0);

    -- On regare si la route a bien été ajouté en testant la fonction taille
    pragma Assert(Taille(Cache_FIFO) = 1);

    -- On ajoute une autre route 
    convert_IP_Int(Adresse_2,2,2,2,2);
    convert_IP_Int(Masque_2,255,255,255,255);
    Interf_2 := To_Unbounded_String("eth1");

    Enregistrer(Cache_FIFO,Adresse_2, Masque_2, Interf_2, 0);
    Enregistrer(Cache_LRU,Adresse_2, Masque_2, Interf_2, 0);
    Enregistrer(Cache_LFU,Adresse_2, Masque_2, Interf_2, 0);
    
    -- Test de la fonction Index
    pragma Assert(Index_Destination(Cache_FIFO,Adresse_2) = 2);
    
    -- Création d'une troisème route (mais qu'on ajoute pas encore)
    convert_IP_Int(Adresse_3,3,3,3,3);
    convert_IP_Int(Masque_3,255,255,255,255);
    Interf_3 := To_Unbounded_String("eth2");

    -- Test de la procedure Est_Presente 
    Est_Presente(Cache_FIFO,Adresse_1,Dans_Cache,Index);
    pragma Assert(Dans_Cache = True and Index = 1);
    Est_Presente(Cache_FIFO,Adresse_3,Dans_Cache,Index);
    Put(Integer'Image(Index));
    Put(Boolean'Image(Dans_Cache));
    pragma Assert(Dans_Cache = False and Index = 0);


    Put_Line("Test OK");

end test_cache;