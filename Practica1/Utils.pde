
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

void arrayCopyFtD(float [] from,double [] to, int n){
  for (int i=0;i<n;i++) to[i] = from[i];
}

double [] prodVect(double [] u, double [] v) {
  double [] res = new double[3];
  res[0] = u[1]*v[2] - (v[1]*u[2]);
  res[1] = -(u[0]*v[2] - (v[0]*u[2]));
  res[2] = u[0]*v[1] - (v[0]*u[1]);
  return res;
}

double prodEsc(double [] u, double [] v) {
  double res;
  res = u[0]*v[0]+u[1]*v[1]+u[2]*v[2];
  return res;
}

double [] sub(double [] u, double [] v){
  double [] res = new double[3];
  res[0] = u[0] - v[0];
  res[1] = u[1] - v[1];
  res[2] = u[2] - v[2];
  return res;
}

double [] add(double [] u, double [] v){
  double [] res = new double[3];
  res[0] = u[0] + v[0];
  res[1] = u[1] + v[1];
  res[2] = u[2] + v[2];
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
      double [] p0 = {width/2.,height/2.,viewerZ};
      double [] inc = {i-p0[0],j-p0[1],-viewerZ};
      double [] p = new double[3];
      double T = MAX_FLOAT;
      double t;
      Figure figure;
      int nearestObject = -1;
      for (int k = 0;k<figures.size();k++) {
        //Para cada figura...
        //Calcular las intersección/es y almacenarla si es más cercana al observador
        figure = (Figure)figures.get(k);               
        //Obtenemos a, b y c (triangles -> a = [0], b = [1], c = [2])
        double [] a = new double[3];
        double [] b = new double[3];
        double [] c = new double[3];
        
        double [] plane = new double[4];//[0]x+[1]y+[2]z+[3] = 0
        //Para cada triangulo comprobamos donde cae el punto, comparamos con
        // la T anterior y nos quedamos con la menor T, y el polígono al que pertenece
        for (int l=0;l<figure.triangles();l++){
          //Interseccion
          arrayCopyFtD(figure.tVerteces[figure.triangles[l][0]],a,3);
          arrayCopyFtD(figure.tVerteces[figure.triangles[l][1]],b,3);
          arrayCopyFtD(figure.tVerteces[figure.triangles[l][2]],c,3);

          //Calculamos el plano
          double [] vBA = sub(a,b);
          double [] vBC = sub(c,b);
          vBC = prodVect(vBA,vBC);
          plane[0] = vBC[0];//figure.tNormals[l][0]-figure.tTriangleCentroids[l][0];//
          plane[1] = vBC[1];//figure.tNormals[l][1]-figure.tTriangleCentroids[l][1];//
          plane[2] = vBC[2];//figure.tNormals[l][2]-figure.tTriangleCentroids[l][2];//
          plane[3] = -plane[0]*a[0]-
                        plane[1]*a[1]-
                          plane[2]*a[2];
                          
          /*double sA,sB,sC;
          sA = plane[0]*a[0]+plane[1]*a[1]+plane[2]*a[2]+plane[3];
          sB = plane[0]*b[0]+plane[1]*b[1]+plane[2]*b[2]+plane[3];
          sC = plane[0]*c[0]+plane[1]*c[1]+plane[2]*c[2]+plane[3];
          
          if((sA !=0)||(sB!=0)||(sC!=0)){
            println("ERROR " + sA+" "+sB+" "+sC);
            println("PLANO A = "+plane[0] +"; B = "+plane[1] + "; C = " + plane[2] + "; D = "+ plane[3]);
            println("Punto a aX = "+a[0]+"; aY = "+a[1]+"; aZ = "+a[2]+";");
            println("Punto b bX = "+b[0]+"; bY = "+b[1]+"; bZ = "+b[2]+";");
            println("Punto c cX = "+c[0]+"; cY = "+c[1]+"; cZ = "+c[2]+";");
            return;
          }*/
          /*println("PLANO A = "+plane[0] +"; B = "+plane[1] + "; C = " + plane[2] + "; D = "+ plane[3]);
          println("Punto a aX = "+a.x+"; aY = "+a.y+"; aZ = "+a.z+";");
          println("Punto b bX = "+b.x+"; bY = "+b.y+"; bZ = "+b.z+";");
          println("Punto c cX = "+c.x+"; cY = "+c.y+"; cZ = "+c.z+";");*/
          //Calculamos la interseccion entre recta y plano
          t = -((plane[0]*p0[0]+plane[1]*p0[1]+plane[2]*p0[2]+plane[3])/(plane[0]*inc[0]+plane[1]*inc[1]+plane[2]*inc[2]));
          //Tenemos el punto de intersección (p = p0 + T*inc)
          p[0] = p0[0] + inc[0]*t;
          p[1] = p0[1] + inc[1]*t;
          p[2] = p0[2] + inc[2]*t;

          //println("Punto p pX = "+p.x+";pY  = "+p.y+";pZ  = "+p.z+";");


          double [] auxR1;
          double [] auxR2;
          double [] auxR3;
          double [] auxN;
          //auxR1 = (b-a)x(p-a)
          auxR1 = prodVect(sub(b,a),sub(p,a));
          //auxR2 = (c-b)x(p-b)
          auxR2 = prodVect(sub(c,b),sub(p,b));
          //auxR3 = (a-c)x(p-c)
          auxR3 = prodVect(sub(a,c),sub(p,c));
          //Copiamos la normal para hacer el producto escalar
          //vBC contenía la normal
          double r1,r2,r3;
          r1 = prodEsc(vBC,auxR1);
          r2 = prodEsc(vBC,auxR2);
          r3 = prodEsc(vBC,auxR3);

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
        //println("PIXEL " + i + " " + j);

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
