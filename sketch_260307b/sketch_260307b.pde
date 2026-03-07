ArrayList<Particle> particles;
int collisionCount = 0;
ArrayList<Integer> history;

int simX = 400; // left part for graph

void setup() {
  size(900,400);
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

class Particle {
  float x, y, r;
  float vx, vy;
  
  Particle(float x_, float y_){
    x = x_;
    y = y_;
    r = 8;
    vx = random(-2,2);
    vy = random(-2,2);
  }
  
  void move(){
    x += vx;
    y += vy;
  }
  
  void wallBounce(){
    if(x < simX + r || x > width - r) vx *= -1;
    if(y < r || y > height - r) vy *= -1;
  }
  
  void collide(Particle other){
    float dx = other.x - x;
    float dy = other.y - y;
    float dist = sqrt(dx*dx + dy*dy);
    float minDist = r + other.r;
    
    if(dist < minDist){
      collisionCount++;
      
      float angle = atan2(dy,dx);
      float overlap = minDist - dist;
      
      x -= cos(angle)*overlap/2;
      y -= sin(angle)*overlap/2;
      
      other.x += cos(angle)*overlap/2;
      other.y += sin(angle)*overlap/2;
      
      float tempX = vx;
      float tempY = vy;
      
      vx = other.vx;
      vy = other.vy;
      
      other.vx = tempX;
      other.vy = tempY;
    }
  }
  
  void show(){
    circle(x,y,r*2);
  }
}
