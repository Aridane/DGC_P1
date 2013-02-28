class Figure {
  //vertex [] verteces = new vertex[8];
  float [][] verteces = new float[10000][];
  float [][] tVerteces = new float[10000][];

  int [][] triangles;
  
  float [][] triangleCentroids;
  float [][] tTriangleCentroids;
  
  
  float [][] normals;
  float [][] tNormals;

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
  
  int nTriangles = 0;

  boolean revolution = false;

  int nSteps = 4;

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
      nSteps = 0;
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
    for(int i=0;i<4;i++) {
      for (int j=0;j<4;j++){
        if (i == j) tMatrix[i][j] = 1;
        else tMatrix[i][j] = 0;
      }
    }
    centroid = new PVector(x/nVerteces, y/nVerteces, z/nVerteces);
    
    if (!revolution) return;
    
    nTriangles = nSteps*2*((nVerteces/nSteps)-1);
    triangles = new int[nTriangles][3];
    triangleCentroids = new float[nTriangles][4];
    normals = new float[nTriangles][4];
    
    tTriangleCentroids = new float[nTriangles][4];
    tNormals = new float[nTriangles][4];
    
    int triangleIndex = 0;
    int aux = 0;
    float tX = 0, tY = 0, tZ = 0;
    for (int j = 0;j<nSteps;j++){
      for (int k=0;k<((nVerteces/nSteps)-1);k++){
        
        aux = k + j*(nVerteces/nSteps);
        
        //Cálculo de Vertices
        triangles[triangleIndex][0] = aux;
        triangles[triangleIndex][1] = (aux + (nVerteces/nSteps))% nVerteces;
        triangles[triangleIndex][2] = triangles[triangleIndex][1] + 1;
        
        //Cálculo del centroide
        tX = tX + verteces[aux][0];
        tX = tX + verteces[triangles[triangleIndex][1]][0];
        tX = tX + verteces[triangles[triangleIndex][2]][0];
        tX = tX/3.;
        
        tY = tY + verteces[aux][1];
        tY = tY + verteces[triangles[triangleIndex][1]][1];
        tY = tY + verteces[triangles[triangleIndex][2]][1];
        tY = tY/3.;
        
        tZ = tZ + verteces[aux][2];
        tZ = tZ + verteces[triangles[triangleIndex][1]][2];
        tZ = tZ + verteces[triangles[triangleIndex][2]][2];        
        tZ = tZ/3.;
        
        triangleCentroids[triangleIndex][0] = tX;
        triangleCentroids[triangleIndex][1] = tY;
        triangleCentroids[triangleIndex][2] = tZ;
        triangleCentroids[triangleIndex][3] = 1;
        
        tTriangleCentroids[triangleIndex][0] = tX;
        tTriangleCentroids[triangleIndex][1] = tY;
        tTriangleCentroids[triangleIndex][2] = tZ;
        tTriangleCentroids[triangleIndex][3] = 1;
        
        
        println("CENTROIDE " + tX + " " + tY + " " + tZ);
        
        tX = 0;
        tY = 0;
        tZ = 0;
        
        //Cálculo de la normal
        float [] v43 = new float[3];
        float [] v40 = new float[3];
        v43[0] = verteces[triangles[triangleIndex][1]][0] - verteces[triangles[triangleIndex][2]][0];
        v43[1] = verteces[triangles[triangleIndex][1]][1] - verteces[triangles[triangleIndex][2]][1];
        v43[2] = verteces[triangles[triangleIndex][1]][2] - verteces[triangles[triangleIndex][2]][2];
        
        
        v40[0] = verteces[triangles[triangleIndex][0]][0] - verteces[triangles[triangleIndex][2]][0];
        v40[1] = verteces[triangles[triangleIndex][0]][1] - verteces[triangles[triangleIndex][2]][1];
        v40[1] = verteces[triangles[triangleIndex][0]][2] - verteces[triangles[triangleIndex][2]][2];
        println("NORMAL v40 " + v40[0] + " " + v40[1]);
        println("NORMAL v43 " + v43[0] + " " + v43[1]);
        
        normals[triangleIndex][0] = v43[1] * v40[2] - (v40[1] * v43[2]);
        normals[triangleIndex][1] = v43[0] * v40[2] - (v40[0] * v43[2]);
        normals[triangleIndex][2] = v43[0] * v40[1] - (v40[0] * v43[1]);
        println("NORMAL ORIGINAL 0 -> " + normals[triangleIndex][0] + " " + normals[triangleIndex][1] + " " + normals[triangleIndex][2]);
        float module = sqrt( normals[triangleIndex][0]* normals[triangleIndex][0] +  
                             normals[triangleIndex][1]* normals[triangleIndex][1] + 
                             normals[triangleIndex][2]* normals[triangleIndex][2]);
                             
        normals[triangleIndex][0] = normals[triangleIndex][0]/module;
        normals[triangleIndex][1] = normals[triangleIndex][1]/module;
        normals[triangleIndex][2] = normals[triangleIndex][2]/module;
        normals[triangleIndex][3] = 1;
        
        tNormals[triangleIndex][0] = normals[triangleIndex][0]/module;
        tNormals[triangleIndex][1] = normals[triangleIndex][1]/module;
        tNormals[triangleIndex][2] = normals[triangleIndex][2]/module;
        tNormals[triangleIndex][3] = 1;
        
         
        triangleIndex = triangleIndex + 1;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////        
        triangles[triangleIndex][0] = aux;
        triangles[triangleIndex][1] = ((aux + (nVerteces/nSteps))% nVerteces) + 1;
        triangles[triangleIndex][2] = aux+1;       
     
     //Cálculo del centroide
        tX = tX + verteces[triangles[triangleIndex][0]][0];
        tX = tX + verteces[triangles[triangleIndex][1]][0];
        tX = tX + verteces[triangles[triangleIndex][2]][0];
        tX = tX/3.;
        
        tY = tY + verteces[triangles[triangleIndex][0]][1];
        tY = tY + verteces[triangles[triangleIndex][1]][1];
        tY = tY + verteces[triangles[triangleIndex][2]][1];
        tY = tY/3.;
        
        tZ = tZ + verteces[triangles[triangleIndex][0]][2];
        tZ = tZ + verteces[triangles[triangleIndex][1]][2];
        tZ = tZ + verteces[triangles[triangleIndex][2]][2];        
        tZ = tZ/3.;
        
        triangleCentroids[triangleIndex][0] = tX;
        triangleCentroids[triangleIndex][1] = tY;
        triangleCentroids[triangleIndex][2] = tZ;
        triangleCentroids[triangleIndex][3] = 1;
        
        tTriangleCentroids[triangleIndex][0] = tX;
        tTriangleCentroids[triangleIndex][1] = tY;
        tTriangleCentroids[triangleIndex][2] = tZ;
        tTriangleCentroids[triangleIndex][3] = 1;
        println("CENTROIDE " + tX + " " + tY + " " + tZ);
        
        tX = 0;
        tY = 0;
        tZ = 0;   
      
      //Cálculo de la normal
        float [] v41 = new float[3];
        v41[0] = verteces[triangles[triangleIndex][2]][0] - verteces[triangles[triangleIndex][1]][0];
        v41[1] = verteces[triangles[triangleIndex][2]][1] - verteces[triangles[triangleIndex][1]][1];
        v41[2] = verteces[triangles[triangleIndex][2]][2] - verteces[triangles[triangleIndex][1]][2];
        
        
        normals[triangleIndex][0] = v40[1] * v41[2] - (v41[1] * v40[2]);
        normals[triangleIndex][1] = v40[0] * v41[2] - (v41[0] * v40[2]);
        normals[triangleIndex][2] = v40[0] * v41[1] - (v41[0] * v40[1]);
        
        module = sqrt( normals[triangleIndex][0]* normals[triangleIndex][0] +  
                             normals[triangleIndex][1]* normals[triangleIndex][1] + 
                             normals[triangleIndex][2]* normals[triangleIndex][2]);
                             
        normals[triangleIndex][0] = normals[triangleIndex][0]/module;
        normals[triangleIndex][1] = normals[triangleIndex][1]/module;
        normals[triangleIndex][2] = normals[triangleIndex][2]/module;
        normals[triangleIndex][3] = 1;
        
        tNormals[triangleIndex][0] = normals[triangleIndex][0]/module;
        tNormals[triangleIndex][1] = normals[triangleIndex][1]/module;
        tNormals[triangleIndex][2] = normals[triangleIndex][2]/module;
        tNormals[triangleIndex][3] = 1;
        println("NORMAL ORIGINAL " + normals[triangleIndex][0] + " " + normals[triangleIndex][1] + " " + normals[triangleIndex][2]);
      
        triangleIndex = triangleIndex + 1;
      }
    }
  }
  
  PVector getCentroid() {
    return centroid;
  }
  
  void updateCentroid() {
    float x = 0, y = 0, z = 0;
    for (int j=0;j<nVerteces;j++) {
      x = x + tVerteces[j][0];
      y = y + tVerteces[j][1];
      z = z + tVerteces[j][2];
    }
    centroid = new PVector(x/nVerteces, y/nVerteces, z/nVerteces);
  }
  
  void normalizeNormals(){
    for (int i=0;i<nTriangles;i++){
      float module = sqrt( tNormals[i][0]* tNormals[i][0] +  
                           tNormals[i][1]* tNormals[i][1] + 
                           tNormals[i][2]* tNormals[i][2]);
      tNormals[i][0] = tNormals[i][0]/module;
      tNormals[i][1] = tNormals[i][1]/module;
      tNormals[i][2] = tNormals[i][2]/module;
          
    }
  }

  //TODO Crear funcion miLinea, la cual aparte de dibujar la línea aplica la perspectiva.
  void draw(float k, boolean triang, boolean norm) {
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
          if (i < ((nVerteces/nSteps)-1)){
            myLine(tVerteces[i+j*(nVerteces/nSteps)], tVerteces[i+j*(nVerteces/nSteps)+1], 2);
          }
        }
      }
      if(triang){
        for(int l=0;l<nTriangles;l=l+2){
          //myLine(tVerteces[triangles[l][0]],tVerteces[triangles[l][1]],2);
          //myLine(tVerteces[triangles[l][1]],tVerteces[triangles[l][2]],2);
          myLine(tVerteces[triangles[l][2]],tVerteces[triangles[l][0]],2);
          //println("--------------"+l+"-----------------");
          //println("PINTO -> " + triangles[l][2] + " " + triangles[l][0]); 
        }
      }
      if(norm){
        for(int l=0;l<nTriangles;l++){
          float [] aux = new float[3];
          aux[0] = tTriangleCentroids[l][0] + tNormals[l][0]*20.;
          aux[1] = tTriangleCentroids[l][1] + tNormals[l][1]*20.;
          aux[2] = tTriangleCentroids[l][2] + tNormals[l][2]*20.;
          println("CENTROIDE " + tTriangleCentroids[l][0] +" "+ tTriangleCentroids[l][1] +" "+ tTriangleCentroids[l][2] );
          println("NORMAL ORIGINAL " + tNormals[l][0] + " " + tNormals[l][1] + " " + tNormals[l][2]);
          println("NORMAL NUEVA " + aux[0] + " " + aux[1] + " " + aux[2]);
          //Línea desde el centroide al centroide + vector
          myLine(tTriangleCentroids[l],aux,1);
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
    tTriangleCentroids = multiplyMatrix(triangleCentroids, tMatrix, nTriangles, 4, 4);
    updateCentroid();
    normalizeNormals();

  }

  void rotateX(float angle0, float iniRotX, float iniRotY) {
    float angle = angle0;
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
        -iniRotX, -iniRotY, 0, 1
      }
    };
    float [][] aux = multiplyMatrix(T, Rx, 4, 4, 4);
    T[3][0] = +iniRotX;
    T[3][1] = +iniRotY;
    aux = multiplyMatrix(aux, T, 4, 4, 4);
    tMatrix = multiplyMatrix(tMatrix,aux, 4, 4, 4);
    
    tVerteces = multiplyMatrix(verteces, tMatrix, nVerteces, 4, 4);
    tTriangleCentroids = multiplyMatrix(triangleCentroids, tMatrix, nTriangles, 4, 4);
    tNormals = multiplyMatrix(normals, tMatrix, nTriangles, 4, 4);


    normalizeNormals();
    updateCentroid();

  }

  void rotateY(float angle0, float iniRotX, float iniRotY) {
    float angle = angle0;
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
        -iniRotX, -iniRotY, 0, 1
      }
    };
    float [][] aux = multiplyMatrix(T, Ry, 4, 4, 4);
    T[3][0] = +iniRotX;
    T[3][1] = +iniRotY;
    aux = multiplyMatrix(aux, T, 4, 4, 4);


    tMatrix = multiplyMatrix(tMatrix, aux, 4, 4, 4);
    tVerteces = multiplyMatrix(verteces, tMatrix, nVerteces, 4, 4);
    updateCentroid();
    
  }
}
