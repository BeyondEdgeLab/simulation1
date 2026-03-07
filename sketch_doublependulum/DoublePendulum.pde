// ---- DoublePendulum ----
// Simulates a double pendulum using RK4 (Runge-Kutta 4th order) integration.
//
// State vector:  [ theta1, omega1, theta2, omega2 ]
//   theta1/2 = angle from the downward vertical (radians)
//   omega1/2 = angular velocity (rad/s)
//
// Physics reference:
//   https://scienceworld.wolfram.com/physics/DoublePendulum.html

class DoublePendulum {
  float theta1, omega1;         // rod 1: angle and angular velocity
  float theta2, omega2;         // rod 2: angle and angular velocity

  float m1, m2;                 // masses
  float l1, l2;                 // rod lengths (simulation units)
  float g;                      // gravity

  float pivotX, pivotY, pivotZ; // 3D pivot position (pixels)
  float scale;                  // pixels per simulation unit

  color col;                    // color for rods, bobs, and trail

  ArrayList<PVector> trail;     // 3D screen positions of the second bob

  DoublePendulum(
      float theta1_, float omega1_,
      float theta2_, float omega2_,
      float pivotX_, float pivotY_, float pivotZ_,
      float scale_,
      color col_) {

    theta1 = theta1_;  omega1 = omega1_;
    theta2 = theta2_;  omega2 = omega2_;
    pivotX = pivotX_;  pivotY = pivotY_;  pivotZ = pivotZ_;
    scale  = scale_;
    col    = col_;

    m1 = M1;  m2 = M2;
    l1 = L1;  l2 = L2;
    g  = GRAVITY;

    trail = new ArrayList<PVector>();
  }

  // ---- Physics ----

  float alpha1(float t1, float w1, float t2, float w2) {
    float delta = t1 - t2;
    float num = -g * (2*m1 + m2) * sin(t1)
                - m2 * g * sin(t1 - 2*t2)
                - 2 * sin(delta) * m2 * (w2*w2*l2 + w1*w1*l1*cos(delta));
    float den = l1 * (2*m1 + m2 - m2 * cos(2*t1 - 2*t2));
    return num / den;
  }

  float alpha2(float t1, float w1, float t2, float w2) {
    float delta = t1 - t2;
    float num = 2 * sin(delta) * (
                  w1*w1*l1*(m1 + m2)
                  + g*(m1 + m2)*cos(t1)
                  + w2*w2*l2*m2*cos(delta));
    float den = l2 * (2*m1 + m2 - m2 * cos(2*t1 - 2*t2));
    return num / den;
  }

  // Advances the simulation by dt seconds using RK4.
  void update(float dt) {
    float k1_t1 = omega1;
    float k1_w1 = alpha1(theta1, omega1, theta2, omega2);
    float k1_t2 = omega2;
    float k1_w2 = alpha2(theta1, omega1, theta2, omega2);

    float k2_t1 = omega1 + 0.5*dt*k1_w1;
    float k2_w1 = alpha1(theta1 + 0.5*dt*k1_t1, omega1 + 0.5*dt*k1_w1,
                         theta2 + 0.5*dt*k1_t2, omega2 + 0.5*dt*k1_w2);
    float k2_t2 = omega2 + 0.5*dt*k1_w2;
    float k2_w2 = alpha2(theta1 + 0.5*dt*k1_t1, omega1 + 0.5*dt*k1_w1,
                         theta2 + 0.5*dt*k1_t2, omega2 + 0.5*dt*k1_w2);

    float k3_t1 = omega1 + 0.5*dt*k2_w1;
    float k3_w1 = alpha1(theta1 + 0.5*dt*k2_t1, omega1 + 0.5*dt*k2_w1,
                         theta2 + 0.5*dt*k2_t2, omega2 + 0.5*dt*k2_w2);
    float k3_t2 = omega2 + 0.5*dt*k2_w2;
    float k3_w2 = alpha2(theta1 + 0.5*dt*k2_t1, omega1 + 0.5*dt*k2_w1,
                         theta2 + 0.5*dt*k2_t2, omega2 + 0.5*dt*k2_w2);

    float k4_t1 = omega1 + dt*k3_w1;
    float k4_w1 = alpha1(theta1 + dt*k3_t1, omega1 + dt*k3_w1,
                         theta2 + dt*k3_t2, omega2 + dt*k3_w2);
    float k4_t2 = omega2 + dt*k3_w2;
    float k4_w2 = alpha2(theta1 + dt*k3_t1, omega1 + dt*k3_w1,
                         theta2 + dt*k3_t2, omega2 + dt*k3_w2);

    theta1 += (dt / 6.0) * (k1_t1 + 2*k2_t1 + 2*k3_t1 + k4_t1);
    omega1 += (dt / 6.0) * (k1_w1 + 2*k2_w1 + 2*k3_w1 + k4_w1);
    theta2 += (dt / 6.0) * (k1_t2 + 2*k2_t2 + 2*k3_t2 + k4_t2);
    omega2 += (dt / 6.0) * (k1_w2 + 2*k2_w2 + 2*k3_w2 + k4_w2);

    if(TRAIL_LENGTH > 0) {
      trail.add(bob2Pos());
      if(trail.size() > TRAIL_LENGTH) trail.remove(0);
    }
  }

  // ---- 3D Position Helpers ----

  // 3D screen position of bob 1 (end of rod 1).
  PVector bob1Pos() {
    return new PVector(
      pivotX + l1 * scale * sin(theta1),
      pivotY + l1 * scale * cos(theta1),
      pivotZ
    );
  }

  // 3D screen position of bob 2 (end of rod 2).
  PVector bob2Pos() {
    PVector b1 = bob1Pos();
    return new PVector(
      b1.x + l2 * scale * sin(theta2),
      b1.y + l2 * scale * cos(theta2),
      pivotZ
    );
  }

  // ---- Drawing ----

  void drawTrail() {
    if(trail.size() < 2) return;
    int n = trail.size();
    for(int i = 1; i < n; i++) {
      float t = (float)i / n;
      float alpha = lerp(TRAIL_ALPHA_MIN, TRAIL_ALPHA_MAX, t);
      stroke(red(col), green(col), blue(col), alpha);
      strokeWeight(TRAIL_WEIGHT);
      PVector a = trail.get(i - 1);
      PVector b = trail.get(i);
      line(a.x, a.y, a.z, b.x, b.y, b.z);
    }
  }

  void drawPendulum() {
    PVector b1 = bob1Pos();
    PVector b2 = bob2Pos();

    if(SHOW_RODS) {
      stroke(red(col), green(col), blue(col), 200);
      strokeWeight(ROD_WEIGHT);
      line(pivotX, pivotY, pivotZ, b1.x, b1.y, b1.z);
      line(b1.x,   b1.y,   b1.z,   b2.x, b2.y, b2.z);
    }

    if(SHOW_BOBS) {
      noStroke();
      fill(red(col), green(col), blue(col), 230);
      pushMatrix();
        translate(b1.x, b1.y, b1.z);
        sphere(BOB_RADIUS);
      popMatrix();

      fill(255, 230);
      pushMatrix();
        translate(b2.x, b2.y, b2.z);
        sphere(BOB_RADIUS);
      popMatrix();
    }
  }

  void show() {
    drawTrail();
    drawPendulum();
  }

  void reset(float t1, float t2) {
    theta1 = t1; omega1 = 0;
    theta2 = t2; omega2 = 0;
    trail.clear();
  }
}
