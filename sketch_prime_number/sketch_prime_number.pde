int maxNumbers = 20000;

boolean[] prime;

ArrayList<PVector> primes = new ArrayList<PVector>();
ArrayList<PVector> composites = new ArrayList<PVector>();

float cell = 8;

float angleX = 0;
float angleY = 0;
float zoom = -800;

float panX = 0;
float panY = 0;

boolean drawing = true;

int x = 0;
int y = 0;
int dx = 1;
int dy = 0;

int segmentLength = 1;
int segmentPassed = 0;
int segmentCount = 0;

int number = 1;

void setup(){

  size(1000,1000,P3D);
  prime = sieve(maxNumbers);
  frameRate(60);
}

void draw(){

  background(10);
  lights();

  translate(width/2 + panX, height/2 + panY, zoom);
  rotateX(angleX);
  rotateY(angleY);

  if(drawing){
    for(int i=0;i<300;i++){

      if(number >= maxNumbers){
        drawing = false;
        break;
      }

      float px = x * cell;
      float py = y * cell;
      float pz = sin(number*0.05) * 60;

      if(prime[number]){
        primes.add(new PVector(px,py,pz));
      }else{
        composites.add(new PVector(px,py,pz));
      }

      x += dx;
      y += dy;

      segmentPassed++;
      number++;

      if(segmentPassed == segmentLength){

        segmentPassed = 0;

        int temp = dx;
        dx = -dy;
        dy = temp;

        segmentCount++;

        if(segmentCount % 2 == 0){
          segmentLength++;
        }
      }
    }
  }

  drawComposites();
  drawPrimes();

  drawUI();
}

void drawPrimes(){

  fill(255,220,80);
  noStroke();

  for(PVector p : primes){

    pushMatrix();
    translate(p.x,p.y,p.z);
    sphere(3);
    popMatrix();

  }
}

void drawComposites(){

  fill(80,120,200,90);
  noStroke();

  for(PVector p : composites){

    pushMatrix();
    translate(p.x,p.y,p.z);
    box(2);
    popMatrix();

  }
}

void drawUI(){

  camera();
  hint(DISABLE_DEPTH_TEST);

  fill(255);
  textSize(16);
  text("Drag mouse: rotate",20,20);
  text("Right drag: pan",20,40);
  text("Mouse wheel: zoom",20,60);
  text("Primes: " + primes.size(),20,80);

  hint(ENABLE_DEPTH_TEST);
}

void mouseDragged(){

  if(mouseButton == LEFT){
    angleY += (mouseX - pmouseX) * 0.01;
    angleX += (mouseY - pmouseY) * 0.01;
  }

  if(mouseButton == RIGHT){
    panX += mouseX - pmouseX;
    panY += mouseY - pmouseY;
  }
}

void mouseWheel(processing.event.MouseEvent event){
  zoom += event.getCount() * 40;
}

boolean[] sieve(int n){

  boolean[] p = new boolean[n+1];

  for(int i=2;i<=n;i++){
    p[i] = true;
  }

  for(int i=2;i*i<=n;i++){

    if(p[i]){

      for(int j=i*i;j<=n;j+=i){
        p[j] = false;
      }

    }
  }

  return p;
}
