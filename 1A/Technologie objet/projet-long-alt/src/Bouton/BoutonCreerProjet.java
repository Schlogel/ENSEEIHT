package Bouton;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

import main.Fenetre;
import main.JCanvas;
import main.Memory;
import main.Pointeur;
import main.testFenetre;

/** Classe du bouton permettant de créer un projet.
 * 
 * @author AB-4
 *
 */
public class BoutonCreerProjet extends JButton implements ToolButton, ActionListener {

	/* Le canvas sur lequel on déssine.
	 * 
	 */
	static JCanvas jc;

	/**
	 * Constrcuteur du bouton.
	 * 
	 */
	public BoutonCreerProjet() {
		super("Créer le projet");
		setForeground(Color.WHITE);
		addActionListener(this);
		setBackground(Color.GRAY);
		setBorderPainted(false);
		setFocusPainted(false);
		setHorizontalAlignment(SwingConstants.CENTER);
		setHorizontalTextPosition(SwingConstants.CENTER);

	}

	/**
	 * Méthode éxecutée lors que le bouton est activé.
	 * Ouvre l'interface graphique du projet.
	 * @param e non utilisé ici
	 */
	@Override
	public void actionPerformed(ActionEvent e) {
		testFenetre.fenetreMenu.setVisible(false); // ferme la fenêtre du menu
		Memory Memory = new Memory(); // Lance la mise en mémoire des actions pour le ctrl+z
		JCanvas jcanvas = new JCanvas((Integer) Fenetre.spinnerLargeur.getValue(),
				(Integer) Fenetre.spinnerHauteur.getValue());
		Color couleur = Color.black;
		testFenetre.pointeur = new Pointeur(jcanvas, couleur, Memory); // créer le pointeur associé à la fenêtre
		Fenetre f = new Fenetre(jcanvas, Memory);
		f.setVisible(true); // affiche la fenêtre pour dessiner
		jc = jcanvas;

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