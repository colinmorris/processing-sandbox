/*
Randomly perturb rows of pixels in an image to the left or right.

Moving the cursor reapplies the effect:
  - Horizontal position of the cursor determines the % of rows that are perturbed (far left=no rows, far right=all rows)
  - Vertical position determines the magnitude of the jiggle. The higher the cursor, the greater the magnitude.
*/

PImage img;

int w = 640;
int h = 480;

// Remember the last 'significant' mouse cursor location
int lastX = 0;
int lastY = 0;
// Redraw if the cursor has moved a distance of this many pixels since last time.
int sensitivity = 50;

void settings() {
 size(w,h); 
}

void setup() {
  img = loadImage("f.jpg");
  img.loadPixels();
}

/* Write to the canvas a version of img where rows are randomly jiggled. This does not mutate img.
- prob: probability of jiggling a particular row as a % from 0 to 100.0
- magnitude: This will be multiplied by a random Gaussian with mean 0 and stdev 1 to get the distance
  to shift each row (i.e. around 70% of rows will be shifted by no more than this many pixels, 95% will
  be shifted by no more than twice this many pixels)
*/
void jiggleRows(float prob, float magnitude) {
  int[] newPixels = new int[w*h];
  int offset = 0;
  for (int y=0; y < h; y++) {
    offset = random(100) < prob ? int(randomGaussian() * magnitude) : 0;
    for (int x=0; x < w; x++) {
      // If we would fall off the edge, we just interpolate using the left-most or right-most pixel, rather than wrapping around
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