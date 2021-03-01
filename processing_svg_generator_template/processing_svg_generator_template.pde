import processing.svg.*;
import controlP5.*;

ControlP5 cp5;

int h1 = 0;
int h2 = height;

void setup() {
  // Okay-ish approximation for 11x14 (1.5in border on 14x17 paper)
  size(800, 1000);
  stroke(0);

  // Controls
  cp5 = new ControlP5(this);

  cp5.addButton("export")
    .setPosition(20, 20)
    .setSize(100, 20);

  cp5.addButton("regenerate")
    .setPosition(20, 50)
    .setSize(100, 20);

  //  Initial draw!
  background(255);
  redraw();
}

// Change input values and redraw
public void regenerate() {
  h1 = (int)random(height);
  h2 = (int)random(height);

  background(255);
  redraw();
}

// Export generation with current values
public void export() {
  beginRecord(SVG, "exports/export.svg");

  background(255);
  redraw();

  endRecord();
}

// Redraw generation with current values
void redraw() {
  line(0, h1, width, h2);
}

void draw() {}
