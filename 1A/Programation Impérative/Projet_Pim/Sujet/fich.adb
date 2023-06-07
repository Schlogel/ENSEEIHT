with Ada.Strings;               use Ada.Strings;	-- pour Both utilisé par Trim
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;          use Ada.Command_Line;
with Ada.Exceptions;            use Ada.Exceptions;	-- pour Exception_Message


-- Illustration de la lecture et de l'écriture de fichiers.
-- Ce programme attend un fichier sur la ligne de commande (par exemple,
-- exemple1.txt ou exemple2.txt) qui contient sur chaque ligne un nombre et un
-- texte.
-- Il produit un autre fichier "bilan.txt".
procedure fich is
	Nom_Entree : Unbounded_String;
	Valeur : Integer;
	Texte : Unbounded_String;
	Numero_Ligne : Integer;
	Entree : File_Type;	-- Le descripteur du ficher d'entrée
	Sortie : File_Type;	-- Le descripteur du ficher de sortie
	Test : Integer;
	Poubelle : Character;
begin
	if Argument_Count /= 1 then
		Put("usage : " & Command_Name & " <fichier>");
	else
		Nom_Entree := To_Unbounded_String (Argument (1));
		Open (Entree, In_File, To_String (Nom_Entree));
		begin
			loop
				Numero_Ligne := Integer (Line (Entree));
				-- Si on attend de lire le texte, on sera déjà sur la ligne suivante.
				Get(Entree,Test);       -- Lire un entier depuis le fichier Entree
                Put(Test);
				Get(Entree,Poubelle);
				Get(Entree, Valeur);
                Put(Valeur);
                Get(Entree,Poubelle);
                Get(Entree,Valeur);
				Put(Valeur);     -- supprimer les blancs du début et de la fin de Texte
				exit when End_Of_File (Entree);
			end loop;
		exception
			when End_Error =>
				Put ("Blancs en surplus à la fin du fichier.");
				null;
		end;
		Close (Entree);
		Close (Sortie);
	end if;
exception
	when E : others =>
		Put_Line (Exception_Message (E));
end fich;
