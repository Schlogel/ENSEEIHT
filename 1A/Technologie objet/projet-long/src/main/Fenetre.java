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

import Bouton.BoutonCouleurRVB;
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
 * 
 * @author AB-4
 *
 */
public class Fenetre extends JFrame{
	
	/*
	 * la barre d'outils de la fenêtre
	 */
	private ToolsTab toolsTab;
	
	public static JSpinner spinnerLargeur; 
	public static JSpinner spinnerHauteur;

	/* 
	 * Constructeur
	 */
	public Fenetre(JCanvas jc, Memory Memory){
		
		//Paramétrage de la fenêtre
		this.setTitle("Tableau");
		this.setSize(jc.getLargeur(), jc.getHauteur());
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setLocationRelativeTo(null);
		
		//Initialisation de la barre d'outils
		this.toolsTab = new ToolsTab();
		
		//Création des boutons
		JButton boutonOuvr = new BoutonOuvrir();
		ToolButton boutonPipe = new BoutonPipette();
		ToolButton boutonGomm = new BoutonGomme();
		JButton boutonEnre = new BoutonEnregistrer();
		ToolButton boutonModi = new BoutonModifierTaille();
		ToolButton boutonRemp = new BoutonRemplissage();
		JButton boutonIncr = new BoutonIncr();
		JButton boutonDecr = new BoutonDecr();
		JButton colorRVB = new BoutonCouleurRVB();
		
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
	
		grille.add(BoutonCouleurRVB.bouton_custom);
				
		
		//Ajout des boutons souhaité 
		this.toolsTab.add(colorRVB);
		this.toolsTab.add(boutonEnre);
		this.toolsTab.add(boutonOuvr);
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
		//traitement du ctrlz:ajout du keylistener
		Undoaction undoaction = new Undoaction(Memory);
		this.setFocusable(true);
		this.requestFocusInWindow();
		this.addKeyListener(undoaction);
		//ajout du gestionnaire de concentration
		CustomFocusListener focus=new CustomFocusListener(this);
		this.addFocusListener(focus);
	} 
	
	
	public Fenetre() {
		//Paramétrage de la fenêtre
		this.setTitle("Menu principal");
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setSize(400, 500);
		this.setLocationRelativeTo(null);
		this.setResizable(false);
		this.setLayout(null);
		
		// Configuration du spinner de la largueur
	    SpinnerModel modelLargeur = new SpinnerNumberModel(
                1920, //valeur initiale
                100, //valeur minimum
                4000, //valeur maximum
                10 //pas
	    ); 
	    
	    // Configuration du spinner de la hauteur
	    SpinnerModel modelHauteur = new SpinnerNumberModel(
                1080, //valeur initiale
                100, //valeur minimum
                4000, //valeur maximum
                10 //pas
	    ); 
	    
	    spinnerLargeur = new JSpinner(modelLargeur);
	    spinnerHauteur = new JSpinner(modelHauteur);
	    spinnerLargeur.setBounds(75,200,100,50);
	    spinnerHauteur.setBounds(225,200,100,50);
	    
	    spinnerLargeur.setFont(new Font("Sans-Serif", Font.BOLD, 25));
	    spinnerHauteur.setFont(new Font("Sans-Serif", Font.BOLD, 25));
	    
	    // Bouton pour créer le projet
	    JButton boutonCreer = new BoutonCreerProjet();
	    JButton boutonQuitter = new BoutonQuitter();
	    boutonCreer.setBounds(125, 300, 150, 50);
	    boutonQuitter.setBounds(150, 400, 100, 50);
	    boutonCreer.setFont(new Font("Sans-Serif", Font.BOLD, 17));
	    boutonQuitter.setFont(new Font("Sans-Serif", Font.BOLD, 17));
	    
	    boutonQuitter.setForeground(Color.WHITE);
	    boutonQuitter.setBackground(Color.BLACK);
	    boutonQuitter.setBorderPainted(false); 
	    boutonQuitter.setFocusPainted(false);
	    
	    // Labels 
	    JLabel nom = new JLabel("Draw7", JLabel.CENTER);
	    nom.setFont(new Font("Sans-Serif", Font.BOLD, 50));
	    nom.setForeground(Color.WHITE);
	    nom.setBounds(100,30,200,50);
	    
	    JLabel hauteur = new JLabel("Hauteur", JLabel.CENTER);
	    hauteur.setFont(new Font("Sans-Serif", Font.BOLD, 20));
	    hauteur.setForeground(Color.WHITE);
	    hauteur.setBounds(25,150,200,50);
	    
	    JLabel largeur = new JLabel("Largeur", JLabel.CENTER);
	    largeur.setFont(new Font("Sans-Serif", Font.BOLD, 20));
	    largeur.setForeground(Color.WHITE);
	    largeur.setBounds(175,150,200,50);
	    
	    // Ajout des éléments
	    this.add(nom); 
	    this.add(hauteur);
	    this.add(largeur);
	    this.add(spinnerHauteur);
	    this.add(spinnerLargeur);
	    this.add(boutonCreer);
	    this.add(boutonQuitter);
	
		this.getContentPane().setBackground(new Color(30, 127, 203));
	    
	}
}

