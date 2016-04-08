PImage img;

int w = 640;
int h = 480;

int lastX = 0;
int lastY = 0;
int sensitivity = 50;

void settings() {
 size(w,h); 
}

void setup() {
  //size(w, h);
  img = loadImage("f.jpg");
  img.loadPixels();
}

void jiggleRows(float prob, float magnitude) {
  int[] newPixels = new int[w*h];
  int offset = 0;
  for (int y=0; y < h; y++) {
    offset = random(100) < prob ? int(randomGaussian() * magnitude) : 0;
    for (int x=0; x < w; x++) {
      int idx = constrain(y*w+x+offset, y*w, (y+1)*w-1);
      newPixels[y*w+x] = img.pixels[idx];
    }
  }
  
  loadPixels();
  for (int i=0; i < w*h; i++) {
    pixels[i] = newPixels[i];
  }
  updatePixels();  
}

void draw() {
  if (lastX+lastY == 0 || dist(mouseX, mouseY, lastX, lastY) > sensitivity) {
   lastX = mouseX;
   lastY = mouseY;
   float jiggleProbability = map(mouseX, 0, w, 0, 100);
   float jiggleMagnitude = map(-1*(mouseY-h), 0, h, 0, 20); 
   jiggleRows(jiggleProbability, jiggleMagnitude);
  }
}