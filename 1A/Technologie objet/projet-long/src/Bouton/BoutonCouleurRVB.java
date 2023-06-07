
package Bouton;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.SwingConstants;

import main.CouleurCustom;
import main.DialogColor;

/** Classe du bouton permettant de choisir une couleur RGB.
 * 
 * @author AB-4
 *
 */

public class BoutonCouleurRVB extends JButton implements ToolButton, ActionListener {
	
	public static CouleurCustom bouton_custom;
	
	/** Constructeur du bouton.
	 * 
	 */
	public BoutonCouleurRVB () {
		super("Choisir une couleur", new ImageIcon("icones/hue.png"));
		setVerticalTextPosition(SwingConstants.BOTTOM);
		setHorizontalTextPosition(SwingConstants.CENTER);
		addActionListener(this);
		bouton_custom = new CouleurCustom();
	}
	
	/** Méthode appelée lors de l'activation du bouton.
	 * @param e Non utilisé ici
	 */
	@Override
	public void actionPerformed(ActionEvent e) {
		DialogColor dc = new DialogColor(null, "Choix couleur", true);
		dc.addBoutonCustom(bouton_custom);
		dc.setVisible(true);
	}

	@Override
	public JButton getBouton() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getNom() {
		// TODO Auto-generated method stub
		return null;
	}

}
