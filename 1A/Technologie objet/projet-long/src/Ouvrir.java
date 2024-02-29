import java.io.File;
import java.io.IOException;
import java.awt.Desktop;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.SwingConstants;
import javax.swing.event.MouseInputAdapter;

public class Ouvrir extends MouseInputAdapter implements ToolButton, ActionListener  {

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
	public Ouvrir() {
		this.icon = new ImageIcon("/home/mathieu/eclipse-workspace/Projet_Long/pl/icones/open.png");
		this.bouton = new JButton("Ouvrir", icon);	
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
		String source = JOptionPane.showInputDialog(null, "Entrez le chemin d'accès au fichier :");
	    // Exemple : /home/mathieu/eclipse-workspace/Projet_Long/test.png
		// Pour spécifier le chemin d'accès au fichier que nous voulons ouvrir
	    File file = new File(source);
	    // Pour ouvrir le fichier avec l'application par défaut selon son type de fichier
	    Desktop desktop = Desktop.getDesktop();
	    try {
	      desktop.open(file);
	    // IOException sera levée si le fichier n'existe pas ou si l'application par défaut ne peut l'ouvrir
	    } catch (IOException g) {
	      g.printStackTrace();
	    }
		
	}
	
	

}