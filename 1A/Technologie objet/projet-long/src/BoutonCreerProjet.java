import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;

public class BoutonCreerProjet implements ToolButton, ActionListener  {

<<<<<<< HEAD
	static JCanvas jc;
=======
>>>>>>> 20d27d603bd9aa4f5c45d97ad245593148262401
	/*
	 * le bouton importé de la bibliothèque swing
	 */
	private JButton bouton;
	
	/*
	 * l'icône à appliquer au bouton en important une image png
	 */
	private Icon icon;
	
	/* 
	 * Constructeur
	 */
	public BoutonCreerProjet() {
		this.bouton = new JButton("Créer le projet");
		this.bouton.addActionListener(this);
		
	}	
	
	
	@Override
	public String getNom() {
		return this.bouton.getName();
	}

	@Override
	public void getImage() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void changeImage() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public JButton getBouton() {
		
		return this.bouton;
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		testFenetre.fenetreMenu.setVisible(false);
<<<<<<< HEAD
		jc = new JCanvas((Integer) Fenetre.spinnerLargeur.getValue(), (Integer) Fenetre.spinnerHauteur.getValue());
=======
		JCanvas jc = new JCanvas((Integer) Fenetre.spinnerLargeur.getValue(), (Integer) Fenetre.spinnerHauteur.getValue());
>>>>>>> 20d27d603bd9aa4f5c45d97ad245593148262401
		Fenetre f = new Fenetre(jc);
		Color couleur = Color.blue;
		testFenetre.pointeur = new Pointeur(jc, couleur);
		f.setVisible(true);
		System.out.println("ça marche!");
		
	}
	
	

}