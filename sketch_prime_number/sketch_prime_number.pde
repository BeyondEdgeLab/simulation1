int maxNumbers = 20000;

boolean[] prime;
int x, y;
int dx = 1;
int dy = 0;
int segmentLength = 1;
int segmentPassed = 0;
int segmentCount = 0;

int step = 0;
int number = 1;

int cell = 6;

void setup() {
  size(900, 900);
  background(10);
  frameRate(60);

  prime = sieve(maxNumbers);

  x = width/2;
  y = height/2;
}

void draw() {

  for (int i = 0; i < 200; i++) {

    if (number >= maxNumbers) return;

    if (prime[number]) {
      stroke(255, 220, 80);
      fill(255, 220, 80);
      circle(x, y, cell);
    } else {
      stroke(80, 120, 180, 90);
      point(x, y);
    }

    x += dx * cell;
    y += dy * cell;

    segmentPassed++;
    number++;

    if (segmentPassed == segmentLength) {

      segmentPassed = 0;

      int temp = dx;
      dx = -dy;
      dy = temp;

      segmentCount++;

      if (segmentCount % 2 == 0) {
        segmentLength++;
      }
    }
  }
}

boolean[] sieve(int n) {

  boolean[] p = new boolean[n+1];

  for (int i = 2; i <= n; i++) {
    p[i] = true;
  }

  for (int i = 2; i*i <= n; i++) {
    if (p[i]) {
      for (int j = i*i; j <= n; j += i) {
        p[j] = false;
      }
    }
  }

  return p;
}