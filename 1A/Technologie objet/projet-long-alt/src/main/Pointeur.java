package main;
import java.awt.event.*;
import java.util.Stack;
import java.awt.AWTException;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Point;
import java.awt.Robot;

import javax.swing.event.MouseInputAdapter;

/** Classe avec les actions faisable par l'utilisateur avec la souris sur le canvas.
 * 
 * @author AB-4
 *
 */
public class Pointeur extends MouseInputAdapter {

	private JCanvas canvas;
	private Color couleur;
	private IDrawable forme;
	private int taille;
	private boolean modeRemplir = false;
	private Memory Memory;
	private Action act;
	
	/**Constructeur
	 * 
	 * @param c  le canvas sur lequel le pointeur est affecté
	 * @param couleur  la couleur iniatiale du pointeur
	 * @param Memory  Pile contenant les actions effectués
	 */
	public Pointeur(JCanvas c, Color couleur, Memory Memory) {
		super();
		canvas = c;
		taille = 8;
		forme = new CercleDrawable(this.couleur,new Dimension(taille,taille)); //forme par défaut
		canvas.addMouseListener(this);
		canvas.addMouseMotionListener(this);
		this.couleur = couleur;
		this.Memory=Memory;
		Stack<Point> points= new Stack<Point>();
		Stack<Graphics> graphics= new Stack<Graphics>();
		this.act= new Action(points,graphics);
		
	}
	
	/**
	 * Afficher graphiquement et sauvegarder les actions brèves du pointeur
	 */
	@Override
	public void mousePressed(MouseEvent e) {
		if (!modeRemplir) {
			Point p = e.getPoint();
			Graphics g=canvas.getGraphics();
			forme.setPos(p);
			forme.draw(g);
			this.act.getpoints().add(p);
			this.act.getgraphics().add(g);
		}
		else {
			// Algorithme flood fill
			Color oldColor = null;
			try {
				oldColor = new Robot().getPixelColor(e.getX(),e.getY());
			} catch (AWTException e1) {
				e1.printStackTrace();
			}
			floodFill(e.getX(),e.getY(),couleur,oldColor);
		}
	}
	
	/**
	 * Configure et sauvegarde en mémoire la forme de l'action et des graphiques
	 */
	@Override
	public void mouseReleased(MouseEvent e) {
	    this.act.setform(this.getForme());
	    this.Memory.add(this.act);
	    Stack<Point> points= new Stack<Point>();
		Stack<Graphics> graphics= new Stack<Graphics>();
		this.act= new Action(points,graphics);
	}
	
	/**
	 * Dessiner et sauvegarder une forme en fonction du déplacement de la souris
	 */
	@Override
	public void mouseDragged(MouseEvent e) {
		if (!modeRemplir) {
			Point p = e.getPoint();
			Graphics g=canvas.getGraphics();
			forme.setPos(p);
			forme.draw(g);
			this.act.getpoints().add(p);
			this.act.getgraphics().add(g);

		} else {
			// Rien
		}

	}

	/** 
	 * Modifier la couleur du pointeur
	 * @param couleur la nouvelle couleur à affecter au pointeur
	 */
	public void setColor(Color couleur) {
		this.couleur = couleur;
		if (forme instanceof CercleDrawable) {
			forme = new CercleDrawable(this.couleur,new Dimension(taille,taille));
		}
		else if (forme instanceof RectangleDrawable) {
			forme = new RectangleDrawable(this.couleur,new Dimension(taille,taille));
		}
		
	}
	
	/**
	 * Récupérer la couleur du pointeur
	 * @return la couleur du pointeur
	 */
	public Color getColor() {
		return couleur;	
	}
	
	/**
	 * Modifier la forme du pointeur
	 * @param new_forme la nouvelle forme du pointeur (cercle ou rectangle)
	 */
	public void setForme(IDrawable new_forme) {
		forme = new_forme;
	}
	
	/**
	 * Récupérer la forme du pointeur
	 * @return la forme actuelle du pointeur
	 */
	public IDrawable getForme() {
		return forme;
	}
	
	/**
	 * Récupérer la taille du pointeur
	 * @return la taille actuelle du pointeur
	 */
	public int getTaille() {
		return taille;
	}
	
	/**
	 * Modifier la taille du pointeur
	 * @param newTaille la nouvelle taille du pointeur
	 */
	public void setTaille(int newTaille) {
		this.taille = newTaille;
	}
	
	/**
	 * Vérifier si on utilise le remplissage
	 * @param mode un boolean valant true si on utilise ce bouton
	 */
	public void setMode(boolean mode) {
		modeRemplir = mode;
	}
	
	/**
	 * Récupérer le canvas utilisé
	 * @return le canvas actuel
	 */
	public JCanvas getCanvas() {
		return this.canvas;
	}
	
	private static void floodFill(int x, int y, Color fillColor, Color oldColor) {
	    /** 
	     * rectangle = new Rectangle(Color.black,1,1)
	     * Si (x,y) hors des limites du canvas Alors
	     * 		Rien
	     *
	     * Sinon
	     * 		Si (oldColor != fillColor) Alors
	     * 			rectangle.dessiner()
	     * 		Sinon
	     * 			Rien
	     * 		FinSi
	     * FinSi
	     * floodFill(x+1,y+1,fillColor,oldColor)
	     * floodFill(x,y+1,...)
	     * floodFill(x+1,y,...)
	     * etc...			
	     */
	    
	}

}
