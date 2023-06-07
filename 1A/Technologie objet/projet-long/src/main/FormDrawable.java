package main;
import java.awt.*;

/** Classe généralisant le code en commun pour les cercles et les rectangles
 * 
 * @author AB-4
 *
 */
public abstract class FormDrawable implements IDrawable {

    
    protected Rectangle rect ;
    protected Color color;
    protected Point pos;
    public static boolean drawEnable;
    
    public FormDrawable(Color color, Dimension dim){
    	drawEnable = true;
        this.color=color;
        Point pos = new Point(0,0);
        this.rect = new Rectangle(pos,dim);
    }
    
    public abstract void draw(Graphics g);
    
    public abstract void drawAuto(Graphics g, Color specialColor, int posX, int posY);
    
    public Rectangle getRectangle(){
        return (Rectangle) rect.clone();
    }
    
    public void setPos(Point new_pos) {
    	pos = new_pos;
    	rect = new Rectangle(pos,rect.getSize());
    }

    public void setcolor(Color c){
    	this.color=c;
    }
    
    public Color getcolor() {
    	return this.color;
    }
    
}