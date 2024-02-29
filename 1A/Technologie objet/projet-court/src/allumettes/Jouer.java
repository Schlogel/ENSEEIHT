package allumettes;

/**
 * Lance une partie des 13 allumettes en fonction des arguments fournis sur la
 * ligne de commande.
 *
 * @author Xavier Crégut
 * @version $Revision: 1.5 $
 */
public class Jouer {

	/**
	 * Lancer une partie. En argument sont donnés les deux joueurs sous la forme
	 * nom@stratégie.
	 *
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) {
		try {
			verifierNombreArguments(args);

			// System.out.println("\n\tà faire !\n");

		} catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		}

		boolean partieOk = true;
		String[] infosJ1 = null;
		String[] infosJ2 = null;

		int indice = 0;
		Jeu jeu;

		if (args[0].equals("-confiant")) {
			indice++;
			jeu = new JeuAllumettes();
		} else {
			jeu = new JeuProxy();
		}

		Strategie stratJ1 = null;
		Strategie stratJ2 = null;
		try {
			infosJ1 = toSplit(args[indice], "@");
			infosJ2 = toSplit(args[1 + indice], "@");
			stratJ1 = setStrat(infosJ1[0], infosJ1[1]);
			stratJ2 = setStrat(infosJ2[0], infosJ2[1]);
		} catch (NotAStratException e) {
			System.out.println(e.getProb());
			afficherUsage();
			System.out.println("\nFin de la partie");
			partieOk = false;
		} catch (ArrayIndexOutOfBoundsException e) {
			System.out.println("Impossible de récupérer les informations"
			+ " concernant le(s) joueur(s)");
			afficherUsage();
			System.out.println("\nFin de la partie");
			partieOk = false;
		}

		if (partieOk) {
			Joueur joueur1 = new Joueur(infosJ1[0], stratJ1);
			Joueur joueur2 = new Joueur(infosJ2[0], stratJ2);
			Arbitre arbitre = new Arbitre(joueur1, joueur2);

			arbitre.arbitrer(jeu);
		}

	}

	/** Méthode permettant de définir la stratégie du joueur.
	 * @param nom le nom du joueur
	 * @param stratString la stratégie en chaine de caractères
	 * @return Strategie la strétgie correspondante
	 * @throws NotAStratException exception indiquant que la stratégie
	 * demandée n'éxiste pas.
	 */
	public static Strategie setStrat(String nom, String stratString)
			throws NotAStratException {
		switch (stratString) {
		case "naif":
			return new StrategieNaive();

		case "rapide":
			return new StrategieRapide();

		case "humain":
			return new StrategieHumaine(nom);

		case "tricheur":
			return new StrategieTriche();

		case "expert":
			return new StrategieExperte();

		default:
			throw new NotAStratException("Erreur dans la définition de(s) stratégie(s)");
		}
	}

	/** Méthode qui permet de vérifier le nombre d'argument entré par l'utilisateur.
	 * @param args les arguments
	 */
	private static void verifierNombreArguments(String[] args) {
		final int nbJoueurs = 2;
		if (args.length < nbJoueurs) {
			throw new ConfigurationException("Trop peu d'arguments : " + args.length);
		}
		if (args.length > nbJoueurs + 1) {
			throw new ConfigurationException("Trop d'arguments : " + args.length);
		}
	}

	/** Méthode permettant de séparer une chaine de caractère en deux en utilisant un
	 * argument.
	 * @param arg la chaine de caractère à séparer en deux
	 * @param spliteur caractère qui permet de distinguer les deux chaine de caractère
	 * @return String[] le tableau contenant les deux chaines de caractères séparées
	 */
	public static String[] toSplit(String arg, String spliteur) {
		return arg.split(spliteur);
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :" + "\n\t"
				+ "java allumettes.Jouer joueur1 joueur2" + "\n\t\t"
				+ "joueur est de la forme nom@stratégie" + "\n\t\t"
				+ "strategie = naif | rapide | expert | humain | tricheur | lent"
				+ "\n" + "\n\t" + "Exemple :" + "\n\t"
				+ "	java allumettes.Jouer Xavier@humain " + "Ordinateur@naif" + "\n");
	}

}
