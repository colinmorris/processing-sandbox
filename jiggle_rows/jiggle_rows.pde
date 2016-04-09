/*
Randomly perturb rows of pixels in an image to the left or right.

Moving the cursor reapplies the effect:
  - Horizontal position of the cursor determines the % of rows that are perturbed (far left=no rows, far right=all rows)
  - Vertical position determines the magnitude of the jiggle. The higher the cursor, the greater the magnitude.
*/

PImage img;

int w = 840;
int h = 660;

int fileIdx = 0;
String[] filenames;

// Remember the last 'significant' mouse cursor location
int lastX = 0;
int lastY = 0;
// Redraw if the cursor has moved a distance of this many pixels since last time.
int sensitivity = 50;

// What to do at the edges of a shifted row
public enum EdgeBehaviour {
  INTERPOLATE, // 'gap' pixels are filled in by the color at the beginning/end of the row
  FLOW  // 'gap' pixels are left blank, if the image's width is less than that of the display, 
        // leftover pixels can be drawn beyond the normal x boundaries of the image  
}

EdgeBehaviour edgeMode = EdgeBehaviour.FLOW;

// If the image doesn't exactly fit the display window, we'll shrink if necessary and center it.
// These give the amount of padding between each side of the image and the edges of the display window.
int xpad = 0;
int ypad = 0;
  

String data_dir = "/home/colin/src/processing-sandbox/shared_images/";

void settings() {
 size(w,h); 
}

void setup() {
  java.io.File folder = new java.io.File(dataPath(data_dir));
  filenames = folder.list();
  if (filenames.length == 0) {
    println("No files found in", data_dir, "Exiting.");
    exit();
    return;
  }
  loadPixels();
  loadAndResizeImage();
}

// Loads the appropriate image from the file system (according to the current value of fileIdx),
// and resizes it to fit the display window.
void loadAndResizeImage() {
  img = loadImage(data_dir + filenames[fileIdx]);
  // Resize if it's too big
  if (img.width > w || img.height > h) {
    float aspect_ratio = img.width/float(img.height);
    if (aspect_ratio > w/float(h)) {
      img.resize(w, 0);
    } else {
      img.resize(0, h);
    }
  }
  img.loadPixels();
  xpad = (w-img.width)/2;
  ypad = (h-img.height)/2;
  // Erase any previous image and draw an unaltered version of the current image. Sort of hacky.
  clearHack();
  jiggleRows(0, 0);
}

/* Given an (x, y) position with respect to img, return the corresponding
 * index into pixels. If img's dimensions don't exactly match the display
 * then center it.
 */
int img_coords_to_display_idx(int x, int y) {
  // Center the image if there's slack
  int y_offset = (h - img.height) / 2;
  int x_offset = (w - img.width) / 2;
  return (y_offset + y)*w + (x_offset + x);
}

/* Write to the display a version of img where rows are randomly jiggled. This does not mutate img.
- prob: probability of jiggling a particular row as a % from 0 to 100.0
- magnitude: This will be multiplied by a random Gaussian with mean 0 and stdev 1 to get the distance
  to shift each row (the average jiggle amount will be around 80% of magnitude)
*/
void jiggleRows(float prob, float magnitude) {
  int offset;
  for (int y=0; y < img.height; y++) {
    offset = random(100) < prob ? int(randomGaussian() * magnitude) : 0;
    for (int x=0; x < img.width; x++) {
      int shifted_x = 0;
      switch (edgeMode) {
        case INTERPOLATE:
          shifted_x = constrain(x+offset, 0, img.width-1);
          break;
        case FLOW:
          shifted_x = constrain(x+offset, 0-xpad, w+xpad-1);
          break;
      }
      int pixels_idx = img_coords_to_display_idx(shifted_x, y);
      pixels[pixels_idx] = img.pixels[y*img.width+x];
    }
  }
  updatePixels();  
}

// Clear the display by iterating over all pixels and setting to grey. (Not clear why background() doesn't work for this.)
void clearHack() {
  for (int x=0; x<w; x++) {
    for (int y=0; y<h; y++) {
      pixels[y*w+x] = color(128);
    }
  }
  updatePixels();
}

void draw() {
  if (lastX+lastY == 0 || dist(mouseX, mouseY, lastX, lastY) > sensitivity) {
   lastX = mouseX;
   lastY = mouseY;
   // Left edge -> jiggle no rows, Right edge -> jiggle all rows
   float jiggleProbability = map(mouseX, 0, w, 0, 100);
   // Left edge -> No jiggle, Right edge -> average jiggle around 16 pixels
   float jiggleMagnitude = map(-1*(mouseY-h), 0, h, 0, 20);
   
   // In 'flow' mode, we need to erase any pixels that have flowed outside the normal bounds of the image 
   if (edgeMode == EdgeBehaviour.FLOW) {
     clearHack();
   }
   jiggleRows(jiggleProbability, jiggleMagnitude);
  }
}

void keyReleased() {
  if (keyCode == LEFT || keyCode == RIGHT) {
    if (keyCode == LEFT) {
      fileIdx = fileIdx == 0 ? filenames.length - 1 : fileIdx - 1;
    } else {
      fileIdx = (fileIdx + 1) % filenames.length;
    }
    loadAndResizeImage();
  }
}