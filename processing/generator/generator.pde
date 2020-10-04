import processing.svg.*;
import megamu.mesh.*;
import java.util.*;


boolean debug = true;
boolean record = false;
boolean twoPanels = true;


//Panel-related dimensions
int panelW = 380;
int panelH = int(panelW * 1.618);
int panelMargin = 10;
int panelPadding = 40;
int deltaPanel = panelMargin+panelPadding;


//Laser-cutter related values
float strokeRaster = 2;
float strokeCut = 0.01;


//Star-related values
int starNum = 12;
int ledDiam = 14;
int starMargin = 50;
int unconnectedStars;
float[][] starfield = new float[starNum][2];
int[][] lines;
boolean[] remove;
String[] names;
String[] starData = new String[6];


//Electronics
float traceW = 5*ledDiam/3;



void setup() {

  size(1200, 635);
  rectMode(CORNER);
  noFill();
  textSize(14); 

  randomSeed(13);

  names = loadStrings("data/latin_nouns.txt");

  placeStars();
  placeLines();
  generateText();
}



void draw() {

  background(255);

  if (record) {
    beginRecord(SVG, "constellation_"+nf((int)random(10000), 4)+ "_" + starData[0].toLowerCase() + ".svg");
  }



  //Panels (cut)
  strokeWeight(debug ? 1: strokeCut);
  noFill();  
  for (int f=0; f<(twoPanels?2:3); f++) {
    rect(panelMargin+f*(panelW+panelMargin*2), panelMargin, panelW, panelH, 10, 10, 10, 10);
  }
  rect(panelMargin+panelPadding*2, panelMargin+panelPadding*11, 
  panelW-panelPadding*4, (panelW-panelPadding*4)/1.618, 
  10, 10, 10, 10);



  //Trace guides (raster)
  strokeWeight(strokeRaster);
  fill(0);
  for (int f=0; f<4; f++) {
    text(char(65+f), getTraceX(f) + 7, panelMargin+panelPadding/2);
    line (getTraceX(f) + traceW/2, panelMargin+panelPadding/1.5, 
      getTraceX(f) + traceW/2, panelMargin+panelPadding/2 + traceW*2);
    line (getTraceX(f) + traceW/2, panelMargin+panelPadding*9, 
      getTraceX(f) + traceW/2, panelMargin+panelPadding*9+traceW*2);
  }
  if (debug) {
    stroke(200, 100, 200, 50);
    noFill();
    //rect(deltaPanel, deltaPanel, panelW-panelPadding*2, panelW-panelPadding*2);
    for (int f=0; f<4; f++) {
      rect (getTraceX(f), panelMargin+panelPadding, 
        traceW, panelH-panelMargin*2-panelPadding);
    }
    stroke(0);
  }



  //Blocks (debug)
  if (debug) {
    strokeWeight(1);
    stroke(200, 200, 100);
    noFill();
    for (int f=0; f<=4; f++) {
      float y = getBlockY(f);
      line(getTraceX(0)+traceW/2, y, getTraceX(3)+traceW/2, y);
    }
    stroke(0);
  }



  //Stars (cut)
  strokeWeight(debug ? 1: strokeCut);
  noFill();
  for (int f=0; f<starNum; f++) {
    float holeDiam = random(6, ledDiam-2);
    ellipse(2*panelMargin + panelW -starfield[f][0]-deltaPanel, starfield[f][1], 
      ledDiam, ledDiam);
    ellipse(starfield[f][0] + (twoPanels?1:2)*(panelW+panelMargin*2)+deltaPanel, starfield[f][1], 
      holeDiam, holeDiam);
  }



  //Star info (raster)
  fill(0);
  textSize(14);
  for (int f=0; f<starNum; f++) {
    String connectInfo = "";

    switch(f) {
    case 0:
    case 1: 
      connectInfo = "AD"; 
      break;
    case 2:
    case 3: 
      connectInfo = "AC"; 
      break;      
    case 4:
    case 5: 
      connectInfo = "CD"; 
      break;
    case 6:
    case 7: 
      connectInfo = "AB"; 
      break;
    case 8:
    case 9: 
      connectInfo = "BD"; 
      break;
    default:
      connectInfo = "BC";
    }    

    if (f%2==0) {
      connectInfo = "-" + connectInfo + "+";
    } else {
      connectInfo = "+" + connectInfo + "-";
    }

    textAlign(CENTER);
    text(connectInfo, 2*panelMargin + panelW -starfield[f][0]-deltaPanel, starfield[f][1]+ ledDiam*1.75);
    textAlign(LEFT);
    if (debug) {
      text(f+1, starfield[f][0] + ledDiam/2 + 4+ (twoPanels?1:2)*(panelW+panelMargin*2)+deltaPanel, starfield[f][1] + 5);
    }
  }
  noFill();



  //Lines (raster)
  strokeWeight(strokeRaster);
  for (int f=0; f<lines.length; f++) {
    int fromStar = lines[f][0];
    int toStar = lines[f][1];
    float startX = starfield[fromStar][0];
    float startY = starfield[fromStar][1];
    float endX = starfield[toStar][0];
    float endY = starfield[toStar][1];
    line( startX + (twoPanels?1:2)*(panelW+panelMargin*2)+deltaPanel, startY, 
      endX + (twoPanels?1:2)*(panelW+panelMargin*2)+deltaPanel, endY);
  }



  //Text (raster)
  textSize(32);
  text(starData[0], (twoPanels?1:2)*(panelW+panelMargin*2)+deltaPanel, panelW+panelPadding);
  textSize(15); 
  text(starData[1], (twoPanels?1:2)*(panelW+panelMargin*2)+deltaPanel+1, panelW+panelPadding+40);
  text(starData[2], (twoPanels?1:2)*(panelW+panelMargin*2)+deltaPanel+1, panelW+panelPadding+64);
  text(starData[3], (twoPanels?1:2)*(panelW+panelMargin*2)+deltaPanel+1, panelW+panelPadding+88);
  text(starData[4], (twoPanels?1:2)*(panelW+panelMargin*2)+deltaPanel+1, panelW+panelPadding+112);
  text(starData[5], (twoPanels?1:2)*(panelW+panelMargin*2)+deltaPanel+1, panelW+panelPadding+136);


  noLoop();
  if (record) {
    endRecord();
  }
}



