package allumettes;

public class JeuProxy implements Jeu {

	/** Constructeur du jeu proxy, qui permet de protéger le
	 * jeu d'allumettes.
	 */
	public JeuProxy() { }

	/** Méthode qui renvoie le nombre d'allumettes restantes
	 * dans la partie.
	 * @return nbAllumettes le nombre d'allumettes restantes
	 */
	@Override
	public int getNombreAllumettes() {
		return JeuAllumettes.nbAllumettes;
	}

	/** Méthode retirer qui renvoie l'exception CoupInvalideException
	 * dès qu'elle est appelée.
	 * @throws OperationInterditeException qui est une exception de
	 * CoupInvalideException, permettant de savoir si un joueur triche.
	 */
	@Override
	public void retirer(int nbPrises) throws CoupInvalideException {
		throw new OperationInterditeException("interdit");

	}

}
