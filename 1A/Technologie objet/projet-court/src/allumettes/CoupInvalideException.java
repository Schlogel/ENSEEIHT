package allumettes;

/** Exception qui indique qu'un coup invalide est joué.
 * @author	Xavier Crégut
 * @version	$Revision: 1.3 $
 */
public class CoupInvalideException extends Exception {

	/** Le coup joué. */
	private int coup;

	/** Problème identifié. */
	private String probleme;

	/** Initialiser CoupInvalideException à partir du coup joué
	 * et du problème identifié.  Par exemple, on peut avoir coup
	 * qui vaut 0 et le problème "< 1".
	 * @param coup le coup joué
	 * @param probleme le problème identifié
	 */
	public CoupInvalideException(int coup, String probleme) {
		super("Coup invalide car " + probleme + " : " + coup);
		this.coup = coup;
		this.probleme = probleme;
	}

	/** Retourner le coup.
	  * @return le coup */
	public int getCoup() {
		return this.coup;
	}

	/** Indiquer le problème.
	  * @return le problème */
	public String getProbleme() {
		return this.probleme;
	}

}
