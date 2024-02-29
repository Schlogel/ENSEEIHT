package allumettes;

/** Classe exception qui signal que la stratégie demandée par l'utilisateur n'existe pas.
 * @author bschloge
 *
 */
public class NotAStratException extends Exception {

	/** Problème identifié. */
	private String probleme;

	/** Constructeur de l'exception qui signale que la stratégie
	 * demandé n'existe pas.
	 */
	public NotAStratException(String message) {
		this.probleme = message;
	}

	/** Méthode permettant d'obtenir le problème. */
	public String getProb() {
		return this.probleme;
	}

}
