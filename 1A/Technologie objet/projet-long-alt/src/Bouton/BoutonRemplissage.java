package Bouton;
import java.awt.AWTException;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.MouseInfo;
import java.awt.Point;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.SwingConstants;
import javax.swing.event.MouseInputAdapter;

import main.FormDrawable;
import main.JCanvas;
import main.testFenetre;

/** Classe du bouton permettant de remplir une zone de la même couleur.
 * 
 * 
 * @author AB-4
 *
 */
public class BoutonRemplissage extends MouseInputAdapter implements ToolButton, ActionListener {

	/*
	 * le bouton importé de la bibliothèque swing
	 */
	private JButton bouton;

	/*
	 * l'icône à appliquer au bouton en important une image png
	 */
	private Icon icon;

	/*
	 * paramètre géré automatiquement
	 */
	private Robot robot;

	/*
	 * permet d'utiliser les méthodes getLargeur() et getHauteur()
	 */
	private JCanvas canvas;

	/*
	 * tableau contenant les pixels
	 */
	private Color[][] pixels;

	/*
	 * la couleur du premier pixel de la surface à remplir
	 */
	private Color firstColor;

	/*
	 * Booléen indiquant si le bouton est activé.
	 */
	private boolean remplissageOn;

	/*
	 * Constructeur du bouton
	 */
	public BoutonRemplissage() {
		this.icon = new ImageIcon("icones/remplir.png");
		this.bouton = new JButton("Remplissage", icon);
		this.bouton.setVerticalTextPosition(SwingConstants.BOTTOM);
		this.bouton.setHorizontalTextPosition(SwingConstants.CENTER);
		this.bouton.addMouseListener(this);
		this.canvas = testFenetre.pointeur.getCanvas();
		this.pixels = new Color[canvas.getLargeur()][canvas.getHauteur()];
		try {
			this.robot = new Robot();
		} catch (AWTException e) {
			e.printStackTrace();
		}
		this.bouton.addActionListener(this);
		this.remplissageOn = false;
		this.canvas.addMouseListener(this);
	}

	@Override
	public String getNom() {
		return this.bouton.getName();
	}

	@Override
	public JButton getBouton() {
		return this.bouton;
	}

	/** Méthode qui remplie la surface de la couleur du pointeur
	 * 
	 * @param x coordonnée de début de remplissage
	 * @param y coordonnée de début de remplissage
	 */
	private void remplissageZone(int x, int y) {
		if (x < 0 || x >= canvas.getLargeur() || y < 0 || y >= canvas.getHauteur()) {
			return;
		}
		if (pixels[x][y] != null) {
			return; // Le pixel a déjà été rempli
		}

		Color currentColor = robot.getPixelColor(x, y);


		if (!currentColor.equals(firstColor)) {

			return; // Arrêter si la couleur du pixel ne correspond pas à la couleur courante
		}

		// Remplir le pixel
		testFenetre.pointeur.getForme().drawAuto(canvas.getGraphics(), testFenetre.pointeur.getColor(), x, y);

		// Appels récursifs : Les pixels adjacents afin de continuer le remplissage de
		// zone dans les quatre directions
		// remplissageZone(x - 1, y); // Pixel à gauche
		// remplissageZone(x + 1, y); // Pixel à droite
		// remplissageZone(x, y - 1); // Pixel au-dessus
		// remplissageZone(x, y + 1); // Pixel en dessous

		// Créer des tâches pour les appels récursifs
		Runnable leftTask = () -> remplissageZone(x - 1, y);
		Runnable rightTask = () -> remplissageZone(x + 1, y);
		Runnable aboveTask = () -> remplissageZone(x, y - 1);
		Runnable belowTask = () -> remplissageZone(x, y + 1);

		// Créer des threads pour exécuter les tâches en parallèle
		Thread leftThread = new Thread(leftTask);
		Thread rightThread = new Thread(rightTask);
		Thread aboveThread = new Thread(aboveTask);
		Thread belowThread = new Thread(belowTask);

		// Démarrer les threads simultanément
		leftThread.start();
		rightThread.start();
		aboveThread.start();
		belowThread.start();

		// Attendre la fin des threads
		try {
			leftThread.join();
			rightThread.join();
			aboveThread.join();
			belowThread.join();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

	/** Méthode appelée lorsque lorsqu'on clique sur le canvas.
	 * Récupère le pixel en dessous du pointeur, et rempli la zone de la couleur du pointeur.
	 * @param e Contient les différents paramètres de pointeur lors du clique.
	 */
	@Override
	public void mousePressed(MouseEvent e) {
		if (this.remplissageOn) {
			Toolkit toolkit = Toolkit.getDefaultToolkit();
			Dimension screenSize = toolkit.getScreenSize();

			Point mouseLocation = MouseInfo.getPointerInfo().getLocation();
			int mouseX = (int) mouseLocation.getX();
			int mouseY = (int) mouseLocation.getY();

			if (mouseX >= 0 && mouseY >= 0 && mouseX < screenSize.getWidth() && mouseY < screenSize.getHeight()) {
				Color pixelColor = robot.getPixelColor(mouseX, mouseY);
				firstColor = pixelColor;
				remplissageZone(mouseX, mouseY);
			}
			this.remplissageOn = false;
			FormDrawable.drawEnable = true;

		}
	}

	/** Méthode appelée lorsque lorsqu'on clique sur le canvas.
	 * Active la fonctionnalitée.
	 * @param e Contient les différents paramètres de pointeur lors du clique.
	 */
	@Override
	public void actionPerformed(ActionEvent e) {
		this.remplissageOn = true;
		FormDrawable.drawEnable = false;
	}

}