-- with Ada.Text_IO;            use Ada.Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body LCA is

	procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_LCA);

	-- Procedure permettant d'initialiser une LCA
	procedure Initialiser(Sda: out T_LCA) is
	begin
		Sda := Null;
	end Initialiser;

	-- Fonction renvoyant un booléen indiquant si la LCA est vide ou non
	function Est_Vide (Sda : T_LCA) return Boolean is
	begin
		return Sda = Null;
	end;

	-- Fonction renvoyant la taille d'une LCA, donc son nombre de maillon qui contiennent des éléments
	function Taille (Sda : in T_LCA) return Integer is
		Taille : Integer := 0;
		A_Detruire : T_LCA;
	begin
		A_Detruire := Sda;
		while A_Detruire /= Null loop
			Taille := Taille + 1;
			A_Detruire := A_Detruire.all.Suivant;
		end loop;
		return Taille;
			
	end Taille;

	-- Porcedure permettant d'enregistrer un couple Cle / Donnee dans une LCA
	-- Si la Cle est déjà présente, alors on remplace sa Donnee associé par la nouvelle
	procedure Enregistrer (Sda : in out T_LCA ; Cle : in T_Cle ; Donnee : in T_Donnee) is
	begin
		if Sda = Null then 
			Sda := new T_Cellule'(Cle, Donnee, Null);
		elsif Sda.all.Cle /= Cle then
			Enregistrer(Sda.all.Suivant, Cle, Donnee);
		else
			Sda.all.Donnee := Donnee;
		end if;
	end Enregistrer;


	-- Fonction renvoyant un booléen indiquant si une Cle est présente ou non dans une LCA
	function Cle_Presente (Sda : in T_LCA ; Cle : in T_Cle) return Boolean is
		A_Detruire : T_LCA;
	begin
		A_Detruire := Sda;
		while A_Detruire /= Null loop
			if A_Detruire.all.Cle = Cle then
				return True;
			else
				A_Detruire := A_Detruire.all.Suivant;
			end if;
		end loop;		
		return False;
	end;

	-- Fonction renvoyant une Donnee associe à une Cle dans une LCA
	-- Si la Cle n'est pas présente alors on relève une exception
	function La_Donnee (Sda : in T_LCA ; Cle : in T_Cle) return T_Donnee is
		A_Detruire : T_LCA;
	begin
		A_Detruire := Sda;
		while A_Detruire /= Null loop
			if A_Detruire.all.Cle = Cle then
				return A_Detruire.all.Donnee;
			else
				A_Detruire := A_Detruire.all.Suivant;
			end if;
		end loop;		
		raise Cle_Absente_Exception;
		
	end La_Donnee;
	
	function La_Donnee_Better (Sda : in T_LCA ; Cle : in T_Cle ; Donnee : in T_Donnee) return T_Donnee is
		A_Detruire : T_LCA;
	begin
		A_Detruire := Sda;
		while A_Detruire /= Null loop
			if A_Detruire.all.Cle = Cle then
				return A_Detruire.all.Donnee;
			else
				A_Detruire := A_Detruire.all.Suivant;
			end if;
		end loop;
		return Donnee;		
		
	end La_Donnee_Better;

	-- Procedure permettant de Supprimer un couple Cle / Donnee dans une LCA
	-- Si la Cle n'est pas présente alors on relève une exception
	procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) is
		A_Detruire : T_LCA;
	begin
		if Sda = Null then
			raise Cle_Absente_Exception;
		elsif Sda.all.Cle = Cle then
			A_Detruire := Sda;
			Sda := Sda.all.Suivant;
			Free (A_Detruire);
		else
			Supprimer (Sda.all.Suivant, Cle);
		end if;	
	end Supprimer;

	-- Procedure permettant de vider une LCA et de libérer l'espace mémoire qu'elle occupait
	procedure Vider (Sda : in out T_LCA) is
	begin
		if Sda /= Null then
			Vider (Sda.all.Suivant);
			Free (Sda);
		else
			Null;
		end if;
	end Vider;

	-- Procedure permettant de traiter chaque couple Cle / Donnee avec la fonction Traiter pour une LCA
	-- Si la fonction Traiter n'aboutit pas pour un couple, le programme doit continuer, cela avec l'exception mis à Null
	procedure Pour_Chaque (Sda : in T_LCA) is
	begin
		if Sda /= Null then
			begin
				Traiter(Sda.all.Cle, Sda.all.Donnee);
			exception
				when others =>
					Null;
			end;
			Pour_Chaque(Sda.all.Suivant);
		else
			Null;
		end if;
	end Pour_Chaque;


end LCA;
