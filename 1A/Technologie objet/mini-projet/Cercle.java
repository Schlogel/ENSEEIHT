import java.awt.Color;
import java.Math;

/** Cercle modélise un cercle géométrique dans un plan équipé d'un
 * repère cartésien.  Un cercle peut être affiché et translaté.
 * Sa distance par rapport à un autre point peut être obtenue.
 *
 * @author  Schlögel Benjamin <Prénom.Nom@enseeiht.fr>
 */
public class Cercle {

	// Défintion de la constante PI
	public final static double PI = Math.PI;

	// Définition des variables associées au cercle
    private Point centre;
    private double rayon;
	private Color couleur;

	/** Construire un cercle à partir de l'abscisse et de l'ordonnée de son centre et de son rayon.
	 * @param centre point du centre
	 * @param rayon rayon du cercle
	 */
	public Cercle(Point centre, double rayon) {
		// System.out.println("CONSTRUCTEUR Point(" + vx + ", " + vy + ")");
		this.centre = centre;
		this.rayon = rayon;
		this.couleur = Color.blue;
	}

    /** Construire un cercle à partir de deux points diamétralement opposé et de couleur bleu.
	 * @param point1 premier point
	 * @param point2 deuxième point
	 */
	public Cercle2P(Point point1, Point point2) {
		// System.out.println("CONSTRUCTEUR Point(" + vx + ", " + vy + ")");
		this.centre = new Point( (point1.getX()+point2.getX())/2 , (point1.getY()+point2.getY())/2 );
		this.rayon = point1.distance(point2)/2;
		this.couleur = Color.blue;
	} 

	/** Construire un cercle à partir de deux points diamétralement opposé et d'une couleur.
	 * @param point1 premier point
	 * @param point2 deuxième point
	 * @param couleur couleur
	 */
	public Cercle2P(Point point1, Point point2, Color couleur) {
		// System.out.println("CONSTRUCTEUR Point(" + vx + ", " + vy + ")");
		this.centre = new Point( (point1.getX()+point2.getX())/2 , (point1.getY()+point2.getY())/2 );
		this.rayon = point1.distance(point2)/2;
		this.couleur = couleur;
	}

    /** Construire un cercle à partir de deux points dont le premier est le centre et le second se trouve dessus.
	 * @param point1 premier point
	 * @param point2 deuxième point
	 */
    public creerCercle(Point point1, Point point2) {
        this.centre = point1;
        this.rayon = point1.distance(point2);
        this.couleur = Color.blue;
    }

	/** Obtenir le centre du cercle.
	 * @return point du centre
	 */
	public double getCentre() {
		return this.centre;
	}

	/** Obtenir le rayon du cercle.
	 * @return rayon du cercle
	 */
	public double getRayon() {
		return this.rayon;
	}

    /** Obtenir le diamètre du cercle.
	 * @return diamètre du cercle
	 */
	public double getDiametre() {
		return this.rayon*2;
	}

    /** Changer le rayon du cercle.
	* @param rayon le nouveau rayon
	*/
	public void setRayon(double rayon) {
		return this.rayon = rayon;
	}

    /** Changer le diamètre du cercle.
	* @param diametre le diamètre rayon
	*/
	public void setDiametre(double diametre) {
		return this.rayon = diametre/2;
	}

	/** Distance par rapport à un autre point.
	 * @param autre l'autre point
	 * @return distance entre this et autre
	 */
	public double distance(Point autre) {
		return Math.sqrt(Math.pow(autre.x - this.x, 2)
					+ Math.pow(autre.y - this.y, 2));
	}

   /** Translater le cercle.
	* @param dx déplacement suivant l'axe des X
	* @param dy déplacement suivant l'axe des Y
	*/
	public void translater(double dx, double dy) {
		(this.centre).translater(double dx, double dy);
	}

//  Gestion de la couleur

	/** Obtenir la couleur du cercle.
	 * @return la couleur du cercle
	 */
	public Color getCouleur() {
		return this.couleur;
	}

	/** Changer la couleur du cercle.
	  * @param nouvelleCouleur nouvelle couleur
	  */
	public void setCouleur(Color nouvelleCouleur) {
		this.couleur = nouvelleCouleur;
	}

    public void afficher() {
        System.out.print("C" & this.rayon & "@");
        this.centre.afficher();
    }

/*
	// La méthode finalize est appelée avant que le récupérateur de
	// mémoire ne détruise l'objet.  Attention toutefois, on ne sait
	// pas quand ces ressources seront libérées et il est donc
	// dangereux de s'appuyer sur ce mécanisme pour libérer des
	// ressources qui sont en nombre limité.
	//
	// D'autre part, pour être sûr que les méthodes << finalize >>
	// sont appelées avant la fermeture de Java, il faut appeler la
	// méthode statique :
	//		System.runFinalizersOnExit(true)
	//
	protected void finalize() {
		System.out.print("DESTRUCTION du point : ");
		this.afficher();
		System.out.println();
	}
*/

//	Représentation interne d'un point
//	---------------------------------

// Remarque : en Java, il est conseillé (convention de programmation)
// de mettre les attributs au début de la classe.

	private double x;		// abscisse
	private double y;		// ordonnée
	private Color couleur;	// couleur du point

}
