with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Calendar; use Ada.Calendar;
with Alea; 

procedure multiplications is

    --Variables
    Recommencer : String := "o";            	--Variable permettant de savoir si l'utilisateur souhaite réviser de nouveau une table
    Table : Integer;                       	--Table de multiplication choisie par l'utilisateur
    Depart : Boolean := False;              	--Variable qui contrôle la valeur de Table pour commencer les 10 calculs
    Erreurs : Integer := 0;                	--Nombres d'erreurs commisent aucours des 10 calculs
    Reponse : Integer := 0;                 	--Nombres de bonnes réponses aucours des 10 calculs
    Nb_Questions : Constant Integer := 10;	--Nombre de questions posé à l'utilisateur (vaut 10 pour ce projet)
    Doublon : Integer := -1;			--Variable qui permet d'éviter que le même calcul soit posé deux fois de suite
    
    --Variable en liens avec l'extension Alea
    Nombre_Aleatoire : Integer;			--Nombre aléatoire utilisé pour les dix calculs et modifié par Get_Random_Number
    
    --Variables en liens avec l'extension Ada.Calendar
    Debut : Time ;				--Variable mesurant l'heure au début du calcul
    Fin : Time ;				--Variable mesurant l'heure à la fin du calcul
    Temps_max : Duration := Duration(0.0);	--Mesure du temps maximale utilisé pour répondre à un calcul
    Temps_moy : Duration := Duration(0.0);	--Mesure du temps moyen utilisé pour répondre aux 10 calculs
    Table_conseillee : Integer;			--Table retenue pour conseiller l'utilisateur
    
    --Déclaration de l'élément générant un nombre aléatoire
    package Mon_Alea is
        new Alea (1, Nb_Questions);
    use Mon_Alea;
   
begin

    --Permettre à l'utilisateur de réviser plusieurs tables de multiplications
    while (Recommencer = "o") or (Recommencer = "O") loop
        
        --Vérification de la valeur de la table choisie
        Depart := False;
        while not(Depart) loop
            New_Line;
            Put ("Table à réviser : ");
            Get (Table);
            if (0<=Table) and (Table<=10) then
                Depart := True;
            else
                Put_Line ("Impossible. La table doit être entre 0 et 10.");
            end if;
        end loop;
        Erreurs := 0;
        Doublon := -1;
        New_Line;
        
        --Proposition des 10 calculs pour une table donné
        for Var in 1..Nb_Questions loop
        
            --Obtetion d'un nombre aléatoire et vérification de s'il était déjà utilisé lors du calcul précédant
            Get_Random_Number (Nombre_Aleatoire);
            while Doublon = Nombre_Aleatoire loop
            	Get_Random_Number (Nombre_Aleatoire);
            end loop;
            Doublon := Nombre_Aleatoire;
            
            --Proposition d'un calcul
            Put ("(M" & Integer'Image(Var) & ")" & Integer'Image(Table) & " *" & Integer'Image(Nombre_Aleatoire) & " ? ");
            Debut := Clock;
            Get (Reponse);
            Fin := Clock;

            --Vérifiaction de la réponse pour le calcul : Table * Nombre_Aleatoire
            if Reponse /= Table*Nombre_Aleatoire then
                Put_Line ("Mauvaise réponse.");
                Erreurs := Erreurs + 1;
            else
                Put_Line ("Bravo!");
            end if;
            New_Line;
            
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
        case Erreurs is
            when 0 => Put ("Aucune erreur. Excellent!");
            when 1 => Put ("Une seule erreur. Très bien.");
            when Nb_Questions => Put ("Tout est faux ! Volontaire ?");
            when 6..(Nb_Questions-1) => Put ("Seulement" & Integer'Image(Nb_Questions-Erreurs) & " bonnes réponses. Il faut apprendre la table de " & Integer'Image(Table) & ".");
            when others => Put (Integer'Image(Erreurs) & " erreurs. Il faut encore travailler la table de" & Integer'Image(Table) & ".");
        end case;
        New_Line ;
        
        --Conclusion sur le temps mis pour répondre aux calculs
        Temps_moy := Temps_moy / Nb_Questions ;
        if Temps_max - Temps_moy > Duration(1.0) then
            Put ("Des hésitations sur la table de" & Integer'Image(Table_conseillee) & " :" & Duration'Image(Temps_max) & " secondes contre" & Duration'Image(Temps_moy) & " en moyenne. Il faut certainement la réviser.");
        else
            null;
        end if;

        --On propose à l'utilisateur de réviser une autre table
        New_Line;
        Put ("On continue (o/n) ? ");
        Get (Recommencer);

    end loop;

end multiplications;
