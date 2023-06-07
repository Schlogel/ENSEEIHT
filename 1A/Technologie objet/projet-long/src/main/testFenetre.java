package main;

/** Classe
 * 
 * @author AB-4
 *
 */
public class testFenetre {
	
	/**
	 * Le pointeur de la fenêtre 
	 */
	public static Pointeur pointeur;
	
	/**
	 * La fenêtre principale, le menu et le canvas
	 */
	public static Fenetre fenetreMenu;
	
	public static void main(String[] args) {
//		new DialogColor(null, "Ceci est un titre", true).setVisible(true);
		fenetreMenu = new Fenetre();
		fenetreMenu.setVisible(true);
	}
}