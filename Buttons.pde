public class Square {
  private float x, y, width, height;
  private boolean flagged, isBomb, revealed, checker;
  private int tileNum;
  public Square(float xPos, float yPos, float w, float h, boolean b) {
    width = w; height = h; x = xPos; y = yPos; flagged = false; revealed = false; isBomb = false; checker = b;
    Interactive.add(this);
    tileNum = 0;
    System.out.println((int)(xPos/60) + ", " + (int)(yPos/60-50));
  }
  
  public void setBomb() { isBomb = true; }
  public boolean isBomb() { return isBomb; }
  
  public void setNum(int n) { tileNum = n; }
  public int getNum() { return tileNum; }
  
  public void mousePressed() {
    if(GAME_OVER || revealed) return;
    if(mouseButton == RIGHT) clickRight();
    if(mouseButton == LEFT) clickLeft();
  }
  
  public void clickLeft() {
    if(flagged) return;
    if(isBomb) setEndScreen();
    revealed = true;
  }
  
  public void clickRight() { //something going wrong here, could also be in the reinitialization of the buttons
    if(flagged) flagsLeft++;
    else flagsLeft--;
    System.out.println(flagsLeft);
    flagged = !flagged;
  }
  
  public void draw() {
    if(GAME_OVER) return;
    rectMode(CORNER);
    fill(0, (flagged ? 100 : 0), (checker ? 90 : 100));
    rect(x, y, width, height);
    fill(0, 0, 0, 100);
    if(revealed) text((isBomb ? "boom" : "" + tileNum), x+width/2, y+(5*width/8));
  }
}

public class Selector {
  private float x, y, width, height;
  private String text;
  private int TYPE;
  
  public Selector(float xPos, float yPos, float w, float h, String t, int T) {
    x = xPos; y = yPos; width = w; height = h; text = t; TYPE = T;
    Interactive.add(this);
  }
  
  public void mousePressed() {
    if(TYPE == 0) setup();
  }
  
  public void draw() {
    rectMode(CENTER);
    fill(255);
    rect(x, y, width, height, 5);
    fill(0);
    text(text, x, y);
  }
}
