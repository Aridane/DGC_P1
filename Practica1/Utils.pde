
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

void myLine(float [] v0, float [] v1, int n) {

    float aux0X = v0[0], aux0Y = v0[1], aux1X = v1[0], aux1Y = v1[1];
    aux0X= aux0X-width/2.;
    aux0Y= aux0Y-height/2.;
    aux1X= aux1X-width/2.;
    aux1Y= aux1Y-height/2.;

    aux0X= aux0X/(1.-(v0[2]/k));
    aux0Y= aux0Y/(1.-(v0[2]/k));
    aux1X= aux1X/(1.-(v1[2]/k));
    aux1Y= aux1Y/(1.-(v1[2]/k));
    
    aux0X= aux0X+width/2.;
    aux0Y= aux0Y+height/2.;
    aux1X= aux1X+width/2.;
    aux1Y= aux1Y+height/2.;
    if (n == 1 )println("PINTO " +aux0X+" "+ aux0Y+" "+ aux1X+" "+ aux1Y);
    line(aux0X, aux0Y, aux1X, aux1Y);
    //if (n == 3) line(v0[0], v0[1], v0[2], v1[0], v1[1], v1[2]);
}

