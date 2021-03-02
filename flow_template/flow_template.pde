import processing.svg.*;
import controlP5.*;

ControlP5 cp5;

int px = 16;
int hfpx = px / 2;

// Noise works best when the difference in "distance" between inputs in small. See https://processing.org/reference/noise_.html
float noiseStep = 0.005;
int noiseSeed = 0;
boolean showNoise = true;

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

void draw() {
  background(255);
  for (int y = hfpx; y < height; y += px) {
    for (int x = hfpx; x < width; x += px) {

      // The noise field will always be the same once seeded.
      // Need to scale down values to only be within on "noise step" of eachother
      float randomRad = noise(x / px * noiseStep, y / px * noiseStep) * 2 * PI;

      if (showNoise) {
        ellipse(x, y, 2, 2);
        line(x, y, x + (hfpx * cos(randomRad)), y + (hfpx * sin(randomRad)));
      }
    }
  }
}
