// ---- Constants ----
// Edit these values to configure the simulation

// --- Window ---
// Uses fullScreen() — window will match your monitor resolution automatically

// --- Graph Panel ---
final float GRAPH_RATIO = 0.44;  // graph panel width as a fraction of the window width (0.0 - 1.0)

// --- Particles ---
final int   PARTICLE_COUNT  = 100;   // number of particles in the simulation
final float PARTICLE_RADIUS = 2;    // radius of each particle in pixels
final float MAX_SPEED       = 2.0;  // max initial speed (particles start with random speed between -MAX_SPEED and +MAX_SPEED)

// --- Graph ---
final int   GRAPH_MAX_COLLISIONS = 1000; // y-axis max on the collision graph
final int   GRAPH_MARGIN         = 50;   // inner padding (pixels) for axis labels
final int   GRAPH_LABEL_SIZE     = 14;   // axis label font size
final int   GRAPH_TICK_SIZE      = 11;   // tick value font size

// --- Visual ---
final int BACKGROUND_COLOR = 30;  // background darkness (0 = black, 255 = white)
