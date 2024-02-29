import java.awt.AWTException;
import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.SwingConstants;
import javax.swing.event.MouseInputAdapter;
import java.awt.Robot;

public class Pipette extends MouseInputAdapter implements ToolButton, ActionListener  {

	/*
	 * le bouton importé de la bibliothèque swing
	 */
	private JButton bouton;
	
	/*
	 * l'icône à appliquer au bouton en important une image png
	 */
	private Icon icon;
	
	/*
	 * la nouvelle couleur prise par la pipette
	 */
	private Color color;
	
	/*
	 * Constructeur
	 */
	public Pipette() {
		this.icon = new ImageIcon("/home/mathieu/eclipse-workspace/Projet_Long/pl/icones/pipette.png");
		this.bouton = new JButton("Pipette", icon);	
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
	public void mouseClicked(MouseEvent e) {
	    // code à exécuter lorsqu'on clique sur la souris
		Robot robot;
		try {
			robot = new Robot();
			// Récupérer la couleur du pixel sous la souris
			this.color = robot.getPixelColor(e.getPoint().x, e.getPoint().y);
			System.out.println(this.color);
		} catch (AWTException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}	
	}
	
	@Override
	public void actionPerformed(ActionEvent e) {
		testFenetre.pointeur.setColor(this.color);
		System.out.println("ça marche!");
		
	}
	
	

}