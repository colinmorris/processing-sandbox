PImage img;

int w = 640;
int h = 480;

void settings() {
 size(w,h); 
}

void setup() {
  //size(w, h);
  img = loadImage("f.jpg");
  img.loadPixels();
}

void lerpMirror() {
  loadPixels();
  for (int y=0; y<h; y++) {
    for (int x=0; x<w/2; x++) {
      int pa = y*w+x;
      int pb = (y+1)*w-x-1;
      color lerped = lerpColor(img.pixels[pa], img.pixels[pb], 0.5);
      pixels[pa] = lerped;
      pixels[pb] = lerped;
    }
  }
  updatePixels();
}

void draw() {
  lerpMirror();
  noLoop();
}