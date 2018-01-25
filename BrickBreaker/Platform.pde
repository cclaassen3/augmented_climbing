class Platform {
  
  Vector location;
  Vector velocity;
  float pWidth;    //platform width (determines size in x-direction)
  float pLength;   //platform length (determines size in y-direction)
  color c;
  
  public Platform(Vector l, Vector v, float w, float len, color c) {
    location = l;
    velocity = v;
    pWidth   = w;
    pLength  = len;
    this.c   = c;
  }
  
  //draws the platform
  void display() {
    fill(c);
    rect(location.x,location.y,pWidth,pLength);
  }
  
  //move the platform
  void move() {
    if (keyPressed) {
      if (key == CODED) {
        if (keyCode == RIGHT)
          moveRight();     
          
        if (keyCode == LEFT)
          moveLeft();
      }
    } 
  }
  
  //move the platform to the right
  void moveRight() {
    if (this.location.x + pWidth <= width - 25)
      location.x += 5;
  }
  
  //move the platform to the left
  void moveLeft() {
    if (this.location.x >= 25)
      location.x -= 5;
  }
  
  //return the location
  Vector getLocation() {
    return location; 
  }
  
  //return the width
  float getWidth() {
    return pWidth; 
  }
  
  //return the length
  float getLength() {
    return pLength; 
  }
  
  //return the platform to it's starting position - in the middle of the screen
  void returnToOrigin() {
    this.setLocation(new Vector(width/2 - pLength, 350));
  }
  
  //set the location
  void setLocation(Vector v) {
    this.location = v; 
  }
  
 
}