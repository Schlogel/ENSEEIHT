package allumettes;

/** Classe qui définie la stratégie triche.
 * @author bschloge
 */
public class StrategieTriche implements Strategie {

	/** Constructeur de la stratégie triche. */
	public StrategieTriche() { }

	/** Méthode permettant de savoir combien d'allumettes le tricheur
	 * souhaite prendre.
	 * @param jeu le jeu en cours
	 * @return int le nombre d'allumettes que le tricheur souhaite prendre.
	 */
	@Override
	public int getPrise(Jeu jeu) {
		int allumRes = jeu.getNombreAllumettes();
		System.out.println("[Je triche...]");

		for (int i = 1; i <= allumRes - 2; i++) {
			try {
				jeu.retirer(1);
			} catch (CoupInvalideException e) { }
		}
		// Affichage dans le terminal
		System.out.println("[Allumettes restantes : 2]");
		return 1;
	}

}
