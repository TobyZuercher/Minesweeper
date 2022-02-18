public class Square {
  private float x, y, width, height;
  private boolean flagged, isBomb, revealed, checker;
  private int tileNum;
  
  public Square(float xPos, float yPos, float w, float h, boolean b) {
    width = w; height = h; x = xPos; y = yPos; flagged = revealed = isBomb = false; checker = b;
    Interactive.add(this);
  }
  
  public void setBomb() {
    isBomb = true;
  }
  
  public boolean isBomb() {
    return isBomb;
  }
  
  public void mousePressed() {
    if(revealed) return;
    if(mouseButton == RIGHT) {
      flagged = !flagged;
    }
    if(mouseButton == LEFT) {
      
    }
  }
  
  public void draw() {
    fill(0, (flagged ? 100 : 0), (checker ? 90 : 100));
    rect(x, y, width, height);
  }
}
