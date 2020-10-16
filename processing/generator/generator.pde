import processing.svg.*;
import megamu.mesh.*;
import java.util.*;


boolean debug = false;
boolean record = true;
boolean keyring = false;

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
int ledDiam = 16;
int starMargin = 32;
int unconnectedStars;
float[][] starfield = new float[starNum][2];
int[][] lines;
boolean[] remove;
String[] starNames;
String[] surnames;
String[] starData = new String[6];


//Electronics
float traceW = 5*13/3; //5mm



void setup() {

  size(1200, 635);
  rectMode(CORNER);
  noFill();
  textSize(14); 

  randomSeed(18);

  starNames = loadStrings("data/latin_nouns.txt");
  surnames = loadStrings("data/surnames.txt");

  placeStars();
  placeLines();
  generateText();
}



void draw() {

  background(255);

  if (record) {
    beginRecord(SVG, "constellation_"+nf((int)random(10000), 4)+ "_" + starData[0].toLowerCase() + ".svg");
  }



  //Set origin to panel top left corner
  pushMatrix();
  translate(panelMargin, panelMargin);



  //Panels (cut)
  strokeWeight(debug ? 1: strokeCut);
  noFill();  
  rect(panelPadding*2, panelPadding*11, 
    panelW-panelPadding*4, (panelW-panelPadding*4)/1.618, 
    10, 10, 10, 10);
  for (int f=0; f<2; f++) {
    rect(0, 0, panelW, panelH, 10, 10, 10, 10);
    translate(panelW+panelMargin*2, 0);
  }
  
  //Ring layer
  rect(0, 0, traceW*2, panelH, 10, 10, 10, 10);
  line(traceW, 0, traceW, panelH);
  translate(traceW*2+panelMargin*2, 0);
  rect(0, 0, traceW*2, panelW-traceW*2+1);
  line(traceW, 0, traceW, panelW-traceW*2+1);


  //Set origin to starfield top left corner
  popMatrix();
  pushMatrix();
  translate(deltaPanel, deltaPanel);



  //Trace guides (raster)
  strokeWeight(strokeRaster);
  fill(0);
  textAlign(LEFT);

  for (int f=0; f<4; f++) {
    float x = getTraceX(f);
    text(char(65+f), x-4, -panelPadding/8-1);
    line (x, 6, x, -panelPadding/2+6+traceW*3);
    line (x, panelPadding*8, x, panelPadding*8+traceW*2);
  }
  if (debug) {
    stroke(200, 100, 200, 50);
    noFill();
    rect(0, 0, panelW-panelPadding*2, panelW-panelPadding*2);
    for (int f=0; f<4; f++) {
      rect (getTraceX(f)-traceW/2, 0, traceW, panelW-panelPadding);
    }
    stroke(0);
  }



  //Led holes (cut)
  strokeWeight(debug ? 1: strokeCut);
  noFill();
  for (int f=0; f<starNum; f++) {
    ellipse(starfield[f][0], starfield[f][1], ledDiam, ledDiam);
  }



  //Star info (raster)
  fill(0);
  textSize(14);
  textAlign(CENTER);

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

    text(connectInfo, starfield[f][0], starfield[f][1]+ ledDiam*1.5);
  }
  noFill();



  //Mirror coordinates
  popMatrix();
  pushMatrix();
  translate(panelW*2-panelMargin, deltaPanel);
  scale(-1, 1);



  //Stars (cut)
  for (int f=0; f<starNum; f++) {
    float holeDiam = random(6, ledDiam-4);
    ellipse(starfield[f][0], starfield[f][1], holeDiam, holeDiam);
  }


  //Lines (raster)
  strokeWeight(strokeRaster);
  for (int f=0; f<lines.length; f++) {
    int fromStar = lines[f][0];
    int toStar = lines[f][1];
    float startX = starfield[fromStar][0];
    float startY = starfield[fromStar][1];
    float endX = starfield[toStar][0];
    float endY = starfield[toStar][1];
    line( startX, startY, endX, endY);
  }



  //Set coordinates to text origin
  popMatrix();
  pushMatrix();
  translate(deltaPanel+panelW+panelMargin*2, deltaPanel+panelW);


  //Text (raster)
  textSize(32);
  textAlign(LEFT);
  text(starData[0], 0, 0);
  textSize(15); 
  text(starData[1], 1, 40);
  text(starData[2], 1, 64);
  text(starData[3], 1, 88);
  text(starData[4], 1, 112);
  text(starData[5], 1, 136);



  //Restore transforms
  popMatrix();


  if (keyring) {
    //Lot of magic numbers, not proud of it.
    pushMatrix();
    translate(panelPadding*3.25, deltaPanel+panelPadding*10.4);
    scale(-0.357, 0.357);
    rotate(PI/2);
    //Lines (raster)
    strokeWeight(strokeCut);
    ellipse(150, -65, 35, 35);
    strokeWeight(strokeRaster*2);
    for (int f=0; f<lines.length; f++) {
      int fromStar = lines[f][0]; 
      int toStar = lines[f][1];
      float startX = starfield[fromStar][0];
      float startY = starfield[fromStar][1];
      float endX = starfield[toStar][0];
      float endY = starfield[toStar][1];
      line( startX, startY, endX, endY);
    }
    popMatrix();
    pushMatrix();
    translate(panelPadding*7, deltaPanel+panelPadding*11.7);
    scale(0.357, 0.357);
    rotate(-PI/2);
    textSize(40);
    textAlign(CENTER);
    text(starData[0], 0, 0);
    popMatrix();
    textSize(14);
  }


  noLoop();
  if (record) {
    endRecord();
  }
}



