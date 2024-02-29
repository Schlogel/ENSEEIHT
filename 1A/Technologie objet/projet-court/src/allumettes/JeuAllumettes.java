package allumettes;

/**
 * Classe définissant le jeu d'allumettes
 * @author bschloge
 */
public class JeuAllumettes implements Jeu {

	/** Nombre d'allumettes restantes dans la partie */
	protected static int nbAllumettes = 13;

	/** Constructeur du jeu d'allumettes. */
	public JeuAllumettes() { }

	/** Méthode qui renvoie le nombre d'allumettes restantes.
	 * @return nbAllumettes le nombre d'allumettes.
	 */
	@Override
	public int getNombreAllumettes() {
		return nbAllumettes;
	}

	/** Méthode qui retire le nombre d'allumettes en paramètre si ce nombre
	 * vérifie les conditions nécessaires.
	 */
	@Override
	public void retirer(int nbPrises) throws CoupInvalideException {
		if (verifierCond(nbPrises)) {
			nbAllumettes -= nbPrises;
		}
	}

	/** Méthode qui indique si un coup est possible en fonction du nombre
	 * d'allumettes restantes, mais aussi en fonction de la prise maximale et si la prise
	 * est supérieur à 1.
	 * @param nbPrises nombre d'allumettes qu'on souhaite retirer du jeu
	 * @return boolean booléen qui indique si le coup est possible
	 * @throws CoupInvalideException exception qui indique que le coup est impossible à
	 * réaliser.
	 */
	public static boolean verifierCond(int nbPrises) throws CoupInvalideException {
		if (nbPrises > nbAllumettes) {
			throw new CoupInvalideException(nbPrises, " (> " + nbAllumettes + ")");
		} else if (nbPrises > PRISE_MAX) {
			throw new CoupInvalideException(nbPrises, " (> " + PRISE_MAX + ")");
		} else if (nbPrises < 1) {
			throw new CoupInvalideException(nbPrises, " (< 1)");
		} else {
			return true;
		}

	}

}
