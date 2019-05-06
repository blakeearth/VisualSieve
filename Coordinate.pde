class Coordinate<X extends Comparable<X>, Y extends Comparable<Y>> implements Comparable<Coordinate> {
  X x;
  Y y;
  
  int age;
  
  public Coordinate(X x, Y y) {
    this.x = x;
    this.y = y;
    this.age = 0;
  }
  
  public int compareTo(Coordinate other) {
    return compareTo(other, true);
  }
  
  public X getX() {
    return x;
  }
  
  public Y getY() {
    return y;
  }
  
  public void setAge(int age) {
    if (age <= 127) this.age = age;
  }
  
  public int getAge() {
    return age;
  }
  
  public int compareTo(Coordinate<X, Y> other, boolean sortByY) {
    if (sortByY) {
      return y.compareTo(other.getY());
    }
    else {
      return x.compareTo(other.getX());
    }
  }
  
  public String toString() {
    return "(" + x + ", " + y + ")";
  }
  
}
