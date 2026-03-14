class SimBody {

  PVector pos;
  PVector vel;
  float mass;
  int col;

  SimBody(PVector p, PVector v, float m, int c) {
    pos = p;
    vel = v;
    mass = m;
    col = c;
  }
}
