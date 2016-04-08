// TODO: file bug about wonky java errors with multiline comments

// Haha, this is totally that Chvrches album

// TODO: make a version of this that just runs automatically & repeatedly on random portions of the image

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

float covar(int x_, int y_, int radius) {
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
  float rmean = r/n;
  float gmean = g/n;
  float bmean = b/n;
  r=0;
  b=0;
  g=0;
  n=0;
  
  for (int x=x_-slop; x <= x_+slop; x++) {
    for (int y=y_-slop; y <= y_+slop; y++) {
      if (x < 0 || y < 0 || x >= w || y >= h) {
        continue;
      }
      color c = img.pixels[y*w+x];
      r += sq(red(c)-rmean);
      b += sq(blue(c)-bmean);
      g += sq(green(c)-gmean);
      n += 1;
    }
  }
  
  float rvar = r/n;
  float gvar = g/n;
  float bvar = b/n;
  //float m = max(rvar, gvar, bvar);
  float m = (rvar + gvar + bvar)/3;
  println(m);
  return m;
}
 
void mouseClicked() { 
  int radius = 2;
  while (covar(mouseX, mouseY, radius+1) < 400.0) {
    radius += 1;
  }
  println("");
  color c = avgColor(mouseX, mouseY, radius);
  fill(c);
  // TODO: in the ellipse case, would be good to calculate variance on precisely the region that's going to be filled
  //ellipse(mouseX, mouseY, radius*2, radius*2);
  rect(mouseX-radius, mouseY-radius, radius*2, radius*2);
}