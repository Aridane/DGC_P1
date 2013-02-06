int iniX, iniY, dragX, dragY;
cube cube;
float k = 800;
float rotateXIniX;
float rotateXIniY;
float rotateXWidth = 60;
float rotateXHeight = 20;
float iniRotX;
float iniRotY;
boolean rotateXPressed = false;

void setup(){
  frame.setResizable(true);
  size(1024,768);
   

  stroke(0);
  strokeWeight(3);
  background(128,128,128);
  
  loop();
  cube cube = null;
  rotateXIniX = width - 100;
  rotateXIniY = 100;
}


void draw(){
   background(128,128,128);
   if (rotateXPressed) fill(160,160,160);
   else fill(90,90,90);
   rect(rotateXIniX,rotateXIniY,rotateXWidth,rotateXHeight);
   fill(0);
   text("RotX",rotateXIniX+15, rotateXIniY+15,-1);
   
   stroke(255,0,0);
   line(width/2, height/2, (width/2)+60, height/2);
   line(width/2, height/2, width/2, height/2-60);
   stroke(0);
   if(cube != null) cube.draw(k);
}

void mousePressed() {
  if (mouseX > rotateXIniX && mouseX < rotateXIniX + rotateXWidth &&
     mouseY > rotateXIniY && mouseY < rotateXIniY + rotateXHeight)
  { 
    rotateXPressed = rotateXPressed ^ true;
    iniRotX = mouseX;
    iniRotY = mouseY;
    if (rotateXPressed) fill(160,160,160);
    else fill(90,90,90);
    rect(rotateXIniX,rotateXIniY,rotateXWidth,rotateXHeight);
    fill(0);
    
    
    println("Mouse pressing rotateX button");
    fill(0);
  }
  else if (rotateXPressed){
    iniX = mouseX;
    iniY = mouseY;
    iniRotX = mouseX;
    iniRotY = mouseY;
  }
  else
  {    
    
    iniX = mouseX;
    iniY = mouseY;
    cube = null;
    draw();
  }
}

void mouseReleased() {
  if (!rotateXPressed &&  !(mouseX > rotateXIniX && mouseX < rotateXIniX + rotateXWidth &&
     mouseY > rotateXIniY && mouseY < rotateXIniY + rotateXHeight)){
       
    PVector v0 = new PVector(iniX, iniY, 0);
    PVector v2 = new PVector(dragX, dragY, 0);
    cube = new cube(v0, v2);
    draw();
  }
  
}

void mouseDragged() {
  dragX = mouseX;
  dragY = mouseY;
  if (rotateXPressed){
    if (cube != null) cube.rotateX((iniY-dragY)/100., iniRotX, iniRotY);
    
    draw();
    iniX = dragX;
    iniY = dragY;
  }
  else {
    PVector v0 = new PVector(iniX, iniY, 0);
    PVector v2 = new PVector(dragX, dragY, 0);
    
    cube = new cube(v0, v2);
    
    draw();
    
    //stroke(255,0,0);
    //line(width/2, height/2, (width/2)+60, height/2);
    //line(width/2, height/2, width/2, height/2-60);
    //stroke(0);
    
    cube.draw(k);
  }

}

