import processing.svg.*;


int w = 380;
int h = int(w * 1.618);
int oft = 10;
int margin = 40;

int starRad = 9;
int starMargin = 50;
int starNum = 12;

PVector[] starField = new PVector[starNum];

void setup() {

  size(1200, 635);
  background(255);
  rectMode(CORNER);
  noFill();

  for (int f=0; f<starNum; f++) {
    boolean relocate = true;
    while (relocate) {
      relocate = false;
      starField[f] = new PVector(oft + random(w-2*margin) + margin, 
        oft + random(w-margin) + margin);
      for (int g=0; g<f; g++) {
        if (starField[f].dist(starField[g])<starMargin) {
          relocate = true;
        }
      }
    }
  }

  noLoop();
  //beginRecord(SVG, "filename.svg");
}

void draw() {

  for (int f=0; f<3; f++) {
    rect(oft+f*(w+oft*2), oft, w, h, 10, 10, 10, 10);
  }

  for (int f=0; f<starNum; f++) {
    ellipse(starField[f].x, starField[f].y, starRad, starRad);
  }

  //endRecord();
}
