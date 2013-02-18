/*class vertex {
 int x;
 int y;
 int z;
 
 vertex(int a, int b, int c) {
 x = a;
 y = b;
 z = c;
 }
 
 setX(a) { 
 x = a;
 }
 setY(b) { 
 y = b;
 }
 setZ(c) { 
 z = c;
 }
 
 setAll(int a, int b, int c) {
 setX(a);
 setY(b);
 setZ(c);
 }
 
 int getX() { 
 return x;
 }
 int getY() { 
 return y;
 }
 int getZ() { 
 return z;
 }
 }
 */

class Cube {
  //vertex [] verteces = new vertex[8];
  PVector [] verteces = new PVector[8];
  PVector [] tverteces = new PVector[8];
  
  PVector centroid;

  Cube(PVector v0, PVector v2) {
    int i = 0;
    verteces[0] = v0.get();

    float base = abs(v0.x-v2.x);

    verteces[1] = new PVector(verteces[0].x + base, verteces[0].y, 0);

    verteces[2] = new PVector(verteces[0].x + base, verteces[0].y + base, 0);

    verteces[3] = new PVector(verteces[0].x, verteces[0].y + base, 0);

    for (i=4;i<8;i++) {
      verteces[i] = verteces[i-4].get();
      verteces[i].z = -base;
    }

    for (i=0;i<8;i++) {
      println(i+" x= "+verteces[i].x+" y= "+verteces[i].y +" z= "+verteces[i].z);
    }
    
    float x = 0,y = 0, z = 0;
    
    for (i=0;i<8;i++){
      x = x + verteces[i].x;
      y = y + verteces[i].y;
      z = z + verteces[i].z;
    }
    centroid = new PVector( x/8, y/8, z/8);
    
  }

  void setverteces(PVector [] v) {
    int i = 0;
    for (i=0;i<8;i++) {
      verteces[i].set(v[i].x, v[i].y, v[i].z);
    }
  }

  void draw(float k) {
    int i = 0;
    for (i=0;i<8;i++) {
      tverteces[i] = verteces[i].get();
      tverteces[i].x = tverteces[i].x - width/2;
      tverteces[i].y = tverteces[i].y - height/2;
    }

    for (i=0;i<8;i++) { 
      tverteces[i].x = tverteces[i].x/(1-(tverteces[i].z/k));
      tverteces[i].y = tverteces[i].y/(1-(tverteces[i].z/k));
    }

    for (i=0;i<8;i++) {
      tverteces[i].x = tverteces[i].x + width/2;
      tverteces[i].y = tverteces[i].y + height/2;
    }

    for (i=0;i<4;i++) {
      stroke(0, 255, 0);
      line(tverteces[i+4].x, tverteces[i+4].y, tverteces[((i+1)%4)+4].x, tverteces[((i+1)%4)+4].y);
    }

    for (i=0;i<4;i++) {

      stroke(0, 0, 255);
      line(tverteces[i].x, tverteces[i].y, tverteces[i+4].x, tverteces[i+4].y);
    }

    for (i=0;i<4;i++) {
      stroke(0);
      line(tverteces[i].x, tverteces[i].y, tverteces[(i+1)%4].x, tverteces[(i+1)%4].y);
    }
  }
  /*void translate (float x, float y, float z) {
    
  }*/
  void rotateX(float angle, float iniRotX, float iniRotY){
    float[][] Rx = {  {1, 0, 0, 0},
                     {0, cos(angle), sin(angle), 0},
                     {0, -sin(angle), cos(angle), 0},
                     {0, 0, 0, 1}  };
    //Traslación
    for (int i=0;i<8;i++) {
      //verteces[i] = verteces[i].get();
      verteces[i].x = verteces[i].x - iniRotX;//- width/2;
      verteces[i].y = verteces[i].y - iniRotY;//- height/2;
    }
    float [][] aux = new float[8][4];
    
    for(int i=0;i<8;i++){
      aux[i][0] = verteces[i].x;
      aux[i][1] = verteces[i].y;
      aux[i][2] = verteces[i].z;
      aux[i][3] = 1;
    }
    
    aux = multiplyMatrix(aux,Rx,8,4,4);
    
    for(int i=0;i<8;i++){
      verteces[i].x = aux[i][0];
      verteces[i].y = aux[i][1];
      verteces[i].z = aux[i][2];
    }
    
    for (int i=0;i<8;i++) {

      //verteces[i] = verteces[i].get();
      verteces[i].x = verteces[i].x + iniRotX;//+ width/2;
      verteces[i].y = verteces[i].y + iniRotY;//+ height/2;
    }
                     
    
  }
}






