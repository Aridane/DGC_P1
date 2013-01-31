int iniX, iniY, dragX, dragY;
cube cube;
void setup(){
  size(1240,768);
  background(255,255,255);
  loop();
  cube cube = null;
}

void draw(){
   if(cube != null) cube.draw();
}

void mousePressed() {
  iniX = mouseX;
  iniY = mouseY;
  cube = null;

}

void mouseReleased() {
  PVector v0 = new PVector(iniX, iniY, 0);
  PVector v2 = new PVector(dragX, dragY, 0);
  background(255,255,255);
  cube = new cube(v0, v2);
  
}

void mouseDragged() {
  dragX = mouseX;
  dragY = mouseY;
  PVector v0 = new PVector(iniX, iniY, 0);
  PVector v2 = new PVector(dragX, dragY, 0);
  cube = new cube(v0, v2);
  background(255,255,255);
  cube.draw();
}

