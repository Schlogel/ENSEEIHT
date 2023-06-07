with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with LCA;

procedure lca_sujet is

	-- Définition des types de Cle et Donnee qu'on souhaite utiliser
	package LCA_String_Integer is
		new LCA (T_Cle => Unbounded_String, T_Donnee => Integer);
	use LCA_String_Integer;


	-- Retourner une chaîne avec des guillemets autour de S
	function Avec_Guillemets (S: Unbounded_String) return String is
	begin
		return '"' & To_String (S) & '"';
	end;

	-- Afficher une Unbounded_String et un entier.
	procedure Afficher (S : in Unbounded_String; N: in Integer) is
	begin
		Put (Avec_Guillemets (S));
		Put (" : ");
		Put (N, 1);
		New_Line;
	end Afficher;

	-- Afficher la Sda.
	procedure Afficher is
		new Pour_Chaque (Afficher);
	
	-- Définition de la Sda
	Sda : LCA_String_Integer.T_LCA;
begin
	Initialiser (Sda);
	Enregistrer (Sda, To_Unbounded_String("un"), 1);
	Enregistrer (Sda, To_Unbounded_String("deux"), 2);
	Afficher (Sda);
	Vider (Sda);
end lca_sujet;
