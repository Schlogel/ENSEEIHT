package allumettes;

/** Classe qui définie la stratégie experte.
 * @author bschloge
 */
public class StrategieExperte implements Strategie {

	/** Constructeur de la stratégie experte. */
	public StrategieExperte() { }

	/** Méthode permettant de savoir combien d'allumettes l'expert
	 * souhaite prendre.
	 * @param jeu le jeu en cours
	 * @return int le nombre d'allumettes que l'expert souhaite prendre.
	 */
	@Override
	public int getPrise(Jeu jeu) {

		// Déclaration des allumettes restantes et de la prise
		int allumRes = jeu.getNombreAllumettes();
		int prise;
		int calculModulo = (allumRes - 1) % (Jeu.PRISE_MAX + 1);

		// Stratégie Experte
		if (calculModulo != 0) {
			prise = (allumRes - 1) % (Jeu.PRISE_MAX + 1);
		} else if (allumRes == 1) {
			prise = 1;
		} else {
			prise = Jeu.PRISE_MAX;
		}

		// Renvoie de la prise
		return prise;
	}

}
