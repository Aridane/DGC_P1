int iniX, iniY, dragX, dragY;
Cube cube;
ArrayList cubes = new ArrayList();
ArrayList figures = new ArrayList();

float k = 400;

int nButtons = 4;
float [][] buttons = new float[nButtons][2];
boolean [] buttonsPressed = new boolean[nButtons];
String [] buttonsText = {
  "Cubo", "Fig", "RotX", "Rev"
};
float buttonWidth = 60;
float buttonHeight = 20;


float iniPressedX;
float iniPressedY;

float prevDragX;
float prevDragY;


void setup() {
  frame.setResizable(true);
  size(1024, 768);
  stroke(0);
  background(128, 128, 128);

  loop();
  Cube cube = null;

  for (int i=0;i<nButtons;i++) {
    buttons[i][0] = width - 100;
    buttons[i][1] = 100 + i*buttonHeight + i*20;
  }
}


void draw() {
  background(128, 128, 128);

  int i = 0, j;
  for (i=0;i<nButtons;i++) {

    if (buttonsPressed[i]) fill(160, 160, 160);
    else fill(90, 90, 90);     
    buttons[i][0] = width - 100;
    buttons[i][1] = 100 + i*buttonHeight + i*20;

    rect(buttons[i][0], buttons[i][1], buttonWidth, buttonHeight);

    fill(0);

    text(buttonsText[i], buttons[i][0]+15, buttons[i][1]+15, -1);
  }   

  stroke(255, 0, 0);
  line(width/2, height/2, (width/2)+60, height/2);
  line(width/2, height/2, width/2, height/2-60);
  stroke(0);
  if (cube != null) cube.draw(k);
  for (i = cubes.size()-1;i>=0;i--) {
    Cube cube = (Cube)cubes.get(i);
    cube.draw(k);
  }
  for (i = figures.size()-1;i>=0;i--) {
    Figure figure = (Figure)figures.get(i);
    figure.draw(k);
  }
  //println("x = " + mouseX + " y = " + mouseY);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    for (int i=0;i<nButtons;i++) {
      //Podemos estar pulsando un boton
      if (mouseX > buttons[i][0] && mouseX < buttons[i][0] + buttonWidth &&
        mouseY > buttons[i][1] && mouseY < buttons[i][1] + buttonHeight)
      { 
        buttonsPressed[i] = buttonsPressed[i] ^ true;
        iniPressedX = mouseX;
        iniPressedY = mouseY;
        if (buttonsPressed[i]) fill(160, 160, 160);
        else fill(90, 90, 90);
        rect(buttons[i][0], buttons[i][1], buttonWidth, buttonHeight);
        fill(0);
        println("Button " + i + " pressed");
        return;
      }
    }
    for (int i=0;i<nButtons;i++) {
      //Estar haciendo click IZQUIERDO con el boton activado
      if (buttonsPressed[i]) {
        iniPressedX = mouseX;
        iniPressedY = mouseY;
        switch(i) {
          //Boton de crear Cubo
        case 0:
          println("CREAR CUBO PRESSED 2");
          break;
          //Boton de crear Figura
        case 1:
          if (figures.size() == 0) {
            Figure figure = new Figure(buttonsPressed[3]);
            figure.addVertex(mouseX, mouseY, 0);
            figures.add(figure);
          }
          else {
            Figure figure = (Figure)figures.get(figures.size()-1);
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
        }
      }
    }
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
  draw();
}

void mouseDragged() {
  dragX = mouseX;
  dragY = mouseY;
  for (int i=0;i<nButtons;i++) {
    //Estar haciendo click con el boton activado
    if (buttonsPressed[i]) {
      switch(i) {
        //Boton de crear Cubo
      case 0:
        PVector v0 = new PVector(iniPressedX, iniPressedY, 0);
        PVector v2 = new PVector(dragX, dragY, 0);
        cube = new Cube(v0, v2);
        break;
        //Boton de crear Figura
      case 1:

        break;
        //Boton de rotar en X
      case 2:
        if (cube != null) cube.rotateX((prevDragY-dragY)*0.02, iniPressedX, iniPressedY);
        Figure figure = (Figure)figures.get(figures.size()-1);
        //println("X = " + (int)(prevDragX-dragX) + " Y = " + (int)(prevDragY-dragY));
        figure.translate(-prevDragX+dragX, -prevDragY+dragY, 0);
        //figure.rotateX((prevDragY-dragY)*0.02, iniPressedX,iniPressedY);
        //figure.translate(iniPressedX,iniPressedY,0);
        draw();         
        break;
      }
    }
  }
  prevDragX = mouseX;
  prevDragY = mouseY;  
  draw();
}

