class Particle {
  float x, y, r;
  float vx, vy;
  color col;       // particle color, set at construction
  int groupId;     // 0 = Group A (red), 1 = Group B (blue)
  int offsprings;  // number of collisions this particle has been involved in
  
  Particle(float x_, float y_, color col_, int groupId_){
    x = x_;
    y = y_;
    col = col_;
    groupId = groupId_;
    offsprings = 0;
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
      // global total
      collisionCount++;
      // per-group counters (a red-blue collision increments both)
      if(groupId == 0 || other.groupId == 0) collisionCountRed++;
      if(groupId == 1 || other.groupId == 1) collisionCountBlue++;
      // per-particle offspring count: each particle uses its own group's constant
      offsprings       += (groupId == 0) ? GROUP_A_OFFSPRING : GROUP_B_OFFSPRING;
      other.offsprings += (other.groupId == 0) ? GROUP_A_OFFSPRING : GROUP_B_OFFSPRING;
      
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
    fill(col);
    noStroke();
    circle(x, y, r*2);
  }
}
