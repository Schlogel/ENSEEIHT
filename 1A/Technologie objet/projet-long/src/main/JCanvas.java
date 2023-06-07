package main;
import java.awt.*;

import javax.swing.*;

/** Classe
 * 
 * @author AB-4
 *
 */
public class JCanvas extends JPanel {
	private int tailleX;
	private int tailleY;
	public static Color couleur = Color.WHITE;
	
	/**Constructeur
	 * 
	 * @param x la largeur du canvas
	 * @param y la hauteur du canvas
	 */
	public JCanvas(int x, int y) {
		this.setBackground(couleur);
		tailleX = x;
		tailleY = y;
		this.setPreferredSize(new Dimension(tailleX,tailleY));

	}
	
	/*
	 * Récupérer la largeur
	 */
	public int getLargeur() {
		return this.tailleX;
	}
	
	/*
	 * Récupérer la hauteur
	 */
	public int getHauteur() {
		return this.tailleY;
	}

}