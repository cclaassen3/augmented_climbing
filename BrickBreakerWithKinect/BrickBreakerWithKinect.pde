import java.util.Arrays;
import java.awt.Rectangle;
import gab.opencv.*;
import SimpleOpenNI.*;
import KinectProjectorToolkit.*;

//Kinect variables
SimpleOpenNI kinect;
OpenCV opencv;
KinectProjectorToolkit kpc;
ArrayList<ProjectedContour> projectedContours;
PImage img;

//Game variables
Ball ball;
Brick bricks[];
LevelManager manager;

//Screen size
int w = 0;
int h = 0;

//Booleans
boolean paused,
        gameOver,
        levelComplete,
        paused_for_help,
        at_main_menu, at_instructions_page, at_countdown,
        playgame_over, help_over, help_back_over;
  
//Ints     
int     level,
        lives,
        play_press_time, interval,
        playgame_X, playgame_Y,
        help_X, help_Y,
        help_back_X, help_back_Y,
        button_width, button_height,
        collision_wait;

void setup() {
  size(displayWidth, displayHeight, P2D); 
 
  //set up Kinect
  kinect = new SimpleOpenNI(this); 
  kinect.enableDepth();
  kinect.enableUser();
  kinect.alternativeViewPointDepthToImage();
  
  //set up OpenCV
  opencv = new OpenCV(this, kinect.depthWidth(), kinect.depthHeight());

  //set up Kinect Projector Toolkit
  kpc = new KinectProjectorToolkit(this, kinect.depthWidth(), kinect.depthHeight());
  kpc.loadCalibration("calibration.txt");
  kpc.setContourSmoothness(4);
  
  //load image
  img = loadImage("texture.jpg");
  
  //set up game
  textFont(createFont("Arial", 16, true));
  level = 1;
  manager = new LevelManager(displayWidth, displayHeight);
  initialize();
  frameRate(100);
  
  //set up collision detection variable
  collision_wait = 0;
}

void draw() {
  
  //get updated kinect reading
  kinect.update();  
  kpc.setDepthMapRealWorld(kinect.depthMapRealWorld()); 
  kpc.setKinectUserImage(kinect.userImage());
  opencv.loadImage(kpc.getImage());
    
  //get projected contours & check for collision with ball
  projectedContours = new ArrayList<ProjectedContour>();
  ArrayList<Contour> contours = opencv.findContours();
  for (Contour contour : contours) {
    if (contour.area() > 1000) {
      ArrayList<PVector> cvContour = contour.getPoints();
      ProjectedContour projectedContour = kpc.getProjectedContour(cvContour, 1.0);
      projectedContours.add(projectedContour);
    }
  }
  
  //decrement collision wait
  if (collision_wait > 0) {
    collision_wait--;
  }
  
  
  //draw projected contours
  background(0);
  for (int i=0; i<projectedContours.size(); i++) {
    ProjectedContour projectedContour = projectedContours.get(i);
    PShape body = createShape();
    body.beginShape();
    body.texture(img);
    for (PVector p : projectedContour.getProjectedContours()) {
      PVector t = projectedContour.getTextureCoordinate(p);
      body.vertex(p.x, p.y, img.width * t.x, img.height * t.y);
        if (collision_wait==0 && ball.detectCollision(p.x, p.y) == true) {
          collision_wait = 20;
        }
      }
    body.endShape();
    shape(body);
  }
  
  //draw game data
  int bricksBroken = 0;
  if (at_countdown) {
     int t = interval - int((millis() - play_press_time) / 1000);
     String time = nf(t , 3);
     
     if (t == 0) {
       at_countdown = false;
       at_main_menu = false;
     } else {
       text(time, width/2, height/2);
     }
  } 
  
  else if (at_main_menu) {
    gameOver = false;
    update(mouseX, mouseY);
    if (playgame_over) {
      fill(240, 128, 128);
    } else {
      fill(200);
    }
    rect(playgame_X, playgame_Y, button_width, button_height);
    
    if (help_over) {
      fill(240, 128, 128);
    } else {
      fill(200);
    }
    rect(help_X, help_Y, button_width, button_height);
    
    textAlign(CENTER, CENTER);
    fill(50);
    text("Play", playgame_X, playgame_Y, button_width, button_height);
    text("Instructions", help_X, help_Y, button_width, button_height);
    text("BRICK BREAKER", playgame_X - 50, playgame_Y - 150, button_width + 100, button_height);
  } 
  
  else if (at_instructions_page) {
    update(mouseX, mouseY);
    textAlign(LEFT, CENTER);
    text("Instructions\n\nYour hands will be moving the paddle around.\nYou can use the paddles to bounce the balls off\nto destroy the bricks above one by one. The yellow\ncolor bricks will take 2 hits to get destroyed.\nYou win by destroying all the bricks in the game.", playgame_X - 100, height/2 - 50);
    if (help_back_over) {
      fill(240, 128, 128);
    } else {
      fill(200);
    }
    rect(help_back_X, help_back_Y, button_width, button_height);
    textAlign(CENTER, CENTER);
    fill(50);
    text("Back", help_back_X, help_back_Y, button_width, button_height);
  } 
  
  else if (!died()) {
    for (int i = 0; i < bricks.length; i++) {
      bricks[i].display();
      ball.detectCollision(bricks[i]);
      if (bricks[i].broken)
        bricksBroken++;
    }
    if (bricksBroken == bricks.length)
      completeLevel();
    ball.display();
    ball.move();
    
    drawLives();
  } 
  
  else {
      if (--lives == 0) {
        gameOver();
      } else {
        ball.returnToOrigin();
      }
  }  
}

