import javax.swing.Box; 
import javax.swing.JButton;

public class ToolsTab {
	
	/*
	 * la barre d'outils
	 */
	private Box toolsTab;
	
	/*
	 * Constructeur
	 */
	public ToolsTab() {
		this.toolsTab = Box.createHorizontalBox();
	}
	
	/*
	 * Ajouter un nouveau bouton
	 */
	public void addBouton(JButton bouton) {
		 this.toolsTab.add(bouton);
	}
	
	public Box getTab() {
		return this.toolsTab;
	}
}