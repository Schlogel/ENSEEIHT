package main;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import javax.swing.AbstractAction;

/** Classe sur la forme de trait basé sur des rectangles
 * 
 * @author AB-4
 *
 */
public class ActionFormeRectangle extends AbstractAction {
	
	public ActionFormeRectangle() {
		super("Rectangle");
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		testFenetre.pointeur.setForme(new RectangleDrawable(testFenetre.pointeur.getColor(),new Dimension(testFenetre.pointeur.getTaille(),testFenetre.pointeur.getTaille()))); // pas optimal

	}

}