void update(int x, int y) {
  if ( overRect(playgame_X, playgame_Y, button_width, button_height) ) {
    playgame_over = true;
    help_over = false;
  } else if ( overRect(help_X, help_Y, button_width, button_height) ) {
    playgame_over = false;
    help_over = true;
  } else if ( overRect(help_back_X, help_back_Y, button_width, button_height)) {
    help_back_over = true;
  } else {
    playgame_over = help_over = help_back_over = false;
  }
}

void mousePressed() {
  if (playgame_over) {
    //LEAVE ACTIONS HERE
    at_countdown = true;
    play_press_time = millis();
  }
  if (help_over) {
    //ADD HELP SCREEN LOGIC HERE;
    at_main_menu = false;
    at_instructions_page = true;
  }
  if (help_back_over) {
     at_instructions_page = false;
     at_main_menu = true;
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
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
  if ((key == 'h' || key == 'H') && !paused_for_help) {
    help(); 
  }
  if ((key == 'x' || key == 'X') && paused_for_help) {
    continueGame();
  }
}

//initialize all game objects
void initialize() {
//  ball = new Ball(new Vector(0,50), new Vector(10,-10), 10, color(0,0,255));
  ball = new Ball(new Vector(20, 100), new Vector(8, 10), 18, color(0,255,255), 1);
  paused = false;
  paused_for_help = false;
  gameOver = false;
  at_main_menu = true;
  at_instructions_page = false;
  interval = 5;
  lives = 3;
  
  playgame_X = (width/2) - 60;
  playgame_Y = (height/2) + 45;
  help_X = playgame_X;
  help_Y = playgame_Y + 70;
  help_back_X = help_X;
  help_back_Y = help_Y + 45;
  button_width = 150;
  button_height = 60;
  
  if (levelComplete && level < 3)
    level++;
 
  bricks = manager.loadLevel(level);
}

//determine whether the ball has reached the bottom of the screen
boolean died() {
  if (ball.getLocation().y >= displayHeight - 10) {
    return true;
  }
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

void help() {
  paused_for_help = true;
  text("                        Instructions\nThis is the classic brick breaker game with a twist.\nInstead of keyboard controlled paddles,\nyou can use your hands to hit the ball anywhere!\nSome bricks will need more than 1 hit to be destroyed.\nWhat are you waiting for, go and have some fun!", width/2 - 145, height/2 - 45);
  noLoop();
}
 
//continue (unpause) the game
void continueGame() {
  paused_for_help = false;
  paused = false;
  loop();
}

void gameOver() {
  initialize();
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
  int rad = 15;
  for (int i = 0; i < lives; i++) {
    fill(255);
    ellipse(width-20,(i*20) + rad, rad, rad);   
  } 
}


//  //get projected contours & check for collision with ball
//  projectedContours = new ArrayList<ProjectedContour>();
//  ArrayList<Contour> contours = opencv.findContours();
//  for (Contour contour : contours) {
//    if (contour.area() > 2000) {
////      if (contour.containsPoint((int) ball.location.x, (int) ball.location.y) == true) {
////        println("collision detected!");
////      }
//      ArrayList<PVector> cvContour = contour.getPoints();
//      ProjectedContour projectedContour = kpc.getProjectedContour(cvContour, 1.0);
//      projectedContours.add(projectedContour);
//    }
//  }
//  
  
//check if ball is within contour
boolean ballIsWithinContour(Contour contour) {
    Rectangle rectangle = contour.getBoundingBox();
    int x = (int) rectangle.getX();
    int y = (int) rectangle.getY();
    int w = (int) rectangle.getWidth();
    int h = (int) rectangle.getHeight();
    rect(x,y,w,h);
    
    if (ball.location.x >= rectangle.x && ball.location.x <= rectangle.x + rectangle.width) {
      if (ball.location.y >= rectangle.y && ball.location.y <= rectangle.y + rectangle.height) {
        return true;
      }
    }
    return false;
}