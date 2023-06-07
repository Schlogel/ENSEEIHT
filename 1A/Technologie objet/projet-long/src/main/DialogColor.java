package main;
import java.awt.Color;
import java.awt.Font;
import java.awt.Frame;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.ParseException;

import javax.swing.event.ChangeListener;
import javax.swing.event.ChangeEvent;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSpinner;
import javax.swing.SpinnerModel;
import javax.swing.SpinnerNumberModel;

/** Classe correspondant à la fenêtre pop-up pour la personnalisation de couleur
 * 
 * @author AB-4
 *
 */
public class DialogColor extends JDialog{

	private static final long serialVersionUID = 1L;
	
	/*
	 * les variables d'instance pour les étiquettes de texte
	 */
	private JLabel labelText, labelRed, labelGreen, labelBlue;
	
	/* Panel de la couleur actuellement choisie */
	private JPanel panelCurrent;
	
	/* Bouton de la grille de couleur qui récupère la couleur choisie */
	private CouleurCustom bouton_couleur_custom;
	
	/*
	 * les variables d'instance pour sélectionner les valeurs des composantes RVB.
	 */
	private JSpinner spinnerRed, spinnerGreen, spinnerBlue;
	
	/*
	 * les boutons présents sur la fenêtre de sélection de couleurs
	 */
	private JButton boutonDialogColor, buttonCancel, buttonOK;
	
	/**
	 * Configurer une fenêtre de dialogue pour la sélection de couleurs
	 * @param owner la fenêtre parente
	 * @param title le titre de la fenêtre de dialogue
	 * @param modal détermine si la fenêtre de dialogue doit être modale ou non
	 */
	public DialogColor(Frame owner, String title, boolean modal) {
		super(owner, title, modal);
		
		// Caractéristique de la fenêtre pop-up
		this.setSize(400, 400);
		this.setLocationRelativeTo(null);
		this.setResizable(false);
		this.setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);
		
		this.setLayout(null);
		
		this.initComponent();
		
		this.createButton();
	}

	/**
	 * Ajouter la couleur spécifique au bouton
	 * @param cc la couleur spécifique du bouton
	 */
	public void addBoutonCustom(CouleurCustom cc) {
		bouton_couleur_custom = cc;
	}
	
	/**
	 * Initialisation de la fenêtre de sélection de couleurs
	 */
	private void initComponent() {
		
		labelText = new JLabel();
		labelText.setText("Choisissez votre couleur :");
		labelText.setFont(new Font("Arial", Font.BOLD, 18));
		labelText.setBounds(60, 20, 300, 50);
		
		panelCurrent = new JPanel();
		panelCurrent.setSize(150, 50);
		panelCurrent.setLocation(118, 85);
		// Couleur initiale à l'ouverture de la fenêtre.
		panelCurrent.setBackground(new Color(100, 100, 100)); 
		
		labelRed = new JLabel();
		labelRed.setText("Rouge");
		labelRed.setBounds(40, 150, 100, 50);

		labelGreen = new JLabel();
		labelGreen.setText("Vert");
		labelGreen.setBounds(180, 150, 100, 50);
		
		labelBlue = new JLabel();
		labelBlue.setText("Bleu");
		labelBlue.setBounds(300, 150, 100, 50);
	
		
		// Configuration des spinner
		SpinnerModel spinnerModelRed = new SpinnerNumberModel(
                100, //valeur initiale
                0, //valeur minimum
                255, //valeur maximum
                1 //pas
	    ); 
		
		SpinnerModel spinnerModelGreen = new SpinnerNumberModel(
                100, //valeur initiale
                0, //valeur minimum
                255, //valeur maximum
                1 //pas
	    ); 
		
		SpinnerModel spinnerModelBlue = new SpinnerNumberModel(
                100, //valeur initiale
                0, //valeur minimum
                255, //valeur maximum
                1 //pas
	    ); 
	    
		
		// Positionnement des différents boutons
	    spinnerRed = new JSpinner(spinnerModelRed);
	    spinnerRed.setBounds(20, 210, 100, 50);
	    spinnerRed.addChangeListener(couleurListener);
	    
	    spinnerGreen = new JSpinner(spinnerModelGreen);
	    spinnerGreen.setBounds(160, 210, 100, 50);
	    spinnerGreen.addChangeListener(couleurListener);
	    
	    spinnerBlue = new JSpinner(spinnerModelBlue);
	    spinnerBlue.setBounds(280, 210, 100, 50);
	    spinnerBlue.addChangeListener(couleurListener);
	    
	    
	    buttonOK = new JButton();
	    buttonOK.setText("OK");
	    buttonOK.setBounds(40, 300, 100, 50);
	    
	    buttonCancel = new JButton();
	    buttonCancel.setText("Annuler");
	    buttonCancel.setBounds(260, 300, 100, 50);
	    
	    buttonOK.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				
				// Maj du getValue()
				try {
					spinnerRed.commitEdit();
					spinnerGreen.commitEdit();
					spinnerBlue.commitEdit();
				} catch (ParseException e1) {
					e1.printStackTrace();
				}
				
				// On recupere les values
				int red = (int) spinnerRed.getValue();
				int green = (int) spinnerGreen.getValue();
				int blue = (int) spinnerBlue.getValue();
				
				// On change la couleur
				testFenetre.pointeur.setColor(new Color(red, green, blue));
				DialogColor.this.setVisible(false);
				
				// On met à jour le panel de couleur custom
				bouton_couleur_custom.updateCouleur(new ActionCouleur(new Color(red, green, blue)));
			}
		});
	    
	    
	    buttonCancel.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				DialogColor.this.setVisible(false);
			}
		});
	    
	    this.add(panelCurrent);
	    
	    this.add(labelText);
	    this.add(labelBlue);
	    this.add(labelRed);
	    this.add(labelGreen);
	    
	    this.add(spinnerBlue);
	    this.add(spinnerGreen);
	    this.add(spinnerRed);
	    
	    this.add(buttonOK);
	    this.add(buttonCancel);
	}
	
	/* Listener sur les changements de couleurs */
	ChangeListener couleurListener = new ChangeListener() {
	    public void stateChanged(ChangeEvent e) {
	        int red = (int) spinnerRed.getValue();
	        int green = (int) spinnerGreen.getValue();
	        int blue = (int) spinnerBlue.getValue();

	        Color selectedColor = new Color(red, green, blue);
	        panelCurrent.setBackground(selectedColor);
	    }
	};
	
	/**
	 * Créer un nouveau bouton
	 */
	private void createButton() {
	    boutonDialogColor = new JButton("Dialog Color");
	    boutonDialogColor.setBounds(160, 300, 100, 50);
	    boutonDialogColor.addActionListener(new ActionListener() {
	        @Override
	        public void actionPerformed(ActionEvent e) {
	        	DialogColor dialog = new DialogColor(null, "Choisissez une couleur", true);
                dialog.setVisible(true);
	        }
	    });
	}
	
	public JButton getBouton() {
	    return boutonDialogColor;
	}

}