void placeStars() {

  //float blockHeight = getBlockY(1) - getBlockY(0) ;

  for (int f=0; f<starNum; f++) {
    boolean relocate = true;
    while (relocate) {
      relocate = false;

      //X coordinate. Do not place on copper trace.
      starfield[f][0] = random(panelW-2*panelPadding);
      float sx = starfield[f][0] + deltaPanel;
      if (sx>=getTraceX(1)-ledDiam/2-1 && sx<=getTraceX(1)+traceW+ledDiam/2+1) {
        relocate = true;
        continue;
      }
      if (sx>=getTraceX(2)-ledDiam/2-1 && sx<=getTraceX(2)+traceW+ledDiam/2+1) {
        relocate = true;
        continue;
      }

      //Y coordinate. Asign to the corresponding block
      int block = 0;
      switch(f) {
      case 0:
      case 1: 
        block = 1; 
        break;
      case 2:
      case 3: 
      case 4:
      case 5: 
        block = 2; 
        break;
      case 6:
      case 7: 
      case 8:
      case 9: 
        block = 3; 
        break;
      default:
        block = 4;
      }
      //starfield[f][1] = random(panelW-2*panelPadding);
      starfield[f][1] = random(getBlockY(block-1)+ledDiam/2+1, getBlockY(block)-ledDiam/2-1);
      for (int g=0; g<f; g++) {
        if (starDist(starfield[f], starfield[g])<starMargin) {
          relocate = true;
          continue;
        }
      }
    }
  }
}




void generateText() {

  //Name
  starData[0] = "";
  while (starData[0].length()<=2 || starData[0].length()>=18 ) {
    starData[0] = names[(int)random(names.length)];
  }
  starData[0] = starData[0].substring(0, 1).toUpperCase() + starData[0].substring(1);

  //Coordinates
  starData[1] = nf((int)random(24), 2) + "h "+nf((int)random(60), 2) +"m "+nf((int)random(60), 2) +"s," +
    " "+nfp((int)random(24)-12, 2)+"º "+nf((int)random(60), 2) +"' "+nf((int)random(60), 2) +"\"";

  //Distance
  starData[2] = "Distance: "+nf(random(1.3, 100), 1, 2)+"pc";

  //Number of stars
  starData[3] = "Main stars: " + (starNum-unconnectedStars);

  //Brightest star
  String[] brightnessLevels = {"α", "α", "α", "β", "β", "γ", "δ", "ε"};
  starData[4] = "Brightest star: "+brightnessLevels[(int)random(brightnessLevels.length)]+" " + starData[0].substring(0, 3) +" "+ nf(random(-0.5, 6.5), 1, 2)+"m";

  starData[5] = "Catalogued in "+(int)random(1600, 1825)+" by "+char((int)random(65, 91))+". Xxxxxxxxx";
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


  //Remove most of the triangles
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
    //This is ugly but oh so convenient...
    for (int g = 0; g<10 && graph[f].size()>=2; g++) {
      int star1 = (int)graph[f].get(g % graph[f].size());
      int star2 = (int)graph[f].get((g+1) % graph[f].size());
      int position = graph[star1].indexOf(star2);
      if (position>=0) {
        println("pass " + g + "      triangle ", f, "-", star1, "-", star2);
        int[] vertices = {f, star1, star2};
        int v1 = (int)random(3);
        int v2 = (v1+1)%3;
        graph[vertices[v1]].remove((Integer)vertices[v2]);        
        graph[vertices[v2]].remove((Integer)vertices[v1]);
      }
    }
  }


  //If a star has more than 3 connections we prune them to three
  for (int f=0; f<starNum; f++) {
    while (graph[f].size()>3) {
      int v1 = (int)random(graph[f].size());
      int star1 = (int) graph[f].get(v1);
      println("Deleting line between", f, "and", star1);
      graph[f].remove((Integer)star1);        
      graph[star1].remove((Integer)f);
    }
  }


  //Update the number of unconnected stars
  unconnectedStars=0;
  for (int f=0; f<starNum; f++) {
    if (graph[f].size()==0) {
      unconnectedStars++;
    }
  }



  //Trim the graph...
  int totalLines = 0;
  for (int f=0; f<starNum; f++) {
    for (int g=f; g>=0; g--) {
      graph[f].remove((Integer)g);
    }
    totalLines += graph[f].size();
  }
  println("-----------");


  //... and transform it into an array
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
    generateText();
    loop();
  }
}


float starDist(float[] s1, float[] s2) {
  PVector v1 = new PVector(s1[0], s1[1]);
  PVector v2 = new PVector(s2[0], s2[1]);
  return PVector.dist(v1, v2);
}


float getTraceX(int index) {
  return map(index, 0, 3, panelMargin+panelPadding/2, panelW+panelMargin-panelPadding/2) - traceW/2;
}

float getBlockY(int index) {
  return map(index, 0, 4, deltaPanel, panelW+panelMargin-panelPadding);
}
