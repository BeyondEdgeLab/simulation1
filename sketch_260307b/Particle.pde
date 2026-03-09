class Particle {
  float x, y, r;
  float vx, vy;
  color col;        // particle color
  int   groupId;    // 0 = Group A (red), 1 = Group B (blue)
  int   offsprings; // total offspring this particle has produced
  float birthSimTime;

  float age(){
    return simElapsedSec - birthSimTime;
  }

  boolean isMature(){
    float minAge = (groupId == 0) ? groupAMinAge : groupBMinAge;
    return age() >= minAge;
  }

  boolean isDead(){
    float maxAge = (groupId == 0) ? groupAMaxAge : groupBMaxAge;
    return age() >= maxAge;
  }
  
  Particle(float x_, float y_, color col_, int groupId_){
    x = x_;
    y = y_;
    col = col_;
    groupId = groupId_;
    offsprings = 0;
    birthSimTime = simElapsedSec;
    r = PARTICLE_RADIUS;
    vx = random(-MAX_SPEED, MAX_SPEED);
    vy = random(-MAX_SPEED, MAX_SPEED);
  }
  
  void move(){
    x += vx * TIME_SCALE;
    y += vy * TIME_SCALE;
  }

  void keepInBounds(){
    float leftBound = simX + r;
    float rightBound = width - r;
    float topBound = r;
    float bottomBound = height - r;

    if(x < leftBound){
      x = leftBound;
      vx = abs(vx);
    } else if(x > rightBound){
      x = rightBound;
      vx = -abs(vx);
    }

    if(y < topBound){
      y = topBound;
      vy = abs(vy);
    } else if(y > bottomBound){
      y = bottomBound;
      vy = -abs(vy);
    }
  }
  
  void wallBounce(){
    keepInBounds();
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
        if(isMature() && other.isMature()){
          int count = groupAOffspring;
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
        if(isMature() && other.isMature()){
          int count = groupBOffspring;
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
      offsprings       += (groupId == 0) ? groupAOffspring : groupBOffspring;
      other.offsprings += (other.groupId == 0) ? groupAOffspring : groupBOffspring;
      
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

      keepInBounds();
      other.keepInBounds();
    }
  }
  
  void show(){
    float maxAge = (groupId == 0) ? groupAMaxAge : groupBMaxAge;
    float minAge = (groupId == 0) ? groupAMinAge : groupBMinAge;
    float a = age();
    float alpha = a < minAge ? map(a, 0, minAge, 80, 255) : 255;
    alpha = a > maxAge * 0.8 ? map(a, maxAge * 0.8, maxAge, 255, 0) : alpha;
    fill(red(col), green(col), blue(col), alpha);
    noStroke();
    circle(x, y, r*2);
  }
}
