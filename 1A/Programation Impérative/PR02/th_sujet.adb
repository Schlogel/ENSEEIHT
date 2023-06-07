with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with TH;

procedure th_sujet is
	
	--Définition de la fonction de hachage
	function H (Cle: Unbounded_String) return Integer is
		
	begin
		if length(Cle) > 11 then
			return length(Cle) mod 11;
		else
			return length(Cle);
		end if;
	end;
	
	--Import du type et des fonctions de th.adb
	package TH_String_Integer is
		new TH (T_Cle => Unbounded_String, T_Donnee => Integer, BORNE_MAX => 11, Type_Hachage => H);
	use TH_String_Integer;
	
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
	Sda : TH_String_Integer.T_TH;

begin
	Initialiser (Sda);
	Enregistrer (Sda, To_Unbounded_String("un"), 1);
	Enregistrer (Sda, To_Unbounded_String("deux"), 2);
	Enregistrer (Sda, To_Unbounded_String("trois"), 3);
	Enregistrer (Sda, To_Unbounded_String("quatres"), 4);
	Enregistrer (Sda, To_Unbounded_String("cinq"), 5);
	Enregistrer (Sda, To_Unbounded_String("quatre-vingt-dix-neuf"), 99);
	Enregistrer (Sda, To_Unbounded_String("vingt-et-un"), 21);
	Afficher (Sda);
	Vider (Sda);
end th_sujet;
