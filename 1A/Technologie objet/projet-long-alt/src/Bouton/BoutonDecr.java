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

/** Classe du bouton permettant de dimineur la taille du tracé.
 * 
 * @author AB-4
 *
 */
public class BoutonDecr extends JButton implements ToolButton, ActionListener  {
		
	/*
	 * Constructeur du bouton
	 */
	public BoutonDecr() {
		super("Diminuer taille", new ImageIcon("icones/-.png"));
		setVerticalTextPosition(SwingConstants.BOTTOM);
		setHorizontalTextPosition(SwingConstants.CENTER);
		addActionListener(this);
	}
	
	@Override
	public String getNom() {
		return getName();
	}

	
	/**Méthode qui réduit la taille du pointeur.
	 * 
	 * @param taille valeur de la modification souhaitée
	 */
	
	private void modifTaille(int taille) {
		if (testFenetre.pointeur.getForme() instanceof RectangleDrawable) {
			testFenetre.pointeur.setForme(new RectangleDrawable(testFenetre.pointeur.getColor(),new Dimension(taille, taille)));
		}
		else {
			testFenetre.pointeur.setForme(new CercleDrawable(testFenetre.pointeur.getColor(),new Dimension(taille, taille)));
		}
		testFenetre.pointeur.setTaille(taille);
	}
	
	/**
	 * Méthode éxecutée lors que le bouton est activé.
	 * Diminue la taille du pointeur.
	 * @param e non utilisé ici
	 */
	@Override
	public void actionPerformed(ActionEvent e) {
		if (testFenetre.pointeur.getTaille() > 6) {
			int new_taille = testFenetre.pointeur.getTaille() - 6;
			modifTaille(new_taille);
		}
		else {
			modifTaille(1);
		}
	}

	@Override
	public JButton getBouton() {
		// TODO Auto-generated method stub
		return null;
	}
}
