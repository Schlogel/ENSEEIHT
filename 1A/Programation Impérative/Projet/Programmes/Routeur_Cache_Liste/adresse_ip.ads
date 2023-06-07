with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

package adresse_ip is

  -- Définition des types utilisés
  type T_Adresse_IP is mod 2 ** 32;
  type T_vecteur is array (1..4) of Integer;

  -- Procedure qui construit une adresse IP à partir de 4 entiers avec la methode de horner
  procedure convert_IP_Int(IP:in out T_Adresse_IP ; a: in Integer; b :in Integer; c: in Integer; d :in Integer );

  -- Fonction qui convertit a.b.c.d (type Adresse_IP) en "a.b.c.d" (type String)
  function convert_IP_Bin(IP:in T_Adresse_IP ) return String ;

  -- Fonction qui retourne les nombres contenus dans une chaine de caractere.
  function nombres(str: in Unbounded_String) return T_vecteur;
    --Post => length(str)>0 and length(str)<15; -- la str doit pouvoir contenir 4 entiers possibles qui ne depassent pas 3 chiffres.

  -- Fonction qui verifie si une IP correspond a un masque et une destination
  function Comparer_bin(IP: in T_Adresse_IP; D : in T_Adresse_IP; M: in T_Adresse_IP) return boolean;

  -- Fonction qui renvoie la taille du masque (i.e. nombre de 1 dans le masque)
  function Taille_Masque(Masque: in T_Adresse_IP) return Integer;


end adresse_ip;
