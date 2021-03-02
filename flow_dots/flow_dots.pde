import processing.svg.*;
import controlP5.*;

ControlP5 cp5;

int px = 16;
int hfpx = px / 2;

float noiseStep = 0.005;
int noiseSeed = 0;
boolean showNoise = false;

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

  Toggle toggle = cp5.addToggle("showNoise")
    .setPosition(130, 20)
    .setSize(50, 20)
    .setValue(showNoise)
    .setColorLabel(0)
    .setMode(ControlP5.SWITCH);
  
  toggle.getCaptionLabel().getStyle().marginTop = -18;
  toggle.getCaptionLabel().getStyle().marginLeft = 54;

  cp5.addSlider("noiseStep")
    .setSize(200, 20)
    .setPosition(250, 20)
    .setLabel("noise step")
    .setColorLabel(0)
    .setRange(0.0, 0.03)
    .setNumberOfTickMarks(7)
    .setValue(noiseStep);
}

public void regenerate() {
  noiseSeed = (int)random(Integer.MAX_VALUE);
  noiseSeed(noiseSeed);
}

public void export() {
  beginRecord(SVG, "exports/export.svg");

  showNoise = false;
  draw();

  endRecord();
}

float noiseAtPointInRads(int x, int y) {
  // The noise field will always be the same once seeded.
  // Need to scale down values to only be within on "noise step" of eachother
  return noise(x / px * noiseStep, y / px * noiseStep) * 2 * PI;
}

void draw() {
  background(255);
  for (int initialY = 0; initialY < height; initialY += px) {
    int y = initialY;
    int x = initialY;
    while (x >= 0 && x <= width && y >= 0 && y <= height) {
      ellipse(x, y, 1, 1);
      float randomRad = noiseAtPointInRads(x, y);
      x += hfpx * cos(randomRad);
      y += hfpx * sin(randomRad);
    }
  }
  if (showNoise) {
    for (int y = hfpx; y < height; y += px) {
      for (int x = hfpx; x < width; x += px) {
        float randomRad = noiseAtPointInRads(x, y);
        ellipse(x, y, 2, 2);
        line(x, y, x + (hfpx * cos(randomRad)), y + (hfpx * sin(randomRad)));
      }
    }
  }
}
