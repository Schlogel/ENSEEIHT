package main;
import java.awt.Color;
import java.awt.LayoutManager;
import javax.swing.JPanel;

/** Classe correspondant au bouton pour personnaliser la couleur du pointeur
 * 
 * @author AB-4
 *
 */
public class CouleurCustom extends JPanel {

	// Le MouseListener actuellement exécuté lorsqu'on clique sur ce panel. 
	// On doit le changer à chaque nouvelle couleur.
	private ActionCouleur actionActuelle; 
	
	public CouleurCustom() {
		actionActuelle = new ActionCouleur(new Color(100,100,100));
		this.setBackground(new Color(100,100,100));
		this.addMouseListener(actionActuelle);
	}

	public CouleurCustom(LayoutManager layout) {
		super(layout);
		// TODO Auto-generated constructor stub
	}

	public CouleurCustom(boolean isDoubleBuffered) {
		super(isDoubleBuffered);
		// TODO Auto-generated constructor stub
	}

	public CouleurCustom(LayoutManager layout, boolean isDoubleBuffered) {
		super(layout, isDoubleBuffered);
		// TODO Auto-generated constructor stub
	}

	public void updateCouleur(ActionCouleur ac) {
		this.removeMouseListener(actionActuelle);
		this.addMouseListener(ac);
		actionActuelle = ac;
		this.setBackground(ac.getCouleur());
	}
	
}
