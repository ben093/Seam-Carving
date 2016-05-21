class SeamCarver {
  PImage img;  //This is a copy of the original image
  float[][] energyMatrix;  //Holds energy for all pixels
  float[][] scaledEnergyMatrix; //Holds energy for all pixels on scale of 0-255
  float[][] vertEnergyMatrix;
  float[][] horizEnergyMatrix;
  float maxEnergy = 0;  //Holds max value in energyMatrix
  float minEnergy = 0;  //Holds min value in energyMatrix
  float INFINITY = sq(255) * 100;
  int PROTECT = 0, ERASE = 1;
  PImage hiddenImage;
  
  SeamCarver(PImage picture) {
    //Creates a SeamCarver object
    img = picture;
    hiddenImage = picture;
  }
  PImage picture() {
    //Returns the current image
    return img;
  }
  int width() {
    //Returns width of the current image
    return img.width;
  }
  int height() {
    //Returns height of the current image
    return img.height;
  }
  void calcEnergy() {
    //Fills energy matrix using dual gradient function
    //Must be called every time the image is changed
    energyMatrix = new float[width()][height()]; 
    horizEnergyMatrix = new float[width()][height()];
    vertEnergyMatrix = new float[width()][height()];
    
    // Fill local energy matrix
    for(int y = 0; y < height(); y++)
    {
      for(int x = 0; x < width(); x++)
      {  // Local energy
         //energyMatrix[x][y] = 
                              /*sq(red  (img.get(x, y - 1 + height()) % height()) - red  (img.get(x, y + 1 + height()) % height())) + 
                              sq(green(img.get(x, y - 1 + height()) % height()) - green(img.get(x, y + 1 + height()) % height())) + 
                              sq(blue (img.get(x, y - 1 + height()) % height()) - blue (img.get(x, y + 1 + height()) % height())) + 
                              sq(red  (img.get(x - 1 + width() % width(), y)) - red  (img.get(x + 1 + width() % width(), y))) + 
                              sq(green(img.get(x - 1 + width() % width(), y)) - green(img.get(x + 1 + width() % width(), y))) + 
                              sq(blue (img.get(x - 1 + width() % width(), y)) - blue (img.get(x + 1 + width() % width(), y)));*/
                              
        color ptop,pbot,pleft,pright;
        int w = width();
        int h = height();
        pleft = img.get((x - 1 + w) % w,y);
        pright = img.get((x + 1 + w) % w,y);
        ptop = img.get(x,(y - 1 + h) % h);
        pbot = img.get(x,(y + 1 + h) % h);

        energyMatrix[x][y] = 
              sq(red(ptop) - red(pbot)) + sq(green(ptop) - green(pbot)) + sq(blue(ptop) - blue(pbot))
            + sq(red(pright) - red(pleft)) + sq(green(pright) - green(pleft)) + sq(blue(pright) - blue(pleft));
        
            //if(x < 10 && y < 10) print(energyMatrix[x][y] + " ");                        
      }
      //if(y < 10) println();
    }    
    
    // Fill vertical cumulative energy matrix
    /*for(int y = 0; y < height(); y++) {
      for(int x = 0; x < width(); x++) {
        //vertEnergyMatrix
        float lowest = INFINITY;
        
        if(y == 0) vertEnergyMatrix[x][y] = energy(x,y);
        else {          
          if(x == 0)
          {            
            if(vertEnergyMatrix[x+1][y-1] < lowest) lowest = vertEnergyMatrix[x+1][y-1]; // Check upper-right for lowest
            if(vertEnergyMatrix[x][y-1] < lowest) lowest = vertEnergyMatrix[x][y-1]; // Check straight up for lowest
            
            
          }
          else if (x == width()-1)
          {
            if(vertEnergyMatrix[x-1][y-1] < lowest) lowest = vertEnergyMatrix[x-1][y-1]; // Check upper-left for lowest
            if(vertEnergyMatrix[x][y-1] < lowest) lowest = vertEnergyMatrix[x][y-1]; // Check straight up for lowest
          }
          else
          {
            if(vertEnergyMatrix[x+1][y-1] < lowest) lowest = vertEnergyMatrix[x+1][y-1]; // Check upper-right for lowest
            if(vertEnergyMatrix[x-1][y-1] < lowest) lowest = vertEnergyMatrix[x-1][y-1]; // Check upper-left for lowest
            if(vertEnergyMatrix[x][y-1] < lowest) lowest = vertEnergyMatrix[x][y-1]; // Check straight up for lowest                        
          }
          
          vertEnergyMatrix[x][y] = lowest + energy(x,y);
          
          //if(y == height() - 1) print("x: " + x + " = "+ vertEnergyMatrix[x][y] + "\n");
          
          //if(x < 10 && y < 10) print(vertEnergyMatrix[x][y] + " ");
        }                            
      }      
      //if(y < 10) println();
    }*/
    
    // Fill horizontal cumulative energy matrix
    /*for(int x = 0; x < width(); x++) {
      for(int y = 0; y < height(); y++) {      
        //horizEnergyMatrix
        float lowest = INFINITY;
        
        if(x == 0) horizEnergyMatrix[x][y] = energy(x,y);
        else {          
          if(y == 0)
          {            
            if(horizEnergyMatrix[x-1][y+1] < lowest) lowest = horizEnergyMatrix[x-1][y+1]; // Check lower-left for lowest
            if(horizEnergyMatrix[x-1][y] < lowest) lowest = horizEnergyMatrix[x-1][y]; // Check straight left for lowest                       
          }
          else if (y == height()-1)
          {
            if(horizEnergyMatrix[x-1][y-1] < lowest) lowest = horizEnergyMatrix[x-1][y-1]; // Check upper-left for lowest
            if(horizEnergyMatrix[x-1][y] < lowest) lowest = horizEnergyMatrix[x-1][y]; // Check straightleft for lowest
          }
          else
          {            
            if(horizEnergyMatrix[x-1][y+1] < lowest) lowest = horizEnergyMatrix[x-1][y+1]; // Check lower-left for lowest
            if(horizEnergyMatrix[x-1][y-1] < lowest) lowest = horizEnergyMatrix[x-1][y-1]; // Check upper-left for lowest
            if(horizEnergyMatrix[x-1][y] < lowest) lowest = horizEnergyMatrix[x-1][y]; // Check straight left for lowest                          
          }
          
          horizEnergyMatrix[x][y] = lowest + energy(x,y);
        }                            
      }      
    }*/
    
  }
  
  void fillVerticalCumulativeMatrix(){
    // Fill vertical cumulative energy matrix
    for(int y = 0; y < height(); y++) {
      for(int x = 0; x < width(); x++) {
        //vertEnergyMatrix
        float lowest = INFINITY;
        
        if(y == 0) vertEnergyMatrix[x][y] = energy(x,y);
        else {          
          if(x == 0)
          {            
            if(vertEnergyMatrix[x+1][y-1] < lowest) lowest = vertEnergyMatrix[x+1][y-1]; // Check upper-right for lowest
            if(vertEnergyMatrix[x][y-1] < lowest) lowest = vertEnergyMatrix[x][y-1]; // Check straight up for lowest                        
          }
          else if (x == width()-1)
          {
            if(vertEnergyMatrix[x-1][y-1] < lowest) lowest = vertEnergyMatrix[x-1][y-1]; // Check upper-left for lowest
            if(vertEnergyMatrix[x][y-1] < lowest) lowest = vertEnergyMatrix[x][y-1]; // Check straight up for lowest
          }
          else
          {
            if(vertEnergyMatrix[x+1][y-1] < lowest) lowest = vertEnergyMatrix[x+1][y-1]; // Check upper-right for lowest
            if(vertEnergyMatrix[x-1][y-1] < lowest) lowest = vertEnergyMatrix[x-1][y-1]; // Check upper-left for lowest
            if(vertEnergyMatrix[x][y-1] < lowest) lowest = vertEnergyMatrix[x][y-1]; // Check straight up for lowest                        
          }
          
          vertEnergyMatrix[x][y] = lowest + energy(x,y);
          
          //if(y == height() - 1) print("x: " + x + " = "+ vertEnergyMatrix[x][y] + "\n");
          
          //if(x < 10 && y < 10) print(vertEnergyMatrix[x][y] + " ");
        }                            
      }      
      //if(y < 10) println();
    } 
  }
  
  void fillHorizontalCumulativeMatrix(){
    // Fill horizontal cumulative energy matrix
    for(int x = 0; x < width(); x++) {
      for(int y = 0; y < height(); y++) {      
        //horizEnergyMatrix
        float lowest = INFINITY;
        
        if(x == 0) horizEnergyMatrix[x][y] = energy(x,y);
        else {          
          if(y == 0)
          {            
            if(horizEnergyMatrix[x-1][y+1] < lowest) lowest = horizEnergyMatrix[x-1][y+1]; // Check lower-left for lowest
            if(horizEnergyMatrix[x-1][y] < lowest) lowest = horizEnergyMatrix[x-1][y]; // Check straight left for lowest                       
          }
          else if (y == height()-1)
          {
            if(horizEnergyMatrix[x-1][y-1] < lowest) lowest = horizEnergyMatrix[x-1][y-1]; // Check upper-left for lowest
            if(horizEnergyMatrix[x-1][y] < lowest) lowest = horizEnergyMatrix[x-1][y]; // Check straightleft for lowest
          }
          else
          {            
            if(horizEnergyMatrix[x-1][y+1] < lowest) lowest = horizEnergyMatrix[x-1][y+1]; // Check lower-left for lowest
            if(horizEnergyMatrix[x-1][y-1] < lowest) lowest = horizEnergyMatrix[x-1][y-1]; // Check upper-left for lowest
            if(horizEnergyMatrix[x-1][y] < lowest) lowest = horizEnergyMatrix[x-1][y]; // Check straight left for lowest                          
          }
          
          horizEnergyMatrix[x][y] = lowest + energy(x,y);
        }                            
      }      
    } 
  }
  void setEnergyProtectRegion(int startX, int startY, int endX, int endY){    
    // Readjust the endX and endY if over extending.
    if(endY > width()) endY = width();
    if(endX > height()) endX = height();
    
    for(int x = startX; x < endX; x++){
      for(int y = startY; y < endY; y++){
        // Set regions to negative infinity in energy matrix.
        energyMatrix[x][y] = INFINITY; 
      }
    }
  }
  
  void setEnergyRemoveRegion(int startX, int startY, int endX, int endY){
    // Immediately return if area has already been erased.
    if(endX == startX) return;
    if(endY == startY) return;
    
    // Readjust the endX and endY if over extending.
    if(endY > width()) endY = width();
    if(endX > height()) endX = height();
    
    
    for(int x = startX; x < endX; x++){
      for(int y = startY; y < endY; y++){
        // Set regions to negative infinity in energy matrix.
        energyMatrix[x][y] = 0 - INFINITY; 
      }
    }
  }
  
  float energy(int x, int y) {
    //Returns energy of pixel at position x, y
    
    return energyMatrix[x][y];    
  }
  PImage energyImage() {
    //Returns an image showing energy scaled and stored in pixels
    PImage target = createImage(img.width, img.height, RGB);
    
    calcEnergy();
    
    // Get max and mins
    for(int x = 1; x < width(); x++){
      for(int y = 1; y < height(); y++){
        if(maxEnergy < energy(x,y))
        {
          maxEnergy = energy(x,y);
        }     
        if(minEnergy > energy(x,y))
        {
          minEnergy = energy(x,y);
        }
      }
    }    
    
    for(int x = 0; x < width(); x++){
      for(int y = 0; y < height(); y++){
        //minEnergy, maxEnergy
        float val = map(energy(x,y), minEnergy, maxEnergy, 0, 255);
        
        target.set(x, y, color(val));
      }
    }
    
    return target;
  }
  int[] findHorizontalSeam() {
    //Returns sequence of y indices for an optimal horizontal seam
    int[] yIndices = new int[width()];
    
    //start at index 0
    int seamY = 0;
    
    for (int x = width()-1; x >= 0; x--) {
      
      //Find original min
      if (x == width()-1) {
        for (int y = 0; y < height(); y++) {
          if (horizEnergyMatrix[x][y] < horizEnergyMatrix[x][seamY]) {
            // Find minimum on right most column
            seamY = y;
          }  
        }
      }
      else {
        //Check if seam is in top row, if so check if next row is less.
        if(seamY == 0) {
          if (horizEnergyMatrix[x][seamY+1] < horizEnergyMatrix[x][seamY]) {
            seamY++; 
          }
        }
        //Check if is in bottom row, if so, check if previous row is less.
        else if (seamY == height() - 1) {
         if (horizEnergyMatrix[x][seamY-1] < horizEnergyMatrix[x][seamY]) {
           seamY--; 
         }
        }
        else {          
          // Typical case, find which way (or neither) that seam needs to move.
         if(horizEnergyMatrix[x][seamY-1] < horizEnergyMatrix[x][seamY] &&
         horizEnergyMatrix[x][seamY-1] == min(horizEnergyMatrix[x][seamY-1], horizEnergyMatrix[x][seamY], horizEnergyMatrix[x][seamY+1])) {
           seamY--;
         }
         else if (horizEnergyMatrix[x][seamY+1] < horizEnergyMatrix[x][seamY]) {
           seamY++;
         }
        }
      }
      yIndices[x] = seamY;

    }
    return yIndices;
  }
  
  int[] findVerticalSeam() {
    //Returns sequence of x indices for an optimal vertical seam
    int[] xIndices = new int[height()];
    
    int minIndex = 0;
    
    // Get minimum on bottom row
    for(int x = 0; x < width()-1; x++)
    {
      if(vertEnergyMatrix[minIndex][height() - 1] > vertEnergyMatrix[x][height() - 1]) minIndex = x;      
    }
    
    // Set the last value in array to the min index
    xIndices[height()-1] = minIndex;
    //print(minIndex + " ");
    
    for(int y = height()-1; y > 0; y--)
    {
      int currX = xIndices[y];

      if(currX == 0) {
        // All the way to the left case 
        if(vertEnergyMatrix[currX][y] < vertEnergyMatrix[currX+1][y]){
           //straight up is minimum
           minIndex = currX;
        }
        else if(vertEnergyMatrix[currX+1][y] < vertEnergyMatrix[currX][y]){
            //upper-right is minimum
            minIndex = currX + 1;
        }
      }
      else if(currX == width()-1){
        // All the way to the right case
        if(vertEnergyMatrix[currX-1][y] < vertEnergyMatrix[currX][y]){
           //upper-left is minimum
           minIndex = currX - 1;
        }
        else if(vertEnergyMatrix[currX][y] < vertEnergyMatrix[currX-1][y]){
           //straight up is minimum
           minIndex = currX;
        }
      }
      else {
       //Typical case
        if(  vertEnergyMatrix[currX-1][y] < vertEnergyMatrix[currX][y]
          && vertEnergyMatrix[currX-1][y] < vertEnergyMatrix[currX+1][y] ){
           //upper-left is minimum
           minIndex = currX - 1;
        }
        else if(  vertEnergyMatrix[currX][y] < vertEnergyMatrix[currX-1][y]
               && vertEnergyMatrix[currX][y] < vertEnergyMatrix[currX+1][y] ){
           //straight up is minimum
           minIndex = currX;
        }
        else if(  vertEnergyMatrix[currX+1][y] < vertEnergyMatrix[currX-1][y]
               && vertEnergyMatrix[currX+1][y] < vertEnergyMatrix[currX][y] ){
           //upper-right is minimum
           minIndex = currX + 1;
        }
       
      }      
      
       xIndices[y-1] = minIndex;
    }
    
    for(int i = 0; i < xIndices.length; i ++){
      //println("x: " + i + " = " + xIndices[i]); 
    }
    
    return xIndices;
  }
  void removeHorizontalSeam(int[] hseam) {
   //Resizes the image by removing the lowest-energy horizontal seam
   //Makes the image shorter
   int a = 0;
   PImage target = createImage(width(), height()-1, RGB);
   for (int x = 0; x < width(); x++) {
     a = 0;
     for (int y = 0; y < height()-1; y++) {
       if (hseam[x] == y) {
         // Skip this seam.
         a++;         
       }
       color c = img.get(x, a); 
       target.set(x, y, c);
       a++;
     }
   }
   img = target;
   
   // Recalculate
   calcEnergy();
   fillHorizontalCumulativeMatrix();
   fillVerticalCumulativeMatrix();
  }
  void removeVerticalSeam(int[] vseam) {
   //Resizes the image by removing the lowest-energy vertical seam
   //Makes the image narrower
   int a = 0;
   PImage target = createImage(width()-1, height(), RGB);
   for (int y = 0; y < height(); y++) {
     a = 0;
     for (int x = 0; x < width()-1; x++) {
       if (vseam[y] == x) {
         // Skip this one.
         a++;
       }
       
       color c = img.get(a, y); 
       target.set(x, y, c);
       a++;
     }
   }

   img = target;
   
   // Recalculate
   calcEnergy();
   fillHorizontalCumulativeMatrix();
   fillVerticalCumulativeMatrix();
  }
  
  // Wasn't sure how below was supposed to be implemented. Instead if you hold LEFT or DOWN it will erase or protect the area selected.
  /*
  void eraseVerticalSeams() {
    //Erases an area selected by right mouse by removing vertical seams until
    //the area is gone; makes the image narrower
  }
  void eraseHorizontalSeams() {
    //Erases an area selected by right mouse by removing horizontal seams until
    //the area is gone; makes the image shorter
  }*/
}