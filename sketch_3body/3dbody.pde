// =======================================================
// 3-Body Gravitational Simulation (3D)
// Processing (.pde)
// =======================================================

float G = 1.0;          // gravitational constant
float dt = 0.01;        // timestep
boolean simPaused = false;

SimBody[] bodies = new SimBody[3];

float rotX = PI/6;
float rotY = PI/4;
float zoom = 400;

float panX = 0;
float panY = 0;

ArrayList<PVector>[] trails;

int TRAIL_MAX = 600;

void setup() {
  size(1200, 900, P3D);
  smooth(8);

  initSystem();
}

void initSystem() {

  bodies[0] = new SimBody(
    new PVector(-60, 0, 0),
    new PVector(0, 1.2, 0.5),
    20,
    color(255, 120, 120)
  );

  bodies[1] = new SimBody(
    new PVector(60, 0, 0),
    new PVector(0, -1.1, -0.4),
    20,
    color(120, 200, 255)
  );

  bodies[2] = new SimBody(
    new PVector(0, 80, 0),
    new PVector(-1.0, 0, 0.7),
    20,
    color(255, 220, 120)
  );

  trails = (ArrayList<PVector>[]) new ArrayList[3];

  for (int i = 0; i < 3; i++) {
    trails[i] = new ArrayList<PVector>();
  }
}

void draw() {

  background(5);
  lights();

  translate(width/2 + panX, height/2 + panY, zoom);

  rotateX(rotX);
  rotateY(rotY);

  scale(1, -1, 1);

  if (!simPaused) updatePhysics();

  drawTrails();
  drawBodies();
}

void updatePhysics() {

  PVector[] forces = new PVector[3];

  for (int i = 0; i < 3; i++)
    forces[i] = new PVector();

  for (int i = 0; i < 3; i++) {
    for (int j = i+1; j < 3; j++) {

      PVector r = PVector.sub(bodies[j].pos, bodies[i].pos);
      float dist = max(r.mag(), 5);

      float f = G * bodies[i].mass * bodies[j].mass / (dist * dist);

      r.normalize();
      r.mult(f);

      forces[i].add(r);
      forces[j].sub(r);
    }
  }

  for (int i = 0; i < 3; i++) {

    SimBody b = bodies[i];

    PVector acc = PVector.div(forces[i], b.mass);

    b.vel.add(PVector.mult(acc, dt));
    b.pos.add(PVector.mult(b.vel, dt));

    trails[i].add(b.pos.copy());

    if (trails[i].size() > TRAIL_MAX)
      trails[i].remove(0);
  }
}

void drawBodies() {

  for (int i = 0; i < 3; i++) {

    SimBody b = bodies[i];

    pushMatrix();
    translate(b.pos.x, b.pos.y, b.pos.z);

    fill(b.col);
    noStroke();
    sphere(10);

    popMatrix();
  }
}

void drawTrails() {

  strokeWeight(2);

  for (int i = 0; i < 3; i++) {

    stroke(bodies[i].col);
    noFill();

    beginShape();

    for (PVector p : trails[i])
      vertex(p.x, p.y, p.z);

    endShape();
  }
}

void mouseDragged() {

  if (mouseButton == LEFT) {

    rotY += (mouseX - pmouseX) * 0.01;
    rotX += (mouseY - pmouseY) * 0.01;

  } else if (mouseButton == RIGHT) {

    panX += mouseX - pmouseX;
    panY += mouseY - pmouseY;
  }
}

void mouseWheel(processing.event.MouseEvent event) {

  float e = event.getCount();
  zoom += e * 20;
}

void keyPressed() {

  if (key == ' ') simPaused = !simPaused;

  if (key == 'r' || key == 'R')
    initSystem();
}

