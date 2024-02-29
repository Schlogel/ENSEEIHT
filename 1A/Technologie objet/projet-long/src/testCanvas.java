import java.awt.*;
import javax.swing.*;

public class testCanvas {
	public static void main(String[] args) {
		JCanvas jc = new JCanvas(1280,720);
		Color couleur = Color.blue;
		new Pointeur(jc,couleur);
		GUIHelper.showOnFrame(jc,"Test : affichage du canvas et dessin simple");
	}
}
