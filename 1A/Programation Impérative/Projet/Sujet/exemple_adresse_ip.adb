with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;

-- Volontairement, ce programme contient des redondances qui pourraient être
-- supprimées en utilisant des sous-programmes et des répétitions.

procedure Exemple_Adresse_IP is

	type T_Adresse_IP is mod 2 ** 32;

	UN_OCTET: constant T_Adresse_IP := 2 ** 8;       -- 256
	POIDS_FORT : constant T_Adresse_IP  := 2 ** 31;	 -- 10000000.00000000.00000000.00000000

	IP1 : T_Adresse_IP;
	IP2 : T_Adresse_IP;
	M1 : T_Adresse_IP;
	D1 : T_Adresse_IP;

	Bit_A_1 : Boolean;
begin
	-- Construire 147.127.18.0 (en appliquant le schéma de Horner)
	IP1 := 147;
	IP1 := IP1 * UN_OCTET + 128;
	IP1 := IP1 * UN_OCTET + 18;
	IP1 := IP1 * UN_OCTET + 15;

	-- Afficher les 4 octets (en sens inverse) en base 10
	Put ("IP1 (octets inversés) = ");
	IP2 := IP1;
	Put (Natural (IP2 mod UN_OCTET));	-- Conversion d'un T_Adresse_IP en Integer pour utiliser Put sur Integer
	IP2 := IP2 / UN_OCTET;
	Put (Natural (IP2 mod UN_OCTET));
	IP2 := IP2 / UN_OCTET;
	Put (Natural (IP2 mod UN_OCTET));
	IP2 := IP2 / UN_OCTET;
	Put (Natural (IP2 mod UN_OCTET));
	New_Line;
	
	-- Afficher les 4 octets (en sens inverse) en base 2
	Put ("IP1 (octets inversés) = ");
	IP2 := IP1;
	Put (Natural (IP2 mod UN_OCTET), Base => 2, Width => 12);
	IP2 := IP2 / UN_OCTET;
	Put (Natural (IP2 mod UN_OCTET), Base => 2, Width => 12);
	IP2 := IP2 / UN_OCTET;
	Put (Natural (IP2 mod UN_OCTET), Base => 2, Width => 12);
	IP2 := IP2 / UN_OCTET;
	Put (Natural (IP2 mod UN_OCTET), Base => 2, Width => 12);
	New_Line;
	New_Line;

	-- Est-ce que le bit de poids fort (1ier bit) est à 1 ?
	Bit_A_1 := (IP1 and POIDS_FORT) /= 0;
	if Bit_A_1 then
		Put_Line ("premier bit à 1");
	else
		Put_Line ("premier bit à 0");
	end if;

	-- Est-ce que le 2ème bit est à 1 ?
	Bit_A_1 := ((IP1 * 2) and POIDS_FORT) /= 0;
	if Bit_A_1 then
		Put_Line ("Deuxième bit à 1");
	else
		Put_Line ("Deuxième bit à 0");
	end if;

	-- Construire un masque 255.255.255
	M1 := -1;	-- des 1 partout
	M1 := M1 - 255;

	New_Line;
	Put ("M1  = ");
	Put (Natural ((M1 / UN_OCTET ** 3) mod UN_OCTET), 1); Put (".");
	Put (Natural ((M1 / UN_OCTET ** 2) mod UN_OCTET), 1); Put (".");
	Put (Natural ((M1 / UN_OCTET ** 1) mod UN_OCTET), 1); Put (".");
	Put (Natural  (M1 mod UN_OCTET), 1);
	New_Line;

	D1 := IP1 - 15;
	Put ("D1  = ");
	Put (Natural ((D1 / UN_OCTET ** 3) mod UN_OCTET), 1); Put (".");
	Put (Natural ((D1 / UN_OCTET ** 2) mod UN_OCTET), 1); Put (".");
	Put (Natural ((D1 / UN_OCTET ** 1) mod UN_OCTET), 1); Put (".");
	Put (Natural  (D1 mod UN_OCTET), 1);
	New_Line;

	Put ("IP1 = ");
	Put (Natural ((IP1 / UN_OCTET ** 3) mod UN_OCTET), 1); Put (".");
	Put (Natural ((IP1 / UN_OCTET ** 2) mod UN_OCTET), 1); Put (".");
	Put (Natural ((IP1 / UN_OCTET ** 1) mod UN_OCTET), 1); Put (".");
	Put (Natural  (IP1 mod UN_OCTET), 1);
	New_Line;

	IP2 := IP1 + 2 ** 8;
	Put ("IP2 = ");
	Put (Natural ((IP2 / UN_OCTET ** 3) mod UN_OCTET), 1); Put (".");
	Put (Natural ((IP2 / UN_OCTET ** 2) mod UN_OCTET), 1); Put (".");
	Put (Natural ((IP2 / UN_OCTET ** 1) mod UN_OCTET), 1); Put (".");
	Put (Natural  (IP2 mod UN_OCTET), 1);
	New_Line;

	-- Est-ce qu'une adresse IP1 correspond à la route (D1, M1)
	if (IP1 and M1) = D1 then
		Put_Line ("IP1 Correspond à (D1, M1)");
	else
		Put_Line ("IP1 ne correspond pas à (D1, M1)");
	end if;

	-- Est-ce qu'une adresse IP1 correspond à la route (D1, M1)
	if (IP2 and M1) = D1 then
		Put_Line ("IP2 Correspond à (D1, M1)");
	else
		Put_Line ("IP2 ne correspond pas à (D1, M1)");
	end if;

	-- Décalerr des bits : il suffit de multiplier par 2 (décalage vers la
	-- gauche) ou diviser par 2 (décalage vers la droite).
	IP1 := 147;
	New_Line;
	Put ("IP1 avant décalage           = "); Put (Integer (IP1),          Base => 2, Width => 15);  New_Line;
	Put ("IP1 décalé à gauche (1 bit)  = "); Put (Integer (IP1 * 2),      Base => 2, Width => 15);  New_Line;
	Put ("IP1 décalé à droite (1 bit)  = "); Put (Integer (IP1 / 2),      Base => 2, Width => 15);  New_Line;
	Put ("IP1 décalé à gauche (3 bit)  = "); Put (Integer (IP1 * 2 ** 3), Base => 2, Width => 15);  New_Line;
	Put ("IP1 décalé à droite (3 bit)  = "); Put (Integer (IP1 / 2 ** 3), Base => 2, Width => 15);  New_Line;



end Exemple_Adresse_IP;
