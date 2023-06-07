package main;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Point;

/** Classe des actions faisable avec un cercle
 * 
 * @author AB-4
 *
 */
public class CercleDrawable extends FormDrawable {

	/**Constructeur
	 * 
	 * @param color la couleur du pointeur
	 * @param dim la dimension du pointeur sous forme de cercle
	 */
	public CercleDrawable(Color color, Dimension dim) {
		super(color, dim);
		
	}

	/**
	 * Dessiner un cercle rempli sur l'objet Graphics fourni
	 */
	@Override
	public void draw(Graphics g) {
		if (FormDrawable.drawEnable == true) {
			Color c = g.getColor();
			g.setColor(color);
			g.fillOval(rect.x, rect.y, rect.height, rect.width);
			g.setColor(c);
		}
	}
	
	/**
	 * Dessiner un cercle rempli sur l'objet Graphics fourni
	 */
	@Override
	public void drawAuto(Graphics g, Color specialColor, int posX, int posY) {
		Color c = g.getColor();
		g.setColor(specialColor);
		g.fillOval(posX, posY, rect.height, rect.width);
		g.setColor(c);
	}

}
