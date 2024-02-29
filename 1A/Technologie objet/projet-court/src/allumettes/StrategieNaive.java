package allumettes;

import java.util.Random;

/** Classe qui définie la stratégie naïve.
 * @author bschloge
 */
public class StrategieNaive implements Strategie {

	/** Le coup du joueur. */
	private Random prise;

	/** Constructeur de la stratégie naïve. */
	public StrategieNaive() {
		this.prise = new Random();
	}

	/** Méthode permettant de savoir combien d'allumettes le naif
	 * souhaite prendre.
	 * @param jeu le jeu en cours
	 * @return int le nombre d'allumettes que le naif souhaite prendre.
	 */
	@Override
	public int getPrise(Jeu jeu) {

		// Renvoie de la prise
		return this.prise.nextInt(Jeu.PRISE_MAX - 1) + 1;
	}

}
