package Bouton;
import java.awt.AWTException;
// Effectuer automatiquement une capture d'écran
import java.awt.Robot;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.SwingConstants;
import javax.swing.event.MouseInputAdapter;

import main.JCanvas;

/** Classe du bouton permettant d'enregistrer le projet en image png.
 * 
 * @author AB-4
 *
 */
public class BoutonEnregistrer extends JButton implements ToolButton, ActionListener  {
	
	/*
	 * Constructeur du bouton
	 */
	public BoutonEnregistrer() {
		super("Enregistrer", new ImageIcon("icones/save.png"));
		setVerticalTextPosition(SwingConstants.BOTTOM);
		setHorizontalTextPosition(SwingConstants.CENTER);
		addActionListener(this);
		
	}	
	
	@Override
	public String getNom() {
		return getName();
	}

	/** Méthode qui enregistre le dessin en faisant une capture d'écran de la fenêtre.
	 * 
	 * @param e Non utilisé ici
	 */
	@Override
	public void actionPerformed(ActionEvent e) {
		try {
			  JCanvas canvas = BoutonCreerProjet.jc;
			
			  Rectangle canvasRect = new Rectangle(canvas.getLocationOnScreen().x ,
					  canvas.getLocationOnScreen().y , 
					  canvas.getWidth(), 
					  canvas.getHeight());
		      BufferedImage image = new Robot().createScreenCapture(canvasRect);
		      
		      // Enregistrer l'image dans un fichier PNG
		      String source = JOptionPane.showInputDialog(null, "Veuillez indiquer le nom du fichier :");
		      // Créer le nouveau fichier/image
		      File file = new File(source + ".png");
		      ImageIO.write(image, "png", file);

		      System.out.println("Le dessin a été sauvegardé.");
		    } catch (IOException | AWTException f) {
		      f.printStackTrace();
		    }
	}

	@Override
	public JButton getBouton() {
		// TODO Auto-generated method stub
		return null;
	}
}
