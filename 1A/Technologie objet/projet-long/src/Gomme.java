import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.SwingConstants;
import javax.swing.event.MouseInputAdapter;

public class Gomme extends MouseInputAdapter implements ToolButton, ActionListener  {

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
	public Gomme() {
		this.icon = new ImageIcon("/home/mathieu/eclipse-workspace/Projet_Long/pl/icones/gomme.png");
		this.bouton = new JButton("Gomme", icon);	
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
		testFenetre.pointeur.setColor(JCanvas.couleur);	
	}
	
	

}