// ---- Main Sketch ----
// Particle class -> Particle.pde
// Constants    -> Constants.pde

ArrayList<Particle> particles;
int collisionCount    = 0;  // total collisions
int collisionCountRed  = 0;  // collisions involving red particles
int collisionCountBlue = 0;  // collisions involving blue particles
ArrayList<Integer> history;      // total
ArrayList<Integer> historyRed;   // red group
ArrayList<Integer> historyBlue;  // blue group
int simX;
int startTime;
int yMax;  // current y-axis ceiling, grows automatically

void settings() {
  fullScreen();
}

void setup() {
  simX = (int)(width * GRAPH_RATIO);
  startTime = millis();
  yMax = GRAPH_Y_MAX_INITIAL;
  particles = new ArrayList<Particle>();
  history     = new ArrayList<Integer>();
  historyRed  = new ArrayList<Integer>();
  historyBlue = new ArrayList<Integer>();
  
  // spawn Group A (red)
  for(int i = 0; i < GROUP_A_COUNT; i++){
    particles.add(new Particle(
      random(simX+20, width-20),
      random(20, height-20),
      color(GROUP_A_R, GROUP_A_G, GROUP_A_B),
      0
    ));
  }
  // spawn Group B (blue)
  for(int i = 0; i < GROUP_B_COUNT; i++){
    particles.add(new Particle(
      random(simX+20, width-20),
      random(20, height-20),
      color(GROUP_B_R, GROUP_B_G, GROUP_B_B),
      1
    ));
  }
}

void draw() {
  background(BACKGROUND_COLOR);
  drawGraph();
  
  // move and wall bounce
  for(Particle p : particles){
    p.move();
    p.wallBounce();
  }
  
  // collisions
  for(int i=0;i<particles.size();i++){
    for(int j=i+1;j<particles.size();j++){
      particles.get(i).collide(particles.get(j));
    }
  }
  
  // show particles
  for(Particle p : particles){
    p.show();
  }
  
  history.add(collisionCount);
  historyRed.add(collisionCountRed);
  historyBlue.add(collisionCountBlue);

  // auto-scale y-axis: use the max of whichever series are enabled
  int activeMax = 0;
  if(SHOW_TOTAL_COLLISIONS) activeMax = max(activeMax, collisionCount);
  if(SHOW_RED_COLLISIONS)   activeMax = max(activeMax, collisionCountRed);
  if(SHOW_BLUE_COLLISIONS)  activeMax = max(activeMax, collisionCountBlue);
  if(activeMax >= yMax * GRAPH_Y_SCALE_AT){
    yMax = (int)(yMax * GRAPH_Y_SCALE_FACTOR);
  }
}

// ---- Graph ----

