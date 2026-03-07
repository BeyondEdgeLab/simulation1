// ---- Double Pendulum Simulation ----
// DoublePendulum class  -> DoublePendulum.pde
// Constants             -> Constants.pde
//
// Multiple pendulums start with nearly-identical initial conditions.
// Their paths diverge over time, visually demonstrating chaotic sensitivity.
//
// Controls:
//   Click anywhere  — reset all pendulums to initial conditions
//   R               — reset all pendulums to initial conditions

ArrayList<DoublePendulum> pendulums;
float pivotX, pivotY, scalePixels;

void settings() {
  fullScreen();
}

void setup() {
  frameRate(60);

  pivotX      = width / 2.0;
  pivotY      = height * PIVOT_Y;
  scalePixels = height * SCALE;

  buildPendulums();
}

void buildPendulums() {
  pendulums = new ArrayList<DoublePendulum>();

  for(int i = 0; i < NUM_PENDULUMS; i++) {
    // Interpolate color from COLOR_START to COLOR_END across the set
    float t = (NUM_PENDULUMS == 1) ? 0.5 : (float)i / (NUM_PENDULUMS - 1);
    color c = lerpColor(COLOR_START, COLOR_END, t);

    // Each pendulum gets a tiny offset on theta1 to show chaos
    float t1 = THETA1_INIT + i * CHAOS_OFFSET;
    float t2 = THETA2_INIT;

    pendulums.add(new DoublePendulum(
      t1, OMEGA1_INIT,
      t2, OMEGA2_INIT,
      pivotX, pivotY,
      scalePixels,
      c
    ));
  }
}

void draw() {
  background(BACKGROUND_COLOR);

  // Step physics multiple times per frame
  for(DoublePendulum p : pendulums) {
    for(int s = 0; s < STEPS_PER_FRAME; s++) {
      p.update(TIME_STEP);
    }
  }

  // Draw trails first (behind rods/bobs)
  for(DoublePendulum p : pendulums) {
    p.drawTrail();
  }

  // Draw pivot point
  fill(200);
  noStroke();
  circle(pivotX, pivotY, 8);

  // Draw rods and bobs on top
  for(DoublePendulum p : pendulums) {
    p.drawPendulum();
  }

  // HUD
  fill(180);
  noStroke();
  textSize(13);
  textAlign(LEFT, TOP);
  text("Double Pendulum  |  " + NUM_PENDULUMS + " pendulums  |  chaos offset: " + CHAOS_OFFSET, 14, 14);
  text("Click or press R to reset", 14, 32);
}

void mousePressed() {
  buildPendulums();
}

void keyPressed() {
  if(key == 'r' || key == 'R') {
    buildPendulums();
  }
}
