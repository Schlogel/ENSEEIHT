package main;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;

import javax.swing.Box;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JPanel;
import javax.swing.JSpinner;
import javax.swing.SpinnerModel;
import javax.swing.SpinnerNumberModel;
import javax.swing.SwingConstants;

import Bouton.BoutonCreerProjet;
import Bouton.BoutonDecr;
import Bouton.BoutonEnregistrer;
import Bouton.BoutonGomme;
import Bouton.BoutonIncr;
import Bouton.BoutonModifierTaille;
import Bouton.BoutonOuvrir;
import Bouton.BoutonPipette;
import Bouton.BoutonQuitter;
import Bouton.BoutonRemplissage;
import Bouton.ToolButton;

/** Classe de la fênetre contenant le canvas.
 * Utilisée lorsqu'on ouvre une image.
 * @author AB-4
 *
 */
public class FenetreOuvrir extends JFrame{
	
	/*
	 * la barre d'outils de la fenêtre
	 */
	private ToolsTab toolsTab;
	
	public static JSpinner spinnerLargeur; 
	public static JSpinner spinnerHauteur;

	/* 
	 * Constructeur
	 */
	public FenetreOuvrir(JCanvas jc, Memory Memory){
		
		//Paramétrage de la fenêtre
		this.setTitle("Tableau");
		this.setSize(jc.getLargeur(), jc.getHauteur());
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setLocationRelativeTo(null);
		
		//Initialisation de la barre d'outils
		this.toolsTab = new ToolsTab();
		
		//Création des boutons
		ToolButton boutonPipe = new BoutonPipette();
		ToolButton boutonGomm = new BoutonGomme();
		JButton boutonEnre = new BoutonEnregistrer();
		ToolButton boutonModi = new BoutonModifierTaille();
		ToolButton boutonRemp = new BoutonRemplissage();
		JButton boutonIncr = new BoutonIncr();
		JButton boutonDecr = new BoutonDecr();
		
		//Création du menu pour changer la forme du pointeur
		JMenuItem menuRect = new JMenuItem(new ActionFormeRectangle());
		menuRect.setIcon(new ImageIcon("icones/rectangle.png")); //ne s'affiche pas
		JMenuItem menuCerc = new JMenuItem(new ActionFormeCercle());
		menuCerc.setIcon(new ImageIcon("icones/cercle.png")); //ne s'affiche pas
		
		JMenuBar menuBar = new JMenuBar();
		
		JMenu menuForm = new JMenu("Forme du pointeur");
		menuForm.add(menuRect);
		menuForm.add(menuCerc);

		menuBar.add(menuForm);
		
		// Création du menu pour changer la couleur du pointeur
		GridLayout menuCouleurs = new GridLayout(3,6);
		Color[] listeCouleurs = {Color.BLACK, Color.BLUE, Color.CYAN, Color.DARK_GRAY, Color.GRAY, Color.GREEN, Color.LIGHT_GRAY, Color.MAGENTA,
				Color.ORANGE, Color.PINK, Color.RED, Color.WHITE, Color.YELLOW};
		
		JPanel grille = new JPanel(menuCouleurs);
		for (Color c : listeCouleurs) {
			JButton b = new JButton("",new ImageIcon("icones/" + c.toString() +".png"));
			b.addMouseListener(new ActionCouleur(c));
			grille.add(b);
		}
		CouleurCustom bouton_custom = new CouleurCustom();
		grille.add(bouton_custom);
		
		// Création du bouton permettant de définir une couleur
		JButton colorRVB = new JButton("Choisir une couleur", new ImageIcon("icones/hue.png"));
		colorRVB.setVerticalTextPosition(SwingConstants.BOTTOM);
		colorRVB.setHorizontalTextPosition(SwingConstants.CENTER);
		colorRVB.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				DialogColor dc = new DialogColor(null, "Choix couleur", true);
				dc.addBoutonCustom(bouton_custom);
				dc.setVisible(true);
			}
		});		
		
		//Ajout des boutons souhaité 
		this.toolsTab.add(colorRVB);
		this.toolsTab.add(boutonEnre);
		this.toolsTab.add(boutonGomm.getBouton());
		this.toolsTab.add(boutonPipe.getBouton());
		this.toolsTab.add(boutonModi.getBouton());
		this.toolsTab.add(boutonRemp.getBouton());
		this.toolsTab.add(boutonIncr);
		this.toolsTab.add(boutonDecr);
		this.toolsTab.add(menuBar);
		this.toolsTab.add(grille);
		
		//On crée un conteneur avec gestion verticale
		Box boxVertical = Box.createVerticalBox();
		boxVertical.add(toolsTab);
		boxVertical.add(jc);
		
		GridLayout grid = new GridLayout(1, 2);
		grid.setHgap(50); 
        grid.setVgap(50); 
		this.setLayout(grid);
		
		//Ajout du contenu dans la fenetre
		this.getContentPane().add(boxVertical);
		//ajout du keylistener de ctrl z
		Undoaction undoaction = new Undoaction(Memory);
		this.setFocusable(true);
		this.requestFocusInWindow();
		//ajout de gestionnaire de concentration
		this.addKeyListener(undoaction);
		CustomFocusListener focus=new CustomFocusListener(this);
		this.addFocusListener(focus);
	} 
}
