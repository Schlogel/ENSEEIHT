package allumettes;

/** Classe qui définie la stratégie humaine.
 * @author bschloge
 */
public class StrategieHumaine implements Strategie {

	/** Le nom du joueur. */
	private String nom;

	/** Constructeur de la stratégie humaine. */
	public StrategieHumaine(String nom) {
		this.nom = nom;
	}

	/** Méthode permettant de savoir combien d'allumettes l'humain
	 * souhaite prendre.
	 * @param jeu le jeu en cours
	 * @return int le nombre d'allumettes que l'humain souhaite prendre.
	 */
	@Override
	public int getPrise(Jeu jeu) {
		String priseString = "";
		int priseInt = 0;

		// Affichage dans le terminal
		System.out.print(this.nom + ", combien d'allumettes ? ");

		priseString = Arbitre.scanPrise.nextLine();

		if (priseString.equals("triche")) {

			try {
				jeu.retirer(1);
			} catch (CoupInvalideException e) {
				System.out.println("\nCette situation ne devrait pas arriver.");
			}

			System.out.println("[Une allumette en moins, plus que "
			+ jeu.getNombreAllumettes() + ". Chut !]");
			return getPrise(jeu);

		} else {

			try {
				priseInt = Integer.parseInt(priseString);
			} catch (NumberFormatException e) {
				System.out.println("Vous devez donner un entier.");
				return getPrise(jeu);
			}
		}

		return priseInt;
	}

	@Override
	public String toString() {
		return "humaine";
	}

}
