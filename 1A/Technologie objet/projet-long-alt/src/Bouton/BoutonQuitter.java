package Bouton;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;

/** Classe du bouton permettant de quitter l'application depuis le menu.
 * 
 * 
 * @author AB-4
 *
 */
public class BoutonQuitter extends JButton implements ToolButton, ActionListener {

	/** Constructeur du bouton.
	 * 
	 */
	public BoutonQuitter() {
		super("Quitter");
		addActionListener(this);
		
	}
	
	/** Méthode appelée lorsque lorsqu'on clique sur le canvas.
	 * Arrête le programme.
	 * @param e Contient les différents paramètres de pointeur lors du clique.
	 */
	@Override
	public void actionPerformed(ActionEvent e) {
		System.exit(0);
		
	}

	@Override
	public String getNom() {
		// TODO Auto-generated method stub
		return getName();
	}

	@Override
	public JButton getBouton() {
		// TODO Auto-generated method stub
		return null;
	}

}
