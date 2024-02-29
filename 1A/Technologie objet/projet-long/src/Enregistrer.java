import java.awt.AWTException;
// Effectuer automatiquement une capture d'écran
import java.awt.Robot;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;
import java.awt.Rectangle;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.SwingConstants;
import javax.swing.event.MouseInputAdapter;

public class Enregistrer extends MouseInputAdapter implements ToolButton, ActionListener  {

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
	public Enregistrer() {
		this.icon = new ImageIcon("/home/mathieu/eclipse-workspace/Projet_Long/pl/icones/save.png");
		this.bouton = new JButton("Enregistrer", icon);	
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
		try {
		      // Créer une image à partir du contenu du tableau
		      BufferedImage image = new Robot().createScreenCapture(new Rectangle(Toolkit.getDefaultToolkit().getScreenSize()));

		      // Enregistrer l'image dans un fichier PNG
		      String source = JOptionPane.showInputDialog(null, "Veuillez indiquer le nom du fichier :");
		      // Créer le nouveau fichier/image
		      File file = new File(source + ".png");
		      ImageIO.write(image, "png", file);

		      System.out.println("Le dessin a été sauvegardé.");
		    } catch (IOException | AWTException f) {
		      f.printStackTrace();
		    }
		
	}
	
	

}