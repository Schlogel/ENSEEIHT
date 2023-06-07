package body adresse_ip is

	UN_OCTET: constant T_Adresse_IP := 2 ** 8;       -- 256

     -- Procedure qui construit une adresse IP à partir de 4 entiers avec la methode de horner
     procedure convert_IP_Int(IP: in out T_Adresse_IP; a: in Integer; b :in Integer; c: in Integer; d :in Integer) is
     begin
	     IP := T_Adresse_IP(a);
	     IP := IP * UN_OCTET + T_Adresse_IP(b);
	     IP := IP * UN_OCTET + T_Adresse_IP(c);
	     IP := IP * UN_OCTET + T_Adresse_IP(d);
     end Convert_IP_Int;

     -- Fonction qui verifie si une IP correspond a un masque et une destination
     function Comparer_bin(IP: in T_Adresse_IP ; D : in T_Adresse_IP; M: in T_Adresse_IP) return boolean is
     begin
	     return (IP and M) = D;
     end Comparer_bin;

     -- Fonction qui convertit a.b.c.d (type Adresse_IP) en "a.b.c.d" (type String)
     function convert_IP_Bin(IP:in T_Adresse_IP ) return String is

          IP1: T_Adresse_IP;
          a:Integer;
          b:Integer;
          c:Integer;
          d:Integer;
          str: Unbounded_String := Null_Unbounded_String;

     begin
          IP1:=IP;
          d:=Natural(IP1 mod UN_OCTET);

          IP1:=IP1/UN_OCTET ;
          c:=Natural(IP1 mod UN_OCTET);

          IP1:=IP1/UN_OCTET ;
          b:=Natural(IP1 mod UN_OCTET);

          IP1:=IP1/UN_OCTET ;
          a:=Natural(IP1 mod UN_OCTET);

          str:= To_Unbounded_String(Integer'Image(a) & "." & Integer'Image(b) & "."& Integer'Image(c) & "." & Integer'Image(d));
          return To_String(str);

     end convert_IP_Bin;

     -- Fonction qui retourne les nombres contenus dans une chaine de caractere.
     function nombres(str: in Unbounded_String) return T_vecteur is
          ABCD: T_vecteur;
          ch: Unbounded_String := Null_Unbounded_String;
          e: Integer := 1;
          Longueur: constant Integer := Length(str);
     begin
          ch:=Null_Unbounded_String;
          for i in 1..Longueur loop
               if not(to_string(str)(i) = '.') then
                    ch := ch & to_string(str)(i);
               else 
                    ABCD(e) := Integer'Value(to_string(ch));
                    e := e + 1;
                    ch:=Null_Unbounded_String;
               end if;
          end loop;
          ABCD(4) := Integer'Value(to_string(ch));
          return ABCD;
     end nombres;

     -- Fonction qui renvoie la taille du masque (i.e. nombre de 1 dans le masque)
     function Taille_Masque(Masque : in T_Adresse_IP) return integer is
          nb : integer := 0;
          M : T_Adresse_IP;
     begin     
          M := Masque;
          for i in 1..32 loop 
               if (M and 2**31) /= 0 then
                    nb := nb + 1;
               else 
                    null;
               end if;
               M := M * 2;
          end loop;
          return nb;
     end Taille_Masque;

end adresse_ip;
