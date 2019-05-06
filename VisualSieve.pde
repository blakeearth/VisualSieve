int focusX;
int focusY;
Plot p;

public void setup() {
  fullScreen();
  cursor(HAND);
  focusX = 0;
  focusY = 0;
  InverseParabola parabola = new InverseParabola();
  p = new Plot(parabola, 30);
  frameRate(60);
}

public void draw() {
  
  p.setLocation(focusX, focusY);
  
  background(0);
  p.display();
  
  
  // thoughts: zooming and/or panning?
  
  // draw axes
  
  // draw all known (yet) points
}

public void mouseDragged() {
  cursor(MOVE);
  focusX += (mouseX - pmouseX);
  focusY += (mouseY - pmouseY);
}

public void mouseReleased() {
  cursor(HAND);
}
