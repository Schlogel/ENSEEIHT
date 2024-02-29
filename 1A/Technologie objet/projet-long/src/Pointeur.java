import java.awt.event.*;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Point;
import javax.swing.event.MouseInputAdapter;

public class Pointeur extends MouseInputAdapter {

	private JCanvas canvas;
	private Color couleur;
	
	public Pointeur(JCanvas c, Color couleur) {
		super();
		canvas = c;
		canvas.addMouseListener(this);
		canvas.addMouseMotionListener(this);
		this.couleur = couleur;
	}
	
	@Override
	public void mousePressed(MouseEvent e) {
		Point p = e.getPoint();
		IDrawable rect = new RectangleDrawable(this.couleur,p,new Dimension(8,8));
		rect.draw(canvas.getGraphics());
	}
	
	@Override
	public void mouseDragged(MouseEvent e) {
		Point p = e.getPoint();
		IDrawable rect = new RectangleDrawable(this.couleur,p,new Dimension(8,8));
		rect.draw(canvas.getGraphics());
	}

	public void setColor(Color couleur) {
		this.couleur = couleur;
	}
	
	public Color getColor() {
		return couleur;
		
	}
	
}
