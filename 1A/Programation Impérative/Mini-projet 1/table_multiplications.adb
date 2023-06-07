with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Calendar; use Ada.Calendar;
with Alea; 

procedure Table_multiplications is
    Recommencer : String := "o";       --Variable permettant de savoir si l'utilisateur souhaite réviser une ou plusieurs tables
    Table : Integer;                   --Table de multiplication choisit par l'utilisateur
    Depart : Boolean := False;         --Variable qui controle la valeur de Table pour commencer les 10 calculs
    Erreurs : Integer := 0;            --Nombres d'erreurs commisent aucours des 10 calculs
    Reponse : Integer := 0;            --Nombres de bonnes réponses aucours des 10 calculs
    Nombre_Aleatoire : Integer;
    Nb_Questions : Integer := 10;
    
    Debut : Time ;
    Fin : Time ;
    Temps_max : Duration := Duration(0.0);
    Temps_moy : Duration;
    Table_conseillee : Integer;
    
   
    package Mon_Alea is
        new Alea (1, Nb_Questions);
    use Mon_Alea;
   
begin

    --Permettre à l'utilisateur de réviser plusieur tables de multiplications
    while (Recommencer = "o") or (Recommencer = "O") loop
        

        --Vérification de la valeur de la table choisit
        Depart := False;
        while not(Depart) loop
            Put ("Table à réviser :");
            Get (Table);
            New_Line;
            if (0<=Table) and (Table<=10) then
                Depart := True;
            else
                Put ("Impossible. La table doit être entre 0 et 10.");
                New_Line;
            end if;
        end loop;

        --Proposition des 10 calculs pour une table donné
        for Var in 1..Nb_Questions loop
            Get_Random_Number (Nombre_Aleatoire);
            Put (Table);
            Put (" *");
            Put (Nombre_Aleatoire);
            Put (" ?");
            Debut := Clock;
            Get (Reponse);
            Fin := Clock;
            New_Line;

            --Vérifiaction de la réponse pour le calcul
            if Reponse /= Table*Nombre_Aleatoire then
                Put ("Mauvaise réponse");
                New_Line ;
                Erreurs := Erreurs + 1;
            else
                Put ("Bravo!");
                New_Line;
            end if;
            
            --Contrôle du temps mis pour répondre au calcul
            Temps_moy := Temps_moy + (Fin - Debut);
            if Temps_max < Fin - Debut then
                Temps_max := Fin - Debut;
                Table_conseillee := Nombre_Aleatoire;
            else
                null;
            end if;
            
        end loop;

        --Fin de l'exercice, conclusion sur le nombre d'erreurs
        if Erreurs = 0 then
            Put ("Aucune erreur. Excellent!");
        elsif Erreurs = 1 then
            Put ("Une seule erreur. Très bien.");
        elsif Erreurs = Nb_Questions then
            Put ("Tout est faux ! Volontaire ?");
        elsif (6 <= Erreurs) and (Erreurs <= Nb_Questions-1) then
            Put ("Seulement ");
            Put (Nb_Questions-Erreurs);
            Put (" bonnes réponses. Il faut apprendre la table de ");
            Put (Table);
            Put (" !");
        elsif (2 <= Erreurs) and (Erreurs <= 5) then
            Put (Erreurs);
            Put (" erreurs. Il faut encore travailler la table de ");
            Put (Table);
            Put (".");
        end if;
        New_Line ;
        
        --Conclusion sur le temps mis pour répondre aux calculs
        Temps_moy := Temps_moy / Nb_Questions ;
        if Temps_max - Temps_moy > 1 then
            Put ("Des hésitations sur la table de ");
            Put (Table_conseillee);
            Put (" : " & Duration'Image(Temps_max));
            Put (" secondes contre " & Duration'Image(Temps_moy));
            Put (" en moyenne. Il faut certainement la réviser.");
            New_Line;
        else
            null;
        end if;

        --On propose à l'utilisateur de réviser une autre table
        Put ("On continue (o/n) ?");
        Get (Recommencer);
        New_Line;

    end loop;

end Table_multiplications;
