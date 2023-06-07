--
--  Les TODO dans le texte vous indique les parties de ce programme à compléter.
--  Les autres parties ne doivent pas être modifiées.
--
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;

-- Objectif : Afficher un tableau trié suivant le principe du tri par sélection.

procedure Tri_Selection is

    Capacite: constant Integer := 10;   -- Cette taille est arbitraire

    type T_TableauElements is array (1..Capacite) of Integer;

    type T_Tableau is
        record
            Elements: T_TableauElements;
            Taille: Integer;
            -- Invariant: 0 <= Taille and Taille <= Capacite;
        end record;



    -- Objectif : Afficher le tableau.
    --    Les éléments sont affichés entre crochets, séparés par des virgules.
    -- Paramètres :
    --    Tab : le tableau à afficher.
    procedure Ecrire(Tab: in T_Tableau) is
    begin
        Put ('[');
        if Tab.Taille > 0 then
            -- Écrire le premier élément
            Put (Tab.Elements (1), 1);

            -- Écrire les autres éléments précédés d'une virgule
            for I in 2..Tab.Taille loop
                Put (", ");
                Put (Tab.Elements (I), 1);
            end loop;
        else
            null;
        end if;
        Put (']');
    end Ecrire;



    -- TODO : spécifier et implanter un sous-programme qui trie un tableau
    -- suivant l'algorithme du tri pas sélection.
    function Trier(Tab: in T_Tableau) return Tab is
    	for I in 1..(Tab.taille-1) loop
    	    imin := I ;
    	    min := Tab.Element(imin) ;
    	    for J in (I+1)..Tab.taille loop
    	    	if Tab.Element(i) < J then
    	    	    imin := J ;
    	    	    min := Tab.Element(imin) ;
    	    	end if;
    	    end loop;
    	end loop; 
	

    -- Objectif : Indiquer si deux tableaux son égaux.
    -- Paramètres :
    --     Tab1, Tab2 : les deux tableaux à comparer
    -- Résultat
    --     Vrai si et seulement si Tab1 et Tab2 sont égaux.
    --
    -- Remarque : Ici on redéfinit l'opérateur "=" déjà présent en Ada qui par
    -- défaut compara les tailles et tous les éléments de Elements.
    function "=" (Tab1, Tab2: in T_Tableau) return Boolean is
        Resultat: Boolean;
        Indice: Integer;
    begin
        if Tab1.Taille /= Tab2.Taille then
            Resultat := False;
        else
            Indice := 1;
            while Indice <= Tab1.Taille
                    and then Tab1.Elements (Indice) = Tab2.Elements (Indice)
            loop
                Indice := Indice + 1;
            end loop;
            Resultat := Indice > Tab1.Taille;
        end if;
        return Resultat;
    end "=";



    -- Programme de test de la procédure Trier.
    procedure Tester_Trier is

        procedure Tester(Tab, Attendu: in T_Tableau) is
            Copie: T_Tableau;
        begin
            Copie := Tab;
            -- TODO : faire l'appel pour trier le tableau Copie
            Tab := Trier(Tab);
            pragma Assert(Copie = Attendu);
        end Tester;

    begin
        Tester (( (1, 9, others => 0), 2),
                ( (1, 9, others => 0), 2));
        Tester (( (4, 2, others => 0), 2),
                ( (2, 4, others => 0), 2));
        Tester (( (1, 3, 4, 2, others => 0), 4),
                ( (1, 2, 3, 4, others => 0), 4));
        Tester (( (4, 3, 2, 1, others => 0), 4),
                ( (1, 2, 3, 4, others => 0), 4));
        Tester (( (-5, 3, 8, 1, -25, 0, 8, 1, 1, 1), 10),
                ( (-25, -5, 0, 1, 1, 1, 1, 3, 8, 8), 10));
        Tester (( (others => 0), 0),
                ( (others => 0), 0));
    end Tester_Trier;


    Tab1 : T_Tableau;
begin
    -- Initialiser le tableau
    Tab1 := ( (1, 3, 4, 2, others => 0), 4);

    -- Afficher le tableau
    Ecrire (Tab1);
    New_Line;

    -- Trier le tableau
    -- TODO
    Tab1 := Trier(Tab1);

    -- Afficher le tableau trié
    Ecrire (Tab1);
    New_Line;

    Tester_Trier;

end Tri_Selection;
