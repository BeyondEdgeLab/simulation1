// ---- Constants ----
// Edit these values to configure the simulation

// --- Window ---
// Uses fullScreen() — window will match your monitor resolution automatically

// --- Simulation Speed ---
final float TIME_SCALE = 10.0;  // multiplier for simulation speed:
                               //   1.0 = real time
                               //   2.0 = 2x faster (1 real second = 2 sim seconds)
                               //  60.0 = 1 real second = 1 sim minute (good for testing tick tiers)

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

// X-axis tick resolution tiers:
// When elapsed time exceeds a threshold, the tick interval upgrades to the next tier.
// TICK_THRESHOLDS = elapsed seconds at which to switch tier (must be ascending)
// TICK_INTERVALS  = tick spacing in seconds for each tier
//   tier 0: 0s+      → tick every 30s
//   tier 1: 5min+    → tick every 1min
//   tier 2: 30min+   → tick every 5min
//   tier 3: 3hr+     → tick every 30min
//   tier 4: 24hr+    → tick every 1hr
//   tier 5: 7days+   → tick every 6hr
final int[] TICK_THRESHOLDS = {  10,  1800, 10800,  86400, 604800 }; // seconds
final int[] TICK_INTERVALS  = {   1,    2,   300,   1800,   3600, 21600 }; // seconds per tick

// --- Visual ---
final int BACKGROUND_COLOR = 30;  // background darkness (0 = black, 255 = white)
