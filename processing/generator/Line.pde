class Line {

  int fromStar, toStar;
  boolean removed = false;

  Line(int _from, int _to) {
    fromStar = _from;
    toStar = _to;
  }

  boolean intersects(Line l) {
    PVector v1 = starField[fromStar];
    PVector v2 = starField[toStar];
    PVector v3 = starField[l.fromStar];
    PVector v4 = starField[l.toStar];

    float uA = ((v4.x-v3.x)*(v1.y-v3.y) - (v4.y-v3.y)*(v1.x-v3.x)) / ((v4.y-v3.y)*(v2.x-v1.x) - (v4.x-v3.x)*(v2.y-v1.y));
    float uB = ((v2.x-v1.x)*(v1.y-v3.y) - (v2.y-v1.y)*(v1.x-v3.x)) / ((v4.y-v3.y)*(v2.x-v1.x) - (v4.x-v3.x)*(v2.y-v1.y));

    return (uA > 0.001 && uA < 0.999 && uB > 0.001 && uB < 0.999);
  }
  
  String toString() {
    return fromStar + ", " + toStar;
  }
  
  PVector toPVector(){
    PVector v1 = starField[fromStar];
    PVector v2 = starField[toStar];
    return PVector.sub(v2, v1);
  }
}
