package Bouton;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.SwingConstants;
import javax.swing.event.MouseInputAdapter;

import main.CercleDrawable;
import main.RectangleDrawable;
import main.testFenetre;

/** Classe du bouton permettant d'augmenter la taille du tracés.
 * 
 * @author AB-4
 *
 */
public class BoutonIncr extends JButton implements ToolButton, ActionListener  {
		
	/*
	 * Constructeur du bouton
	 */
	public BoutonIncr() {
		super("Augmenter taille", new ImageIcon("icones/+.png"));
		setVerticalTextPosition(SwingConstants.BOTTOM);
		setHorizontalTextPosition(SwingConstants.CENTER);
		addActionListener(this);
	}
	
	@Override
	public String getNom() {
		return getName();
	}

	@Override
	public JButton getBouton() {
		return null;
	}
	
	/** Méthode éxecutée lors que le bouton est activé.
	 * Méthode qui augmente la taille du pointeur.
	 * 
	 * @param e Non utilisée ici
	 */
	@Override
	public void actionPerformed(ActionEvent e) {
		int new_taille = testFenetre.pointeur.getTaille() + 6;
		if (testFenetre.pointeur.getForme() instanceof RectangleDrawable) {
			testFenetre.pointeur.setForme(new RectangleDrawable(testFenetre.pointeur.getColor(),new Dimension(new_taille, new_taille)));
		}
		else {
			testFenetre.pointeur.setForme(new CercleDrawable(testFenetre.pointeur.getColor(),new Dimension(new_taille, new_taille)));
		}
		
		testFenetre.pointeur.setTaille(new_taille);
	}
}
