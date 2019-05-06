import java.util.TreeSet;
import java.util.Iterator;

class Plot {
  ArrayList<Point> valuePoints;
  ArrayList<Point> otherPoints;
  ArrayList<Float> xs;
  TreeSet<Coordinate<Float, Float>> cs;
  float resolution = 0.5;
  
  Quadratic q;
  
  int x;
  int y;
  
  int plotFrames;
  int plotRate; // every plotRate frames, we will get a new x in xs
  
  int xAxisLength;
  int yAxisLength;
  int scale;
  
  int originX;
  int originY;
  
  public Plot(Quadratic q, int scale) {
    this.yAxisLength = height * 3 / 4;
    this.plotFrames  = 0;
    this.plotRate = 5;
    this.xs = new ArrayList<Float>();
    this.cs = new TreeSet<Coordinate<Float, Float>>();
    
    this.scale = scale;
    
    this.yAxisLength = height * 3 / 4;
    this.xAxisLength = width * 3 / 4;
    
    this.q = q;
  }
  
  public void setLocation(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public Coordinate<Float, Float> convertToScreen(Coordinate c) {
    return new Coordinate<Float, Float>(originX + (float)c.getX() * scale, originY + (float)c.getY() * scale);
  }
  
  public void display() {
    plotFrames++;
    originX = x + width / 4;
    originY = y + height / 2;
    
    if (plotFrames % plotRate == 0) {
      if (xs.isEmpty()) {
        xs.add(0f);
      }
      else xs.add(xs.get(xs.size() - 1) + resolution);
      
      for (Float f: q.evaluate(xs.get(xs.size() - 1))) {
        Coordinate c;
        float newX = (float)xs.get(xs.size() - 1);
        float newY = f;
        c = new Coordinate<Float, Float>(newX, newY);
        cs.add(c);
        
        if ((float)c.getX() % 1 == 0) {
          println("whole x");
        }
        
      }
    }
    
    stroke(255);
    line(originX, originY - yAxisLength / 2, originX, originY + yAxisLength / 2);
    line(originX, originY, x + xAxisLength, originY);
    
    fill(0);
    Iterator<Coordinate<Float, Float>> csi = cs.descendingIterator();
    
    if (!cs.isEmpty()) { 
      Coordinate<Float, Float> previous = cs.last();
      while (csi.hasNext()) {
        Coordinate<Float, Float> next = csi.next();
        next.setAge(next.getAge() + 1);
        Coordinate<Float, Float> nextConverted = convertToScreen(next);
        Coordinate<Float, Float> previousConverted = convertToScreen(previous);
        println(next);
        stroke(2 * next.getAge());
        line(previousConverted.getX(), previousConverted.getY(), nextConverted.getX(), nextConverted.getY());
        
        previous = next;
      }
    }
  }
}
