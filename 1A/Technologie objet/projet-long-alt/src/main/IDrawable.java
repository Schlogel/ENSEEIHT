package main;
import java.awt.*;

/** Classe
 * 
 * @author AB-4
 *
 */
public interface IDrawable {
    
    public void draw(Graphics g);
    
    public void drawAuto(Graphics g, Color specialColor, int posX, int posY);

    public Rectangle getRectangle();
    
    public void setPos(Point new_pos);

    public void setcolor(Color c);
    
    public Color getcolor();
}