import javax.swing.*;  
import javax.swing.event.*;
import java.awt.*;

/*
 * Ajout de la barre d'outils sur la partie supérieure du tableau blanc
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
	public Fenetre(JCanvas jc){
		
		//Paramétrage de la fenêtre
		this.setTitle("Tableau");
		this.setSize(jc.getLargeur(), jc.getHauteur());
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setLocationRelativeTo(null);
		
		//Initialisation de la barre d'outils
		this.toolsTab = new ToolsTab();
		
		//Création des boutons
		ToolButton boutonExpe = new BoutonExperimental();
		ToolButton boutonOuvr = new Ouvrir();
		ToolButton boutonPipe = new Pipette();
		ToolButton boutonGomm = new Gomme();
		ToolButton boutonEnre = new Enregistrer();
		ToolButton boutonModi = new ModifierTaille();

		//Ajout des boutons souhaité 
		this.toolsTab.addBouton(boutonEnre.getBouton());
		this.toolsTab.addBouton(boutonOuvr.getBouton());
		this.toolsTab.addBouton(boutonGomm.getBouton());
		this.toolsTab.addBouton(boutonPipe.getBouton());
		this.toolsTab.addBouton(boutonModi.getBouton());
		this.toolsTab.addBouton(boutonExpe.getBouton());
		
		
		//On crée un conteneur avec gestion verticale
		Box boxVertical = Box.createVerticalBox();
		boxVertical.add(toolsTab.getTab()); // pas optimal : à changer
		boxVertical.add(jc);
		
		GridLayout grid = new GridLayout(1, 2);
		grid.setHgap(50); 
        grid.setVgap(50); 
		this.setLayout(grid);
		
		//Ajout du contenue dans la fenetre
		this.getContentPane().add(boxVertical);
		
	} 
	
	public Fenetre() {
		//Paramétrage de la fenêtre
		this.setTitle("Menu principal");
		this.setSize(400, 400);
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setLocationRelativeTo(null);
		
		// Configuration du spinner de la largueur
	    SpinnerModel modelLargeur = new SpinnerNumberModel(
                1920, //valeur initiale
                100, //valeur minimum
                4000, //valeur maximum
                10 //pas
	    ); 
	    
	    spinnerLargeur = new JSpinner(modelLargeur);
	    
	    spinnerLargeur.setBounds(100,100,45,30); 
	    
	    // Configuration du spinner de la hauteur
	    SpinnerModel modelHauteur = new SpinnerNumberModel(
                1080, //valeur initiale
                100, //valeur minimum
                4000, //valeur maximum
                10 //pas
	    ); 
	    
	    spinnerHauteur = new JSpinner(modelHauteur);
	    
	    spinnerHauteur.setBounds(100,100,45,30); 
	    
	    // Bouton pour créer le projet
	    ToolButton boutonCreer = new BoutonCreerProjet();
	    ToolButton boutonQuitter = new BoutonQuitter();
	    
	    // Label 
	    JLabel nom = new JLabel("Draw7", JLabel.CENTER);
	    
	    Box boxVertical = Box.createVerticalBox();
	    boxVertical.add(nom); 
	    boxVertical.add(spinnerHauteur); 
	    boxVertical.add(spinnerLargeur);
		boxVertical.add(boutonCreer.getBouton()); // pas optimal : à changer
		boxVertical.add(boutonQuitter.getBouton()); // pas optimal : à changer
		
		this.getContentPane().add(boxVertical);
	    
	}
}
