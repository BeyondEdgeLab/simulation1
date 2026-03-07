// ---- Constants ----
// Edit these values to configure the simulation

// --- Window ---
// Uses fullScreen() — window will match your monitor resolution automatically

// --- Simulation Speed ---
final float TIME_SCALE = 1.0;  // multiplier for simulation speed:
                               //   1.0 = real time
                               //   2.0 = 2x faster (1 real second = 2 sim seconds)
                               //  60.0 = 1 real second = 1 sim minute (good for testing tick tiers)

// --- Graph Panel ---
final float GRAPH_RATIO = 0.44;  // graph panel width as a fraction of the window width (0.0 - 1.0)

// --- Particles ---
final float PARTICLE_RADIUS = 20;    // radius of each particle in pixels
final float MAX_SPEED       = 3.0;  // max initial speed (particles start with random speed between -MAX_SPEED and +MAX_SPEED)

// Group A — Red
final int GROUP_A_COUNT = 10;        // number of red particles
final int GROUP_A_R     = 220;        // red channel
final int GROUP_A_G     = 60;         // green channel
final int GROUP_A_B     = 60;         // blue channel

// Group B — Blue
final int GROUP_B_COUNT = 10;        // number of blue particles
final int GROUP_B_R     = 60;         // red channel
final int GROUP_B_G     = 130;        // green channel
final int GROUP_B_B     = 220;        // blue channel

// --- Graph ---
final int   GRAPH_Y_MAX_INITIAL   = 100;  // starting y-axis max (collision count)
final float GRAPH_Y_SCALE_AT      = 0.75;  // auto-scale y-axis when count reaches this fraction of current max (0.0-1.0)
final float GRAPH_Y_SCALE_FACTOR  = 2.0;   // how much to multiply the y-axis max when scaling up
final int   GRAPH_MARGIN         = 50;   // inner padding (pixels) for axis labels
final int   GRAPH_LABEL_SIZE     = 14;   // axis label font size
final int   GRAPH_TICK_SIZE      = 11;   // tick value font size
final int   GRAPH_MIN_TICK_PX    = 60;   // minimum pixel distance between x-axis ticks before they are thinned out
final int   GRAPH_MIN_Y_TICK_PX  = 40;   // minimum pixel distance between y-axis ticks before they are thinned out
final int   GRAPH_Y_TICK_BASE    = 100;  // first y-axis tick appears at this count value (e.g. 100, then 200, 300...)

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

// --- Graph Lines ---
// Set to true/false to show or hide each collision series on the plot
final boolean SHOW_TOTAL_COLLISIONS = true;   // white line  — all collisions combined
final boolean SHOW_RED_COLLISIONS   = true;   // red line    — collisions involving red particles
final boolean SHOW_BLUE_COLLISIONS  = true;   // blue line   — collisions involving blue particles
