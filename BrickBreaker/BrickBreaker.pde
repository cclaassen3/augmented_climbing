Ball ball;
Platform platform;
Brick bricks[];

PFont f;

boolean paused,
        gameOver,
        levelComplete;
        
int     level,
        numBricks,
        lives;

void setup() {
  size(600,400);
  frameRate(100);
  f = createFont("Arial", 16, true);
  textFont(f);
  numBricks = 24;
  level     = 1;
  initialize();
}

void draw() {
  background(255);
  int bricksBroken = 0;
  if (!died()) {
    for (int i = 0; i < bricks.length; i++) {
      bricks[i].display();
      ball.detectCollision(bricks[i]);
      if (bricks[i].broken)
        bricksBroken++;
    }
    if (bricksBroken == bricks.length)
      completeLevel();
    ball.detectCollision(platform); 
    ball.display();
    ball.move();
    platform.display();
    platform.move();
    drawLives();
  } else {
      if (--lives == 0) {
        gameOver();
      } else {
        ball.returnToOrigin();
        platform.returnToOrigin();
      }
  }  
}


void keyPressed() {
  //restart the game or move on to the next level
  if (key == ENTER && gameOver) {
    restartGame();
  } else if (key == ENTER && levelComplete) {
    restartGame();
    levelComplete = false;
  }
  //pause the game
  if (key == 'p' || key == 'P' && !paused) {
    pauseGame();
  }
  //continue (unpause) the game
  if ((key == 'c' || key == 'C') && paused) {
    continueGame();
  }
  //exit the game
  if ((key == 'q' || key == 'Q') && paused) {
    exit(); 
 }
 
}

//initialize all game objects
void initialize() {
  ball     = new Ball(new Vector(width/2,339), new Vector(2,-2), 10, color(0,0,255));
  platform = new Platform(new Vector(width/2-30,350), new Vector(3,0), 60, 10, color(128,128,128));
  paused   = false;
  gameOver = false;
  lives    = 3;
  
  if (levelComplete)
    numBricks += 12;
  
  bricks = new Brick[numBricks];
  
  for (int i = 0; i < bricks.length; i++)
    if (i % 5 > 0) {
       bricks[i] = new Brick(new Vector(((i % 12) * width/12), ((i/12) * 20)), width/12, 20, color(255,0,0));
    } else {
      bricks[i] = new Brick(new Vector(((i % 12) * width/12), ((i/12) * 20)), width/12, 20, color(255,255,0));
    }
}

//determine whether the ball has fallen under the platform
boolean died() {
  Vector bLoc = ball.getLocation();      //ball location
  Vector pLoc = platform.getLocation();  //platform location
  
  if (bLoc.x < 0 && bLoc.y > pLoc.y)
    return true; 
  else if (bLoc.x > width && bLoc.y > pLoc.y)
    return true;
  else if (bLoc.y > height)
    return true;
  else
    return false;
}

//restart the game
void restartGame() {
  initialize();
  loop();
}
 
//pause the game
void pauseGame() {
  paused = true;
  text("Game Paused. Press [c] to continue.\nPress [q] to quit game.", width/2 - 100, height/2);
  noLoop();
}
 
//continue (unpause) the game
void continueGame() {
  paused = false;
  loop();
}

void gameOver() {
  gameOver = true;
  fill(0);
  text("Game Over!", width/2 - 50, height/2);
  noLoop();
  numBricks = 12;
}
 
//complete the level by stopping the draw() method and displaying level completeion text
void completeLevel() {
  noLoop();
  redraw();
  levelComplete = true;
  text("Level " + level + " complete!\nPress enter to start level " + ++level + ".", width/2 - 100, height/2);
}

//draws balls on the side of the screen to represent the number of lives remaining
void drawLives() {
  int rad = 10;
  for (int i = 0; i < lives; i++) {
    fill(0);
    ellipse(width-20,(i*20) + rad, rad, rad);   
  } 
}