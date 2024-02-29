package allumettes;

/**
 * Classe définissant un joueur
 * @author bschloge
 */
public class Joueur implements Strategie {

	/** Nom du joueur */
	private String nom;

	/** Stratégie du joueur */
	private Strategie strat;

	/**
	 * Constructeur du joueur
	 *
	 * @param nom Chaine de caractère du nom du joueur
	 * @param strat la stratégie du joueur
	 */
	public Joueur(String nom, Strategie strat) {
		this.nom = nom;
		this.strat = strat;
	}

	/**
	 * Renvoie le nom du joueur
	 *
	 * @return Nom Chaine de caractère du nom du joueur
	 */
	public String getNom() {
		return this.nom;
	}

	/** Méthode qui renvoie la stratégie du joueur.
	 * @return strat la stratégie du joueur
	 */
	public Strategie getStrat() {
		return this.strat;
	}

	/** Méthode qui redéfinie la stratégie du joueur.
	 * @param strat la nouvelle stratégie
	 */
	public void setStrat(Strategie strat) {
		this.strat = strat;
	}

	/** Méthode qui renvoie le nombre d'allumettes que le joueur souhaite prendre.
	 * @param jeu le jeu en cours
	 * @return int le nombre d'allumettes que le joueur prend
	 */
	@Override
	public int getPrise(Jeu jeu) {
		return this.strat.getPrise(jeu);
	}

}
