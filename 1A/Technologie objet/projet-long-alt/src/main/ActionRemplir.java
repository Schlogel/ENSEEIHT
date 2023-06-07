package main;
import java.awt.event.ActionEvent;

import javax.swing.AbstractAction;
import javax.swing.Icon;

/** Classe correspondant à l'action du bouton remplir
 * 
 * @author AB-4
 *
 */
public class ActionRemplir extends AbstractAction {

	public ActionRemplir() {
		super("Remplir");
	}


	public ActionRemplir(String name, Icon icon) {
		super(name, icon);
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub

	}

}
