import java.util.TreeSet;
import java.util.Iterator;

class Plot {
  ArrayList<Coordinate> axisCoordinates;
  TreeSet<Coordinate> cs;
  float resolution = 1;
  
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
  ArrayList<Coordinate> labels;
  
  int originX;
  int originY;
  
  int cachedOriginX;
  int cachedOriginY;
  int cachedScale;
  boolean newImportant;
  
  public Plot(Quadratic q, int scale) {
    this.plotFrames  = 0;
    this.plotRate = 5;
    this.axisCoordinates = new ArrayList<Coordinate>();
    this.cs = new TreeSet<Coordinate>();
    
    this.scale = scale;
    
    this.yAxisLength = height * 3 / 4;
    this.xAxisLength = width * 3 / 4;
    this.labelLength = scale;
    this.labels = new ArrayList<Coordinate>();
    
    this.q = q;
  }
  
  public void setLocation(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public void zoom(int add) {
    if (this.scale + add > 20) this.scale += add;
  }
  
  public Coordinate convertToScreen(Coordinate c) {
    return new Coordinate(originX + c.getX() * scale, originY - c.getY() * scale);
  }
  
  public void addLabel(float x, float y) {
    Coordinate newLabel = new Coordinate(x, y);
    newLabel.update();
    boolean makeLabel = true;
    for (Coordinate label: labels) {
      if (abs(label.getX() - newLabel.getX()) < E && abs(label.getY() - newLabel.getY()) < E) makeLabel = false;
    }
    if (makeLabel) {
      labels.add(newLabel);
    }
  }
  
  public void displayLabel(Coordinate label) {
    Coordinate labelConverted = convertToScreen(label);
    label.update();
    labelLength = scale;
    textSize(scale / 2);
    textAlign(CENTER);
    stroke(2 * label.getAge());
    fill(label.getAge(), (3 / 4) * label.getAge(), (1 / 2) * label.getAge());
    if (label.getX() < E) {
      // we are on the y-axis
      line(labelConverted.getX() - labelLength / 2, labelConverted.getY(), labelConverted.getX() + labelLength / 2, labelConverted.getY());
      text(floor(label.getY()), labelConverted.getX() - labelLength, labelConverted.getY() + 9);
    }
    else if (label.getY() < E) {
      line(labelConverted.getX(), labelConverted.getY() - labelLength / 2, labelConverted.getX(), labelConverted.getY() + labelLength / 2);
      text(floor(label.getX()), labelConverted.getX(), labelConverted.getY() + labelLength);
    }
  }
  
  public void displayConnections() {
    for (Coordinate c: cs) {
      if (c.isInteger(E) && abs(c.getX()) >= 2 - E) {
        for (Coordinate otherC: cs) {
          if (otherC.isInteger(E)) {
            if (c.getY() * otherC.getY() < 0 && abs(otherC.getX()) >= 2 - E) {
              Coordinate convertedCoordinate = convertToScreen(c);
              Coordinate convertedOtherCoordinate = convertToScreen(otherC);
              stroke(c.getAge() / 4);
              line(convertedOtherCoordinate.getX(), convertedOtherCoordinate.getY(), convertedCoordinate.getX(), convertedCoordinate.getY());
            }
          }
        }
      }
    }
  }
  
  public void relateIntegers() {
    newImportant = false;
    for (Coordinate c: cs) {
      if (c.isInteger(E)) {
        for (Coordinate otherC: cs) {
          if (otherC.isInteger(E)) {
            if (c.getY() * otherC.getY() < 0) {
              int[] pointColor = new int[3];
              // MUST SWITCH TO SORTED/CACHED SYSTEM
              for (Coordinate axisC: axisCoordinates) {
                if (axisC.isImportant() && abs(axisC.getY()) < E) axisC.update();
                if (axisC.isInteger(E) && !axisC.isImportant() && abs(axisC.getX()) >= 2 - E && abs(axisC.getY()) < E) {
                  int pointX = Math.round(axisC.getX());
                  if (pointX == abs(Math.round(otherC.getY() * c.getY()))) {
                    pointColor[0] = 64;
                    pointColor[1] = 128;
                    pointColor[2] = 255;
                    axisC.setImportant(true);
                    axisC.setAnimate(true);
                    newImportant = true;
                    axisC.setFill(pointColor);
                  }
                  else if (cs.last().getY() > pointX / 2) {
                    pointColor[0] = 64;
                    pointColor[1] = 255;
                    pointColor[2] = 128;
                    axisC.setImportant(true);
                    axisC.setAnimate(true);
                    newImportant = true;
                    axisC.setFill(pointColor);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  
  public void displayGraph() {
    Iterator<Coordinate> csi = cs.descendingIterator();
    if (cachedOriginX != originX || cachedOriginY != originY || newImportant || cachedScale != scale) {
      background(0);
      displayConnections();
      if (!cs.isEmpty()) { 
        Coordinate previous = cs.last();
        while (csi.hasNext()) {
          Coordinate next = csi.next();
          Coordinate nextConverted = convertToScreen(next);
          Coordinate previousConverted = convertToScreen(previous);
          
          next.update();
          
          stroke(2 * next.getAge());
          line(previousConverted.getX(), previousConverted.getY(), nextConverted.getX(), nextConverted.getY());
          
          //draw axes
          Coordinate convertedOrigin = convertToScreen(new Coordinate(0f, 0f));
          line(previousConverted.getX(), convertedOrigin.getY(), nextConverted.getX(), convertedOrigin.getY());
          line(convertedOrigin.getX(), previousConverted.getY(), convertedOrigin.getX(), nextConverted.getY());
          
          previous = next;
        }
      }
    }
    else {
      if (!cs.isEmpty()) { 
        Coordinate previous = cs.last();
        Coordinate next = cs.first();
        while (csi.hasNext()) {
          previous = next;
          next = csi.next();
          next.update();
        }
        Coordinate nextConverted = convertToScreen(next);
        Coordinate previousConverted = convertToScreen(previous);
        stroke(2 * next.getAge());
        line(previousConverted.getX(), previousConverted.getY(), nextConverted.getX(), nextConverted.getY());
        
        //workaround for now (only the last thing in the set gets drawn)
        Coordinate oppositeNext = new Coordinate(next.getX(), -next.getY());
        Coordinate oppositePrevious = new Coordinate(previous.getX(), -previous.getY());
        Coordinate oppositeNextConverted = convertToScreen(oppositeNext);
        Coordinate oppositePreviousConverted = convertToScreen(oppositePrevious);
        line(oppositePreviousConverted.getX(), oppositePreviousConverted.getY(), oppositeNextConverted.getX(), oppositeNextConverted.getY());
        
        //draw axes
        Coordinate convertedOrigin = convertToScreen(new Coordinate(0f, 0f));
        line(previousConverted.getX(), convertedOrigin.getY(), nextConverted.getX(), convertedOrigin.getY());
        line(convertedOrigin.getX(), previousConverted.getY(), convertedOrigin.getX(), nextConverted.getY());
        line(convertedOrigin.getX(),  oppositePreviousConverted.getY(), convertedOrigin.getX(), oppositeNextConverted.getY());
      }
    }
    cachedOriginX = originX;
    cachedOriginY = originY;
    cachedScale = scale;
  }
  
  public void addNextValues() {
    Coordinate lastAxisCoordinate;
    if (axisCoordinates.isEmpty()) {
      axisCoordinates.add(new Coordinate(0f, 0f));
      lastAxisCoordinate = axisCoordinates.get(axisCoordinates.size() - 1);
    }
    else {
      lastAxisCoordinate = axisCoordinates.get(axisCoordinates.size() - 1);
      Coordinate newAxisCoordinate = new Coordinate(lastAxisCoordinate.getX() + resolution, 0f);
      axisCoordinates.add(newAxisCoordinate);
    }
    
    for (Float f: q.evaluate(lastAxisCoordinate.getX())) {
      Coordinate c;
      float newX = lastAxisCoordinate.getX();
      float newY = f;
      c = new Coordinate(newX, newY);
      cs.add(c);
      
      if (abs(c.getX() - floor(c.getX())) < E) {
        addLabel(c.getX(), 0f);
      }
      
      if (abs(c.getY() - floor(c.getY())) < E) {
        addLabel(0f, c.getY());
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

    stroke(255);
    
    fill(0);
    
    displayGraph();
    
    relateIntegers();
    
    for (Coordinate label: labels) {
      displayLabel(label);
    }
    
    for (Coordinate c: cs) {
      c.display(this);
    }
    
    for (Coordinate c: axisCoordinates) {
      c.display(this);
    }
    
  }
}
