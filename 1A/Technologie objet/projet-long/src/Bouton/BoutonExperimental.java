package Bouton;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

import main.testFenetre;

/** Classe du bouton permettant d'enregistrer le projet en image png.
 * Cette classe n'est pas utilisée dans le programme, elle servait de test.
 * @author AB-4
 *
 */
public class BoutonExperimental extends JButton implements ToolButton, ActionListener  {
	
	/*
	 * Constructeur du bouton.
	 */ 
	public BoutonExperimental() {
		super("Bouton experimental", new ImageIcon("icones/carre_jaune.png"));
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

	/**
	 * Méthode éxecutée lors que le bouton est activé.
	 * Change la couleur du pointeur.
	 * @param e non utilisé ici
	 */
	@Override
	public void actionPerformed(ActionEvent e) {
		testFenetre.pointeur.setColor(Color.yellow);
		
	}
	
	

}