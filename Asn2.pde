/* SeamCarving - resize an image by seam-carving
   'o' displays original; 'e' shows energy image
   'LEFT' cuts one vertical seam (makes the image narrower)
   'DOWN' cuts one horizontal seam (makes the image shorter)
   'DELETE' erases an area selected by right mouse drag by
   removing horizontal seams until the area is gone
   'BACKSPACE' erases an area selected by right mouse by
   removing vertical seams until the area is gone
   Left mouse selection protects a region from being removed;
   'c' clears the protection.
   This api implements SeamCarver mostly as described by
   http://nifty.stanford.edu/2015/hug-seam-carving/. It adds
   the ability to use the left mouse button to select areas
   that will be protected; right mouse button selects areas
   that will be erased.
*/

PImage img, currentImg;
PImage hiddenImg;
PImage energyImg;  //Displays energy
String[] fname = {"HJoceanSmall.jpg", "arch_sunset.jpg", "hot_air.jpg"};
SeamCarver carver, currentCarver;
boolean drawVertSeam = false, drawHorizSeam = false, displayEnergy = false;
int startx, starty;  //Used for selection
int[] vertSeam;
int[] horizSeam;
boolean isLeftMouse = false;
int endx;
int endy;

void setup() {
  size(400, 400);
  surface.setResizable(true);
  carver = new SeamCarver(loadImage(fname[0]));
  surface.setSize(carver.width(), carver.height());
  energyImg = carver.energyImage();
  currentImg = carver.picture();
  img = loadImage(fname[0]);
  stroke(255, 0, 0);
  noFill();
  rectMode(CORNERS);
}
void draw() {
  background(0);
  image(currentImg, 0, 0);
  if (drawVertSeam) drawVert();
  if (drawHorizSeam) drawHoriz();
  if (mousePressed) {
    if (mouseButton == LEFT) stroke(255, 0, 0);
    else if (mouseButton == RIGHT) stroke(0, 255, 0);
    rect(startx, starty, mouseX, mouseY);
  }
}
void drawVert() {
  //Draws lowest-energy vertical seam in display window
  vertSeam = carver.findVerticalSeam();
  
  for(int i = 0; i < carver.height(); i++) {
    
    point(vertSeam[i],i);
  }
}
void drawHoriz() {
  //Draws lowest-energy horizontal seam in display window
  //Draws lowest-energy vertical seam in display window
  horizSeam = carver.findHorizontalSeam();
  
  for(int i = 0; i < carver.width(); i++) {
    
    point(i,horizSeam[i]);
  }
}
void mousePressed() {
  //Start selection
  startx = mouseX;
  starty = mouseY;
  if(mousePressed){
    if(mouseButton == LEFT) isLeftMouse = true;
    else isLeftMouse = false;
  }
}
void mouseReleased() {
  //Complete selection and take appropriate action
  endx = mouseX;
  endy = mouseY;
  
  if(endy < starty){
    int temp = starty;
    starty = endy;
    endy = temp;
  }
  if(endx < startx){
    int temp = startx;
    startx = endx;
    endx = temp;
  }
  
  callMouseEvents();
}

void callMouseEvents() {
  if(endy < starty){
    int temp = starty;
    starty = endy;
    endy = temp;
  }
  if(endx < startx){
    int temp = startx;
    startx = endx;
    endx = temp;
  }
  
  if(isLeftMouse){
    carver.setEnergyProtectRegion(startx, starty, endx, endy);
    carver.fillVerticalCumulativeMatrix();
    carver.fillHorizontalCumulativeMatrix();
  }
  else{ // Right button was clicked
    carver.setEnergyRemoveRegion(startx, starty, endx, endy);
    carver.fillVerticalCumulativeMatrix();
    carver.fillHorizontalCumulativeMatrix();
  } 
}

void keyPressed() {
  //Take action according to key
  if(key == 'e') currentImg = carver.energyImage(); 
  else if(key == 'o') currentImg = carver.picture();
  else if(key == 'v') {
    drawVertSeam = true;
    drawHorizSeam = false;
  }
  else if(key == 'h') {
    drawHorizSeam = true;
    drawVertSeam = false;
  }
  else if(key == 'c') {
     drawHorizSeam = false;
     drawVertSeam = false;
     startx = 0;
     starty = 0;
     endx = 0;
     endy = 0;
     carver.calcEnergy();
     horizSeam = carver.findHorizontalSeam();
     vertSeam = carver.findVerticalSeam();
  }
  else if(keyCode == LEFT){ 
    //drawVertSeam = true;
    vertSeam = carver.findVerticalSeam();
    carver.removeVerticalSeam(vertSeam);
    surface.setSize(carver.width(), carver.height());
    callMouseEvents();
    hiddenImg = carver.picture();
    currentImg = carver.picture();
    vertSeam = carver.findVerticalSeam();
    if(!isLeftMouse) endx--; // Make sure area is selected
  }
  else if(keyCode == DOWN){ 
    //drawHorizSeam = true;
    horizSeam = carver.findHorizontalSeam();
    carver.removeHorizontalSeam(horizSeam);
    surface.setSize(carver.width(), carver.height());
    hiddenImg = carver.picture();
    currentImg = carver.picture();
    callMouseEvents();
    horizSeam = carver.findHorizontalSeam();
    if(!isLeftMouse) endy--;
  }
  else if(keyCode == BACKSPACE){} // Not implemented, just hold left after selecting a region.
  else if(keyCode == DELETE){} // Not implemented, just hold down after selecting a region.
  
  
}