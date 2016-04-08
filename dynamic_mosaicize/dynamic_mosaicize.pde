// TODO: file bug about wonky java errors with multiline comments

// Haha, this is totally that Chvrches album

// TODO: make a version of this that just runs automatically & repeatedly on random portions of the image

// TODO: make a version that draws rectangles that can iteratively grow in whatever direction accomodates them

// TODO: s to save, p to pause. Try out some other base images.

// TODO: figure out how to get some more modular structure in here. Nice to have a few different smallish variants on a given sketch. There's got to be a better way to do that than copy-pasting into a new, mostly-duplicated sketch, or commenting/uncommenting code blocks within one sketch 

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

color avgColor(int x_, int y_, int radius) {
  return avgColor(x_, y_, radius, radius, radius, radius);
}

color avgColor(int x_, int y_, int left, int right, int top, int bottom) { 
  int n = 0;
  float r = 0;
  float b = 0;
  float g = 0;
  for (int x=x_-left; x <= x_+right; x++) {
    for (int y=y_-top; y <= y_+bottom; y++) {
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

float covar(int x, int y, int radius) {
  return covar(x, y, radius, radius, radius, radius);
}

float covar(int x_, int y_, int left, int right, int top, int bottom) {
  int n = 0;
  float r = 0;
  float b = 0;
  float g = 0;
  for (int x=x_-left; x <= x_+right; x++) {
    for (int y=y_-top; y <= y_+bottom; y++) {
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
  
  for (int x=x_-left; x <= x_+right; x++) {
    for (int y=y_-top; y <= y_+bottom; y++) {
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
  float m = max(rvar, gvar, bvar);
  //float m = (rvar + gvar + bvar)/3;
  println(m);
  return m;
}

void drawBubble(int x, int y) {
  int radius = 2;
  float thresh = 400.0;
  while (covar(x, y, radius+1) < thresh) {
    radius += 1;
  }
  boolean l = true;
  int nl = radius;
  boolean r = true;
  int nr = radius;
  boolean t = true;
  int nt = radius;
  boolean b = true;
  int nb = radius;
  while (l || r || t || b) {
    if (l) {
      if (covar(x, y, nl+1, nr, nt, nb) < thresh && x-nl >= 0) {
        nl += 1;
      } else {
        l = false;
      }
    }
    if (r) {
      if (covar(x, y, nl, nr+1, nt, nb) < thresh && x+nr < w) {
        nr += 1;
      } else {
        r = false;
      }
    }
    
    if (t) {
      if (covar(x, y, nl, nr, nt+1, nb) < thresh && y-nt >= 0) {
        nt += 1;
      } else {
        t = false;
      }
    }
    if (b) {
      if (covar(x, y, nl, nr, nt, nb+1) < thresh && y+nb < h) {
        nb += 1;
      } else {
        b = false;
      }
    }
  }
    
  
  println("");
  color c = avgColor(x, y, nl, nr, nt, nb);
  fill(c);
  // TODO: in the ellipse case, would be good to calculate variance on precisely the region that's going to be filled
  //ellipse(mouseX, mouseY, radius*2, radius*2);
  rect(x-nl, y-nt, nl+nr, nt+nb);
}
 
void mouseClicked() { 
  drawBubble(mouseX, mouseY);
}