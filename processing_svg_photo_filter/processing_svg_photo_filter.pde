import processing.svg.*;
import controlP5.*;
import java.util.Map;

ControlP5 cp5;

enum Filter {
  ZAG("zig zag", 1),
  MAZE("maze", 2),
  HATCH("hatching", 3),
  BUB("bubbles", 4);

  static Map<Integer, Filter> filters = new HashMap<Integer, Filter>();
  String label;
  int val;

  private Filter(String label, int val) {
      this.label = label;
      this.val = val;
  }

  static {
      for (Filter e: values()) {
          filters.put(e.val, e);
      }
  }
};
Filter filter = Filter.ZAG;

PImage img;

int px;
int hfPx;

float strokeMultiplier = 1.0;
float heightMultiplier = 1.0;

RadioButton filterRadio;
RadioButton pixelRadio;

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

  cp5.addButton("changeImage")
    .setPosition(20, 80)
    .setSize(100, 20)
    .setLabel("change image");

  cp5.addSlider("strokeMultiplier")
    .setSize(200, 20)
    .setPosition(250, 20)
    .setLabel("line width")
    .setColorLabel(0)
    .setRange(0, 2)
    .setNumberOfTickMarks(21)
    .setValue(strokeMultiplier);

  cp5.addSlider("heightMultiplier")
    .setSize(200, 20)
    .setPosition(250, 50)
    .setLabel("height variance")
    .setColorLabel(0)
    .setRange(0, 2)
    .setNumberOfTickMarks(21)
    .setValue(heightMultiplier);

  filterRadio = cp5.addRadioButton("filterRadion")
    .setPosition(130, 20)
    .setSize(20, 20)
    .setColorForeground(color(83, 165, 253))
    .setColorActive(color(56, 110, 215))
    .setColorLabel(color(0));

  for (Filter f: Filter.values()) {
    filterRadio.addItem(f.label, f.val);
  }
  filterRadio.activate(1);

  pixelRadio = cp5.addRadioButton("pixelRadio")
    .setPosition(200, 20)
    .setSize(20, 20)
    .setColorForeground(color(83, 165, 253))
    .setColorActive(color(56, 110, 215))
    .setColorLabel(color(0))
    .addItem("4px", 4)
    .addItem("8px", 8)
    .addItem("16px", 16);

  pixelRadio.activate(2);

  // Allows us to get the color and brightness of a point on the image on a scale of 0 - px
  colorMode(HSB, px, px, px);

  //  Initial image selection
  changeImage();
}

void controlEvent(ControlEvent e) {
  if (e.isFrom(filterRadio)) {
    filter = Filter.filters.get((int) e.getGroup().getValue());
  } else if (e.isFrom(pixelRadio)) {
    px = (int) e.getGroup().getValue();
    hfPx = px / 2;
    colorMode(HSB, px, px, px);
  } else {
    return;
  }

  if (img != null) {
    reset();
    redraw();
  }
}

// Show file selector
public void changeImage() {
  selectInput("Select an image:", "imageSelected");
}

// Set the new image and redraw
void imageSelected(File file) {
  if (file != null) {
    img = loadImage(file.getAbsolutePath());
    img.resize(width, 0);
    reset();
    redraw();
  }
}

// Change input values and redraw
public void regenerate() {
  reset();
  redraw();
}

// Export generation with current values
public void export() {
  beginRecord(SVG, "exports/export.svg");

  reset();
  redraw();

  endRecord();
}

// Refill the canvas with white
void reset() {
  background(0, 0, px);
}

// Redraw generation with current values
void redraw() {
  switch (filter) {
    case ZAG:
      zag();
      break;
    case MAZE:
      maze();
      break;
    case HATCH:
      hatch();
      break;
    case BUB:
      bub();
      break;
    default:
  }
}

float brightnessAtPoint(int x, int y) {
  return brightness(img.get(x, y));
}

void zag() {
  for (int y = 0; y < height; y += px) {
    int y1 = y;
    for (int x = 0; x < width; x += hfPx) {
      // The larger the number, the darker the pixel on the image
      float invertedBrightness = px - brightnessAtPoint(x, y);

      // Larger strokes for darker points
      strokeWeight(invertedBrightness * strokeMultiplier);

      // More variation in the zig zag for darker points
      float y2 = y + random(-invertedBrightness, invertedBrightness) * heightMultiplier;

      line(x, y1, x + hfPx, y2);
      y1 = (int) y2;
    }
  }
}

void maze() {
  strokeWeight(1 * strokeMultiplier);

  for (int y = 0; y < height; y += px) {
    for (int x = 0; x < width; x += px) {
      // Grabs the brightness of a point on a scale of 0 - 2
      int scaledBrightness = (int) brightnessAtPoint(x, y) / (px / 2);
      int direction = px * ((int) random(2));

      switch (scaledBrightness) {
        case 0:
          line(x, y + hfPx, x + hfPx, y + direction);
          line(x + hfPx, y + px - direction, x + px, y + hfPx);
        case 1:
          line(x, y + px - direction,x + px, y + direction);
        default:
          // Draw nothing for the brightest points
      }
    }
  }
}

void hatch() {
  strokeWeight(2 * strokeMultiplier);

  for (int y = 0; y < height; y += px) {
    for (int x = 0; x < width; x += px) {
      // Grabs the brightness of a point on a scale of 0 - 4
      int scaledBrightness = (int) brightnessAtPoint(x, y) / (px / 4);

      switch (scaledBrightness) {
        case 0:
          line(x, y + hfPx, x + hfPx, y + px);
          line(x + hfPx, y, x + px, y + hfPx);
        case 1:
          line(x, y + hfPx, x + hfPx, y);
          line(x + hfPx, y + px, x + px, y + hfPx);
        case 2:
          line(x, y, x + px, y + px);
        case 3:
          line(x, y + px, x + px, y);
        default:
          // Draw nothing for the brightest points
      }
    }
  }
}

void bub() {
  println("Implement me!");
}

void draw() {}
