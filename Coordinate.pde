class Coordinate implements Comparable<Coordinate> {
  Float x;
  Float y;
  
  boolean important;
  boolean animate;
  int[] fill;
  int animationBuffer;
  
  int age;
  
  public Coordinate(Float x, Float y) {
    this.x = x;
    this.y = y;
    this.age = 0;
    this.important = false;
    this.animate = false;
    this.fill = new int[3];
  }
  
  public Coordinate(Float x, Float y, boolean important, boolean animate) {
    this.x = x;
    this.y = y;
    this.age = 0;
    this.important = important;
    this.animate = animate;
    this.fill = new int[3];
  }
  
  public void setImportant(boolean important) {
    this.important = important;
  }
  
  public boolean isImportant() {
    return this.important;
  }
  
  public void setAnimate(boolean animate) {
    this.animate = animate;
    this.animationBuffer = age;
  }
  
  public int compareTo(Coordinate other) {
    return compareTo(other, true);
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  public boolean isInteger(float E) {
    return (abs(x - floor(x)) < E && abs(y - floor(y)) < E);
  }
  
  public void update() {
    if (age <= 126) age++;
  }
  
  public int getAge() {
    return age;
  }
  
  public int compareTo(Coordinate other, boolean sortByFloat) {
    if (sortByFloat) {
      return y.compareTo(other.getY());
    }
    else {
      return x.compareTo(other.getY());
    }
  }
  
  public void setFill(int[] fill) {
    this.fill = fill;
  }
  
  public void display(Plot p) {
    if (important) {
      Coordinate cConverted = p.convertToScreen(this);
      if (animate) {
        stroke(fill[0], fill[1], fill[2]);
        fill(fill[0], fill[1], fill[2]);
        circle(cConverted.getX(), cConverted.getY(), 15 * (age - animationBuffer) / 126);
      }
      else {
        stroke(fill[0], fill[1], fill[2]);
        fill(fill[0], fill[1], fill[2]);
        circle(cConverted.getX(), cConverted.getY(), 15);
      }
    }
  }
  
  public String toString() {
    return "(" + x + ", " + y + ")";
  }
  
}
