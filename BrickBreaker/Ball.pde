class Ball {
  
  Vector location;
  Vector velocity;
  float radius;
  color c;
 
  public Ball(Vector l, Vector v, float r, color c) {
    location = l;
    velocity = v;
    radius   = r;
    this.c   = c;
  }
 
  //draws the ball
  void display() {
    fill(c);
    ellipse(location.x,location.y,radius*2,radius*2);
  }
 
  //moves the ball and detects if it hits the wall
  void move() {
    location.add(velocity);
    if (location.x - radius <= 0 || location.x + radius >= width) {
      velocity.x *= -1;
    }
   
    if (location.y - radius <= 0) {
      velocity.y *= -1;
    }
  }
 
  //return the location
  Vector getLocation() {
    return location; 
  }
 
  //determines if the ball has collided with the platform
  void detectCollision(Platform p) {
    Vector pLoc = p.getLocation();
   
    if ((this.location.x + radius >= pLoc.x && this.location.x + radius <= pLoc.x + p.getWidth() + 1) &&
        (this.location.y + radius >= pLoc.y && this.location.y - radius <= pLoc.y + p.getLength() + 1)) {
           velocity.y *= -1;
    }
  }
 
  //determine if the ball has collided with a brick
  boolean detectCollision(Brick b) {
    Vector bLoc = b.getLocation();
   
    if ((this.location.x + radius >= bLoc.x && this.location.x + radius <= bLoc.x + b.getWidth()) &&
        (this.location.y + radius >= bLoc.y && this.location.y - radius <= bLoc.y + b.getLength())) {
           velocity.y *= -1;
           b.breakBrick();
           return true;
    }
       
    return false;
  }
 
  //return to the ball to it's starting position - on top of the platform
  void returnToOrigin() {
    this.setLocation(new Vector(width/2,339));
  }
 
  //set the location
  void setLocation(Vector v) {
    this.location = v; 
  }
 
  //return description of the ball
  String toString() {
    return "x: " + location.x + " y: " + location.y + " radius: " + radius;
  }
 
}