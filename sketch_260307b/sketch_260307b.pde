// ---- Main Sketch ----
// Particle class -> Particle.pde
// Constants    -> Constants.pde

ArrayList<Particle> particles;
int collisionCount = 0;
ArrayList<Integer> history;
int simX;

void settings() {
  fullScreen();
}

void setup() {
  simX = (int)(width * GRAPH_RATIO);
  particles = new ArrayList<Particle>();
  history = new ArrayList<Integer>();
  
  for(int i=0;i<PARTICLE_COUNT;i++){
    particles.add(new Particle(random(simX+20,width-20), random(20,height-20)));
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
  
  // y-axis: 0 at bottom, max at top
  textAlign(RIGHT, CENTER);
  text("0",    m - 5, height - m);
  text(GRAPH_MAX_COLLISIONS/2, m - 5, height/2);
  text(GRAPH_MAX_COLLISIONS,   m - 5, m/2);
  
  // x-axis: start and "now"
  textAlign(CENTER, TOP);
  text("0", m, height - m + 5);
  text(history.size(), simX - m/2, height - m + 5);
  
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
  
  // --- Data line ---
  noFill();
  stroke(100, 200, 255);
  beginShape();
  for(int i = 0; i < history.size(); i++){
    float x = map(i, 0, max(history.size(), 1), m, simX - m/2);
    float y = map(history.get(i), 0, GRAPH_MAX_COLLISIONS, height - m, m/2);
    vertex(x, y);
  }
  endShape();
}

