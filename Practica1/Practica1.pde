int iniX, iniY, dragX, dragY;
cube cube;
float k = 800;

void setup(){
  frame.setResizable(true);
  size(1024,768);
  stroke(0);
  strokeWeight(3);
  background(128,128,128);
  ellipse(1000,760,10,20);
  
  loop();
  cube cube = null;
}

void draw(){
   stroke(255,0,0);
   line(width/2, height/2, (width/2)+60, height/2);
   line(width/2, height/2, width/2, height/2-60);
   stroke(0);
   if(cube != null) cube.draw(k);
}

void mousePressed() {
  iniX = mouseX;
  iniY = mouseY;
  cube = null;
  background(128,128,128);
  
  stroke(255,0,0);
  line(width/2, height/2, (width/2)+60, height/2);
  line(width/2, height/2, width/2, height/2-60);
  stroke(0);
}

void mouseReleased() {
  PVector v0 = new PVector(iniX, iniY, 0);
  PVector v2 = new PVector(dragX, dragY, 0);
  
  background(128,128,128);
  
  stroke(255,0,0);
  line(width/2, height/2, (width/2)+60, height/2);
  line(width/2, height/2, width/2, height/2-60);
  stroke(0);
  cube = new cube(v0, v2);
  
}

void mouseDragged() {
  dragX = mouseX;
  dragY = mouseY;
  PVector v0 = new PVector(iniX, iniY, 0);
  PVector v2 = new PVector(dragX, dragY, 0);
  
  background(128,128,128);
  
  stroke(255,0,0);
  line(width/2, height/2, (width/2)+60, height/2);
  line(width/2, height/2, width/2, height/2-60);
  stroke(0);
  cube = new cube(v0, v2);
  
  stroke(255,0,0);
  line(width/2, height/2, (width/2)+60, height/2);
  line(width/2, height/2, width/2, height/2-60);
  stroke(0);
  
  cube.draw(k);
}

