package Bouton;
import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.SwingConstants;
import javax.swing.event.MouseInputAdapter;

import main.FenetreOuvrir;
import main.JCanvas;
import main.Memory;
import main.Pointeur;

/** Classe du bouton permettant d'ouvrir une image.
 * 
 * @author AB-4
 *
 */
public class BoutonOuvrir extends JButton implements ToolButton, ActionListener {
	
	private Memory memory;
	
	/* Nouvelle fenetre utilisé pour ouvrir l'image.
	 * 
	 */
	private FenetreOuvrir fenetreDessin;
	
	/* Nouveau pointeur sur le nouveau canvas
	 * 
	 */
	private Pointeur pointeur;
	/*
	 * la taille de l'image à ouvrir
	 */
	private int imageWidth, imageHeight;
	
	/*
	 * Constructeur du bouton.
	 */
	public BoutonOuvrir() {
		super("Ouvrir", new ImageIcon("icones/open.png"));
		setVerticalTextPosition(SwingConstants.BOTTOM);
		setHorizontalTextPosition(SwingConstants.CENTER);
		addActionListener(this);
		this.memory = new Memory();
	}

	@Override
	public String getNom() {
		return getName();
	}

	@Override
	public JButton getBouton() {
		return null;
	}

	/** Méthode qui récupert l'image est qui la met dans un canvas.
	 * 
	 * @param file l'image sélétionnée
	 * @return JCanvas Le canvas qui contient l'image
	 */
	private JCanvas createCanvasWithImage(File file) {
		JCanvas canvas;
		try {
			BufferedImage image = ImageIO.read(file);
	        imageWidth = image.getWidth();
	        imageHeight = image.getHeight();
	        canvas = new JCanvas(imageWidth, imageHeight);
		    JLabel imageLabel = new JLabel(new ImageIcon(file.getAbsolutePath()));
		    canvas.add(imageLabel);
		    canvas.repaint();
		    
		} catch (IOException e) {
	        e.printStackTrace();
	        canvas = null;
	    }
		return canvas; 
	}

	/** Méthode éxecutée lors que le bouton est activé.
	 * Ouvre une nouvelle fenetre avec l'image demandés.
	 * 
	 * @param e Non utilisée ici
	 */
	@Override
	public void actionPerformed(ActionEvent e) {
		String source = JOptionPane.showInputDialog(null, "Entrez le chemin d'accès au fichier :");
		// Exemple : /home/mathieu/projet-long-alt/test.png
		// Pour spécifier le chemin d'accès au fichier que nous voulons ouvrir
		File file = new File(source);
		JCanvas canvas = createCanvasWithImage(file);
		pointeur = new Pointeur(canvas, Color.black, memory);
		fenetreDessin = new FenetreOuvrir(canvas, memory);
		
	    fenetreDessin.setVisible(true);

	}

}