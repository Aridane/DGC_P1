class Figure {
  //vertex [] verteces = new vertex[8];
  float [][] verteces = new float[10000][];
  float [][] tVerteces = new float[10000][];

  float [][] tMatrix = {
    {
      1, 0, 0, 0
    }
    , {
      0, 1, 0, 0
    }
    , {
      0, 0, 1, 0
    }
    , {
      0, 0, 0, 1
    }
  };

  PVector centroid;

  boolean revolution = false;

  int nSteps = 10;

  boolean closed = false;

  int nVerteces = 0;

  Figure(boolean revolutionFlag) {
    revolution = revolutionFlag;
    
  }

  boolean closed() {
    return closed;
  }

  void setVertex(int n, float x, float y, float z) {
    verteces[n][0] = x;
    verteces[n][1] = y;
    verteces[n][2] = z; 
    verteces[n][3] = 1;
  }

  void setverteces(float [][] v) {
    int i = 0;
    for (i=0;i<nVerteces;i++) {
      verteces[i][0] = v[i][0];
      verteces[i][1] = v[i][1];
      verteces[i][2] = v[i][2]; 
      verteces[i][3] = 1;
    }
  }

  void addVertex(float x, float y, float z) {
    verteces[nVerteces] = new float[4];
    verteces[nVerteces][0] = x;
    verteces[nVerteces][1] = y;
    verteces[nVerteces][2] = z;
    verteces[nVerteces][3] = 1;

    tVerteces[nVerteces] = new float[4];
    tVerteces[nVerteces][0] = x;
    tVerteces[nVerteces][1] = y;
    tVerteces[nVerteces][2] = z;
    tVerteces[nVerteces][3] = 1;

    nVerteces = nVerteces + 1;
  }

  void closeFigure() {
    closed = true;
    float x = 0, y = 0, z = 0;
    if (!revolution) {
      for (int i=0;i<nVerteces;i++) {
        x = x + tVerteces[i][0];
        y = y + tVerteces[i][1];
        z = z + tVerteces[i][2];
      }
    }
    else {
      float angle = 360;
      x = tVerteces[0][0];
      y = tVerteces[0][1];
      z = tVerteces[0][2];
      for (int i=1; i<nSteps;i++) {
        for (int k=0;k<nVerteces;k++) {
          verteces[k][0] = verteces[k][0] - width/2;
          verteces[k][1] = verteces[k][1] - height/2;
        }

        rotateY(((TWO_PI)/nSteps), 0, 0);       

        for (int k=0;k<nVerteces;k++) {
          verteces[k][0] = verteces[k][0] + width/2;
          verteces[k][1] = verteces[k][1] + height/2;
          tVerteces[k][0] = tVerteces[k][0] + width/2;
          tVerteces[k][1] = tVerteces[k][1] + height/2;
        }


        for (int j=0;j<nVerteces;j++) {
          println(" i = " + i + " nVerteces = " + nVerteces);
          verteces[i*nVerteces+j] = new float[4];

          verteces[i*nVerteces+j][0] = tVerteces[j][0];
          verteces[i*nVerteces+j][1] = tVerteces[j][1];
          verteces[i*nVerteces+j][2] = tVerteces[j][2];
          verteces[i*nVerteces+j][3] = tVerteces[j][3];
          x = x + tVerteces[j][0];
          y = y + tVerteces[j][1];
          z = z + tVerteces[j][2];
        }
      }
      nVerteces = nVerteces * nSteps;
      println(" nVerteces = " + nVerteces);
      tVerteces = new float[nVerteces][4];
      for (int i=0;i<nVerteces;i++) {
        tVerteces[i][0] = verteces[i][0];
        tVerteces[i][1] = verteces[i][1];
        tVerteces[i][2] = verteces[i][2];
        tVerteces[i][3] = verteces[i][3];
      }
    }
    for(int i=0;i<4;i++)
      for (int j=0;j<4;j++){
        if (i == j) tMatrix[i][j] = 1;
        else tMatrix[i][j] = 0;
      }
    centroid = new PVector(x/nVerteces, y/nVerteces, z/nVerteces);
  }

  //TODO Crear funcion miLinea, la cual aparte de dibujar la línea aplica la perspectiva.
  void draw(float k) {
    int i = 0;
    float z = 0, a = 0;
    if (!closed)for (i=0;i<nVerteces-1;i++) myLine(tVerteces[i], tVerteces[(i+1)], 2);
    
    if (closed && !revolution) {
      myLine(tVerteces[nVerteces-1], tVerteces[0], 2);
      for (i=0;i<nVerteces-1;i++) myLine(tVerteces[i], tVerteces[(i+1)], 2);
    }
    if (closed && revolution) {
      for (i=0;i<(nVerteces/nSteps);i++) {
        for (int j=0;j<nSteps;j++) {
          myLine(tVerteces[(j*(nVerteces/nSteps))+i], tVerteces[((j+1)%nSteps)*(nVerteces/nSteps)+i],2);  
          if (i < ((nVerteces/nSteps)-1))myLine(tVerteces[i+j*(nVerteces/nSteps)], tVerteces[i+j*(nVerteces/nSteps)+1], 2);
        }
      }
    }
  }

  void translate (float x, float y, float z) {
    //Traslación 
    float [][] T = {
      {
        1, 0, 0, 0
      }
      , 
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 0, 1, 0
      }
      , 
      {
        x, y, z, 1
      }
    };

    tMatrix = multiplyMatrix(T,tMatrix, 4, 4, 4);
    tVerteces = multiplyMatrix(verteces, tMatrix, nVerteces, 4, 4);

  }

  void rotateX(float angle, float iniRotX, float iniRotY) {
    float[][] Rx = {  
      {
        1, 0, 0, 0
      }
      , 
      {
        0, cos(angle), sin(angle), 0
      }
      , 
      {
        0, -sin(angle), cos(angle), 0
      }
      , 
      {
        0, 0, 0, 1
      }
    };
    println("================================================");
                for (int j=0;j<nVerteces;j++) {
          println(" i = " + j + " --- " + verteces[j][0] + " " + verteces[j][1] + " " + verteces[j][2] + " " + verteces[j][3]);
        }
    for (int k=0;k<nVerteces;k++) {
      verteces[k][0] = verteces[k][0] - iniRotX;
      verteces[k][1] = verteces[k][1] - iniRotY;
      verteces[k][2] = verteces[k][2];
      verteces[k][3] = verteces[k][3];
      
    }
                for (int j=0;j<nVerteces;j++) {
          println(" i = " + j + " --- " + verteces[j][0] + " " + verteces[j][1] + " " + verteces[j][2] + " " + verteces[j][3]);
        }
    tMatrix = multiplyMatrix(Rx,tMatrix, 4, 4, 4);
    tVerteces = multiplyMatrix(verteces, tMatrix, nVerteces, 4, 4);

    for (int k=0;k<nVerteces;k++) {
      verteces[k][0] = verteces[k][0] + iniRotX;
      verteces[k][1] = verteces[k][1] + iniRotY;
      tVerteces[k][0] = tVerteces[k][0] + iniRotX;
      tVerteces[k][1] = tVerteces[k][1] + iniRotY;
    }
                for (int j=0;j<nVerteces;j++) {
          println(" i = " + j + " --- " + verteces[j][0] + " " + verteces[j][1] + " " + verteces[j][2] + " " + verteces[j][3]);
        }
            println("================================================");
  }

  void rotateY(float angle, float iniRotX, float iniRotY) {
    float[][] Ry = {  
      {
        cos(angle), 0, -sin(angle), 0
      }
      , 
      {
        0, 1, 0, 0
      }
      , 
      {
        sin(angle), 0, cos(angle), 0
      }
      , 
      {
        0, 0, 0, 1
      }
    };
   /* for (int k=0;k<nVerteces;k++) {
      verteces[k][0] = verteces[k][0] - iniRotX;
      verteces[k][1] = verteces[k][1] - iniRotY;
    }*/
    
    tMatrix = multiplyMatrix(Ry,tMatrix, 4, 4, 4);
    tVerteces = multiplyMatrix(verteces, tMatrix, nVerteces, 4, 4);
    /*    for (int k=0;k<nVerteces;k++) {
      verteces[k][0] = verteces[k][0] + iniRotX;
      verteces[k][1] = verteces[k][1] + iniRotY;
      tVerteces[k][0] = tVerteces[k][0] + iniRotX;
      tVerteces[k][1] = tVerteces[k][1] + iniRotY;
    }*/
            for (int j=0;j<nVerteces;j++) {
          println(" i = " + j + " --- " + tVerteces[j][0] + " " + tVerteces[j][1] + " " + tVerteces[j][2] + " " + tVerteces[j][3]);
        }
  }
}
