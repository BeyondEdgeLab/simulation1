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
float camOffsetX, camOffsetY; // pan offset in screen pixels
float camZoom;                // zoom multiplier
float prevMouseX, prevMouseY; // last drag position

// Reset button bounds (set in draw so they scale with window)
float btnX, btnY, btnW, btnH;

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
  camOffsetX = 0;  camOffsetY = 0;
  camZoom   = 1.0;

  buildPendulums();
}

void buildPendulums() {
  pendulums = new ArrayList<DoublePendulum>();

  // Spread pendulums symmetrically along Z around the pivot
  float totalZ = (NUM_PENDULUMS - 1) * Z_SPREAD;

  for(int i = 0; i < NUM_PENDULUMS; i++) {
    float t = (float)i / max(1, (NUM_PENDULUMS - 1));
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

  // ---- Orbit + pan camera around the pivot ----
  translate(camOffsetX, camOffsetY, 0);         // pan (screen space)
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
  text("Left-drag: orbit  |  Right-drag: pan  |  Scroll: zoom  |  Space: reset camera", 14, 32);

  // Reset button
  btnW = 140;  btnH = 30;
  btnX = width - btnW - 16;
  btnY = 16;
  boolean hover = mouseX >= btnX && mouseX <= btnX + btnW &&
                  mouseY >= btnY && mouseY <= btnY + btnH;
  fill(hover ? color(220, 80, 80) : color(160, 50, 50));
  stroke(220, 100, 100);
  strokeWeight(1);
  rect(btnX, btnY, btnW, btnH, 5);
  fill(255);
  noStroke();
  textSize(13);
  textAlign(CENTER, CENTER);
  text("Reset Simulation", btnX + btnW/2, btnY + btnH/2);

  hint(ENABLE_DEPTH_TEST);
}

// ---- Input ----

void mouseDragged() {
  float dx = mouseX - prevMouseX;
  float dy = mouseY - prevMouseY;
  if(mouseButton == RIGHT) {
    camOffsetX += dx * CAM_PAN_SENSITIVITY;
    camOffsetY += dy * CAM_PAN_SENSITIVITY;
  } else {
    camAngleY += dx * CAM_DRAG_SENSITIVITY;
    camAngleX += dy * CAM_DRAG_SENSITIVITY;
  }
  prevMouseX = mouseX;
  prevMouseY = mouseY;
}

void mousePressed() {
  prevMouseX = mouseX;
  prevMouseY = mouseY;
}

void mouseReleased() {
  // Only trigger button if mouse barely moved (i.e. a click, not a drag)
  float dx = abs(mouseX - prevMouseX);
  float dy = abs(mouseY - prevMouseY);
  if(dx < 5 && dy < 5) {
    if(mouseX >= btnX && mouseX <= btnX + btnW &&
       mouseY >= btnY && mouseY <= btnY + btnH) {
      buildPendulums();  // reset physics only — camera unchanged
    }
  }
}

void mouseWheel(MouseEvent e) {
  camZoom -= e.getCount() * CAM_ZOOM_STEP;
  camZoom  = constrain(camZoom, CAM_ZOOM_MIN, CAM_ZOOM_MAX);
}

void keyPressed() {
  if(key == 'r' || key == 'R') {
    buildPendulums();
  }
  if(key == ' ') {
    camAngleX  = CAM_INIT_ANGLE_X;
    camAngleY  = CAM_INIT_ANGLE_Y;
    camOffsetX = 0;  camOffsetY = 0;
    camZoom    = 1.0;
  }
}
