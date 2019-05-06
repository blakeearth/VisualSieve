int focusX;
int focusY;
int desiredFrames;
final int mouseWheelZoom = 3;
Plot p;

public void setup() {
  size(1280, 600);
  background(0);
  cursor(HAND);
  focusX = 0;
  focusY = 0;
  InverseParabola parabola = new InverseParabola();
  p = new Plot(parabola, 30);
  desiredFrames = 10;
}

public void draw() {
  frameRate(desiredFrames);
  if (frameCount % 10 == 0) desiredFrames += 1;  
  p.setLocation(focusX, focusY);
  
  p.display();
}

public void mouseDragged() {
  cursor(MOVE);
  focusX += (mouseX - pmouseX);
  focusY += (mouseY - pmouseY);
}

public void mouseReleased() {
  cursor(HAND);
}

public void mouseWheel(MouseEvent event) {
  int add = 0;
  if (event.getCount() < 0) {
    add = mouseWheelZoom;
  }
  else if (event.getCount() > 0) {
    add = -mouseWheelZoom;
  }
  
  p.zoom(add);
}
