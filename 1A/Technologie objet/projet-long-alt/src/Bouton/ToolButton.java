package Bouton;
import java.awt.event.ActionEvent;

import javax.swing.JButton;

/** Interface des différents boutons à implanter.
 * 
 * 
 * @author AB-4
 *
 */
public interface ToolButton {
	
	/** Méthode appelée lorsque lorsqu'on clique sur le canvas.
	 * @param e Contient les différents paramètres de pointeur lors du clique.
	 */
	void actionPerformed(ActionEvent e);
	
	/** Renvoie le bouton associé à la fonctionnalité si besoin.
	 * 
	 * @return JButton Le bouton associé.
	 */
	JButton getBouton();
	
	/** Renvoie le nom du bouton.
	 * 
	 * @return String Le nom du bouton.
	 */
	public String getNom();

}