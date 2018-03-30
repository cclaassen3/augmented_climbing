class LevelManager {
  
  String[] levelMapping = new String[]{"easy", "medium", "hard"};
  // 1 = red
  // 2 = yellow
  // 3 = green
  color[] colorMapping = new color[]{color(255, 0, 0), color(255, 255, 0), color(0, 128, 0)};
  
  int screenWidth;
  int screenHeight;
  
  public LevelManager(int screenWidth, int screenHeight) {
    this.screenWidth = screenWidth;
    this.screenHeight = screenHeight;
  }
  
    color getColorFromMapping(int choice) {
    return this.colorMapping[choice-1];
  }

  Brick[] loadLevel(int level) {
    Brick[] bricks;
    String path = sketchPath("levels/" + levelMapping[level - 1]);
    //Manual selection, redo with random number later
    String[] fileNames = listFileNames(path);
    System.out.println(path);
    System.out.println(Arrays.toString(fileNames));
    if (fileNames.length == 0) {
      System.out.println("Error: No level files found in levels\\" + levelMapping[level - 1]);
      return null;
    } else {
      int rand = int(random(fileNames.length));
      String[] levelInfo = loadStrings(path + "/" + fileNames[rand]); 
      System.out.println(Arrays.toString(levelInfo));
      
      int columns = Integer.parseInt(levelInfo[0]);
      int colWidth = screenWidth / columns;
      System.out.println("Column Width " + colWidth);
      bricks = new Brick[Integer.parseInt(levelInfo[2])];
      int brickCounter = 0;
      int rowHeight = screenHeight / Integer.parseInt(levelInfo[1]);
      int sizeMetadata = 3; // how many rows of metadata to generate level
      System.out.println();
      
      for (int i = 0; i < levelInfo.length - sizeMetadata; i++) {
        String row = levelInfo[i + sizeMetadata];
        System.out.println("On row " + row);
        int brickStart = 0;
        char prev = '0';
        char cur = '0';
        for (int col = 0; col < row.length(); col++) {
          prev = cur;
          cur = row.charAt(col);
          if (int(cur) >=49 && int(cur) <= 57) { //cur is 1-9
            if (prev != cur) {
              brickStart = col;
            }
          } else if (cur == '/') {
            //End brick
            bricks[brickCounter] = new Brick(new Vector(brickStart * colWidth, i * rowHeight),
                                             colWidth * (col - brickStart + 1),
                                             rowHeight,
                                             colorMapping[Character.getNumericValue(prev) - 1],
                                             Character.getNumericValue(prev));
            prev = '0';
            brickCounter++;
          } 
        }
      }
      
      return bricks;
    }
  }
  
  // This function returns all the files in a directory as an array of Strings  
  String[] listFileNames(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      String names[] = file.list();
      return names;
    } else {
      // If it's not a directory
      return null;
    }
  }

}
