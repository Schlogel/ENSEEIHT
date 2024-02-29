package allumettes;

import java.util.Scanner;

public class Arbitre {

	/** Joueur numéro 1 */
	private Joueur joueur1;

	/** Joueur numéro 2 */
	private Joueur joueur2;

	/** Prise récupéré */
	protected static Scanner scanPrise;

	/** Constructeur qui initialise deux joueurs.
	 * @param joueur1 le joueur 1
	 * @param joueur2 le joueur 2
	 */
	public Arbitre(Joueur joueur1, Joueur joueur2) {
		this.joueur1 = joueur1;
		this.joueur2 = joueur2;
	}

	/** Méthode qui permet à deux joueurs de joueur chacun leur tour.
	 * @param jeu le jeu d'allumettes
	 */
	public void arbitrer(Jeu jeu) {
		// Initialisation du joueur courant par le joueur 1
		Joueur joueurCourant = new Joueur(this.joueur1.getNom(), this.joueur1.getStrat());
		String nomCourant;
		boolean partieValable = true;
		scanPrise = new Scanner(System.in);

		while ((jeu.getNombreAllumettes() > 0) && (partieValable)) {
			int priseCourante = 0;
			boolean coupValable = false;

			do {
				nomCourant = joueurCourant.getNom();
				System.out.println("Allumettes restantes : " + jeu.getNombreAllumettes());

				try {
					priseCourante = joueurCourant.getPrise(jeu);
				} catch (OperationInterditeException e) {
					System.out.print("Abandon de la partie car " + joueurCourant.getNom()
					+ " triche !");
					partieValable = false;
					coupValable = true; // pour sortir du while
				}

				if (partieValable) {

					// Affichage dans le terminal
					System.out.print(nomCourant + " prend " + priseCourante
					+ " allumette");
					if (priseCourante > 1) {
						System.out.print("s");
					}
					System.out.println(".");

					try {
						JeuAllumettes.verifierCond(priseCourante);
						JeuAllumettes.nbAllumettes -= priseCourante;
						coupValable = priseCourante != 0;

					} catch (CoupInvalideException e) {
						System.out.println("Impossible ! Nombre invalide : "
						+ e.getCoup() + e.getProbleme() + "\n");

					}

				}

			} while (!coupValable);
			System.out.println();
			// changer de joueur
			joueurCourant = swapJoueur(joueurCourant, joueur1, joueur2);

		} // fin du while (nbAllumettes=0)

		if (partieValable) {
			joueurCourant = swapJoueur(joueurCourant, joueur1, joueur2);
			System.out.println(joueurCourant.getNom() + " perd !");
			joueurCourant = swapJoueur(joueurCourant, joueur1, joueur2);
			System.out.println(joueurCourant.getNom() + " gagne !");
		}

	}

	/** Méthode qui permet d'échanger d'alterner entre les deux joueurs, en
	 * modifiant le joueur courant.
	 * @param joueurCourant le joueur qui est changé en fonction du tour
	 * @param joueur1 le joueur 1
	 * @param joueur2 le joueur 2
	 * @return joueur soit le joueur 1 soit le joueur 2 en fonction du tour précédent
	 */
	public static Joueur swapJoueur(Joueur joueurCourant,
			Joueur joueur1, Joueur joueur2) {
		if (joueurCourant.getNom() == joueur1.getNom()) {
			return joueur2;
		} else {
			return joueur1;
		}
	}

}
