/* Represents an integer point we want to draw special attention to
 *
 */
class Point {
  Coordinate<Float, Float> c;
  Plot p;
  int[] fill;
  boolean animate;
  boolean display;

  public Point(Plot p, Coordinate<Float, Float> c, int[] fill, boolean animate) {
    this.p = p;
    this.c = c;
    this.fill = fill;
    this.animate = animate;
    this.display = true;
  }
  
  public Point(Plot p, Coordinate<Float, Float> c, int[] fill, boolean animate, boolean display) {
    this.p = p;
    this.c = c;
    this.fill = fill;
    this.animate = animate;
    this.display = display;
  }
  
  public void setFill(int[] fill) {
    this.fill = fill;
  }
  
  public void setVisible(boolean visible) {
    this.display = visible;
  }
  
  public Coordinate<Float, Float> getCoordinate() {
   return this.c; 
  }
  
  public void display() {
    if (display) {
      Coordinate<Float, Float> cConverted = p.convertToScreen(c);
      if (animate) {
        c.update();
        
        int ageSubtractor = 2 * c.getAge();
        stroke(fill[0] - ageSubtractor, fill[1] - ageSubtractor, fill[2] - ageSubtractor);
        noFill();
        circle(cConverted.getX(), cConverted.getY(), c.getAge());
      }
      stroke(fill[0], fill[1], fill[2]);
      fill(fill[0], fill[1], fill[2]);
      circle(cConverted.getX(), cConverted.getY(), 15);
    }
  }
  
  public String toString() {
    return c.toString();
  }
}
