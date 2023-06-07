<<<<<<< HEAD
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
procedure Exemple_Fichiers is
	Nom_Sortie : Unbounded_String;
	Nom_Entree : Unbounded_String;
	Valeur : Integer;
	Texte : Unbounded_String;
	Somme : Integer;
	Numero_Ligne : Integer;
	Entree : File_Type;	-- Le descripteur du ficher d'entrée
	Sortie : File_Type;	-- Le descripteur du ficher de sortie
begin
	if Argument_Count /= 1 then
		Put("usage : " & Command_Name & " <fichier>");
	else
		Nom_Entree := To_Unbounded_String (Argument (1));
		Nom_Sortie := To_Unbounded_String ("bilan.txt");
		Create (Sortie, Out_File, To_String (Nom_Sortie));
		Open (Entree, In_File, To_String (Nom_Entree));
		begin
			Somme := 0;
			loop
				Numero_Ligne := Integer (Line (Entree));
				-- Si on attend de lire le texte, on sera déjà sur la ligne suivante.
				Get (Entree, Test);       -- Lire un entier depuis le fichier Entree
				Texte := Get_Line (Entree); -- Lire le reste de la ligne depuis le fichier Entree
				Trim (Texte, Both);	        -- supprimer les blancs du début et de la fin de Texte

				Somme := Somme + Valeur;

				Put (Sortie, Numero_Ligne, 3);   -- Écrire le numéro de ligne sur 3 postions sur le fichier Sortie
				Put (Sortie, " " & Texte & " ");
				Put (Sortie, Somme, 1);
				New_Line (Sortie);
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
end Exemple_Fichiers;
=======
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
procedure Exemple_Fichiers is
	Nom_Sortie : Unbounded_String;
	Nom_Entree : Unbounded_String;
	Valeur : Integer;
	Texte : Unbounded_String;
	Somme : Integer;
	Numero_Ligne : Integer;
	Entree : File_Type;	-- Le descripteur du ficher d'entrée
	Sortie : File_Type;	-- Le descripteur du ficher de sortie
begin
	if Argument_Count /= 1 then
		Put("usage : " & Command_Name & " <fichier>");
	else
		Nom_Entree := To_Unbounded_String (Argument (1));
		Nom_Sortie := To_Unbounded_String ("bilan.txt");
		Create (Sortie, Out_File, To_String (Nom_Sortie));
		Open (Entree, In_File, To_String (Nom_Entree));
		begin
			Somme := 0;
			loop
				Numero_Ligne := Integer (Line (Entree));
				-- Si on attend de lire le texte, on sera déjà sur la ligne suivante.
				Get (Entree, Valeur);       -- Lire un entier depuis le fichier Entree
				Texte := Get_Line (Entree); -- Lire le reste de la ligne depuis le fichier Entree
				Trim (Texte, Both);	        -- supprimer les blancs du début et de la fin de Texte
				Put(Boolean'Image(Texte = "fin"));

				Somme := Somme + Valeur;

				Put (Sortie, Numero_Ligne, 3);   -- Écrire le numéro de ligne sur 3 postions sur le fichier Sortie
				Put (Sortie, " " & Texte & " ");
				Put (Sortie, Somme, 1);
				New_Line (Sortie);
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
end Exemple_Fichiers;
>>>>>>> d698e286ee0cb828632a20f6d9c1e089bc736fc5
