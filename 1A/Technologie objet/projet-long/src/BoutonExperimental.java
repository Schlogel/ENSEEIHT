import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;

public class BoutonExperimental extends MouseInputAdapter implements ToolButton, ActionListener  {

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
	public BoutonExperimental() {
		this.icon = new ImageIcon("icones/carre_jaune.png");
		this.bouton = new JButton("Bouton experimental", icon);	
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
		testFenetre.pointeur.setColor(Color.yellow);
		System.out.println("ça marche!");
		
	}
	
	

}