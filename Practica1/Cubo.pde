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

class cube {
  //vertex [] vertexes = new vertex[8];
  PVector [] vertexes = new PVector[8];

  cube(PVector v0, PVector v2) {
    int i = 0;
    vertexes[0] = v0.get();
    //vertexes[2] = v2.get();

    float base = abs(v0.x-v2.x);
    //float heigth = abs(v0.x-v2.x)

    //vertexes[1] = vertexes[0].get();
    vertexes[1] = new PVector(vertexes[0].x + base, vertexes[0].y, 0);
    //vertexes[1].x = vertexes[0].x + base;
    //vertexes[1].y = vertexes[0].y;
    //vertexes[1].z = 0;
    vertexes[2] = new PVector(vertexes[0].x + base, vertexes[0].y + base, 0);
    
    vertexes[3] = new PVector(vertexes[0].x, vertexes[0].y + base, 0);
    /*vertexes[3].x = vertexes[0].x;
     vertexes[3].y = vertexes[0].y + base;
     vertexes[3].z = 0;*/

    for (i=4;i<8;i++) {
      vertexes[i] = vertexes[i-4].get();
      vertexes[i].z = base;
    }
    for (i=0;i<8;i++) {
      println(i+" x= "+vertexes[i].x+" y= "+vertexes[i].y +" z= "+vertexes[i].z);
    }
  }

  void setVertexes(PVector [] v) {
    int i = 0;
    for (i=0;i<8;i++) {
      //vertexes[i].setAll(v[0], v[1], v[2]);
      vertexes[i].set(v[i].x, v[i].y, v[i].z);
    }
  }

  void draw() {
    int i = 0;
    for (i=0;i<4;i++) {
      line(vertexes[i].x, vertexes[i].y, vertexes[(i+1)%4].x, vertexes[(i+1)%4].y);
      //rect(vertexes[i+4].x, vertexes[i+4].y, vertexes[((i+1)%4)+4].x, vertexes[((i+1)%4)+4].y);
      //rect(vertexes[i].x, vertexes[i].y, vertexes[i+4].x, vertexes[i+4].y);
    }
  }
}







