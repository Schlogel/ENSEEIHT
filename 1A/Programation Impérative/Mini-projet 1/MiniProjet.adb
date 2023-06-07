with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;

procedure Table_multiplications is
    Recommencer : String := "o" ;    --Variable permettant de savoir si l'utilisateur souhaite r�viser une ou plusieurs tables
    Table : Integer ;                   --Table de multiplication choisit par l'utilisateur
    Depart : Boolean := False ;         --Variable qui controle la valeur de Table pour commencer les 10 calculs
    Erreurs : Integer := 0 ;            --Nombres d'erreurs commisent aucours des 10 calculs
    Reponse : Integer := 0 ;            --Nombres de bonnes r�ponses aucours des 10 calculs
    Nombre_Aleatoire : Integer := 0 ;
begin

    --Permettre � l'utilisateur de r�viser plusieur tables de multiplications
    while (Recommencer = "o") or (Recommencer = "O") loop

        --V�rification de la valeur de la table choisit
        Depart := False ;
        while not(Depart) loop
        Put ("Table � r�viser :") ;
        Get (Table) ;
        New_Line ;
        if (0<=Table) and (Table<=10) then
            Depart := True ;
        else
            Put ("Impossible. La table doit �tre entre 0 et 10.") ;
            New_Line ;
        end if;
        end loop;

        --Proposition des 10 calculs pour une table donn�
        for Var in 1..10 loop
            Put (Table) ;
            Put (" *") ;
            Put (Nombre_Aleatoire) ;
            Put (" ?") ;
            Get (Reponse) ;
            New_Line ;

            --V�rifiaction de la r�ponse pour le calcul
            if Reponse /= Table*Nombre_Aleatoire then
                Put ("Mauvaise r�ponse") ;
                New_Line ;
                Erreurs := Erreurs + 1 ;
            else
                Put ("Bravo!") ;
                New_Line ;
            end if;

        end loop;

        --Fin de l'exercice, conclusion sur le nombre d'erreurs
        if Erreurs = 0 then
            Put ("Aucune erreur. Excellent!") ;
        elsif Erreurs = 1 then
            Put ("Une seule erreur. Tr�s bien.") ;
        elsif Erreurs = 10 then
            Put ("Tout est faux ! Volontaire ?") ;
        elsif (6 <= Erreurs) and (Erreurs <= 9) then
            Put ("Seulement ") ;
            Put (10-Erreurs) ;
            Put (" bonnes r�ponses. Il faut apprendre la table de ") ;
            Put (Table) ;
            Put (" !") ;
        elsif (2 <= Erreurs) and (Erreurs <= 5) then
            Put (Erreurs) ;
            Put (" erreurs. Il faut encore travailler la table de ") ;
            Put (Table) ;
            Put (".") ;
        end if;
        New_Line ;

        --On propose � l'utilisateur de r�viser une autre table
        Put ("On continue (o/n) ?") ;
        Get (Recommencer) ;
        New_Line ;

    end loop;

end Table_multiplications;
