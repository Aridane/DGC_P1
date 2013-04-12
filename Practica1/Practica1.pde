float iniX, iniY, dragX, dragY;
Cube cube;

float [] light = {800,50,500};
double [] normalizedLight = new double[3];

int selectedFigure = -1;

ArrayList figures = new ArrayList();
ArrayList cubes = new ArrayList();

boolean doom = false;

float k = 800;

int nButtons = 14;
float [][] buttons = new float[nButtons][2];
boolean [] buttonsPressed = new boolean[nButtons];
String [] buttonsText = {
  "Cubo", "Fig", "RotX", "Rev", "Tr", "RotY", "Triangles", "Normals", "Persp", "Rayos", "Del", "Iluminación", "Suavizado", "TestAreas"
};
float buttonWidth = 90;
float buttonHeight = 20;


float iniPressedX;
float iniPressedY;

float prevDragX;
float prevDragY;


void setup() {
  frame.setResizable(true);
  size(800, 640);
  stroke(0);
  background(128, 128, 128);
 
  
  loop();
  Cube cube = null;
  for (int i=0;i<(nButtons/2);i++) {
    buttons[i][0] = width - 200;
    buttons[i][1] = 150 + i*buttonHeight + i*20;
  }
  for (int i=nButtons/2;i<nButtons;i++) {
    buttons[i][0] = width - 100;
    buttons[i][1] = 150 + (i-nButtons/2)*buttonHeight + (i-nButtons/2)*20;
  }
}


void draw() {
  background(128, 128, 128);
  int i = 0, j;
  for (i=0;i<nButtons/2;i++) {

    if (buttonsPressed[i]) fill(160, 160, 160);
    else fill(90, 90, 90);     
    buttons[i][0] = width - 200;
    buttons[i][1] = 150 + i*buttonHeight + i*20;

    rect(buttons[i][0], buttons[i][1], buttonWidth, buttonHeight);

    fill(0);

    text(buttonsText[i], buttons[i][0]+15, buttons[i][1]+15, -1);
  }
  for (i=nButtons/2;i<nButtons;i++) {

    if (buttonsPressed[i]) fill(160, 160, 160);
    else fill(90, 90, 90);     
    buttons[i][0] = width - 100;
    buttons[i][1] = 150 + (i-nButtons/2)*buttonHeight + (i-nButtons/2)*20;

    rect(buttons[i][0], buttons[i][1], buttonWidth, buttonHeight);

    fill(0);

    text(buttonsText[i], buttons[i][0]+15, buttons[i][1]+15, -1);
  }  
  rect(light[0],light[1],50,50);
  stroke(255, 0, 0);
  line(width/2, height/2, (width/2)+60, height/2);
  line(width/2, height/2, width/2, height/2-60);
  stroke(0);

  if (figures.size() == 0) return;
  Figure figure;
  if (buttonsPressed[9]) {
    //A Pintar con trazado de rayos
    println("A POR LOS RAYOS");
    for (int l = figures.size()-1;l>=0;l--) {
      figure = (Figure)figures.get(l);
      figure.closed = false;
      figure.translate(0, 0, 0);
      figure.closed = true;
  }
    
    rayTracing(figures, k, buttonsPressed);
    
    if (buttonsPressed[8]) {
      for (int l = figures.size()-1;l>=0;l--) {
        figure = (Figure)figures.get(l);
        figure.applyPerspective(k);
      }
    }
    println("FIN RAYOS");
  }
  if (cube != null) cube.draw(k, buttonsPressed);
  for (i = cubes.size()-1;i>=0;i--) {
    Cube cube = (Cube)cubes.get(i);
    cube.draw(k, buttonsPressed);
  }
  for (i = figures.size()-1;i>=0;i--) {
    figure = (Figure)figures.get(i);
    if (i == selectedFigure) strokeWeight(2);
    figure.draw(k, buttonsPressed /*buttonsPressed[6],buttonsPressed[7],buttonsPressed[8]*/);
    strokeWeight(1);
  }
  stroke (0);

  
  //println("x = " + mouseX + " y = " + mouseY);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    Figure figure;
    for (int i=0;i<nButtons;i++) {
      //Podemos estar pulsando un boton
      if (mouseX > buttons[i][0] && mouseX < buttons[i][0] + buttonWidth &&
        mouseY > buttons[i][1] && mouseY < buttons[i][1] + buttonHeight)
      { 
        buttonsPressed[i] = buttonsPressed[i] ^ true;
        if (buttonsPressed[i]) fill(160, 160, 160);
        else fill(90, 90, 90);
        rect(buttons[i][0], buttons[i][1], buttonWidth, buttonHeight);
        fill(0);
        if ((i==8)&&(buttonsPressed[i])) {
          for (int l = figures.size()-1;l>=0;l--) {
            figure = (Figure)figures.get(l);
            figure.applyPerspective(k);
          }
        }
        else if (i==8) {
          for (int l = figures.size()-1;l>=0;l--) {
            figure = (Figure)figures.get(l);
            figure.translate(0, 0, 0);
          }
        }
        return;
      }
    }
    PVector actualPos = new PVector(mouseX, mouseY);
    float min = MAX_FLOAT;
    selectedFigure = -1;
    for (int i=0;i<figures.size();i++) {
      figure = (Figure)figures.get(i);
      if (figure.closed()) {
        float dist = actualPos.dist(figure.getCentroid());
        if (dist < min) {
          min = dist;
          selectedFigure = i;
        }
      }
    }
    for (int i=0;i<nButtons;i++) {
      //Estar haciendo click IZQUIERDO con el boton activado
      if (buttonsPressed[i]) {
        println("BUTTONPRESSED" + " " + i);
        switch(i) {
          //Boton de crear Cubo
        case 0:
          println("CREAR CUBO PRESSED 2");
          break;
          //Boton de crear Figura
        case 1:
          if (figures.size() == 0) {
            figure = new Figure(buttonsPressed[3]);
            figure.addVertex(mouseX, mouseY, 0);
            figures.add(figure);
          }
          else {
            figure = (Figure)figures.get(figures.size()-1);
            if (figure.closed()) {
              Figure newFigure = new Figure(buttonsPressed[3]);
              newFigure.addVertex(mouseX, mouseY, 0);
              figures.add(newFigure);
            }
            else {
              figure.addVertex(mouseX, mouseY, 0);
            }
          }
          break;
          //Boton de rotar en X
          //Si hacemos click izquierdo con el boton de rotar pulsado, pasamos a elegir que forma está seleccionada.
        case 2:
          prevDragX = mouseX;
          prevDragY = mouseY;

          break;
          //Trasladar
        case 4:
          prevDragX = mouseX;
          prevDragY = mouseY;

          break;
          //Rotar en Y
        case 5:
          prevDragX = mouseX;
          prevDragY = mouseY;
          break;
        case 8:
          println("8 PULSADO");
          break;
        case 10:
          if (selectedFigure!=-1)figures.remove(selectedFigure);
          break;
        }
      }
    }
    iniPressedX = mouseX;
    iniPressedY = mouseY;
  }
  else if (mouseButton == RIGHT) {
    //En caso de click derecho con el boton de figura, procedemos a "cerrar"
    if (buttonsPressed[1]) {
      Figure figure = (Figure)figures.get(figures.size()-1);
      if (!figure.closed()) {
        figure.closeFigure();
      }
    }
  }
}

