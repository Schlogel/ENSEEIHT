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
import main.testFenetre;

/** Classe du bouton permettant d'échanger la couleur du pointeur par
 * la couleur désigné par le pointeur sur le canvas.
 * 
 * @author AB-4
 *
 */
public class BoutonPipette extends MouseInputAdapter implements ToolButton, ActionListener  {

	/*
	 * le bouton importé de la bibliothèque swing.
	 */
	private JButton bouton;
	
	/*
	 * L'icone doit être au format png.
	 */
	private Icon icon;
	
	/*
	 * Booléen indiquant si le bouton est activé.
	 */
	private boolean pipetteOn;
		
	/*
	 * Constructeur du bouton.
	 */
	public BoutonPipette() {
		this.icon = new ImageIcon("icones/pipette.png");
		this.bouton = new JButton("Pipette", icon);	
		this.bouton.setVerticalTextPosition(SwingConstants.BOTTOM);
		this.bouton.setHorizontalTextPosition(SwingConstants.CENTER);
		this.bouton.addActionListener(this);
		this.pipetteOn = false;
		testFenetre.pointeur.getCanvas().addMouseListener(this);
	}
	
	@Override
	public String getNom() {
		return this.bouton.getName();
	}

	@Override
	public JButton getBouton() {
		return this.bouton;
	}

	/** Méthode appelée lorsque lorsqu'on clique sur le canvas.
	 * Méthode qui récupère la couleur sous le pointeur et change
	 * la couleur courante du pointeur.
	 * @param e Contient les différents paramètres de pointeur lors du clique.
	 */
	@Override
	public void mousePressed(MouseEvent e) {
		if (this.pipetteOn) {
			try {
	            Robot robot = new Robot();
	            Toolkit toolkit = Toolkit.getDefaultToolkit();
	            Dimension screenSize = toolkit.getScreenSize();
		        Point mouseLocation = MouseInfo.getPointerInfo().getLocation();
		        int mouseX = (int) mouseLocation.getX();
		        int mouseY = (int) mouseLocation.getY();
		
		        if (mouseX >= 0 && mouseY >= 0 && mouseX < screenSize.getWidth() && mouseY < screenSize.getHeight()) {
		            Color pixelColor = robot.getPixelColor(mouseX, mouseY);
		            testFenetre.pointeur.setColor(pixelColor);
		        }

			} catch (AWTException e1) {
				e1.printStackTrace();
			} finally {
				this.pipetteOn = false;
				FormDrawable.drawEnable = true;
			}
		}
	}

	/** Méthode éxecutée lors que le bouton est activé.
	 * Active le bouton pipette et désactive le tracé.
	 * 
	 * @param e Non utilisée ici
	 */
	@Override
	public void actionPerformed(ActionEvent e) {
		this.pipetteOn = true;
		FormDrawable.drawEnable = false;
	}
}
