import processing.event.MouseEvent;

// ===============================
// PARAMETERS
// ===============================

float G = 10000;
float dt = 0.01;
int SUBSTEPS = 40;

Body[] bodies = new Body[3];

ArrayList<PVector>[] trails;
int TRAIL = 1500;

// camera controls
float camAngle = 0;
float zoom = 700;

float rotX = PI/6;
float rotY = 0;

float panX = 0;
float panY = 0;


// ===============================
// SETUP
// ===============================

void setup(){
  size(1400,900,P3D);
  smooth(8);
  initSystem();
}

void initSystem(){

  float scale = 200;
  float vScale = sqrt(G / scale);   // Kepler-correct velocity scaling

  bodies[0] = new Body(
    new PVector(-0.97000436,0.24308753,0).mult(scale),
    new PVector(0.4662036850,0.4323657300,0).mult(vScale),
    1,color(255,120,120));

  bodies[1] = new Body(
    new PVector(0.97000436,-0.24308753,0).mult(scale),
    new PVector(0.4662036850,0.4323657300,0).mult(vScale),
    1,color(120,200,255));

  bodies[2] = new Body(
    new PVector(0,0,0),
    new PVector(-0.93240737,-0.86473146,0).mult(vScale),
    1,color(255,220,100));

  trails = (ArrayList<PVector>[]) new ArrayList[3];

  for(int i=0;i<3;i++)
    trails[i] = new ArrayList<PVector>();
}


// ===============================
// DRAW LOOP
// ===============================

void draw(){

  background(5);
  lights();

  // slow automatic orbit
  camAngle += 0.002;

  translate(width/2 + panX, height/2 + panY, 0);

  rotateX(rotX);
  rotateY(rotY + camAngle);

  translate(0,0,-zoom);

  for(int s = 0; s < SUBSTEPS; s++)
    stepPhysics();

  drawTrails();
  drawBodies();
}


// ===============================
// PHYSICS
// ===============================

void stepPhysics(){

  PVector[] acc = computeAcceleration();

  for(int i=0;i<3;i++)
    bodies[i].vel.add(PVector.mult(acc[i], dt*0.5));

  for(int i=0;i<3;i++)
    bodies[i].pos.add(PVector.mult(bodies[i].vel, dt));

  acc = computeAcceleration();

  for(int i=0;i<3;i++)
    bodies[i].vel.add(PVector.mult(acc[i], dt*0.5));

  for(int i=0;i<3;i++){

    trails[i].add(bodies[i].pos.copy());

    if(trails[i].size()>TRAIL)
      trails[i].remove(0);
  }
}


PVector[] computeAcceleration(){

  PVector[] acc = new PVector[3];

  for(int i=0;i<3;i++)
    acc[i] = new PVector();

  for(int i=0;i<3;i++){
    for(int j=i+1;j<3;j++){

      PVector r = PVector.sub(bodies[j].pos,bodies[i].pos);

      float d = r.mag()+2;

      float f = G/(d*d*d);

      PVector a = r.copy().mult(f);

      acc[i].add(a);
      acc[j].sub(a);
    }
  }

  return acc;
}


// ===============================
// DRAWING
// ===============================

void drawBodies(){

  for(int i=0;i<3;i++){

    pushMatrix();

    translate(bodies[i].pos.x,bodies[i].pos.y,bodies[i].pos.z);

    fill(bodies[i].col);
    noStroke();
    sphere(14);

    popMatrix();
  }
}

void drawTrails(){

  strokeWeight(2);

  for(int i=0;i<3;i++){

    stroke(bodies[i].col);
    noFill();

    beginShape();

    for(PVector p:trails[i])
      vertex(p.x,p.y,p.z);

    endShape();
  }
}


// ===============================
// MOUSE CONTROLS
// ===============================

void mouseDragged(){

  if(mouseButton == LEFT){

    rotY += (mouseX-pmouseX)*0.01;
    rotX += (mouseY-pmouseY)*0.01;

  } else if(mouseButton == RIGHT){

    panX += mouseX-pmouseX;
    panY += mouseY-pmouseY;
  }
}


void mouseWheel(MouseEvent event){

  zoom += event.getCount()*30;

  zoom = constrain(zoom,200,2000);
}


// ===============================
// BODY CLASS
// ===============================

class Body{

  PVector pos;
  PVector vel;
  float mass;
  int col;

  Body(PVector p,PVector v,float m,int c){
    pos=p;
    vel=v;
    mass=m;
    col=c;
  }
}