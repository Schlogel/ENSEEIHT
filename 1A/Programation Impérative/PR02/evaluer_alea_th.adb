with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Ada.Command_Line;     use Ada.Command_Line;
with Alea;
with TH;

-- �valuer la qualit� du g�n�rateur al�atoire et les TH.
procedure Evaluer_Alea_TH is

	function H (Cle: Integer) return Integer is
	begin
		if Cle > 1000 then
			return Cle mod 11;
		else
			return Cle;
		end if;
	end;
	
	package TH_Objets is
		new TH (T_Cle => Integer, T_Donnee => Integer, BORNE_MAX => 1000, Type_Hachage => H);

	-- Afficher l'usage.
	procedure Afficher_Usage is
	begin
		New_Line;
		Put_Line ("Usage : " & Command_Name & " Borne Taille");
		New_Line;
		Put_Line ("   Borne  : les nombres sont tir�s dans l'intervalle 1..Borne");
		Put_Line ("   Taille : la taille de l'�chantillon");
		New_Line;
	end Afficher_Usage;


	-- Afficher le Nom et la Valeur d'une variable.
	-- La Valeur est affich�e sur la Largeur_Valeur pr�cis�e.
	procedure Afficher_Variable (Nom: String; Valeur: in Integer; Largeur_Valeur: in Integer := 1) is
	begin
		Put (Nom);
		Put (" : ");
		Put (Valeur, Largeur_Valeur);
		New_Line;
	end Afficher_Variable;

	-- �valuer la qualit� du g�n�rateur de nombre al�atoire Alea sur un
	-- intervalle donn� en calculant les fr�quences absolues minimales et
	-- maximales des entiers obtenus lors de plusieurs tirages al�atoires.
	--
	-- Param�tres :
	-- 	  Borne: in Entier	-- le nombre al�atoire est dans 1..Borne
	-- 	  Taille: in Entier -- nombre de tirages (taille de l'�chantillon)
	-- 	  Min, Max: out Entier -- fr�quence minimale et maximale
	--
	-- N�cessite :
	--    Borne > 1
	--    Taille > 1
	--
	-- Assure : -- poscondition peu int�ressante !
	--    0 <= Min Et Min <= Taille
	--    0 <= Max Et Max <= Taille
	--    Min /= Max ==> Min + Max <= Taille
	--
	-- Remarque : On ne peut ni formaliser les 'vraies' postconditions,
	-- ni �crire de programme de test car on ne ma�trise par le g�n�rateur
	-- al�atoire.  Pour �crire un programme de test, on pourrait remplacer
	-- le g�n�rateur par un g�n�rateur qui fournit une s�quence connue
	-- d'entiers et pour laquelle on pourrait d�terminer les donn�es
	-- statistiques demand�es.
	-- Ici, pour tester on peut afficher les nombres al�atoires et refaire
	-- les calculs par ailleurs pour v�rifier que le r�sultat produit est
	-- le bon.
	procedure Calculer_Statistiques (
		Borne    : in Integer;  -- Borne sup�rieur de l'intervalle de recherche
		Taille   : in Integer;  -- Taille de l'�chantillon
		Min, Max : out Integer  -- min et max des fr�quences de l'�chantillon
	) with
		Pre => Borne > 1 and Taille > 1,
		Post => 0 <= Min and Min <= Taille
			and 0 <= Max and Max <= Taille
			and (if Min /= Max then Min + Max <= Taille)
	is
		package Mon_Alea is
			new Alea (1, Borne);
		use Mon_Alea;
		
		Sda : TH_Objets.T_TH;
		Nombre_Aleatoire : integer;
		Donnee : integer;

	begin
		Max := 1;
		Min := Taille;
		TH_Objets.Initialiser(Sda);
		for index in 1..Taille loop
			Donnee := 0;
			Get_Random_Number (Nombre_Aleatoire);
			TH_Objets.Enregistrer(Sda, Nombre_Aleatoire, TH_Objets.La_Donnee_Better(Sda,Nombre_Aleatoire,Donnee) + 1);
		end loop;
		
		for Numero in 1..Borne loop
			Donnee := TH_Objets.La_Donnee_Better(Sda,Numero,Donnee);
			if Min > Donnee then
				Min := Donnee;
			else
				Null;
			end if;
			if Max < Donnee then
				Max := Donnee;
			else
				Null;
			end if;
		end loop;
		TH_Objets.Vider(Sda);
				
	end Calculer_Statistiques;



	Min, Max: Integer; -- fr�quence minimale et maximale d'un �chantillon
	Borne: Integer;    -- les nombres al�atoire sont tir�s dans 1..Borne
	Taille: integer;   -- nombre de tirages al�atoires
begin
	if Argument_Count /= 2 then
		Afficher_Usage;
	else
		-- R�cup�rer les arguments de la ligne de commande
		Borne := Integer'Value (Argument (1));
		Taille := Integer'Value (Argument (2));

		-- Afficher les valeur de Borne et Taille
		Afficher_Variable ("Borne ", Borne);
		Afficher_Variable ("Taille", Taille);
	
		Calculer_Statistiques (Borne, Taille, Min, Max);
		
		-- Afficher les fr�quence Min et Max
		Afficher_Variable ("Min", Min);
		Afficher_Variable ("Max", Max);
	end if;
	exception
		when others => Put_Line("Veuillez saisir deux entier superieur ou egale a 2"); 
end Evaluer_Alea_TH;
