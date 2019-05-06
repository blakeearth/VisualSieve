import java.util.TreeSet;
import java.util.Iterator;

class Plot {
  ArrayList<Point> vps;
  ArrayList<Point> ops;
  ArrayList<Float> xs;
  TreeSet<Coordinate<Float, Float>> cs;
  float resolution = 0.5;
  
  Quadratic q;
  
  int x;
  int y;
  final float E = 0.0000001;
  
  int plotFrames;
  int plotRate; // every plotRate frames, we will get a new x in xs
  
  int xAxisLength;
  int yAxisLength;
  int scale;
  int labelLength;
  ArrayList<Coordinate<Float, Float>> labels;
  
  int originX;
  int originY;
  
  public Plot(Quadratic q, int scale) {
    this.plotFrames  = 0;
    this.plotRate = 5;
    this.xs = new ArrayList<Float>();
    this.cs = new TreeSet<Coordinate<Float, Float>>();
    this.vps = new ArrayList<Point>();
    this.ops = new ArrayList<Point>();
    
    this.scale = scale;
    
    this.yAxisLength = height * 3 / 4;
    this.xAxisLength = width * 3 / 4;
    this.labelLength = 32;
    this.labels = new ArrayList<Coordinate<Float, Float>>();
    
    this.q = q;
  }
  
  public void setLocation(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public void zoom(int add) {
    if (this.scale + add > 20) this.scale += add;
  }
  
  public Coordinate<Float, Float> convertToScreen(Coordinate c) {
    return new Coordinate<Float, Float>(originX + (float)c.getX() * scale, originY + (float)c.getY() * scale);
  }
  
  public void addLabel(float x, float y) {
    Coordinate newLabel = new Coordinate<Float, Float>(x, y);
    newLabel.update();
    boolean makeLabel = true;
    for (Coordinate label: labels) {
      if (abs((float)label.getX() - (float)newLabel.getX()) < E && abs((float)label.getY() - (float)newLabel.getY()) < E) makeLabel = false;
    }
    if (makeLabel) {
      labels.add(newLabel);
    }
  }
  
  public void displayLabel(Coordinate label) {
    Coordinate labelConverted = convertToScreen(label);
    label.update();
    textSize(18);
    textAlign(CENTER);
    stroke(2 * label.getAge());
    fill(2 * label.getAge());
    if ((float)label.getX() < E) {
      // we are on the y-axis
      line((float)labelConverted.getX() - labelLength / 2, (float)labelConverted.getY(), (float)labelConverted.getX() + labelLength / 2, (float)labelConverted.getY());
      text(floor((float)label.getY()), (float)labelConverted.getX() - labelLength, (float)labelConverted.getY() + 9);
    }
    else if ((float)label.getY() < E) {
      line((float)labelConverted.getX(), (float)labelConverted.getY() - labelLength / 2, (float)labelConverted.getX(), (float)labelConverted.getY() + labelLength / 2);
      text(floor((float)label.getX()), (float)labelConverted.getX(), (float)labelConverted.getY() + labelLength);
    }
  }
  
  public void connectPoints() {
    for (Point p: vps) {
      for (Point otherP: vps) {
        if (p.getCoordinate().getY() * otherP.getCoordinate().getY() < 0) {
          // draw connections between every point on other branch
          Coordinate<Float, Float> convertedPCoordinate = convertToScreen(p.getCoordinate());
          Coordinate<Float, Float> convertedOtherPCoordinate = convertToScreen(otherP.getCoordinate());
          stroke(p.getCoordinate().getAge());
          line((float)convertedOtherPCoordinate.getX(), (float)convertedOtherPCoordinate.getY(), (float)convertedPCoordinate.getX(), (float)convertedPCoordinate.getY());
          
          int[] pointColor = new int[3];
          // MUST SWITCH TO SORTED SYSTEM
          for (Point anotherP: ops) {
            int pointX = Math.round((float)anotherP.getCoordinate().getX());
            if (pointX == abs(Math.round((float)otherP.getCoordinate().getY() * (float)p.getCoordinate().getY()))) {
              pointColor[0] = 64;
              pointColor[1] = 128;
              pointColor[2] = 255;
              anotherP.setFill(pointColor);
              anotherP.setVisible(true);
            }
            else if (cs.last().getY() > pointX / 2) {
              pointColor[0] = 64;
              pointColor[1] = 255;
              pointColor[2] = 128;
              anotherP.setFill(pointColor);
              anotherP.setVisible(true);
            }
          }
        }
      }
    }
  }
  
  public void addNextValues() {
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
      
      if (abs((float)c.getX() - floor((float)c.getX())) < E && abs((float)c.getY() - floor((float)c.getY())) < E && abs((float)c.getY()) >= 2 - E) {
        // this is a non-one or zero whole number point on the parabola
        addLabel((float)c.getX(), 0f);
        addLabel(0f, (float)c.getY());
        
        int[] pointColor = new int[3];
        pointColor[0] = 255;
        pointColor[1] = 255;
        pointColor[2] = 255;
        Point newVP = new Point(this, c, pointColor, true);
        vps.add(newVP);
      }
      if (abs((float)c.getX() - floor((float)c.getX())) < E) {
        int[] pointColor = new int[3];
        pointColor[0] = 255;
        pointColor[1] = 255;
        pointColor[2] = 255;
        Coordinate<Float, Float> coordinateToTest = new Coordinate<Float, Float>((float)c.getX(), 0f);
        Point newOP = new Point(this, coordinateToTest, pointColor, true, false);
        ops.add(newOP);
        addLabel((float)c.getX(), 0f);
      }
      else if (abs((float)c.getY() - floor((float)c.getY())) < E) {
        addLabel(0f, (float)c.getY());
      }
    }
  }
  
  public void display() {
    plotFrames++;
    originX = x + width / 4;
    originY = y + height / 2;
    
    if (plotFrames % plotRate == 0) {
      addNextValues();
    }
    
    for (Coordinate label: labels) {
      displayLabel(label);
    }
    
    for (Point p: vps) {
      p.display();
    }
    
    for (Point p: ops) {
      p.display();
    }
    
    connectPoints();
    
    stroke(255);
    
    fill(0);
    Iterator<Coordinate<Float, Float>> csi = cs.descendingIterator();
    
    if (!cs.isEmpty()) { 
      Coordinate<Float, Float> previous = cs.last();
      while (csi.hasNext()) {
        Coordinate<Float, Float> next = csi.next();
        next.update();
        Coordinate<Float, Float> nextConverted = convertToScreen(next);
        Coordinate<Float, Float> previousConverted = convertToScreen(previous);
        stroke(2 * next.getAge());
        line(previousConverted.getX(), previousConverted.getY(), nextConverted.getX(), nextConverted.getY());
        
        //draw axes
        Coordinate<Float, Float> convertedOrigin = convertToScreen(new Coordinate<Float, Float>(0f, 0f));
        line(previousConverted.getX(), convertedOrigin.getY(), nextConverted.getX(), convertedOrigin.getY());
        line(convertedOrigin.getX(), previousConverted.getY(), convertedOrigin.getX(), nextConverted.getY());
        
        previous = next;
      }
    }
  }
}
