package allumettes;

/** Classe qui définie la stratégie rapide.
 * @author bschloge
 */
public class StrategieRapide implements Strategie {

	/** Constructeur de la stratégie rapide. */
	public StrategieRapide() { }

	/** Méthode permettant de savoir combien d'allumettes le rapide
	 * souhaite prendre.
	 * @param jeu le jeu en cours
	 * @return int le nombre d'allumettes que le rapide souhaite prendre.
	 */
	@Override
	public int getPrise(Jeu jeu) {

		// Déclaration des allumettes restantes et de la prise
		int allumRes = jeu.getNombreAllumettes();
		int prise;

		// Stratégie Rapide
		if (allumRes < Jeu.PRISE_MAX) {
			prise = allumRes;
		} else {
			prise = Jeu.PRISE_MAX;
		}

		// Renvoie de la prise
		return prise;
	}

}