void placeStars() {

  boolean refresh = true;

  while (refresh) {

    refresh = false;

    for (int f=0; f<starNum; f++) {

      //Y coordinate
      starfield[f][1] =ledDiam/2+random(panelW-2*panelPadding-ledDiam);

      //X coordinate
      int traceX = f/2;
      switch(traceX) {
      case 0:
        starfield[f][0] = random(getTraceX(0)+ledDiam/2+traceW/2, getTraceX(3)-traceW/2-ledDiam/2);
        break;
      case 1:
        starfield[f][0] = random(getTraceX(0)+ledDiam/2+traceW/2, getTraceX(2));
        break;        
      case 2:
        starfield[f][0] = random(getTraceX(2), getTraceX(3)-traceW/2-ledDiam/2);
        break;
      case 3:
        starfield[f][0] =random(getTraceX(0)+ledDiam/2+traceW/2, getTraceX(1));
        break;         
      case 4:
        starfield[f][0] =random(getTraceX(1), getTraceX(3)-traceW/2-ledDiam/2);
        break;         
      default:
        starfield[f][0] =random(getTraceX(1), getTraceX(2));
      }

      //Quick and dirty: if a star is on the copper trace, its position is regenerated.
      float sx = starfield[f][0];
      if (sx-ledDiam/2<=0 ||
        sx+ledDiam/2>=panelW-2*panelPadding||
        sx>=getTraceX(1)-traceW/2-ledDiam/2 && sx<=getTraceX(1)+traceW/2+ledDiam/2||
        sx>=getTraceX(2)-traceW/2-ledDiam/2 && sx<=getTraceX(2)+traceW/2+ledDiam/2) {
        f=f-1;
      }
    }

    for (int f=0; f<starNum; f++) {
      //Remove if too close or if on the same "line"
      for (int g=0; g<f; g++) {
        if (starDist(starfield[f], starfield[g])<starMargin) {
          refresh = true;
          break;
        }
        if (abs(starfield[f][1]-starfield[g][1])<ledDiam*0.75) {
          refresh = true;
          break;
        }
      }
    }
  }
}




void generateText() {

  //Name
  starData[0] = "";
  while (starData[0].length()<=2 || starData[0].length()>=18 ) {
    starData[0] = starNames[(int)random(starNames.length)];
  }
  starData[0] = starData[0].substring(0, 1).toUpperCase() + starData[0].substring(1);

  //Coordinates
  starData[1] = nf((int)random(24), 2) + "h "+nf((int)random(60), 2) +"m "+nf((int)random(60), 2) +"s," +
    " "+nfp((int)random(180)-90, 2)+"º "+nf((int)random(60), 2) +"' "+nf((int)random(60), 2) +"\"";

  //Distance
  starData[2] = "Distance: "+nf(random(1.3, 100), 1, 2)+"pc";

  //Number of stars
  starData[3] = "Main stars: " + (starNum-unconnectedStars);

  //Brightest star
  String[] brightnessLevels = {"α", "α", "α", "β", "β", "γ", "δ", "ε"};
  starData[4] = "Brightest star: "+brightnessLevels[(int)random(brightnessLevels.length)]+" " + starData[0].substring(0, 3) +" "+ nf(random(-0.5, 6.5), 1, 2)+"m";

  String surname = surnames[(int)random(surnames.length)];
  surname = surname.substring(0, 1).toUpperCase() + surname.substring(1);
  starData[5] = "Catalogued in "+(int)random(1600, 1825)+" by "+char((int)random(65, 91))+". " + surname;
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
  float x = map(index, 0, 3, 0, panelW-panelPadding*2);
  if (index==0) {
    //x -= traceW;
  } else if (index==3) {
    //x += traceW;
  }
  return x;
}

float getBlockY(int index) {
  return map(index, 0, 4, 0, panelW-panelPadding*2);
}
