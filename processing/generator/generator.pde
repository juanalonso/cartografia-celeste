import processing.svg.*;
import megamu.mesh.*;
import java.util.*;


boolean debug = false;
boolean record = true;
boolean twoPanels = true;


//Panel-related dimensions
int panelW = 380;
int panelH = int(panelW * 1.618);
int panelMargin = 10;
int panelPadding = 40;
int holeDiam = 9;
int deltaPanel = panelMargin+panelPadding;


//Laser-cutter related values
float strokeRaster = 1;
float strokeCut = 0.01;


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

  randomSeed(4);

  placeStars();
  placeLines();

}



void draw() {

  background(255);

  if (record) {
    beginRecord(SVG, "constellation_"+nf((int)random(10000), 4)+".svg");
  }

  strokeWeight(debug ? strokeRaster: strokeCut);
  noFill();

  for (int f=0; f<(twoPanels?2:3); f++) {
    rect(panelMargin+f*(panelW+panelMargin*2), panelMargin, panelW, panelH, 10, 10, 10, 10);
  }

  for (int f=0; f<starNum; f++) {

    float deltaRad = random(starDiam - holeDiam -1);

    //ellipse(starfield[f][0]+deltaPanel, starfield[f][1]+deltaPanel, 
    //  starDiam, starDiam);

    ellipse(2*panelMargin + panelW -starfield[f][0]-deltaPanel, starfield[f][1]+deltaPanel, 
      starDiam, starDiam);

    ellipse(starfield[f][0] + (twoPanels?1:2)*(panelW+panelMargin*2)+deltaPanel, starfield[f][1]+deltaPanel, 
      holeDiam+deltaRad, holeDiam+deltaRad);

    fill(0);
    text(f, 2*panelMargin + panelW -starfield[f][0]-deltaPanel+ starDiam/2 + 4, starfield[f][1]+deltaPanel+4);
    if (debug) {
      text(f, starfield[f][0] + starDiam/2 + 3+ (twoPanels?1:2)*(panelW+panelMargin*2)+deltaPanel, starfield[f][1]+deltaPanel);
    }
    noFill();
  }

  strokeWeight(strokeRaster);
  for (int f=0; f<lines.length; f++) {

    int fromStar = lines[f][0];
    int toStar = lines[f][1];
    float startX = starfield[fromStar][0];
    float startY = starfield[fromStar][1];
    float endX = starfield[toStar][0];
    float endY = starfield[toStar][1];

    line( startX + (twoPanels?1:2)*(panelW+panelMargin*2)+deltaPanel, startY+deltaPanel, 
      endX + (twoPanels?1:2)*(panelW+panelMargin*2)+deltaPanel, endY +deltaPanel);
  }

  noLoop();
  if (record) {
    endRecord();
  }
}



void placeStars() {
  for (int f=0; f<starNum; f++) {
    boolean relocate = true;
    while (relocate) {
      relocate = false;
      starfield[f][0] = random(panelW-2*panelPadding);
      starfield[f][1] = random(panelW-2*panelPadding);
      for (int g=0; g<f; g++) {
        if (starDist(starfield[f], starfield[g])<starMargin) {
          relocate = true;
        }
      }
    }
  }
}



void  placeLines() {

  //Calculate Delaunay triangulation
  Delaunay delaunay = new Delaunay(starfield);
  lines = delaunay.getLinks();

  //lines include some (0,0) tuples at the end of it. We can remove them
  for (int g=0; g<lines.length; g++) {
    if (lines[g][0]==0 && lines[g][1]==0) {
      lines = Arrays.copyOf(lines, g);
      break;
    }
  }
  remove = new boolean[lines.length];


  //Calculate convex hull
  Hull hull = new Hull(starfield);
  int[] extrema = hull.getExtrema();


  //Remove convex hull from triangulation
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


  //Remove some triangles
  ArrayList[] graph = new ArrayList[starNum];
  for (int f=0; f<starNum; f++) {
    graph[f] = new ArrayList();
  }
  for (int f=0; f<lines.length; f++) {
    if (!remove[f]) {
      graph[lines[f][0]].add(lines[f][1]);
      graph[lines[f][1]].add(lines[f][0]);
    }
  }
  for (int f=0; f<starNum; f++) {
    if (graph[f].size()>=2) {
      int star1 = (int)graph[f].get(0);
      int star2 = (int)graph[f].get(1);
      int position = graph[star1].indexOf(star2);
      if (position>=0) {
        println("triangle ", f, "-", star1, "-", star2, "found");
        int[] vertices = {f, star1, star2};
        int v1 = (int)random(3);
        int v2 = (v1+1)%3;
        graph[vertices[v1]].remove((Integer)vertices[v2]);        
        graph[vertices[v2]].remove((Integer)vertices[v1]);
      }
    }
  }
  int totalLines = 0;
  for (int f=0; f<starNum; f++) {
    for (int g=f; g>=0; g--) {
      graph[f].remove((Integer)g);
    }
    totalLines += graph[f].size();
  }
  println("-----------");
  lines = new int[totalLines][2];

  int count = 0;
  for (int f=0; f<starNum; f++) {
    for (int g=0; g<graph[f].size(); g++) {
      lines[count][0] = f;
      lines[count][1] = (int)graph[f].get(g);
      count++;
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
