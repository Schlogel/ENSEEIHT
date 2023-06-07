package main;

import java.awt.event.FocusEvent;

import java.awt.event.FocusListener;
import javax.swing.JFrame;

/** Classe
 * 
 * @author AB-4
 *
 */
class CustomFocusListener implements FocusListener {
	
	JFrame window;
	
	public CustomFocusListener(JFrame window) {
		this.window=window;
	}
    @Override
    public void focusGained(FocusEvent e) {
        // Request keyboard focus for the window
    }

    @Override
    public void focusLost(FocusEvent e) {
    	this.window.requestFocusInWindow();
    }

}
