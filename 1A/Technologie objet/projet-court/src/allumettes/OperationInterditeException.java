package allumettes;

/** Classe d'exception qui indique que l'utilisation de la méthode
 * "retirer" est interdite.
 * @author bschloge
 *
 */
public class OperationInterditeException extends RuntimeException {

	/** Constructeur qui créer l'exception OperationInterditeException. */
	public OperationInterditeException(String message) {
		super(message);
	}
}
