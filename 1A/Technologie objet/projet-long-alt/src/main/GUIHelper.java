package main;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.swing.*;
import javax.swing.JFrame;

/** Classe
 * 
 * @author AB-4
 *
 */
public class GUIHelper {
    
	/**
	 * Créer une fenêtre, lui ajouter un composant et l'afficher
	 * @param component le composant à afficher
	 * @param frameName le titre de la fenêtre
	 */
    public static void showOnFrame(JComponent component, String frameName) {
        JFrame frame = new JFrame(frameName);
        WindowAdapter wa = new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        };
        frame.addWindowListener(wa);
        frame.getContentPane().add(component);
        frame.pack();
        frame.setVisible(true);
    }

}