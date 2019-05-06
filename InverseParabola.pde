/* Represents a parabola x = y^2 (returns two outputs)
 *
 */
 
import java.lang.Math;
 
class InverseParabola extends Quadratic {
  
  public InverseParabola() {
  }
  
  public ArrayList<Float> evaluate(float x) {
    ArrayList<Float> ys = new ArrayList<Float>();
    float posY = (float)Math.sqrt(x);
    float negY = -posY;
    ys.add(posY);
    ys.add(negY);
    
    return ys;
  }
}
