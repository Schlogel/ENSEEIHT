package Bouton;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.SwingConstants;
import javax.swing.event.MouseInputAdapter;

import main.GUIHelper;
import main.JCanvas;
import main.testFenetre;

/** Classe du bouton permettant d'ouvrir un nouveau canvas.
 * 
 * @author AB-4
 *
 */
public class BoutonModifierTaille extends MouseInputAdapter implements ToolButton, ActionListener  {

	/*
	 * le bouton importé de la bibliothèque swing
	 */
	private JButton bouton;
	
	/*
	 * L'icone doit être au format png
	 */
	private Icon icon;
	
	/* Le canvas sur lequel on déssine.
	 * 
	 */
	private JCanvas canvas;
	
	/*
	 * Constructeur du bouton
	 */
	public BoutonModifierTaille() {
		this.icon = new ImageIcon("icones/Taille.png");
		this.bouton = new JButton("Taille Tableau", icon);	
		this.bouton.setVerticalTextPosition(SwingConstants.BOTTOM);
		this.bouton.setHorizontalTextPosition(SwingConstants.CENTER);
		this.bouton.addActionListener(this);
		this.canvas = testFenetre.pointeur.getCanvas();
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

	/** Méthode éxecutée lors que le bouton est activé.
	 * Ouvre une nouveau canvas avec les taille demandées.
	 * 
	 * @param e Non utilisée ici
	 */
	@Override
	public void actionPerformed(ActionEvent e) {
		String largeur = JOptionPane.showInputDialog(null, "Entrez la largeur du tableau :");
	    String hauteur = JOptionPane.showInputDialog(null, "Entrez la hauteur du tableau :");
	    BoutonCreerProjet.jc.setPreferredSize(new Dimension(Integer.parseInt(largeur),Integer.parseInt(hauteur)));
	    GUIHelper.showOnFrame(BoutonCreerProjet.jc,"Test : affichage du nouveau canvas et dessin simple");

	}

}