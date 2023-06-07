Les fichiers rendus sont : 

1.NRZ_et_Modulation.m : 
	•Création du signal NRZ (Non Return to Zero )
	•Calcul de sa DSP avec pwelch (methode prédéfinie)
	•Calcul de sa DSP théorique (formule donnée)
	•Tracé des 2 DSP et comparaisons.
	•Création du signal modulé 
	•Calcul de sa DSP 

2.SignalBruit_Demodulation_par_Filtrage.m :
	•Création d’un bruit gaussien
	•Création d’un signal modulé bruité
	•Filtres passe bas et passe haut :      
          	- réponses impulsionelles
          	- DSP et tracé
         	- Représentation du signal filtré sans filter
        	- Representation du signal filtré avec filter.
       	- DSP du signal filtré. 
	•Calcul d’énergie et seuil pour le signal filtré (passe haut et passe bas)
	•Calcul du TEB (Taux d’Erreurs Binaires) pour le signal démodulé par filtrage. 

3.Demodulateur_V21.m :
	•Démodulation sans erreur de phase avec démodulateur FSK
		-Calcul d’intégrale. 
		-Représentation du signal en sortie sous forme de suite de bits.
		-Calcul du TEB du signal de sortie. 
	•Demodulation avec erreur de phase : 
		-Démodulation avec démodulateur FSK(sans gestion d’erreur)
		-Démodulation avec démodulateur FSK (avec gestion d’erreur)
	Dans ces deux dernières sous-parties , nous avons effectué ces actions-ci : 
       	-Calcul d’intégrale. 
		-Représentation du signal en sortie sous forme de suite de bits.
       	-Calcul du TEB du signal de sortie.(TEB non nul !)

4.Demoduler_Images.m : 
Fichier contenant fonction Demoduler_Images qui gére la démodulation d’un signal modulé quelquonque. 

5.Images.m :  Application de la fonction Demoduler_Images sur des morceaux d’images donnés dans les fichiers fichieri.m avec i allant de 1 à 6 .  
Pour visualiser l’image, il suffit d’executer le fichier Images.m
 

