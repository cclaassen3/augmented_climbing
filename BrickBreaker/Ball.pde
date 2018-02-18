class Ball {
  Vector prevLocation;
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
    prevLocation = location;
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
   

    if ((this.location.x + radius > pLoc.x && this.location.x + radius < pLoc.x + p.getWidth()) &&
        (this.location.y + radius > pLoc.y && this.location.y - radius < pLoc.y + p.getLength())) {
           velocity.y *= -1;
           this.location.y += 1;

     //if ((this.location.y + radius <= ploc.y))
    float middle  = (2 * pLoc.x + p.getWidth()) / 2;
    
    if ((this.location.x + radius >= pLoc.x && this.location.x - radius <= pLoc.x + p.getWidth()) &&
        (this.location.y + radius >= pLoc.y && this.location.y - radius <= pLoc.y + p.getLength())) {
           float offset = (this.location.x - middle) / 2;
           
           print(offset, "\n");
           velocity.y = -1;
           if (offset > 0) {
             velocity.x =  sq(abs(offset/4.5));
           } else {
             velocity.x =  -1 * sq(abs(offset/4.5));
           }
           
           float unitvector = sqrt(sq(velocity.x) + sq(velocity.y));
           velocity.y = 2 * sqrt(2) * velocity.y / unitvector;
           velocity.x = 2 * sqrt(2) * velocity.x / unitvector;
           
           //print(offset, "\n");
           
           //print("@@@@@@@@@@@@@@@@@@@@@\n");
           if (abs(velocity.y) < .4) {
             velocity.y = -.4;
             unitvector = sqrt(sq(velocity.x) + sq(velocity.y));
             velocity.y = 4 * velocity.y / unitvector;
             velocity.x = 4 * velocity.x / unitvector;
           }
           print(velocity.x, velocity.y, "\n");  
           
        }
    }
    
  }
 
  //determine if the ball has collided with a brick
  boolean detectCollision(Brick b) {
    Vector bLoc = b.getLocation();
    
    float distX = abs(this.location.x - bLoc.x - b.getWidth()/2);
    float distY = abs(this.location.y - bLoc.y - b.getLength()/2);
    
    // no collision
    if ((distX > b.getWidth()/2 + radius) || (distY > b.getLength()/2 + radius)) {
        return false;
    }
    
    boolean hit = false;
    
    if (distX <= b.getWidth()/2) {
        velocity.y *= -1; 
        hit = true;
    }
    if (distY <= b.getLength()/2) {
        velocity.x *= -1; 
        hit = true;
    } 
    float deltaX = distX - b.getWidth()/2;
    float deltaY = distY - b.getLength()/2;
    if ((deltaX*deltaX + deltaY*deltaY) <= (radius * radius)) {
       velocity.x *= -1;
       velocity.y *= -1;
       hit = true;
    }
    if (hit) {
      location = prevLocation;
      if (b.hardness > 1) {
           b.hardness = 1;
           b.setColor(color(255,0,0));
           return false;
      }
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