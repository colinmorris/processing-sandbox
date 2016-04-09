PImage img;

int w = 1200;
int h = 800;

int fileIdx = 0;
String[] filenames;

String data_dir = "/home/colin/src/processing-sandbox/shared_images/";

boolean lerped = true;

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
  println(filenames[0]);
    
  drawImage();
}

void drawImage() {
  img = loadImage(data_dir + filenames[fileIdx]);
  // Resize if it's too big
  if (img.width > w || img.height > h) { //<>//
    float aspect_ratio = img.width/float(img.height);
    if (aspect_ratio > w/float(h)) {
      img.resize(w, 0);
    } else {
      img.resize(0, h);
    }
  }
  img.loadPixels();
  background(128);
  lerpMirror();
}

void lerpMirror() {
  loadPixels();
  println(img.height);
  println(img.width);
  for (int y=0; y<img.height; y++) {
    for (int x=0; x<img.width/2; x++) {
      // Indices into the image pixels
      int imga = y*img.width+x;
      int imgb = y*img.width + (img.width-x-1);
      // Indices into the canvas
      // TODO: Center?
      int pa = y*w+x;
      int pb = y*w + (img.width-x-1);
      color lerped = lerpColor(img.pixels[imga], img.pixels[imgb], 0.5);
      pixels[pa] = lerped;
      pixels[pb] = lerped;
    }
  }
  updatePixels();
  lerped = true;
}

void unlerp() {
  image(img, 0, 0);
}

void draw() {
  //lerpMirror();
}

void keyReleased() {
  if (keyCode == LEFT || keyCode == RIGHT) {
    if (keyCode == LEFT) {
      fileIdx = fileIdx == 0 ? filenames.length - 1 : fileIdx - 1;
    } else {
      fileIdx = (fileIdx + 1) % filenames.length;
    }
    drawImage();
  }
  if (key == ' ') {
    if (!lerped) {
      drawImage();
    } else {
      unlerp();
      lerped = false;
    }
  }
}