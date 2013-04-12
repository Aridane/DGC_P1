
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

void arrayCopyFtD(float [] from, double [] to, int n) {
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

double [] sub(double [] u, double [] v) {
  double [] res = new double[3];
  res[0] = u[0] - v[0];
  res[1] = u[1] - v[1];
  res[2] = u[2] - v[2];
  return res;
}

double [] add(double [] u, double [] v) {
  double [] res = new double[3];
  res[0] = u[0] + v[0];
  res[1] = u[1] + v[1];
  res[2] = u[2] + v[2];
  return res;
}

double module(double [] u) {
  return (double)sqrt((float)(u[0]*u[0] + u[1]*u[1] + u[2]*u[2]));
}

double det(double [][] mat) {
  return (mat[0][0]*mat[1][1]*mat[2][2] +
    mat[0][1]*mat[1][2]*mat[2][0] +
    mat[0][2]*mat[1][0]*mat[2][1] -
    mat[2][0]*mat[1][1]*mat[0][2] -
    mat[2][1]*mat[1][2]*mat[0][0] -
    mat[2][2]*mat[1][0]*mat[0][1]);
}

void myLine(float [] v0, float [] v1, boolean p) {
  float aux0X = v0[0], aux0Y = v0[1], aux1X = v1[0], aux1Y = v1[1];
  line(aux0X, aux0Y, aux1X, aux1Y);
}

void rayTracing(ArrayList figures, float viewerZ, boolean [] options) {

  Figure checkerFigure = (Figure)figures.get(0);   
  float xMinLimit = checkerFigure.limitMinX;
  float yMinLimit = checkerFigure.limitMinY;
  float xMaxLimit = checkerFigure.limitMaxX;
  float yMaxLimit = checkerFigure.limitMaxY;
  for (int counter = 1;counter<figures.size();counter++) {
    checkerFigure = (Figure)figures.get(counter);
    if ((checkerFigure.limitMinX < xMinLimit)&&(checkerFigure.limitMinX > 0)) xMinLimit = checkerFigure.limitMinX;
    if ((checkerFigure.limitMinY < yMinLimit)&&(checkerFigure.limitMinY > 0)) yMinLimit = checkerFigure.limitMinY;
    if ((checkerFigure.limitMaxX > xMaxLimit)&&(checkerFigure.limitMaxX < width)) xMaxLimit = checkerFigure.limitMaxX;
    if ((checkerFigure.limitMaxY > yMaxLimit)&&(checkerFigure.limitMaxY < height)) xMaxLimit = checkerFigure.limitMaxY;

  }

  for (float i=xMinLimit;i<xMaxLimit;i++) {
    if (i > width) continue;
    for (float j=yMinLimit;j<yMaxLimit;j++) {
      if (j > height) continue;
      //Para cada pixel X = i, Y = j;
      //Determinar el rayo que va desde el observador
      //p = p0 +t*(x1-x0)
      double [] p0 = new double[3];
      double [] inc = new double[3];
      double [] triangleNormal = new double[3];
      double [] triangleCentroid = new double[3];
      if (!options[8]) {
        //println("SIN PERSPECTIVA");
        p0[0] = i;
        p0[1] = j;
        p0[2] = viewerZ;
      }
      else {
        //println("CON PERSPECTIVA");
        p0[0] = width/2.;
        p0[1] = height/2.;
        p0[2] = viewerZ;
      }
      inc[0] = (double)i-p0[0];
      inc[1] = (double)j-p0[1];
      inc[2] = 0-p0[2];
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
        for (int l=0;l<figure.triangles();l++) {
          //Interseccion
          arrayCopyFtD(figure.tVerteces[figure.triangles[l][0]], a, 3);
          arrayCopyFtD(figure.tVerteces[figure.triangles[l][1]], b, 3);
          arrayCopyFtD(figure.tVerteces[figure.triangles[l][2]], c, 3);
          //Test de Áreas
          double [] vBA = sub(a, b);
          double [] vBC = sub(c, b);
          vBC = prodVect(vBC, vBA);
          if (options[13]) {
            double la, lb, lc, s, perim, alfa, beta, gamma, A, Aa, Ab, Ac;
            double [] vCA = sub(a, c);
           // double [] vBA = sub(a, b);
            //double [] vBC = sub(c, b);
            la = module(vBA);
            lb = module(vBC);
            lc = module(vCA);
            perim = la + lb + lc;
            //Área del triángulo exterior
            s = perim/2.;
            A = (double)sqrt((float)(s*(s-la)*(s-lb)*(s-lc)));
            //Ahora calculamos el área de los triángulos interiores y el test
            
            //TODO EL PROBLEMA ESTÁ EN EL TEST DE INCLUSION QUE GENERA LA T
            
            
            double [][] matA = {
              {
                b[0]-a[0], c[0]-a[0], inc[0]
              }
              , {
                b[1]-a[1], c[1]-a[1], inc[1]
              }
              , {
                b[2]-a[2], c[2]-a[2], inc[2]
              }
            };
            double [][] matBeta = {
              {
                p0[0]-a[0], c[0]-a[0], inc[0]
              }
              , {
                p0[1]-a[1], c[1]-a[1], inc[1]
              }
              , {
                p0[2]-a[2], c[2]-a[2], inc[2]
              }
            };
            double [][] matGamma = {
              {
                b[0]-a[0], p0[0]-a[0], inc[0]
              }
              , {
                b[1]-a[1], p0[1]-a[1], inc[1]
              }
              , {
                b[2]-a[2], p0[2]-a[2], inc[2]
              }
            };
            double [][] matT = {
              {
                b[0]-a[0], c[0]-a[0], p0[0]-a[0]
              }
              , {
                b[1]-a[1], c[1]-a[1], p0[1]-a[1]
              }
              , {
                b[2]-a[2], c[2]-a[2], p0[2]-a[2]
              }
            };

            beta = det(matBeta)/det(matA);
            gamma = det(matGamma)/det(matA);
            t = det(matT)/det(matA);

            if (((gamma+beta)<1) && (gamma>0) && (beta>0)) {
              if (t<T) {
                T = t;
                nearestObject = k;
                triangleNormal[0] = figure.tNormals[l][0];//vBC[0];
                triangleNormal[1] = figure.tNormals[l][1];//vBC[1];
                triangleNormal[2] = figure.tNormals[l][2];//vBC[2];
                triangleCentroid[0] = figure.tTriangleCentroids[l][0];
                triangleCentroid[1] = figure.tTriangleCentroids[l][1];
                triangleCentroid[2] = figure.tTriangleCentroids[l][2];
                alfa = 1. - beta - gamma;
                Aa = alfa * A;
                Ab = beta * A;
                Ac = gamma * A;
              }
            }

            //Tenemos el punto de intersección (p = p0 + T*inc)
           // p[0] = p0[0] + inc[0]*t;
           // p[1] = p0[1] + inc[1]*t;
           // p[2] = p0[2] + inc[2]*t;
          }
          //Test de producto vectorial
          else {
            //Calculamos el plano

            plane[0] = vBC[0];//figure.tNormals[l][0]-figure.tTriangleCentroids[l][0];//
            plane[1] = vBC[1];//figure.tNormals[l][1]-figure.tTriangleCentroids[l][1];//
            plane[2] = vBC[2];//figure.tNormals[l][2]-figure.tTriangleCentroids[l][2];//
            plane[3] = -plane[0]*a[0]-
              plane[1]*a[1]-
              plane[2]*a[2];
            //Calculamos la interseccion entre recta y plano
            t = -((plane[0]*p0[0]+plane[1]*p0[1]+plane[2]*p0[2]+plane[3])/(plane[0]*inc[0]+plane[1]*inc[1]+plane[2]*inc[2]));
            //Tenemos el punto de intersección (p = p0 + T*inc)
            p[0] = p0[0] + inc[0]*t;
            p[1] = p0[1] + inc[1]*t;
            p[2] = p0[2] + inc[2]*t;
            double [] auxR1;
            double [] auxR2;
            double [] auxR3;
            double [] auxN;

            auxR1 = prodVect(sub(b, a), sub(p, a));
            auxR2 = prodVect(sub(c, b), sub(p, b));
            auxR3 = prodVect(sub(a, c), sub(p, c));
            //Copiamos la normal para hacer el producto escalar
            //vBC contenía la normal
            double r1, r2, r3;
            r1 = prodEsc(vBC, auxR1);
            r2 = prodEsc(vBC, auxR2);
            r3 = prodEsc(vBC, auxR3);

            if ((r1 == 0)||(r2 == 0)||(r3 == 0))

            {
              //El punto está dentro
              //Almacenamos la T para este poligono.
              if (t<T) {
                T = t;
                nearestObject = k;
                triangleNormal[0] = vBC[0];
                triangleNormal[1] = vBC[1];
                triangleNormal[2] = vBC[2];
                triangleCentroid[0] = figure.tTriangleCentroids[l][0];
                triangleCentroid[1] = figure.tTriangleCentroids[l][1];
                triangleCentroid[2] = figure.tTriangleCentroids[l][2];
              }
            }
            else if ((r1>0)&&(r2>0)&&(r3>0)) {
              if (t<T) {
                T = t;
                nearestObject = k;
                triangleNormal[0] = vBC[0];
                triangleNormal[1] = vBC[1];
                triangleNormal[2] = vBC[2];
                triangleCentroid[0] = figure.tTriangleCentroids[l][0];
                triangleCentroid[1] = figure.tTriangleCentroids[l][1];
                triangleCentroid[2] = figure.tTriangleCentroids[l][2];
              }
            }
            else if ((r1<0)&&(r2<0)&&(r3<0)) {
              if (t<T) {
                T = t;
                nearestObject = k;
                triangleNormal[0] = vBC[0];
                triangleNormal[1] = vBC[1];
                triangleNormal[2] = vBC[2];
                triangleCentroid[0] = figure.tTriangleCentroids[l][0];
                triangleCentroid[1] = figure.tTriangleCentroids[l][1];
                triangleCentroid[2] = figure.tTriangleCentroids[l][2];
              }
            }
          }
        }
      }
      if (nearestObject!=-1)
      {
        //println("PIXEL " + i + " " + j);

        //Pintar el píxel con el color apropiado, es decir, el del objeto más cercano
        figure = (Figure)figures.get(nearestObject);
        stroke(figure.colour[0], figure.colour[1], figure.colour[2]);
        //Iluminación Básica
        if (options[11]) {
          double module = sqrt( (float)(triangleNormal[0] * triangleNormal[0] +  
            triangleNormal[1] * triangleNormal[1] + 
            triangleNormal[2] * triangleNormal[2]));
          triangleNormal[0] = triangleNormal[0]/module;
          triangleNormal[1] = triangleNormal[1]/module;
          triangleNormal[2] = triangleNormal[2]/module;

          normalizedLight[0] = light[0] - triangleCentroid[0];
          normalizedLight[1] = light[1] - triangleCentroid[1];
          normalizedLight[2] = light[2] - triangleCentroid[2];

          module = sqrt((float)(normalizedLight[0] * normalizedLight[0] +  
            normalizedLight[1] * normalizedLight[1] + 
            normalizedLight[2] * normalizedLight[2]));

          normalizedLight[0] = normalizedLight[0]/module;
          normalizedLight[1] = normalizedLight[1]/module;
          normalizedLight[2] = normalizedLight[2]/module;    
          //Producto escalar nL
          double factor = triangleNormal[0]*normalizedLight[0] +
            triangleNormal[1]*normalizedLight[1] +
            triangleNormal[2]*normalizedLight[2];

          if (factor > 1)  factor = 1;
          if (factor < 0.2) factor = 0.2;
          int [] col = new int[3];
          col[0] = (int)(factor*figure.colour[0]+40);
          if (col[0]>255) col[0] = 255;

          col[1] = (int)(factor*figure.colour[1]+40);
          if (col[1]>255) col[1] = 255;

          col[2] = (int)(factor*figure.colour[2]+40);
          if (col[2]>255) col[2] = 255;

          stroke(col[0], col[1], col[2]);
        }
        //Iluminación suavizada
        //else if (options[12] && options[13]) {
        //}
        point(i, j);
      }
      /*else {
       //stroke(128,128,128);
       point(i,j);
       }*/
    }
  }
}

