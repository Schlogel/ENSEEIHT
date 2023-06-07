package main;
import java.awt.Color;
import java.awt.event.*;

/** Classe sur la gestion de la couleur du pointeur
 * 
 * @author AB-4
 *
 */
public class ActionCouleur extends MouseAdapter {

	private Color c;
	

	public ActionCouleur(Color couleur) {
		c = couleur;
	}

	public void mouseClicked(MouseEvent arg0) {
		testFenetre.pointeur.setColor(c);
	}

	public Color getCouleur() {
		return c;
	}
	
}
