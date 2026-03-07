// ---- Double Pendulum Simulation — 3D View ----
// DoublePendulum class  -> DoublePendulum.pde
// Constants             -> Constants.pde
//
// Multiple pendulums start with nearly-identical initial conditions.
// Their paths diverge over time, visually demonstrating chaotic sensitivity.
// The pendulums are spread along the Z axis so you can orbit around them.
//
// Controls:
//   Mouse drag        — orbit camera (left/right = rotate, up/down = tilt)
//   Scroll wheel      — zoom in/out
//   Click             — reset simulation
//   R                 — reset simulation
//   Space             — reset camera angle only

ArrayList<DoublePendulum> pendulums;
float pivotX, pivotY, scalePixels;
float camAngleX, camAngleY;   // current orbit angles (radians)
float camZoom;                // zoom multiplier
float prevMouseX, prevMouseY; // last drag position

void settings() {
  fullScreen(P3D);
}

void setup() {
  frameRate(60);

  pivotX      = width  / 2.0;
  pivotY      = height * PIVOT_Y;
  scalePixels = height * SCALE;

  // Default camera angle: slight tilt and rotation so 3D depth is visible
  camAngleX = CAM_INIT_ANGLE_X;
  camAngleY = CAM_INIT_ANGLE_Y;
  camZoom   = 1.0;

  buildPendulums();
}

void buildPendulums() {
  pendulums = new ArrayList<DoublePendulum>();

  // Spread pendulums symmetrically along Z around the pivot
  float totalZ = (NUM_PENDULUMS - 1) * Z_SPREAD;

  for(int i = 0; i < NUM_PENDULUMS; i++) {
    float t = (NUM_PENDULUMS == 1) ? 0.5 : (float)i / (NUM_PENDULUMS - 1);
    color c  = lerpColor(COLOR_START, COLOR_END, t);

    float t1  = THETA1_INIT + i * CHAOS_OFFSET;
    float pz  = i * Z_SPREAD - totalZ / 2.0;  // centred on 0

    pendulums.add(new DoublePendulum(
      t1, OMEGA1_INIT,
      THETA2_INIT, OMEGA2_INIT,
      pivotX, pivotY, pz,
      scalePixels,
      c
    ));
  }
}

void draw() {
  background(BACKGROUND_COLOR);
  lights();

  // ---- Orbit camera around the pivot ----
  // Translate origin to pivot, rotate, translate back
  translate(pivotX, pivotY, 0);
  scale(camZoom);
  rotateX(camAngleX);
  rotateY(camAngleY);
  translate(-pivotX, -pivotY, 0);

  // Physics
  for(DoublePendulum p : pendulums) {
    for(int s = 0; s < STEPS_PER_FRAME; s++) {
      p.update(TIME_STEP);
    }
  }

  // Trails (drawn behind rods/bobs)
  for(DoublePendulum p : pendulums) {
    p.drawTrail();
  }

  // Pivot marker
  noStroke();
  fill(200);
  pushMatrix();
    translate(pivotX, pivotY, 0);
    sphere(5);
  popMatrix();

  // Rods and bobs
  for(DoublePendulum p : pendulums) {
    p.drawPendulum();
  }

  // ---- HUD overlay (drawn flat in screen space) ----
  hint(DISABLE_DEPTH_TEST);
  camera();          // reset to default 2D-like view for text
  noLights();
  fill(180);
  noStroke();
  textSize(13);
  textAlign(LEFT, TOP);
  text("Double Pendulum  |  " + NUM_PENDULUMS + " pendulums  |  chaos offset: " + CHAOS_OFFSET, 14, 14);
  text("Drag to orbit  |  Scroll to zoom  |  Click or R = reset  |  Space = reset camera", 14, 32);
  hint(ENABLE_DEPTH_TEST);
}

// ---- Input ----

void mouseDragged() {
  float dx = mouseX - prevMouseX;
  float dy = mouseY - prevMouseY;
  camAngleY += dx * CAM_DRAG_SENSITIVITY;
  camAngleX += dy * CAM_DRAG_SENSITIVITY;
  prevMouseX = mouseX;
  prevMouseY = mouseY;
}

void mousePressed() {
  prevMouseX = mouseX;
  prevMouseY = mouseY;
  // single click resets simulation (but not if user just started dragging)
}

void mouseReleased() {
  // if mouse barely moved, treat as a reset click
  float dx = abs(mouseX - prevMouseX);
  float dy = abs(mouseY - prevMouseY);
  if(dx < 5 && dy < 5) buildPendulums();
}

void mouseWheel(MouseEvent e) {
  camZoom -= e.getCount() * 0.05;
  camZoom  = constrain(camZoom, 0.2, 5.0);
}

void keyPressed() {
  if(key == 'r' || key == 'R') {
    buildPendulums();
  }
  if(key == ' ') {
    camAngleX = CAM_INIT_ANGLE_X;
    camAngleY = CAM_INIT_ANGLE_Y;
    camZoom   = 1.0;
  }
}
