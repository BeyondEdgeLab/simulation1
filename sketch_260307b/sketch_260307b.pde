// ---- Main Sketch ----
// Particle class -> Particle.pde
// Constants    -> Constants.pde

ArrayList<Particle> particles;
ArrayList<Particle> pendingParticles;
int collisionCount    = 0;
int collisionCountRed  = 0;
int collisionCountBlue = 0;
ArrayList<Integer> history;         // total collisions
ArrayList<Integer> historyRed;      // red collisions
ArrayList<Integer> historyBlue;     // blue collisions
ArrayList<Integer> historyPopTotal; // total population
ArrayList<Integer> historyPopRed;   // red population
ArrayList<Integer> historyPopBlue;  // blue population
int simX;
int startTime;
int yMax;     // collision plot y-ceiling
int yMaxPop;  // population plot y-ceiling

void settings() {
  fullScreen();
}

void setup() {
  simX = (int)(width * GRAPH_RATIO);
  startTime = millis();
  yMax    = GRAPH_Y_MAX_INITIAL;
  yMaxPop = GRAPH_POP_Y_MAX_INITIAL;
  particles        = new ArrayList<Particle>();
  pendingParticles = new ArrayList<Particle>();
  history         = new ArrayList<Integer>();
  historyRed      = new ArrayList<Integer>();
  historyBlue     = new ArrayList<Integer>();
  historyPopTotal = new ArrayList<Integer>();
  historyPopRed   = new ArrayList<Integer>();
  historyPopBlue  = new ArrayList<Integer>();
  
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
  // stop simulation when population cap is reached
  if(particles.size() >= MAX_POPULATION){
    noLoop();
    // draw a message over the simulation area
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("Population cap reached: " + particles.size() + " particles",
         simX + (width - simX) / 2, height / 2);
    return;
  }
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
  // add offspring spawned during collision loop
  particles.addAll(pendingParticles);
  pendingParticles.clear();

  // remove particles that have exceeded their max age
  for(int i = particles.size() - 1; i >= 0; i--){
    if(particles.get(i).isDead()) particles.remove(i);
  }

  // stop simulation if all particles have died
  if(STOP_ON_EXTINCTION && particles.size() == 0){
    noLoop();
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("Extinction: all particles have died", simX + (width - simX) / 2, height / 2);
    return;
  }

  // show particles
  for(Particle p : particles){
    p.show();
  }
  
  history.add(collisionCount);
  historyRed.add(collisionCountRed);
  historyBlue.add(collisionCountBlue);

  // count current population by group
  int popRed = 0, popBlue = 0;
  for(Particle p : particles){
    if(p.groupId == 0) popRed++;
    else               popBlue++;
  }
  historyPopTotal.add(particles.size());
  historyPopRed.add(popRed);
  historyPopBlue.add(popBlue);

  // auto-scale collision y-axis
  int activeMax = 0;
  if(SHOW_TOTAL_COLLISIONS) activeMax = max(activeMax, collisionCount);
  if(SHOW_RED_COLLISIONS)   activeMax = max(activeMax, collisionCountRed);
  if(SHOW_BLUE_COLLISIONS)  activeMax = max(activeMax, collisionCountBlue);
  if(activeMax >= yMax * GRAPH_Y_SCALE_AT){
    yMax = (int)(yMax * GRAPH_Y_SCALE_FACTOR);
  }

  // auto-scale population y-axis
  int popMax = 0;
  if(SHOW_TOTAL_POPULATION) popMax = max(popMax, particles.size());
  if(SHOW_RED_POPULATION)   popMax = max(popMax, popRed);
  if(SHOW_BLUE_POPULATION)  popMax = max(popMax, popBlue);
  if(popMax >= yMaxPop * GRAPH_Y_SCALE_AT){
    yMaxPop = (int)(yMaxPop * GRAPH_Y_SCALE_FACTOR);
  }
}

// ---- Graph ----

