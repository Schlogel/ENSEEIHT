package main;
import java.awt.*;
import java.util.*;

/** Classe des actions faisable par l'utilisateur.
 * 
 * @author AB-4
 *
 */
public class Action {
	private Stack<Point> points= new Stack<>();
	private Stack<Graphics> graphics= new Stack<>();
	private IDrawable form;
	
	
	public Action(Stack<Point> points, Stack<Graphics> graphics) {
		this.points=points;
		this.graphics= graphics;
	}
	
	public Stack<Point> getpoints(){
		return this.points;
	}
	
	public Stack<Graphics> getgraphics(){
		return this.graphics;
	}
	
	public IDrawable getform() {
		return this.form;
	}
	
	public void setform(IDrawable form) {
		this.form=form;
	}

}
