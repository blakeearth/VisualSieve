/* Represents an integer point we want to draw special attention to
 *
 */
class Point {
  int x;
  int y;
  color fill;
  
  public Point(int x, int y, color fill) {
    this.x = x;
    this.y = y;
    this.fill = fill;
  }
  
  public void setFill(color fill) {
    this.fill = fill;
  }
  
  public void display() {
    
  }
  
}
