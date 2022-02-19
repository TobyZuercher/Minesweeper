import de.bezier.guido.*;
public static final int NUM_ROWS = 10;
public static final int NUM_COLUMNS = 10;
public Square[][] field = new Square[NUM_ROWS][NUM_COLUMNS];

public void setup() {
  size(600, 600);
  background(0);
  textSize(18);
  noStroke();
  colorMode(HSB, 360, 100, 100, 100);
  Interactive.make(this);
  float bWidth = width/NUM_COLUMNS; float bHeight = height/NUM_ROWS;
  boolean b = false;
  for(int i = 0; i < NUM_ROWS; i++) {
    b = !b;
    for(int j = 0; j < NUM_COLUMNS; j++) {
      b = !b;
      float x = i * bWidth; float y = j * bHeight;
      field[i][j] = new Square(x, y, bWidth, bHeight, b);
    }
  }
}

public void draw() {
  background(0);
}
