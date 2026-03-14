// ─── OrbitalBody.pde  —  a single gravitational body ─────────────────────────

class OrbitalBody {
  PVector pos, vel, acc;
  float   mass;
  color   col;
  ArrayList<PVector> trail;

  OrbitalBody(float x,  float y,  float z,
              float vx, float vy, float vz,
              float m,  color c) {
    pos   = new PVector(x, y, z);
    vel   = new PVector(vx, vy, vz);
    acc   = new PVector(0, 0, 0);
    mass  = m;
    col   = c;
    trail = new ArrayList<PVector>();
  }

  // ── Deep copy ──────────────────────────────────────────────────────────────
  OrbitalBody copy() {
    OrbitalBody b = new OrbitalBody(
      pos.x, pos.y, pos.z,
      vel.x, vel.y, vel.z,
      mass, col);
    b.acc = acc.copy();
    // trail intentionally not copied – twin starts with a clean history
    return b;
  }

  // ── Trail bookkeeping ──────────────────────────────────────────────────────
  void recordTrail() {
    trail.add(pos.copy());
    if (trail.size() > TRAIL_MAX) trail.remove(0);
  }

  void clearTrail() { trail.clear(); }

  // ── Rendering ──────────────────────────────────────────────────────────────
  // alphaScale: 1.0 = fully opaque, 0.35 = translucent twin
  void draw(float sc, boolean drawTrail, float alphaScale) {
    // --- coloured trail (drawn with stroke, not affected by lighting) ---
    if (drawTrail && trail.size() > 1) {
      noFill();
      strokeWeight(1.2);
      int n = trail.size();
      for (int i = 1; i < n; i++) {
        float t = (float) i / n;
        stroke(red(col), green(col), blue(col), t * 195 * alphaScale);
        PVector a = trail.get(i - 1);
        PVector b = trail.get(i);
        line(a.x * sc, a.y * sc, a.z * sc,
             b.x * sc, b.y * sc, b.z * sc);
      }
    }

    // --- body sphere (lit by scene lights) ---
    float r = 5 + sqrt(mass) * 5;
    pushMatrix();
    translate(pos.x * sc, pos.y * sc, pos.z * sc);
    noStroke();
    fill(red(col), green(col), blue(col), 255 * alphaScale);
    sphere(r);
    popMatrix();
  }

  // --- velocity arrow ---
  void drawVelocityArrow(float sc, float alphaScale) {
    PVector tip = PVector.add(pos, PVector.mult(vel, 0.7));
    strokeWeight(1.5);
    stroke(255, 220, 50, 200 * alphaScale);
    line(pos.x * sc, pos.y * sc, pos.z * sc,
         tip.x * sc, tip.y * sc, tip.z * sc);
    // small sphere at tip as arrowhead
    pushMatrix();
    translate(tip.x * sc, tip.y * sc, tip.z * sc);
    noStroke();
    fill(255, 220, 50, 180 * alphaScale);
    sphere(3);
    popMatrix();
  }
}
