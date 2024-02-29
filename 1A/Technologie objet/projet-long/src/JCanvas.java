import java.awt.*;

import javax.swing.*;

public class JCanvas extends JPanel {
	private int tailleX;
	private int tailleY;
	static Color couleur = Color.WHITE;
	
	public JCanvas(int x, int y) {
		this.setBackground(couleur);
		tailleX = x;
		tailleY = y;
		this.setPreferredSize(new Dimension(tailleX,tailleY));

	}
	
	public int getLargeur() {
		return this.tailleX;
	}
	
	public int getHauteur() {
		return this.tailleY;
	}

}