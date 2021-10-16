float overshoot = 0.5;
float division = 0.01;

int r = 2;
int currentIndex = 0;
ArrayList<Circle> circles;
ArrayList<ArrayList<PVector>> shapes = new ArrayList<ArrayList<PVector>>();

boolean showAll = false;

void setup() {
  size(1000, 1000);
  pixelDensity(1);
  background(0);

  r = width / 250;

  // WEIGHTED CHOICE ALGORITHM FOR COLOR
  circles = new ArrayList<Circle>();

  int leftX = int(width * -1 * overshoot);
  int rightX = int(width * (1 + overshoot));
  int topY = int(height * -1 * overshoot);
  int bottomY = int(height * (1 + overshoot));

  float lowerBoundX = 100;
  float upperBoundX = width - 100;
  float lowerBoundY = 100;
  float upperBoundY = height - 100;

  float resolution = int(width * division);

  int numColumns = int((rightX - leftX) / resolution);
  int numRows = int((bottomY - topY) / resolution);

  float[][] grid = new float[numColumns][numRows];

  float defaultAngle = PI * 0.25;
  float scale = 0.0125;

  for (int i = 0; i < numColumns; i++) {
    for (int j = 0; j < numRows; j++) {
      float xOff = (i * scale);
      float yOff = (j * scale);
      float noiseVal = noise(xOff, yOff);
      grid[i][j] = noiseVal*-TWO_PI;
    }
  }

  // DRAWING
  // =======
  int numCircles = 50000;
  int tries = 0;
  int currentX = 0;
  int currentY = 0;

  while (tries < 100000) {
    float halfWidth = (width / 2) + (width * overshoot);
    float halfHeight = (height / 2) + (height * overshoot);
    int x = int(halfWidth + randomGaussian() * halfWidth);
    int y = int(halfHeight + randomGaussian() * halfHeight);
    int numSteps = int(10 + randomGaussian() * 10);
    float currentR = r;
    float stepSize = width * 0.01;

    ArrayList<PVector> positions = new ArrayList<PVector>();

    for (int i = 0; i < numSteps; i++) {
      // Circle Packing
      boolean hasCollision = false;
      for (int j = 0; j < circles.size(); j++) {
        Circle compare = circles.get(j);
        float d = dist(x, y, compare.position.x, compare.position.y);
        if (d < (compare.radius + currentR) / 2 + 4) {
          hasCollision = true;
          break;
        }
      }

      if (x < lowerBoundX || x > upperBoundX || y < lowerBoundY || y > upperBoundY) {
        break;
      }

      if (hasCollision) {
        break;
      }

      positions.add(new PVector(x, y));

      int xOff = x - leftX;
      int yOff = y - topY;

      int colIndex = floor(xOff / resolution);
      int rowIndex = floor(yOff / resolution);

      if (colIndex < 0 || rowIndex < 0 || colIndex >= grid.length || rowIndex >= grid[colIndex].length) {
        break;
      }

      float angle = grid[colIndex][rowIndex];

      float xStep = stepSize * cos(angle);
      float yStep = stepSize * sin(angle);

      x += xStep;
      y += yStep;
    }

    for (int i = 0; i < positions.size(); i++) {
      PVector current = positions.get(i);
      Circle currentCircle = new Circle(current, r);
      circles.add(currentCircle);
    }

    if (positions.size() > 0) {
      shapes.add(positions);
    }

    tries++;
  }
  
  println(shapes.size(), tries);
}

void draw() {
  background(0);
  if (shapes.size() > 0) {
    noFill();
    stroke(255);
    strokeWeight(r);

    int jStart = 0;
    int jMax = shapes.size();

    if (!showAll) {
      jStart = currentIndex;
      jMax = jStart + 1;
    }

    for (int j = jStart; j < jMax; j++) {
      ArrayList<PVector> positions = shapes.get(j);
      beginShape();
      for (int i = 0; i < positions.size(); i++) {
        PVector current = positions.get(i);
        noFill();
        vertex(current.x, current.y);

        //ellipse(current.x, current.y, r*1.5, r*1.5);
      }

      endShape();
    }
  }
}

void keyPressed() {
  if (key == 'r') {
    currentIndex = 0;
  }
  if (key == 'a') {
    showAll = !showAll;
  }
}

void mousePressed() {
  if (currentIndex + 1 >= shapes.size()) {
    exit();
  }
  currentIndex++;
  println(currentIndex, shapes.size());
}