// Draws a y-axis with smooth appearing/thinning ticks inside a subplot band.
// pxBottom/pxTop = pixel y boundaries; curVal = current max data value; yAxisMax = scale ceiling
void drawYAxis(int m, int pxBottom, int pxTop, int curVal, int yAxisMax, int tickBase){
  int yStep = tickBase;
  float plotH = pxBottom - pxTop;
  while(yAxisMax > 0 && (yStep / (float)yAxisMax) * plotH < (GRAPH_MIN_Y_TICK_PX / 4.0)){
    yStep *= 2;
  }
  float lastDrawnTy = pxBottom;
  for(int v = yStep; v <= curVal; v += yStep){
    float ty = map(v, 0, yAxisMax, pxBottom, pxTop);
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
  fill(200); noStroke(); textAlign(RIGHT, CENTER);
  text("0", m - 7, pxBottom);
}

// Draws x-axis ticks and labels along a given pixel y (the axis line).
void drawXAxis(int m, int pxAxisY, float elapsedSec){
  float plotW = (simX - m/2.0) - m;
  float tickInterval = TICK_INTERVALS[0];
  for(int ti = 0; ti < TICK_THRESHOLDS.length; ti++){
    if(elapsedSec >= TICK_THRESHOLDS[ti]) tickInterval = TICK_INTERVALS[ti + 1];
  }
  while(elapsedSec > 0 && (tickInterval / elapsedSec) * plotW < GRAPH_MIN_TICK_PX){
    tickInterval *= 2;
  }
  textSize(GRAPH_TICK_SIZE);
  for(float t = tickInterval; t <= elapsedSec; t += tickInterval){
    float tx = map(t, 0, elapsedSec, m, simX - m/2);
    stroke(180);
    line(tx, pxAxisY, tx, pxAxisY + 5);
    fill(200); noStroke(); textAlign(CENTER, TOP);
    int totalSec = (int)t;
    String lbl;
    if(totalSec < 60)            lbl = totalSec + "s";
    else if(totalSec < 3600)   { int mn=totalSec/60; int sc=totalSec%60;   lbl = sc==0 ? mn+"m" : mn+"m"+sc+"s"; }
    else if(totalSec < 86400)  { int hr=totalSec/3600; int mn=(totalSec%3600)/60; lbl = mn==0 ? hr+"h" : hr+"h"+mn+"m"; }
    else                       { int dy=totalSec/86400; int hr=(totalSec%86400)/3600; lbl = hr==0 ? dy+"d" : dy+"d"+hr+"h"; }
    text(lbl, tx, pxAxisY + 7);
  }
  fill(200); noStroke(); textAlign(CENTER, TOP);
  text("0", m, pxAxisY + 7);
}

// Draws data lines for a subplot given history arrays, pixel bounds, and y ceiling.
void drawLines(ArrayList<Integer> hist1, color c1, boolean show1,
               ArrayList<Integer> hist2, color c2, boolean show2,
               ArrayList<Integer> hist3, color c3, boolean show3,
               int m, int pxBottom, int pxTop, int yAxisMax){
  int n = hist1.size();
  if(n < 2) return;
  if(show1){ noFill(); stroke(c1);
    beginShape();
    for(int i=0;i<n;i++) vertex(map(i,0,n,m,simX-m/2), map(hist1.get(i),0,yAxisMax,pxBottom,pxTop));
    endShape(); }
  if(show2 && hist2.size()>=2){ noFill(); stroke(c2);
    beginShape();
    for(int i=0;i<hist2.size();i++) vertex(map(i,0,n,m,simX-m/2), map(hist2.get(i),0,yAxisMax,pxBottom,pxTop));
    endShape(); }
  if(show3 && hist3.size()>=2){ noFill(); stroke(c3);
    beginShape();
    for(int i=0;i<hist3.size();i++) vertex(map(i,0,n,m,simX-m/2), map(hist3.get(i),0,yAxisMax,pxBottom,pxTop));
    endShape(); }
}

void drawGraph(){
  int m    = GRAPH_MARGIN;
  int midY = height / 2;

  // outer border + divider
  stroke(255); noFill();
  rect(0, 0, simX, height);
  stroke(80);
  line(0, midY, simX, midY);

  float elapsedSec = ((millis() - startTime) / 1000.0) * TIME_SCALE;

  // ---- TOP SUBPLOT: Collision Count ----
  int topPxBottom = midY - m/2;
  int topPxTop    = m/2;
  // axes
  stroke(180);
  line(m, topPxBottom, simX - m/2, topPxBottom); // x-axis
  line(m, topPxTop,    m, topPxBottom);           // y-axis
  // y ticks
  textSize(GRAPH_TICK_SIZE);
  int refCount = 0;
  if(SHOW_TOTAL_COLLISIONS) refCount = max(refCount, collisionCount);
  if(SHOW_RED_COLLISIONS)   refCount = max(refCount, collisionCountRed);
  if(SHOW_BLUE_COLLISIONS)  refCount = max(refCount, collisionCountBlue);
  drawYAxis(m, topPxBottom, topPxTop, refCount, yMax, GRAPH_Y_TICK_BASE);
  // x ticks
  drawXAxis(m, topPxBottom, elapsedSec);
  // axis labels
  textSize(GRAPH_LABEL_SIZE); fill(255); noStroke();
  textAlign(CENTER, BOTTOM);
  text("Time", simX/2, midY - 2);
  pushMatrix();
    translate(12, midY/2); rotate(-HALF_PI);
    textAlign(CENTER, CENTER);
    text("Collisions", 0, 0);
  popMatrix();
  // data lines
  drawLines(history,      color(255,255,255), SHOW_TOTAL_COLLISIONS,
            historyRed,   color(GROUP_A_R, GROUP_A_G, GROUP_A_B), SHOW_RED_COLLISIONS,
            historyBlue,  color(GROUP_B_R, GROUP_B_G, GROUP_B_B), SHOW_BLUE_COLLISIONS,
            m, topPxBottom, topPxTop, yMax);

  // ---- BOTTOM SUBPLOT: Population ----
  int botPxBottom = height - m/2;
  int botPxTop    = midY + m/2;
  // axes
  stroke(180);
  line(m, botPxBottom, simX - m/2, botPxBottom); // x-axis
  line(m, botPxTop,    m, botPxBottom);           // y-axis
  // y ticks
  textSize(GRAPH_TICK_SIZE);
  int refPop = 0;
  if(SHOW_TOTAL_POPULATION) refPop = max(refPop, historyPopTotal.size() > 0 ? historyPopTotal.get(historyPopTotal.size()-1) : 0);
  if(SHOW_RED_POPULATION)   refPop = max(refPop, historyPopRed.size()   > 0 ? historyPopRed.get(historyPopRed.size()-1)     : 0);
  if(SHOW_BLUE_POPULATION)  refPop = max(refPop, historyPopBlue.size()  > 0 ? historyPopBlue.get(historyPopBlue.size()-1)   : 0);
  drawYAxis(m, botPxBottom, botPxTop, refPop, yMaxPop, GRAPH_Y_TICK_BASE);
  // x ticks
  drawXAxis(m, botPxBottom, elapsedSec);
  // axis labels
  textSize(GRAPH_LABEL_SIZE); fill(255); noStroke();
  textAlign(CENTER, BOTTOM);
  text("Time", simX/2, height - 2);
  pushMatrix();
    translate(12, midY + (height - midY)/2); rotate(-HALF_PI);
    textAlign(CENTER, CENTER);
    text("Population", 0, 0);
  popMatrix();
  // data lines
  drawLines(historyPopTotal, color(255,255,255), SHOW_TOTAL_POPULATION,
            historyPopRed,   color(GROUP_A_R, GROUP_A_G, GROUP_A_B), SHOW_RED_POPULATION,
            historyPopBlue,  color(GROUP_B_R, GROUP_B_G, GROUP_B_B), SHOW_BLUE_POPULATION,
            m, botPxBottom, botPxTop, yMaxPop);
}

