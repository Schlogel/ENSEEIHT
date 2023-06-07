package main;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import javax.swing.AbstractAction;

/** Classe sur la forme de trait basé sur des cercles
 * 
 * @author AB-4
 *
 */
public class ActionFormeCercle extends AbstractAction {
	
	public ActionFormeCercle() {
		super("Cercle");
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		testFenetre.pointeur.setForme(new CercleDrawable(testFenetre.pointeur.getColor(),new Dimension(testFenetre.pointeur.getTaille(),testFenetre.pointeur.getTaille()))); // pas optimal

	}

}
