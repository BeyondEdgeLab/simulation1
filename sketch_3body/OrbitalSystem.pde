// ─── OrbitalSystem.pde  —  N-body system with velocity-Verlet integration ────

class OrbitalSystem {
  OrbitalBody[] bodies;

  OrbitalSystem(OrbitalBody[] b) {
    bodies = b;
    // seed accelerations so the first Verlet step is correct
    PVector[] a0 = gravAcc();
    for (int i = 0; i < bodies.length; i++) bodies[i].acc = a0[i];
  }

  // ── Deep copy (used to build the perturbed twin) ──────────────────────────
  OrbitalSystem copy() {
    OrbitalBody[] b = new OrbitalBody[bodies.length];
    for (int i = 0; i < bodies.length; i++) b[i] = bodies[i].copy();
    return new OrbitalSystem(b);
  }

  // ── Gravitational accelerations (softened Plummer kernel) ─────────────────
  PVector[] gravAcc() {
    int n = bodies.length;
    PVector[] a = new PVector[n];
    for (int i = 0; i < n; i++) a[i] = new PVector(0, 0, 0);

    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        PVector r    = PVector.sub(bodies[j].pos, bodies[i].pos);
        float   d2   = r.magSq() + SOFTENING * SOFTENING;
        float   d    = sqrt(d2);
        float   coef = G / (d2 * d);          // G / |r|^3  (softened)
        a[i].add(PVector.mult(r, coef * bodies[j].mass));
        a[j].sub(PVector.mult(r, coef * bodies[i].mass));
      }
    }
    return a;
  }

  // ── Velocity-Verlet integration (one sub-step) ────────────────────────────
  void step(float dt) {
    // 1) advance positions using current vel + acc
    for (OrbitalBody b : bodies) {
      b.pos.x += b.vel.x * dt + 0.5 * b.acc.x * dt * dt;
      b.pos.y += b.vel.y * dt + 0.5 * b.acc.y * dt * dt;
      b.pos.z += b.vel.z * dt + 0.5 * b.acc.z * dt * dt;
      b.recordTrail();
    }
    // 2) evaluate acceleration at new positions
    PVector[] newAcc = gravAcc();
    // 3) advance velocities using average of old and new acc
    for (int i = 0; i < bodies.length; i++) {
      bodies[i].vel.x += 0.5 * (bodies[i].acc.x + newAcc[i].x) * dt;
      bodies[i].vel.y += 0.5 * (bodies[i].acc.y + newAcc[i].y) * dt;
      bodies[i].vel.z += 0.5 * (bodies[i].acc.z + newAcc[i].z) * dt;
      bodies[i].acc = newAcc[i];
    }
  }

  // ── Rendering ─────────────────────────────────────────────────────────────
  void draw(float sc, boolean trails, boolean vectors, float alpha) {
    for (OrbitalBody b : bodies) {
      b.draw(sc, trails, alpha);
      if (vectors) b.drawVelocityArrow(sc, alpha);
    }
  }

  // ── Diagnostics ───────────────────────────────────────────────────────────
  // Total mechanical energy: KE + PE
  float totalEnergy() {
    float ke = 0, pe = 0;
    for (OrbitalBody b : bodies)
      ke += 0.5 * b.mass * b.vel.magSq();
    for (int i = 0; i < bodies.length; i++)
      for (int j = i + 1; j < bodies.length; j++) {
        float d = max(PVector.dist(bodies[i].pos, bodies[j].pos), SOFTENING);
        pe -= G * bodies[i].mass * bodies[j].mass / d;
      }
    return ke + pe;
  }

  // Mass-weighted centre of mass
  PVector centerOfMass() {
    PVector cm    = new PVector();
    float   total = 0;
    for (OrbitalBody b : bodies) {
      cm.add(PVector.mult(b.pos, b.mass));
      total += b.mass;
    }
    return cm.div(total);
  }

  // Largest distance from CoM — used to fit the camera
  float boundingRadius() {
    PVector cm = centerOfMass();
    float   r  = 0.5;
    for (OrbitalBody b : bodies)
      r = max(r, PVector.dist(b.pos, cm));
    return r;
  }
}
