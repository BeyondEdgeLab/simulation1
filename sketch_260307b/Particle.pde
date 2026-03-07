class Particle {
  float x, y, r;
  float vx, vy;
  
  Particle(float x_, float y_){
    x = x_;
    y = y_;
    r = PARTICLE_RADIUS;
    vx = random(-MAX_SPEED, MAX_SPEED);
    vy = random(-MAX_SPEED, MAX_SPEED);
  }
  
  void move(){
    x += vx * TIME_SCALE;
    y += vy * TIME_SCALE;
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
