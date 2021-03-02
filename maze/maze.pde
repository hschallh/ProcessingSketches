import processing.svg.*;
import controlP5.*;

ControlP5 cp5;

int px = 32;
int hfPx = px / 2;
boolean drawMiddleLine = true;
int[][] randos;

void setup() {
  size(1056, 1344);
  stroke(0);

  // Controls
  cp5 = new ControlP5(this);

  cp5.addButton("export")
    .setPosition(20, 20)
    .setSize(100, 20);

  cp5.addButton("regenerate")
    .setPosition(20, 50)
    .setSize(100, 20);

  cp5.addToggle("drawMiddleLine")
     .setPosition(130, 20)
     .setSize(50, 20)
     .setValue(true)
     .setColorLabel(0)
     .setMode(ControlP5.SWITCH);

  //  Initial draw!
  randos = new int[width / px][height / px];
  regenerate();
}


// Change input values and redraw
public void regenerate() {
  for (int y = 0; y < height / px; y++) {
    for (int x = 0; x < width / px; x++) {
      randos[x][y] = px * ((int) random(2));;
    }
  }
}

// Export generation with current values
public void export() {
  beginRecord(SVG, "exports/export.svg");
  draw();
  endRecord();
}

// Redraw generation with current values
void draw() {
  background(255);

  for (int y = 0; y < height; y += px) {
    for (int x = 0; x < width; x += px) {
      int direction = randos[x / px][y / px];

      line(x, y + hfPx, x + hfPx, y + direction);
      line(x + hfPx, y + px - direction, x + px, y + hfPx);
      if (drawMiddleLine) {
        line(x, y + px - direction,x + px, y + direction);
      }
    }
  }
}
