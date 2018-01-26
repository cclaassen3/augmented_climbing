class Brick {
 
  Vector location;
  float bWidth;   //brick width
  float bLength;  //brick length
  color c;
  boolean broken;
  int hardness;

  public Brick(Vector l, float w, float len, color c, int h) {
    location = l;
    bWidth   = w;
    bLength  = len;
    this.c   = c;
    broken   = false;
    hardness = h;
  }
 
  void display() {
    fill(c);
    rect(location.x, location.y, bWidth, bLength);
  }
 
  //return the location
  Vector getLocation() {
    return location; 
  }
 
  //set the location
  void setLocation(Vector v) {
    location = v;
  }
 
  //return the width
  float getWidth() {
    return bWidth;
  }
 
  //return the length
  float getLength() {
    return bLength; 
  }
 
  //'breaks' the brick
  void breakBrick() {
    this.setLocation(new Vector(-100,-100));
    broken = true;
  }
 
  //return description of the brick
  String toString() {
    return "x: " + location.x + " y: " + location.y + " width: " + bWidth + " length: " + bLength;
  }
 
}