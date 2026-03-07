// ---- Double Pendulum Constants ----
// All configurable values for the simulation.
// Rod lengths and masses use arbitrary simulation units; SCALE controls pixel conversion.

// --- Pendulums ---
final int   NUM_PENDULUMS    = 7;       // how many pendulums to show simultaneously
final float CHAOS_OFFSET     = 0.0005; // tiny angle offset between each pendulum (reveals chaos)

// --- Physical Parameters ---
final float L1               = 1.5;    // length of rod 1 (simulation units)
final float L2               = 1.5;    // length of rod 2 (simulation units)
final float M1               = 2.0;    // mass of bob 1
final float M2               = 1.0;    // mass of bob 2
final float GRAVITY          = 9.81;   // gravitational acceleration (units/s²)

// --- Initial Conditions ---
final float THETA1_INIT      = HALF_PI;  // initial angle of rod 1 from vertical (radians)
final float THETA2_INIT      = HALF_PI;  // initial angle of rod 2 from vertical (radians)
final float OMEGA1_INIT      = 0.0;    // initial angular velocity of rod 1 (rad/s)
final float OMEGA2_INIT      = 0.0;    // initial angular velocity of rod 2 (rad/s)

// --- Display Scale ---
// Pivot sits at (width/2, height * PIVOT_Y).
// Rods are drawn at:  pixel_length = rod_length * height * SCALE
final float PIVOT_Y          = 0.35;   // pivot Y position as fraction of screen height (0=top, 1=bottom)
final float SCALE            = 0.20;   // rod length scale: fraction of screen height per unit length

// --- Trail ---
final int   TRAIL_LENGTH     = 500;    // number of trail positions to keep (0 = no trail)
final float TRAIL_ALPHA_MAX  = 220;    // alpha of newest trail point
final float TRAIL_ALPHA_MIN  = 0;      // alpha of oldest trail point
final float TRAIL_WEIGHT     = 1.5;    // trail stroke weight

// --- Physics Integration ---
final float TIME_STEP        = 0.01;   // RK4 time step in seconds (smaller = more accurate)
final int   STEPS_PER_FRAME  = 1;     // physics steps computed per drawn frame (controls speed)

// --- Visual ---
final int   BACKGROUND_COLOR = 15;     // background darkness (0=black, 255=white)
final int   BOB_RADIUS       = 8;      // bob circle radius in pixels
final int   ROD_WEIGHT       = 2;      // rod stroke weight
final boolean SHOW_RODS      = true;   // draw connecting rods
final boolean SHOW_BOBS      = true;   // draw bob circles

// --- Color Palette ---
// First and last pendulum colors; intermediate ones interpolate between them.
final color COLOR_START      = #FF3333;  // color of pendulum 0 (red)
final color COLOR_END        = #3388FF;  // color of pendulum N-1 (blue)
