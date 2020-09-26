import processing.svg.*;
import java.util.*;


int w = 380;
int h = int(w * 1.618);
int oft = 10;
int margin = 40;

int starRad = 13;
int starMargin = 60;
int starNum = 12;

float angleMargin = 20.0;

int holeRad = 9;

PVector[] starField = new PVector[starNum];
ArrayList<Line> lines = new ArrayList<Line>();



void setup() {

  size(1200, 635);
  rectMode(CORNER);
  noFill();
  pixelDensity(2);

  randomSeed(4);

  placeStars();
  placeLines();
  //noLoop();

  //beginRecord(SVG, "filename.svg");
}



void draw() {

  background(255);
  strokeWeight(0.001);
  //noFill();

  for (int f=0; f<3; f++) {
    rect(oft+f*(w+oft*2), oft, w, h, 10, 10, 10, 10);
  }

  for (int f=0; f<starNum; f++) {
    float deltaRad = random(starRad - holeRad -1);
    //strokeWeight(0.001);
    //stroke(0);
    //noFill();
    ellipse(starField[f].x, starField[f].y, 
      starRad, starRad);
    ellipse(starField[f].x + 2*(w+oft*2), starField[f].y, 
      holeRad+deltaRad, holeRad+deltaRad);
    //strokeWeight(1);
    //fill(0);
    //text(f, starField[f].x, starField[f].y);
  }

  strokeWeight(1);
  for (int f=0; f<lines.size(); f++) {
    int fromStar = lines.get(f).fromStar;
    int toStar = lines.get(f).toStar;
    if (!lines.get(f).removed) {
      stroke(0);
    } else {
      stroke(150, 150, 255);
    }
    line(starField[fromStar].x, starField[fromStar].y, 
      starField[toStar].x, starField[toStar].y );
  }

  noLoop();

  //endRecord();
}



void placeStars() {
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
}



void  placeLines() {

  lines.clear();

  //Create all lines
  for (int f=0; f<starNum; f++) {
    for (int g=0; g<f; g++) {
      Line newLine = new Line(f, g);
      lines.add(newLine);
    }
  }

  //Mark intersections
  Collections.shuffle(lines, new Random(44));
  for (int f=0; f<lines.size(); f++) {
    for (int g=0; g<f; g++) {
      Line l = lines.get(f);
      if (l.intersects(lines.get(g)) && !lines.get(g).removed) {
        l.removed=true;
        lines.set(f, l);
      }
    }
  }

  //Clear array
  for (int f=lines.size()-1; f>=0; f--) {
    if (lines.get(f).removed) {
      lines.remove(f);
    }
  }

  for (int f=0; f<starNum; f++) {

    println("Star ", f);

    HashMap<Integer, Float> angleDict = new HashMap<Integer, Float>();

    for (int g=0; g<lines.size(); g++) {
      Line l = lines.get(g);
      if (l.fromStar == f) {
        angleDict.put(l.toStar, null);
      } else if (l.toStar == f) {
        angleDict.put(l.fromStar, null);
      }
    }

    Integer[] neighbours = angleDict.keySet().toArray(new Integer[0]);
    angleDict.put(neighbours[0], 0.0);

    Line aL = new Line(f, neighbours[0]);
    PVector aV = aL.toPVector();

    for (int g=1; g<neighbours.length; g++) {
      Line bL = new Line(f, neighbours[g]);
      PVector bV = bL.toPVector();
      angleDict.put(neighbours[g], degrees(atanAngle(aV, bV)));
    }

    angleDict = sortByValue(angleDict);
    println(angleDict);

    neighbours = angleDict.keySet().toArray(new Integer[0]);
    for (int g=1; g<neighbours.length; g++) {
      if (abs(angleDict.get(neighbours[g-1])-angleDict.get(neighbours[g]))<angleMargin) {
        println(neighbours[g-1], neighbours[g]);
        for (int h=0; h<lines.size(); h++) {
          Line l = lines.get(h);
          if ((l.fromStar == neighbours[g] && l.toStar==f)||
            (l.fromStar == f && l.toStar==neighbours[g])) {
            l.removed = true;
            lines.set(h, l);
          }
        }
      }
    }
  }

  //Clear array
  for (int f=lines.size()-1; f>=0; f--) {
    if (lines.get(f).removed) {
      lines.remove(f);
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


//OLD CODE
//SUBSTRACTIVE 1
//for (int f=0; f<starNum; f++) {
//  for (int g=0; g<f; g++) {
//    Line newLine = new Line(f, g);
//    boolean addLine = true;
//    for (int h=0; h<lines.size(); h++) {
//      if (newLine.intersects(lines.get(h))) {
//        addLine = false;
//      }
//    }
//    if (addLine) {
//      lines.add(newLine);
//    }
//  }
//}
//SUBSTRACTIVE 1


//ADDITIVE
//for (int f=0; f<1200; f++) {

//  Line newLine = new Line(0, 0);
//  boolean choosePair = true;
//  while (choosePair) {
//    choosePair = false;

//    int fromStar = int(random(starNum));
//    int toStar = fromStar;
//    while (fromStar==toStar) {
//      toStar = int(random(starNum));
//    }

//    newLine = new Line(fromStar, toStar);
//    for (int g=0; g<f; g++) {
//      if (newLine.intersects(lines.get(g))) {
//        choosePair = true;
//      }
//    }
//  }
//  lines.add(new Line(newLine.fromStar, newLine.toStar));
//}
//ADDITIVE

float atanAngle(PVector v1, PVector v2) {
  float a = atan2(v2.y, v2.x) - atan2(v1.y, v1.x);
  if (a < 0) a += TWO_PI;
  return a;
}


//https://www.geeksforgeeks.org/sorting-a-hashmap-according-to-values/
HashMap<Integer, Float> sortByValue(HashMap<Integer, Float> hm) { 

  List<Map.Entry<Integer, Float> > list = 
    new LinkedList<Map.Entry<Integer, Float> >(hm.entrySet()); 

  Collections.sort(list, new Comparator<Map.Entry<Integer, Float> >() { 
    public int compare(Map.Entry<Integer, Float> o1, 
      Map.Entry<Integer, Float> o2) { 
      return (o1.getValue()).compareTo(o2.getValue());
    }
  }
  ); 

  HashMap<Integer, Float> temp = new LinkedHashMap<Integer, Float>(); 
  for (Map.Entry<Integer, Float> aa : list) { 
    temp.put(aa.getKey(), aa.getValue());
  } 
  return temp;
} 