void mouseReleased() {

  for (int i=0;i<nButtons;i++) {
    if (!(mouseX > buttons[i][0] && mouseX < buttons[i][0] + buttonWidth &&
      mouseY > buttons[i][1] && mouseY < buttons[i][1] + buttonHeight))
    { 
      //Estar haciendo click con el boton activado
      if (buttonsPressed[i]) {
        switch(i) {
          //Boton de crear Cubo
        case 0:
          println("CREAR CUBO RELEASED " + iniPressedX + " " + iniPressedY);
          PVector v0 = new PVector(iniPressedX, iniPressedY, 0);
          PVector v2 = new PVector(dragX, dragY, 0);
          cube = new Cube(v0, v2);
          break;
          //Boton de crear Figura
        case 1:

          break;
          //Boton de rotar en X
        case 2:

          break;
        }
      }
    }
  }  
  //draw();
}

void mouseDragged() {
  dragX = mouseX;
  dragY = mouseY;
  Figure figure;
  //Boton de crear Cubo
  if (buttonsPressed[0]) {
    PVector v0 = new PVector(iniPressedX, iniPressedY, 0);
    PVector v2 = new PVector(dragX, dragY, 0);
    cube = new Cube(v0, v2);
  }
  //Boton de crear Figura

  //Boton de rotar en X
  if (buttonsPressed[2]) {
    if (cube != null) cube.rotateX((prevDragY-dragY)*0.02, iniPressedX, iniPressedY);  
    if (selectedFigure != -1) {
      figure = (Figure)figures.get(selectedFigure);
      figure.rotateX((prevDragY-dragY)*0.02, iniPressedX, iniPressedY); 
      if (buttonsPressed[8]) {
        figure.applyPerspective(k);
      }
    }
  }
  if (buttonsPressed[4]) {
    if (selectedFigure != -1) {
      figure = (Figure)figures.get(selectedFigure);
      figure.translate(-prevDragX+dragX, -prevDragY+dragY, 0);
      if (buttonsPressed[8]) {
        figure.applyPerspective(k);
      }
    }
  }
  if (buttonsPressed[5]) {
    if (cube != null) cube.rotateX((prevDragY-dragY)*0.02, iniPressedX, iniPressedY); 
    if (selectedFigure != -1) {
      figure = (Figure)figures.get(selectedFigure);
      figure.rotateY((prevDragX-dragX)*0.02, iniPressedX, iniPressedY); 
      if (buttonsPressed[8]) {
        figure.applyPerspective(k);
      }
    }
  }

  prevDragX = mouseX;
  prevDragY = mouseY;
}

