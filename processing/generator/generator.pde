import processing.svg.*;
import megamu.mesh.*;
import java.util.*;


boolean debug = false;


//Panel-related dimensions
int panelW = 380;
int panelH = int(panelW * 1.618);
int panelMargin = 10;
int panelPadding = 40;
int holeDiam = 9;
int deltaPanel = panelMargin+panelPadding;


//Star-related dimensions
int starNum = 12;
int starDiam = 13;
int starMargin = 50;
float[][] starfield = new float[starNum][2];
int[][] lines;
boolean[] remove;



void setup() {

  size(1200, 635);
  rectMode(CORNER);
  noFill();
  pixelDensity(2);

  randomSeed(5);

  placeStars();
  placeLines();

  //beginRecord(SVG, "filename.svg");
}



void draw() {

  background(255);
  strokeWeight(debug ? 1: 0.001);
  noFill();

  for (int f=0; f<3; f++) {
    rect(panelMargin+f*(panelW+panelMargin*2), panelMargin, panelW, panelH, 10, 10, 10, 10);
  }

  for (int f=0; f<starNum; f++) {

    float deltaRad = random(starDiam - holeDiam -1);

    //ellipse(starfield[f][0]+deltaPanel, starfield[f][1]+deltaPanel, 
    //  starDiam, starDiam);

    ellipse(2*panelMargin + panelW -starfield[f][0]-deltaPanel, starfield[f][1]+deltaPanel, 
      starDiam, starDiam);


    ellipse(starfield[f][0] + 2*(panelW+panelMargin*2)+deltaPanel, starfield[f][1]+deltaPanel, 
      holeDiam+deltaRad, holeDiam+deltaRad);

    fill(0);
    text(f, 2*panelMargin + panelW -starfield[f][0]-deltaPanel+ starDiam/2 + 3, starfield[f][1]+deltaPanel);
    if (debug) {
      text(f, starfield[f][0] + starDiam/2 + 3+ 2*(panelW+panelMargin*2)+deltaPanel, starfield[f][1]+deltaPanel);
    }
    noFill();
  }

  strokeWeight(1);
  for (int f=0; f<lines.length; f++) {

    int fromStar = lines[f][0];
    int toStar = lines[f][1];
    float startX = starfield[fromStar][0];
    float startY = starfield[fromStar][1];
    float endX = starfield[toStar][0];
    float endY = starfield[toStar][1];

    if (remove[f]) {
      if (debug) {
        stroke(0, 40);
      } else {
        continue;
      }
    }

    line( startX + 2*(panelW+panelMargin*2)+deltaPanel, startY+deltaPanel, endX + 2*(panelW+panelMargin*2)+deltaPanel, endY +deltaPanel);

    if (remove[f]) {
      stroke(0);
    }
  }

  noLoop();

  //endRecord();
}



void placeStars() {
  for (int f=0; f<starNum; f++) {
    boolean relocate = true;
    while (relocate) {
      relocate = false;
      starfield[f][0] = random(panelW-2*panelPadding);
      starfield[f][1] = random(panelW-panelPadding);
      for (int g=0; g<f; g++) {
        if (starDist(starfield[f], starfield[g])<starMargin) {
          relocate = true;
        }
      }
    }
  }
}



void  placeLines() {

  Delaunay myDelaunay = new Delaunay(starfield);
  lines = myDelaunay.getLinks();
  remove = new boolean[lines.length];

  Hull hull = new Hull(starfield);
  int[] extrema = hull.getExtrema();



  for (int f=0; f<extrema.length; f++) {

    int fromStar = extrema[f];
    int toStar = extrema[(f+1)%extrema.length];

    for (int g=0; g<lines.length; g++) {
      if ((lines[g][0]==fromStar && lines[g][1]==toStar) ||
        lines[g][0]==toStar && lines[g][1]==fromStar) {
        remove[g] = true;
      }
    }
  }
}


void keyPressed() {
  if (key==' ') {
    placeStars();
    placeLines();
    loop();
  }
}


float starDist(float[] s1, float[] s2) {
  PVector v1 = new PVector(s1[0], s1[1]);
  PVector v2 = new PVector(s2[0], s2[1]);
  return PVector.dist(v1, v2);
}
