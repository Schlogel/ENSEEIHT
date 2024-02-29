import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;

public class BoutonQuitter implements ToolButton, ActionListener {

	private JButton bouton;
	
	public BoutonQuitter() {
		this.bouton = new JButton("Quitter");
		this.bouton.addActionListener(this);
		
	}
	
	@Override
	public void actionPerformed(ActionEvent e) {
		System.exit(0);
		
	}

	@Override
	public String getNom() {
		// TODO Auto-generated method stub
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
		// TODO Auto-generated method stub
		return bouton;
	}

}
