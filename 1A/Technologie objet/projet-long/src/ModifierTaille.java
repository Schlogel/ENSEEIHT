import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.SwingConstants;
import javax.swing.event.MouseInputAdapter;

public class ModifierTaille extends MouseInputAdapter implements ToolButton, ActionListener  {

	/*
	 * le bouton importé de la bibliothèque swing
	 */
	private JButton bouton;
	
	/*
	 * l'icône à appliquer au bouton en important une image png
	 */
	private Icon icon;
	
	/*
	 * Constructeur
	 */
	public ModifierTaille() {
		this.icon = new ImageIcon("/home/mathieu/eclipse-workspace/Projet_Long/pl/icones/Taille.png");
		this.bouton = new JButton("Taille Tableau", icon);	
		this.bouton.setVerticalTextPosition(SwingConstants.BOTTOM);
		this.bouton.setHorizontalTextPosition(SwingConstants.CENTER);
		this.bouton.addActionListener(this);
		
	}	
	
	//@Override
	//public void mousePressed(MouseEvent e) {
		//Point p = e.getPoint();
		//IDrawable rect = new RectangleDrawable(Color.black,p,new Dimension(8,8));
		//rect.draw(canvas.getGraphics());
	//}
	
	@Override
	public String getNom() {
		return this.bouton.getName();
	}

	@Override
	public void getImage() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void changeImage() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public JButton getBouton() {	
		return this.bouton;
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		String largeur = JOptionPane.showInputDialog(null, "Entrez la largeur du tableau :");
	    String hauteur = JOptionPane.showInputDialog(null, "Entrez la hauteur du tableau :");
	    BoutonCreerProjet.jc.setPreferredSize(new Dimension(Integer.parseInt(largeur),Integer.parseInt(hauteur)));
	    GUIHelper.showOnFrame(BoutonCreerProjet.jc,"Test : affichage du nouveau canvas et dessin simple");

	}

}