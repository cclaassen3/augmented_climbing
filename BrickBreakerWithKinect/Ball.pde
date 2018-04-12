class Ball {
  Vector prevLocation;
  Vector location;
  Vector velocity;
  float radius;
  color c;
  float speedup;
  public Ball(Vector l, Vector v, float r, color c, float s) {
    location = l;
    velocity = v;
    radius   = r;
    this.c   = c;
    speedup = s;
  }
 
  //draw the ball
  void display() {
    fill(c);
    ellipse(location.x,location.y,radius*2,radius*2);
  }
 
  //move the ball (inlc. detecting if it hits a wall)
  void move() {
    prevLocation = location;
    location.add(velocity);
    if (location.x - radius <= 0 || location.x + radius >= width) {
      velocity.x *= -1 * speedup;
    }
   
    if (location.y - radius <= 0) {
      velocity.y *= -1 * speedup;
    }
    // adjust to change how fast ball speeds up
    speedup += .001
  }
 
  //return ball's location
  Vector getLocation() {
    return location; 
  }
  
  //take action if ball collided with human
  void collisionDetected() {
    bounceBallRandomly();
  }

  
  //determine if the ball has collided with a point
  boolean detectCollision(float px, float py) {
    
    //get distance between the point and circle's center
    float distX = ball.location.x - px;
    float distY = ball.location.y - py;
    float distance = sqrt( (distX*distX) + (distY*distY) );
  
    //check if point's distance from the ball's center <= radius
    if (distance <= ball.radius) {
       bounceBallRandomly();
       return true;
    }
    return false;
  }
  
  void bounceBallRandomly() {
    if (random(-1,1) < 0) {
      this.velocity.x = -1 * random(7, 16) * speedup;
    } else {
      this.velocity.x = random(7, 16) * speedup;
    }
    if (this.velocity.y >= 0) {
      this.velocity.y = -1 * random(7, 16) * speedup;
    } else {
      this.velocity.y = random(7, 16) * speedup;
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
        velocity.y *= -1 * speedup; 
        hit = true;
    }
    if (distY <= b.getLength()/2) {
        velocity.x *= -1 * speedup; 
        hit = true;
    } 
    float deltaX = distX - b.getWidth()/2;
    float deltaY = distY - b.getLength()/2;
    if ((deltaX*deltaX + deltaY*deltaY) <= (radius * radius)) {
       velocity.x *= -1 * speedup;
       velocity.y *= -1 * speedup;
       hit = true;
    }
    if (hit) {
     LevelManager l = new LevelManager(0,0);
     location = prevLocation;
     println(b.hardness);
     if (b.hardness > 1) {
        b.hardness--;
        b.setColor(l.getColorFromMapping(b.hardness));
        return true;
     }
      b.breakBrick();
      return true;
    }
       
    return false;
  }
 
  //return to the ball to its starting position
  void returnToOrigin() {
    this.setLocation(new Vector(20,100));
    this.velocity = new Vector(8, 10);
  }
 
  //set the ball's location
  void setLocation(Vector v) {
    this.location = v; 
  }
 
  //return description of the ball
  String toString() {
    return "x: " + location.x + " y: " + location.y + " radius: " + radius;
  }
 
}
