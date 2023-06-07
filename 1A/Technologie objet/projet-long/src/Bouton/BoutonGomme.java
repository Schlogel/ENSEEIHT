package Bouton;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;

import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.SwingConstants;
import javax.swing.event.MouseInputAdapter;

import main.CercleDrawable;
import main.IDrawable;
import main.JCanvas;
import main.testFenetre;

/** Classe du bouton permettant d'effacer les tracés.
 * 
 * @author AB-4
 *
 */
public class BoutonGomme extends MouseInputAdapter implements ToolButton, ActionListener  {

	/*
	 * Le bouton importé de la bibliothèque swing
	 */
	private JButton bouton;
	
	/* Le canvas sur lequel on déssine.
	 * 
	 */
	private JCanvas canvas;
	
	/*
	 * L'icone doit être au format png
	 */
	private Icon icon;
	
	/*
	 * Constructeur du bouton
	 */
	public BoutonGomme() {
		this.icon = new ImageIcon("icones/gomme.png");
		this.bouton = new JButton("Gomme", icon);
		this.bouton.setVerticalTextPosition(SwingConstants.BOTTOM);
		this.bouton.setHorizontalTextPosition(SwingConstants.CENTER);
		this.bouton.addActionListener(this);
		this.canvas = testFenetre.pointeur.getCanvas();
		this.canvas.addMouseListener(this);
		
	}	
	
	/** Méthode appelée lorsque lorsqu'on clique sur le canvas.
	 * Dessine sur le canvas.
	 * @param e Contient les différents paramètres de pointeur lors du clique.
	 */
	@Override
	public void mousePressed(MouseEvent e) {
		Point p = e.getPoint();
		IDrawable rect = new CercleDrawable(Color.black,new Dimension(8,8));
		rect.draw(canvas.getGraphics());
	}
	
	@Override
	public String getNom() {
		return this.bouton.getName();
	}

	@Override
	public JButton getBouton() {
		
		return this.bouton;
	}

	/**
	 * Méthode éxecutée lors que le bouton est activé.
	 * Change la couleur du pointeur par la couleur du canvas.
	 * @param e non utilisé ici
	 */
	@Override
	public void actionPerformed(ActionEvent e) {
		testFenetre.pointeur.setColor(JCanvas.couleur);	
	}
	
	

}