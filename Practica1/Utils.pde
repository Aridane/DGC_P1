
float [][] multiplyMatrix(float v[][], float R[][], int n1, int  m1, int m2) {
  // v x R
  float [][] M = new float[n1][m2];
  for (int i=0;i<n1;i++) {
    for (int j=0;j<m2;j++) {
      for (int k=0;k<m1;k++) {
        M[i][j] += v[i][k] * R[k][j];
      }
    }
  }
  return M;
}

double [] prodVect(double [] u, double [] v) {
  double [] res = new double[3];
  res[0] = u[1]*v[2] - (v[1]*u[2]);
  res[1] = -(u[0]*v[2] - (v[0]*u[2]));
  res[2] = u[0]*v[1] - (v[0]*u[1]);
  return res;
}

void myLine(float [] v0, float [] v1, boolean p) {

    float aux0X = v0[0], aux0Y = v0[1], aux1X = v1[0], aux1Y = v1[1];
    line(aux0X, aux0Y, aux1X, aux1Y);
}

void rayTracing(ArrayList figures, float viewerZ){
  for (int i=0;i<width;i++) {
    for (int j=0;j<height;j++){
    //Para cada pixel X = i, Y = j;
    //Determinar el rayo que va desde el observador
    //p = p0 +t*(x1-x0)
      PVector p0 = new PVector(width/2.,height/2.,viewerZ);
      PVector inc = new PVector(i-p0.x,j-p0.y,-k);
      PVector p;
      float T = MAX_FLOAT;
      float t;
      Figure figure;
      int nearestObject = -1;
      for (int k = 0;k<figures.size();k++) {
        //Para cada figura...
        //Calcular las intersección/es y almacenarla si es más cercana al observador
        figure = (Figure)figures.get(k);               
        //Obtenemos a, b y c (triangles -> a = [0], b = [1], c = [2])
        PVector a = new PVector(0,0,0);
        PVector b = new PVector(0,0,0);
        PVector c = new PVector(0,0,0);
        
        float [] plane = new float[4];//[0]x+[1]y+[2]z+[3] = 0
        //Para cada triangulo comprobamos donde cae el punto, comparamos con
        // la T anterior y nos quedamos con la menor T, y el polígono al que pertenece
        for (int l=0;l<figure.triangles();l++){
          //Interseccion
          a.set(figure.tVerteces[figure.triangles[l][0]]);
          b.set(figure.tVerteces[figure.triangles[l][1]]);
          c.set(figure.tVerteces[figure.triangles[l][2]]);
          //Calculamos el plano
          PVector vBA = new PVector(0,0,0);
          PVector vBC = new PVector(0,0,0);
          vBA = PVector.sub(a,b);
          vBC = PVector.sub(c,b);
          vBC = vBA.cross(vBC);
          plane[0] = vBC.x;
          plane[1] = vBC.y;
          plane[2] = vBC.z;
          plane[3] = -plane[0]*c.x-
                        plane[1]*c.y-
                          plane[2]*c.z;
                          
          /*float sA,sB,sC;
          sA = plane[0]*a.x+plane[1]*a.y+plane[2]*a.z+plane[3];
          sB = plane[0]*b.x+plane[1]*b.y+plane[2]*b.z+plane[3];
          sC = plane[0]*c.x+plane[1]*c.y+plane[2]*c.z+plane[3];
          */
          /*if((sA !=0)||(sB!=0)||(sC!=0)){
            println("ERROR " + sA+" "+sB+" "+sC);
            println("PLANO A = "+plane[0] +"; B = "+plane[1] + "; C = " + plane[2] + "; D = "+ plane[3]);
            println("Punto a aX = "+a.x+"; aY = "+a.y+"; aZ = "+a.z+";");
            println("Punto b bX = "+b.x+"; bY = "+b.y+"; bZ = "+b.z+";");
            println("Punto c cX = "+c.x+"; cY = "+c.y+"; cZ = "+c.z+";");
            return;
          }*/
          /*println("PLANO A = "+plane[0] +"; B = "+plane[1] + "; C = " + plane[2] + "; D = "+ plane[3]);
          println("Punto a aX = "+a.x+"; aY = "+a.y+"; aZ = "+a.z+";");
          println("Punto b bX = "+b.x+"; bY = "+b.y+"; bZ = "+b.z+";");
          println("Punto c cX = "+c.x+"; cY = "+c.y+"; cZ = "+c.z+";");*/
          //Calculamos la interseccion entre recta y plano
          t = -((plane[0]*p0.x+plane[1]*p0.y+plane[2]*p0.z+plane[3])/(plane[0]*inc.x+plane[1]*inc.y+plane[2]*inc.z));
          //Tenemos el punto de intersección (p = p0 + T*inc)
          p = inc.get();
          p.mult(t);
          p.add(p0);
          //println("Punto p pX = "+p.x+";pY  = "+p.y+";pZ  = "+p.z+";");

          PVector aux1 = new PVector(0,0,0);
          PVector aux2 = new PVector(0,0,0);
          PVector auxR1 = new PVector(0,0,0);
          PVector auxR2 = new PVector(0,0,0);
          PVector auxR3 = new PVector(0,0,0);
          PVector auxN = new PVector(0,0,0);

          //auxR1 = (b-a)x(p-a)
          aux1 = b.get();
          aux1.sub(a);
          aux2 = p.get();
          aux2.sub(a);
          auxR1 = aux1.get();
          auxR1 = auxR1.cross(aux2);
          //auxR2 = (c-b)x(p-b)
          aux1 = c.get();
          aux1.sub(b);
          aux2 = p.get();
          aux2.sub(b);
          auxR2 = aux1.get();
          auxR2 = auxR2.cross(aux2);
          //auxR3 = (a-c)x(p-c)
          aux1 = a.get();
          aux1.sub(c);
          aux2 = p.get();
          aux2.sub(c);
          auxR3 = aux1.get();
          auxR3 = auxR3.cross(aux2);
          //Copiamos la normal para hacer el producto escalar
          auxN.set(figure.tNormals[l]);
          float r1,r2,r3;
          r1 = auxN.dot(auxR1);
          r2 = auxN.dot(auxR2);
          r3 = auxN.dot(auxR3);

          if ((r1 == 0)||(r2 == 0)||(r3 == 0))
                
          {
            //El punto está dentro
            //Almacenamos la T para este poligono.
            if(t<T){
              T = t;
              nearestObject = k;
            /*  r1 = plane[0]*a.x+plane[1]*a.y+plane[2]*a.z+plane[3];
              r2 = plane[0]*b.x+plane[1]*b.y+plane[2]*b.z+plane[3];
              r3 = plane[0]*c.x+plane[1]*c.y+plane[2]*c.z+plane[3];
              float r4 = plane[0]*p.x+plane[1]*p.y+plane[2]*p.z+plane[3];
              println("1----r1 "+r1+" r2 "+r2+" r3 "+r3 + " " +r4 + " " +k + " " + (float)(plane[0]*figure.triangleCentroids[l][0]+plane[1]*figure.triangleCentroids[l][1]+plane[2]*figure.triangleCentroids[l][2]+plane[3])); //<>//
              */
            }
          }
          else if ((r1>0)&&(r2>0)&&(r3>0)) {
            if(t<T){
              T = t;
              nearestObject = k;
              /*r1 = plane[0]*a.x+plane[1]*a.y+plane[2]*a.z+plane[3];
              r2 = plane[0]*b.x+plane[1]*b.y+plane[2]*b.z+plane[3];
              r3 = plane[0]*c.x+plane[1]*c.y+plane[2]*c.z+plane[3];
             float r4 = plane[0]*p.x+plane[1]*p.y+plane[2]*p.z+plane[3];
               println("1----r1 "+r1+" r2 "+r2+" r3 "+r3 + " " +r4 + " " +k + " " + (float)(plane[0]*figure.triangleCentroids[l][0]+plane[1]*figure.triangleCentroids[l][1]+plane[2]*figure.triangleCentroids[l][2]+plane[3])); //<>//
            */}
          }
          else if ((r1<0)&&(r2<0)&&(r3<0)){
            if(t<T){
              T = t;
              nearestObject = k;
              /*r1 = plane[0]*a.x+plane[1]*a.y+plane[2]*a.z+plane[3];
              r2 = plane[0]*b.x+plane[1]*b.y+plane[2]*b.z+plane[3];
              r3 = plane[0]*c.x+plane[1]*c.y+plane[2]*c.z+plane[3];
              float r4 = plane[0]*p.x+plane[1]*p.y+plane[2]*p.z+plane[3];
              println("1----r1 "+r1+" r2 "+r2+" r3 "+r3 + " " +r4 + " " +k + " " + (float)(plane[0]*figure.triangleCentroids[l][0]+plane[1]*figure.triangleCentroids[l][1]+plane[2]*figure.triangleCentroids[l][2]+plane[3])); //<>//
           */
            }
          }
        }
      }
      if(nearestObject!=-1)
      {
        println("PIXEL " + i + " " + j);

        //Pintar el píxel con el color apropiado, es decir, el del objeto más cercano
        figure = (Figure)figures.get(nearestObject);
        stroke(figure.colour[0],figure.colour[1],figure.colour[2]);
        point(i,j);
      }
      /*else {
        //stroke(128,128,128);
        point(i,j);
      }*/
    }
  } 
}
