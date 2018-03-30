import java.util.Arrays;

Ball ball;
Platform platform1;
Platform platform2;
Brick bricks[];
LevelManager manager;


PFont f;

boolean paused,
        gameOver,
        levelComplete,
        paused_for_help,
        at_main_menu, at_instructions_page, at_countdown,
        playgame_over, help_over, help_back_over;
        
int     level,
        lives,
        play_press_time, interval,
        playgame_X, playgame_Y,
        help_X, help_Y,
        help_back_X, help_back_Y,
        button_width, button_height;

void setup() {
  size(600, 400);
  frameRate(100);
  f = createFont("Arial", 16, true);
  textFont(f);
  level     = 1;
  manager = new LevelManager(600, 400);
  initialize();
}

void draw() {
  background(255);
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
  } else if (at_main_menu) {
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
  } else if (at_instructions_page) {
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
  } else if (!died()) {
    for (int i = 0; i < bricks.length; i++) {
      bricks[i].display();
      ball.detectCollision(bricks[i]);
      if (bricks[i].broken)
        bricksBroken++;
    }
    if (bricksBroken == bricks.length)
      completeLevel();
    platform1.display();
    platform2.display();
    platform1.move();
    platform2.move();
    ball.detectCollision(platform1); 
    ball.detectCollision(platform2); 
    ball.display();
    ball.move();
    drawLives();
  } else {
      if (--lives == 0) {
        gameOver();
      } else {
        ball.returnToOrigin();
        platform1.returnToOrigin();
        platform2.returnToOrigin();
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
  ball     = new Ball(new Vector(width/2,339), new Vector(2,-2), 10, color(0,0,255));
  platform1 = new Platform(new Vector(width/2+30,350), new Vector(3,0), 60, 10, color(128,128,128), 1);
  platform2 = new Platform(new Vector(width/2-90,350), new Vector(3,0), 60, 10, color(128,128,128), 2);
  paused   = false;
  paused_for_help = false;
  gameOver = false;
  at_main_menu = true;
  at_instructions_page = false;
  interval = 10;
  
  lives    = 3;
  
  playgame_X = (width/2) - 60;
  playgame_Y = (height/2) + 45;
  help_X = playgame_X;
  help_Y = playgame_Y + 45;
  help_back_X = help_X;
  help_back_Y = help_Y + 45;
  button_width = 120;
  button_height = 30;
  
  if (levelComplete && level < 3)
    level++;
 
  bricks = manager.loadLevel(level);

}

//determine whether the ball has fallen under the platform
boolean died() {
  Vector bLoc = ball.getLocation();      //ball location  
  if (bLoc.y + ball.radius > height) {
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
  text("                        Instructions\nPlayer 1: Press [a] & [d] to move paddle.\nPlayer 2: Use arrow keys to move paddle.\nPress [p] to pause.\nPress [x] to return to game.", width/2 - 142, height/2 - 30);
  noLoop();
}
 
//continue (unpause) the game
void continueGame() {
  paused_for_help = false;
  paused = false;
  loop();
}

void gameOver() {
  gameOver = true;
  at_main_menu = true;
  //fill(0);
  //text("Game Over!", width/2 - 50, height/2, button_width, button_height);
  //noLoop();
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