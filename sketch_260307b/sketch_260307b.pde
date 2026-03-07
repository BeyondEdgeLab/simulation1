// ---- Main Sketch ----
// Particle class -> Particle.pde

ArrayList<Particle> particles;
int collisionCount = 0;
ArrayList<Integer> history;

int simX = 533; // left part for graph

void setup() {
  size(1200,600);
  particles = new ArrayList<Particle>();
  history = new ArrayList<Integer>();
  
  for(int i=0;i<25;i++){
    particles.add(new Particle(random(simX+20,width-20), random(20,height-20)));
  }
}

void draw() {
  background(30);
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
  stroke(255);
  noFill();
  rect(0,0,simX,height);
  
  noFill();
  beginShape();
  for(int i=0;i<history.size();i++){
    float x = map(i,0,history.size(),0,simX);
    float y = map(history.get(i),0,1000,height,0);
    vertex(x,y);
  }
  endShape();
}

