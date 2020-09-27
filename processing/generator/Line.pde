class Line {

  int fromStar, toStar;
  boolean removed = false;

  Line(int _from, int _to) {
    fromStar = _from;
    toStar = _to;
  }

  boolean intersects(Line l) {
    PVector v1 = new PVector(starfield[fromStar][0], starfield[fromStar][1]);
    PVector v2 = new PVector(starfield[toStar][0], starfield[toStar][1]);
    PVector v3 = new PVector(starfield[l.fromStar][0], starfield[l.fromStar][1]);
    PVector v4 = new PVector(starfield[l.toStar][0], starfield[l.toStar][1]);

    float uA = ((v4.x-v3.x)*(v1.y-v3.y) - (v4.y-v3.y)*(v1.x-v3.x)) / ((v4.y-v3.y)*(v2.x-v1.x) - (v4.x-v3.x)*(v2.y-v1.y));
    float uB = ((v2.x-v1.x)*(v1.y-v3.y) - (v2.y-v1.y)*(v1.x-v3.x)) / ((v4.y-v3.y)*(v2.x-v1.x) - (v4.x-v3.x)*(v2.y-v1.y));

    return (uA > 0.001 && uA < 0.999 && uB > 0.001 && uB < 0.999);
  }
  
  String toString() {
    return fromStar + ", " + toStar;
  }
  
  PVector toPVector(){
    PVector v1 = new PVector(starfield[fromStar][0], starfield[fromStar][1]);
    PVector v2 = new PVector(starfield[toStar][0], starfield[toStar][1]);
    return PVector.sub(v2, v1);
  }
}
