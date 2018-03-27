class Vector {
  float x;
  float y;
 
  public Vector(float x, float y) {
    this.x = x;
    this.y = y; 
  }
 
  //add a vector to this instance
  void add(Vector v) {
    x += v.x;
    y += v.y; 
  }
  
}
