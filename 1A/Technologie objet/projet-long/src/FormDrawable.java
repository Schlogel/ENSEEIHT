import java.awt.*;

public abstract class FormDrawable implements IDrawable {

    
    protected Rectangle rect ;
    protected Color color;
    
    public FormDrawable(Color color, Point pos, Dimension dim){
        this.color=color;
        this.rect = new Rectangle(pos,dim);
    }
    
    public abstract void draw(Graphics g) ;
    
    public Rectangle getRectangle(){
        return (Rectangle) rect.clone();
    }
    
}