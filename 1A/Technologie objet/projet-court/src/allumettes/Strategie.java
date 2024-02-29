package allumettes;

/** Interface qui définie les stratégies. */
public interface Strategie {

	/** Méthode qui permet de savoir combien d'allumettes le joueur souhaite retirer.
	 * @param jeu le jeu en cours
	 * @return int le nombre d'allumettes que le joueur souhaite retirer.
	 */
	int getPrise(Jeu jeu);
}
