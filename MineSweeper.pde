import de.bezier.guido.*;
public static final int NUM_ROWS = 10;
public static final int NUM_COLUMNS = 10;
public Square[][] field = new Square[NUM_ROWS][NUM_COLUMNS]; // can only make squares for some reason :(  --> i'll fix it later when it works
public boolean GAME_OVER = false;
public int flagsLeft = 0;
public static final int RESTART = 0;

public void setup() {
  GAME_OVER = false;
  flagsLeft = 0;
  size(600, 650); // 60 * NUM_COLUMNS, 60 * NUM_ROWS + 50  --> eventually change to set size that can later change
  background(0);
  textSize(24);
  textAlign(CENTER);
  noStroke();
  colorMode(HSB, 360, 100, 100, 100);
  Interactive.make(this);
  float bWidth = width/NUM_COLUMNS; float bHeight = (height - 50)/NUM_ROWS;
  boolean b = false;
  for(int r = 0; r < NUM_ROWS; r++) {
    int n = NUM_ROWS;
    if(n%2 == 0) b = !b;
    for(int c = 0; c < NUM_COLUMNS; c++) {
      b = !b;    
      float x = r * bWidth; float y = c * bHeight + 50;
      field[r][c] = new Square(x, y, bWidth, bHeight, b);
    }
  }
  int numBombs = (int)((NUM_ROWS*NUM_COLUMNS) * 0.15);
  for(int i = 0; i < numBombs; i++) {
    int x = (int)(Math.random() * NUM_COLUMNS);
    int y = (int)(Math.random() * NUM_ROWS);
    if(field[y][x].isBomb()) i -= 1;
    else field[y][x].setBomb();
  }
  flagsLeft = numBombs;
  for(int i = 0; i < NUM_ROWS; i++) {
    for(int j = 0; j < NUM_COLUMNS; j++) {
      if(!field[i][j].isBomb()) {
        for(int n1 = -1; n1 <= 1; n1++) {
          for(int n2 = -1; n2 <= 1; n2++) {
            if(i+n1 >= 0 && i+n1 < NUM_ROWS && j+n2 >= 0 && j+n2 < NUM_COLUMNS) {
              if(field[i+n1][j+n2].isBomb()) field[i][j].setNum(field[i][j].getNum() + 1);
            }
          }
        }
      }
    }
  }
  loop();
}

public void draw() {
  if(GAME_OVER) return;
  background(0);
  fill(0, 0, 100);
  text(flagsLeft, 20, 25);
}

public void setEndScreen() {
  noLoop();
  GAME_OVER = true;
  background(0);
  textSize(50);
  text("YOU LOST", width/2, height/2);
  textSize(25);
  Selector c = new Selector(width/2, 3*height/4, 100, 50, "restart", RESTART);
  c.draw();
}

public void clickedZero() {
  for(int i = 0; i < NUM_ROWS; i++) {
    for(int j = 0; j < NUM_COLUMNS; j++) {
      if(field[i][j].zeroClicked()) {
        System.out.println(i + ", " + j);
        for(int n1 = -1; n1 <= 1; n1++) {
          for(int n2 = -1; n2 <= 1; n2++) {
            if(i+n1 >= 0 && i+n1 < NUM_ROWS && j+n2 >= 0 && j+n2 < NUM_COLUMNS) {
              Square s = field[i + n1][j + n2];
              if(!s.isRevealed())
                s.clickLeft();
            }
          }
        }
      }
    }
  }
}


// TO DO:
// - make the restart work, stop it from marking flags incorrectly
// - add win screen
// - add colors for numbers, better font, nice tiles, better score counters, nicer looking screen and animations
// - potentially add different modes, but will be hard
// - on first click, if not a 0 square then regenerate
