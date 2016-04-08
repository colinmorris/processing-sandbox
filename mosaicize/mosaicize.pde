PImage img;

int w = 640;
int h = 480;

int mousedowned = 0;

void settings() {
 size(w,h); 
}

void setup() {
  //size(w, h);
  img = loadImage("f.jpg");
  img.loadPixels();
  noStroke();
  image(img, 0, 0);
}

color avgColor(int x_, int y_, float radius) {
  int slop = int(radius);
  int n = 0;
  float r = 0;
  float b = 0;
  float g = 0;
  for (int x=x_-slop; x <= x_+slop; x++) {
    for (int y=y_-slop; y <= y_+slop; y++) {
      if (x < 0 || y < 0 || x >= w || y >= h) {
        continue;
      }
      color c = img.pixels[y*w+x];
      r += red(c);
      b += blue(c);
      g += green(c);
      n += 1;
    }
  }
  return color(r/n, g/n, b/n);
}

void draw() {
  // apparently I need this dumb thing
}

void mousePressed() {
  mousedowned = millis();
}
  

void mouseReleased() {
  int duration = millis() - mousedowned;
  float size = map(min(duration, 1000*2), 0, 2000, 5, 100); 
  size = 40;
  color c = avgColor(mouseX, mouseY, size/2);
  fill(c);
  //ellipse(mouseX, mouseY, size, size);
  rect(mouseX-size, mouseY-size, size*2, size*2);
}