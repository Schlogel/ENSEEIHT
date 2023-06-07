package main;

/** Classe qui effectue le ctrl+z pour enlever une action.

 * 
 * @author AB-4
 *
 */
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Point;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.Stack;

public class Undoaction implements KeyListener {
    private Memory Memory;

    public Undoaction( Memory Memory) {
        this.Memory = Memory;
    }

    @Override
	//traitement à effectuer après qu'on clique sur ctrlz
    public void keyPressed(KeyEvent e) {
        if (e.isControlDown() && e.getKeyCode() == KeyEvent.VK_Z) {
        	if(!Memory.empty()) {
				//prendre la dernière action pour la redessiner separemment
        		Action act=Memory.pop();
        		repaint(Memory,act);
			}
        }
    }

    @Override
    public void keyReleased(KeyEvent e) {}

    @Override
    public void keyTyped(KeyEvent e) {}

	//méthode pour effectuer la logique de retour en arrière
    public void repaint(Memory memory, Action action) {
    	IDrawable forme1 = action.getform();
    	Color c=forme1.getcolor();
    	forme1.setcolor(Color.white);
		Stack<Point> points1= action.getpoints();
		Stack<Graphics> graphics1= action.getgraphics();
		//redessiner la dernière action en utilisant la couleur d'arrière plan
		for(int i=0; i<points1.size();i++ ) {
			forme1.setPos(points1.get(i));
			forme1.draw(graphics1.get(i));

		}
		//redessiner les anciennes actions
		forme1.setcolor(c);
    	for(Action act:memory) {
    		IDrawable forme = act.getform();
    		Stack<Point> points= act.getpoints();
    		Stack<Graphics> graphics= act.getgraphics();
    		for(int i=0; i<points.size();i++ ) {
    			forme.setPos(points.get(i));
    			forme.draw(graphics.get(i));

    		}
    	}
    
    }
}
