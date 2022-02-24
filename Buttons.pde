public class Square {
  private float x, y, width, height;
  private boolean flagged, isBomb, revealed, checker, zeroClicked;
  private int tileNum, row, col;
  
  public Square(float xPos, float yPos, float w, float h, boolean b, int r, int c) {
    width = w; height = h; x = xPos; y = yPos; flagged = false; revealed = false; isBomb = false; zeroClicked = false; checker = b; row = r; col = c;
    Interactive.add(this);
    tileNum = 0;
  }
  
  public void setBomb() { isBomb = true; }
  public void setNum(int n) { tileNum = n; }
  
  public int getNum() { return tileNum; }
  public boolean zeroClicked() { return zeroClicked; }
  public boolean isRevealed() { return revealed; }
  public boolean isFlagged() { return flagged; }
  public boolean checkered() { return checker; }
  public boolean isBomb() { return isBomb; }
  
  public float[] getPos() {
    return new float[]{x, y, width, height};
  }
  
  public void clear() {
    flagged = false; revealed = false; isBomb = false; zeroClicked = false; tileNum = 0;
  }
        
  public void mousePressed() {
    if(GAME_OVER || revealed) return;
    if(mouseButton == RIGHT) clickRight();
    if(mouseButton == LEFT) clickLeft();
  }
  
  public void clickLeft() {
    if(GAME_OVER || revealed) return;
    if(flagged) return;
    if(firstClick) {
      if(isBomb || tileNum != 0) {
        reRunSetup(col, row);
        return;
      }
      else firstClick = false;
    }
    if(isBomb) setEndScreen(false);
    revealed = true;
    if(tileNum == 0) {
      zeroClicked = true;
      clickedZero();
      zeroClicked = false;
    }
  }
  
  public void clickRight() {
    if(firstClick || GAME_OVER || revealed) return;
    if(flagged) flagsLeft++;
    else flagsLeft--;
    flagged = !flagged;
  }
  
  public void draw() {
    if(GAME_OVER) return;
    rectMode(CORNER);
    fill(0, 100, (checker ? 90 : 100), (flagged ? 100 : 0));
    rect(x, y, width, height);
    fill(0, 0, 0, 100);
    if(revealed) text((isBomb ? "boom" : "" + tileNum), x+width/2, y+(5*width/8));
  }
}

public class RestartButton {
  private float x, y, width, height;
  private String text;
  
  public RestartButton(float xPos, float yPos, float w, float h, String s) {
    x = xPos; y = yPos; width = w; height = h; text = s;
  }
  
  public void clicked() {
    setup();
  }
  
  public void show() {
    rectMode(CENTER);
    fill(255);
    rect(x, y, width, height, 5);
    fill(0);
    text(text, x, y+height/8);
  }
}

public void reRunSetup(int r, int c) {
  setup();
  field[c][r].clickLeft();
}