void drawGraph(){
  int m = GRAPH_MARGIN;
  
  // panel background border
  stroke(255);
  noFill();
  rect(0, 0, simX, height);
  
  // plot area axes
  stroke(180);
  // x axis
  line(m, height - m, simX - m/2, height - m);
  // y axis
  line(m, m/2, m, height - m);
  
  // --- Tick labels ---
  fill(200);
  textSize(GRAPH_TICK_SIZE);
  
  // y-axis ticks: base on the largest active series
  int refCount = 0;
  if(SHOW_TOTAL_COLLISIONS) refCount = max(refCount, collisionCount);
  if(SHOW_RED_COLLISIONS)   refCount = max(refCount, collisionCountRed);
  if(SHOW_BLUE_COLLISIONS)  refCount = max(refCount, collisionCountBlue);

  // y-axis: ticks appear at fixed absolute count values (GRAPH_Y_TICK_BASE, 2x, 3x...)
  // each frame: loop all possible tick positions up to current refCount,
  // draw only those at least GRAPH_MIN_Y_TICK_PX from the last drawn one — no sudden jumps
  {
    // find a coarse start interval so we don't iterate millions of times
    int yStep = GRAPH_Y_TICK_BASE;
    float plotH = (height - m) - (m / 2.0);
    while(yMax > 0 && (yStep / (float)yMax) * plotH < (GRAPH_MIN_Y_TICK_PX / 4.0)){
      yStep *= 2;
    }
    textSize(GRAPH_TICK_SIZE);
    float lastDrawnTy = height - m; // track pixel y of last drawn tick (starts at 0-line)
    for(int v = yStep; v <= refCount; v += yStep){
      float ty = map(v, 0, yMax, height - m, m / 2.0);
      // only draw if far enough from the previous drawn tick
      if(lastDrawnTy - ty >= GRAPH_MIN_Y_TICK_PX){
        stroke(180);
        line(m - 5, ty, m, ty);
        fill(200); noStroke(); textAlign(RIGHT, CENTER);
        String lbl;
        if(v >= 1000000)    lbl = nf(v/1000000.0, 1, 1) + "M";
        else if(v >= 1000)  lbl = nf(v/1000.0, 1, 1) + "k";
        else                lbl = str(v);
        text(lbl, m - 7, ty);
        lastDrawnTy = ty;
      }
    }
    // always draw "0" at origin
    fill(200); noStroke(); textAlign(RIGHT, CENTER);
    text("0", m - 7, height - m);
  }
  
  // x-axis: fixed-interval ticks at absolute time positions
  // resolution auto-upgrades as elapsed time crosses TICK_THRESHOLDS
  float elapsedSec = ((millis() - startTime) / 1000.0) * TIME_SCALE;

  // pick interval tier
  float tickInterval = TICK_INTERVALS[0];
  for(int ti = 0; ti < TICK_THRESHOLDS.length; ti++){
    if(elapsedSec >= TICK_THRESHOLDS[ti]){
      tickInterval = TICK_INTERVALS[ti + 1];
    }
  }

  // widen interval if ticks would overlap in pixel space
  // keep doubling until ticks are at least GRAPH_MIN_TICK_PX apart
  float plotW = (simX - m/2.0) - m;
  while(elapsedSec > 0 && (tickInterval / elapsedSec) * plotW < GRAPH_MIN_TICK_PX){
    tickInterval *= 2;
  }

  textSize(GRAPH_TICK_SIZE);
  for(float t = tickInterval; t <= elapsedSec; t += tickInterval){
    float tx = map(t, 0, elapsedSec, m, simX - m/2);
    // tick line
    stroke(180);
    line(tx, height - m, tx, height - m + 5);
    // smart label: "30s", "1m", "1m30s", "2m" ...
    fill(200);
    noStroke();
    textAlign(CENTER, TOP);
    int totalSec = (int)t;
    String lbl;
    if(totalSec < 60){
      lbl = totalSec + "s";
    } else if(totalSec < 3600){
      int mins = totalSec / 60;
      int secs = totalSec % 60;
      lbl = secs == 0 ? mins + "m" : mins + "m" + secs + "s";
    } else if(totalSec < 86400){
      int hrs  = totalSec / 3600;
      int mins = (totalSec % 3600) / 60;
      lbl = mins == 0 ? hrs + "h" : hrs + "h" + mins + "m";
    } else {
      int days = totalSec / 86400;
      int hrs  = (totalSec % 86400) / 3600;
      lbl = hrs == 0 ? days + "d" : days + "d" + hrs + "h";
    }
    text(lbl, tx, height - m + 7);
  }
  // always draw "0" at the origin
  fill(200);
  noStroke();
  textAlign(CENTER, TOP);
  text("0", m, height - m + 7);
  
  // --- Axis labels ---
  textSize(GRAPH_LABEL_SIZE);
  fill(255);
  
  // X label: "Time"
  textAlign(CENTER, BOTTOM);
  text("Time", simX / 2, height - 5);
  
  // Y label: "Collision Count" rotated
  pushMatrix();
    translate(12, height / 2);
    rotate(-HALF_PI);
    textAlign(CENTER, CENTER);
    text("Collision Count", 0, 0);
  popMatrix();
  
  // --- Data lines (color-coded, enabled by constants) ---
  int n = history.size();
  if(n > 1){
    if(SHOW_TOTAL_COLLISIONS){
      noFill(); stroke(255, 255, 255); // white
      beginShape();
      for(int i = 0; i < n; i++){
        float x = map(i, 0, n, m, simX - m/2);
        float y = map(history.get(i), 0, yMax, height - m, m/2);
        vertex(x, y);
      }
      endShape();
    }
    if(SHOW_RED_COLLISIONS){
      noFill(); stroke(GROUP_A_R, GROUP_A_G, GROUP_A_B); // red
      beginShape();
      for(int i = 0; i < historyRed.size(); i++){
        float x = map(i, 0, n, m, simX - m/2);
        float y = map(historyRed.get(i), 0, yMax, height - m, m/2);
        vertex(x, y);
      }
      endShape();
    }
    if(SHOW_BLUE_COLLISIONS){
      noFill(); stroke(GROUP_B_R, GROUP_B_G, GROUP_B_B); // blue
      beginShape();
      for(int i = 0; i < historyBlue.size(); i++){
        float x = map(i, 0, n, m, simX - m/2);
        float y = map(historyBlue.get(i), 0, yMax, height - m, m/2);
        vertex(x, y);
      }
      endShape();
    }
  }
}

