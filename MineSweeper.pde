import de.bezier.guido.*;
public static final int NUM_ROWS = 10;
public static final int NUM_COLUMNS = 10;
public Square[][] field = new Square[NUM_ROWS][NUM_COLUMNS]; // can only make squares for some reason :(  --> i'll fix it later when it works
public boolean GAME_OVER = false; 
public boolean firstClick = true;
public int flagsLeft = 0;
public RestartButton r = null;
public static final int WIDTH = 600;
public static final int HEIGHT = 650;
public PImage flag;
public PFont font;
public PImage[] particleImages = new PImage[5];
public ArrayList<Particle> explosions = new ArrayList<Particle>();

public void setup() {
  flag = loadImage("flag.png");
  font = createFont("bitlow.ttf", 72);
  particleImages[0] = loadImage("red_particle.png");
  particleImages[1] = loadImage("green_particle.png");
  particleImages[2] = loadImage("blue_particle.png");
  particleImages[3] = loadImage("purple_particle.png");
  particleImages[4] = loadImage("gray_particle.png");
  textFont(font);
  GAME_OVER = false;
  firstClick = true;
  flagsLeft = 0;
  size(600, 650); // 60 * NUM_COLUMNS, 60 * NUM_ROWS + 50  --> eventually change to set size that can later change
  textSize(24);
  textAlign(CENTER);
  noStroke();
  colorMode(HSB, 360, 100, 100, 100);
  background(0, 0, 0, 100);
  Interactive.make(this);
  float bWidth = width/NUM_COLUMNS; float bHeight = (height - 50)/NUM_ROWS;
  boolean b = false;
  for(int r = 0; r < NUM_ROWS; r++) {
    int n = NUM_ROWS;
    if(n%2 == 0) b = !b;
    for(int c = 0; c < NUM_COLUMNS; c++) {
      b = !b;    
      float x = r * bWidth; float y = c * bHeight + 50;
      if(field[r][c] == null)
        field[r][c] = new Square(x, y, bWidth, bHeight, b, r, c);
      else { 
        field[r][c].clear();
      }
    }
  }
  int numBombs = (int)((NUM_ROWS*NUM_COLUMNS) * 0.15) + (int)(Math.random() * 4);
  for(int i = 0; i < numBombs; i++) {
    int x = (int)(Math.random() * NUM_COLUMNS);
    int y = (int)(Math.random() * NUM_ROWS);
    if(field[y][x].getBomb()) i -= 1;
    else { field[y][x].setBomb(); }
  }
  flagsLeft = numBombs;
  for(int i = 0; i < NUM_ROWS; i++) {
    for(int j = 0; j < NUM_COLUMNS; j++) {
      if(!field[i][j].getBomb()) {
        for(int n1 = -1; n1 <= 1; n1++) {
          for(int n2 = -1; n2 <= 1; n2++) {
            if(i+n1 >= 0 && i+n1 < NUM_ROWS && j+n2 >= 0 && j+n2 < NUM_COLUMNS) {
              if(field[i+n1][j+n2].getBomb()) field[i][j].setNum(field[i][j].getNum() + 1);
            }
          }
        }
      }
    }
  }
  loop();
}

public void mousePressed() {
  if(r != null) {
    if(mouseX >= (width/2)-50 && mouseX <= (width/2)+50 && mouseY <= 3*height/4+25 && mouseY >= 3*height/4-25) {
      r.clicked();
      r = null;
    }
  }
}

public void draw() {
  if(GAME_OVER) return;
  background(0, 0, 50, 100);
  fill(0, 0, 100);
  image(flag, 45, 5, 40, 40);
  text(flagsLeft, 30 , 35);
  for(int r = 0; r < NUM_ROWS; r++) {
    for(int c = 0; c < NUM_ROWS; c++) {
      Square s = field[r][c];
      float[] pos = s.getPos();
      fill(80, 60 + (s.isRevealed() ? 0 : 20), (s.checkered() ? 90 : 100) - (s.isRevealed() ? 0 : 10));
      rect(pos[0], pos[1], pos[2], pos[3]);
    }
  }
  stroke(0);
  strokeWeight(2);
  for(int r = 0; r < NUM_ROWS; r++) {
    for(int c = 0; c < NUM_ROWS; c++) {
      Square s = field[r][c];
      float[] pos = s.getPos();
      float x = pos[0]; float y = pos[1]; float w = pos[2]; float h = pos[3];
      if(!s.isRevealed()) {
        if(c == NUM_COLUMNS-1 || field[r][c+1].isRevealed()) line(x, y+h, x+w, y+h);
        if(c == 0 || field[r][c-1].isRevealed()) line(x, y, x+w, y);
        if(r == NUM_ROWS-1 || field[r+1][c].isRevealed()) line(x+w, y, x+w, y+h);
        if(r == 0 || field[r-1][c].isRevealed()) line(x, y, x, y+h);
      }
    }
  }
  noStroke();
  for(int i = 0; i < explosions.size(); i++) {
    if(!explosions.get(i).show()) { killParticle(explosions.get(i));}
  }
  for(int r = 0; r < NUM_ROWS; r++) {
    for(int c = 0; c < NUM_COLUMNS; c++) {
      if(!field[r][c].isRevealed() && !field[r][c].getBomb()) {
        return;
      }
    }
  }
  for(int r = 0; r < NUM_ROWS; r++) {
    for(int c = 0; c < NUM_COLUMNS; c++) {
      field[r][c].draw();
    }
  }
  setEndScreen(true);
}

public void setEndScreen(boolean won) {
  noLoop();
  GAME_OVER = true;
  fill(0);
  rect(50, 100, width-100, height-150, 5);
  textSize(50);
  fill(255);
  text("YOU " + (won ? "WON" : "LOST"), width/2, height/2);
  textSize(25);
  r = new RestartButton(width/2, 3*height/4, 200, 50, "RESTART");
  r.show();
}

public void clickedZero() {
  for(int i = 0; i < NUM_ROWS; i++) {
    for(int j = 0; j < NUM_COLUMNS; j++) {
      if(field[i][j].blankClicked()) {
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
// - potentially add different modes, but will be hard
// - make restart button work at y = 3*height/4
// - particles :) --> add in textures, additionally actually make them appear upon clicking. maybe change randomness to a set thing
