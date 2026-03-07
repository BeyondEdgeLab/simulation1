class Particle {
  float x, y, r;
  float vx, vy;
  color col;        // particle color
  int   groupId;    // 0 = Group A (red), 1 = Group B (blue)
  int   offsprings; // total offspring this particle has produced
  int   birthTime;  // millis() at creation, used to compute simulated age

  // returns simulated age in seconds (respects TIME_SCALE)
  float age(){
    return ((millis() - birthTime) / 1000.0) * TIME_SCALE;
  }

  // returns true once particle has lived long enough to produce offspring
  boolean isMature(){
    float minAge = (groupId == 0) ? GROUP_A_MIN_AGE : GROUP_B_MIN_AGE;
    return age() >= minAge;
  }

  // returns true when particle has exceeded its lifespan
  boolean isDead(){
    float maxAge = (groupId == 0) ? GROUP_A_MAX_AGE : GROUP_B_MAX_AGE;
    return age() >= maxAge;
  }
  
  Particle(float x_, float y_, color col_, int groupId_){
    x = x_;
    y = y_;
    col = col_;
    groupId = groupId_;
    offsprings = 0;
    birthTime = millis();
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
      // global total — always incremented
      collisionCount++;
      // per-group: only count when both particles are the same color
      // red vs blue collisions count in total only
      if(groupId == 0 && other.groupId == 0){
        collisionCountRed++;
        // spawn red offspring only if both parents are mature
        if(isMature() && other.isMature()){
          int count = GROUP_A_OFFSPRING;
          for(int k = 0; k < count; k++){
            float mx = (x + other.x) / 2;
            float my = (y + other.y) / 2;
            pendingParticles.add(new Particle(
              mx + random(-r*2, r*2),
              my + random(-r*2, r*2),
              color(GROUP_A_R, GROUP_A_G, GROUP_A_B),
              0
            ));
          }
        }
      }
      if(groupId == 1 && other.groupId == 1){
        collisionCountBlue++;
        // spawn blue offspring only if both parents are mature
        if(isMature() && other.isMature()){
          int count = GROUP_B_OFFSPRING;
          for(int k = 0; k < count; k++){
            float mx = (x + other.x) / 2;
            float my = (y + other.y) / 2;
            pendingParticles.add(new Particle(
              mx + random(-r*2, r*2),
              my + random(-r*2, r*2),
              color(GROUP_B_R, GROUP_B_G, GROUP_B_B),
              1
            ));
          }
        }
      }
      // per-particle offspring tracking
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
    // fade out as particle approaches end of life
    float maxAge = (groupId == 0) ? GROUP_A_MAX_AGE : GROUP_B_MAX_AGE;
    float minAge = (groupId == 0) ? GROUP_A_MIN_AGE : GROUP_B_MIN_AGE;
    float a = age();
    // dim while immature (not yet able to reproduce)
    float alpha = a < minAge ? map(a, 0, minAge, 80, 255) : 255;
    // fade near death
    alpha = a > maxAge * 0.8 ? map(a, maxAge * 0.8, maxAge, 255, 0) : alpha;
    fill(red(col), green(col), blue(col), alpha);
    noStroke();
    circle(x, y, r*2);
  }
}
