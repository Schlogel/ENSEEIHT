
package body TH is


	-- Procedure permettant d'initialiser une TH
	procedure Initialiser(Sda: out T_TH) is
	begin
		for Index in 1..BORNE_MAX loop
			Objets_LCA.Initialiser(Sda(Index));
		end loop;
		
	end Initialiser;

	-- Fonction renvoyant un booléen indiquant si la TH est vide ou non
	function Est_Vide (Sda : T_TH) return Boolean is
		Resultat : Boolean := True;
	begin
		for Index in 1..(BORNE_MAX) loop
			if not Objets_LCA.Est_Vide(Sda(Index)) then
				Resultat := False;
			else
				null;
			end if;
		end loop;
		return Resultat;
	end;

	-- Fonction renvoyant la taille d'une TH, donc son nombre de maillon qui contiennent des éléments
	function Taille (Sda : in T_TH) return Integer is
		Taille : integer := 0;
	begin
		for Index in 1..(BORNE_MAX) loop
			if not Objets_LCA.Est_Vide(Sda(Index)) then
				Taille := Taille + Objets_LCA.Taille(Sda(Index));
			else
				null;
			end if;
		end loop;
		return Taille;
	end Taille;

	-- Porcedure permettant d'enregistrer un couple Cle / Donnee dans une TH
	-- Si la Cle est déjà présente, alors on remplace sa Donnee associé par la nouvelle
	procedure Enregistrer (Sda : in out T_TH ; Cle : in T_Cle ; Donnee : in T_Donnee) is
	begin
		if Est_Vide(Sda) then
			Objets_LCA.Initialiser(Sda(Type_Hachage(Cle)));
		else
			Null;
		end if;
		Objets_LCA.Enregistrer(Sda(Type_Hachage(Cle)),Cle,Donnee);
	end Enregistrer;
	
	-- Fonction renvoyant un booléen indiquant si une Cle est présente ou non dans une TH
	function Cle_Presente (Sda : in T_TH ; Cle : in T_Cle) return Boolean is
	begin
		return Objets_LCA.Cle_Presente(Sda(Type_Hachage(Cle)),Cle);			
	end;

	-- Fonction renvoyant une Donnee associe à une Cle dans une TH
	function La_Donnee (Sda : in T_TH ; Cle : in T_Cle) return T_Donnee is		
	begin
		return Objets_LCA.La_Donnee(Sda(Type_Hachage(Cle)),Cle);
	end La_Donnee;
	
	
	function La_Donnee_Better (Sda : in T_TH ; Cle : in T_Cle ; Donnee : in T_Donnee) return T_Donnee is		
	begin
		return Objets_LCA.La_Donnee_Better(Sda(Type_Hachage(Cle)),Cle,Donnee);
	end La_Donnee_Better;

	-- Procedure permettant de Supprimer un couple Cle / Donnee dans une TH
	procedure Supprimer (Sda : in out T_TH ; Cle : in T_Cle) is
		
	begin
		Objets_LCA.Supprimer(Sda(Type_Hachage(Cle)),Cle);
	end Supprimer;

	-- Procedure permettant de vider une TH et de libérer l'espace mémoire qu'elle occupait
	procedure Vider (Sda : in out T_TH) is
	begin
		if not Est_Vide(Sda) then
			for Index in 1..(BORNE_MAX) loop
				if not Objets_LCA.Est_Vide(Sda(Index)) then
					Objets_LCA.Vider(Sda(Index));
				else
					Null;
				end if;
			end loop;
		else
			Null;
		end if;
	end Vider;

	-- Procedure permettant de traiter chaque couple Cle / Donnee avec la fonction Traiter pour une TH
	procedure Pour_Chaque (Sda : in T_TH) is
		procedure LCA_Pour_Chaque is new Objets_LCA.Pour_Chaque(Traiter);
	begin
		if not Est_Vide(Sda) then
			for Index in 1..(BORNE_MAX) loop
				if not Objets_LCA.Est_Vide(Sda(Index)) then
					LCA_Pour_Chaque(Sda(Index));
				else
					Null;
				end if;
			end loop;
		else
			Null;
		end if;
	end Pour_Chaque;

end TH;
