# Particle Simulation

A two-group particle population simulation built in [Processing](https://processing.org/). Two species (red and blue) move around a bounded arena, collide, reproduce, age, and die — while a live graph panel tracks collisions and population over time.

---

## Features

- **Two particle groups** — Group A (red) and Group B (blue), each with independent parameters
- **Lifecycle system** — every particle is born, matures, can reproduce, then dies after a configurable lifespan
- **Collision physics** — elastic collisions; same-color collisions trigger offspring spawning
- **Live dual-subplot graph**
  - *Top*: cumulative collision count per group over time
  - *Bottom*: live population count per group over time
- **Smart x-axis ticks** — automatically upgrade resolution (seconds → minutes → hours → days) as time passes, and thin out to prevent overlap
- **Auto-scaling y-axes** — both subplots scale up when data approaches the current ceiling
- **Simulation stop conditions**
  - Population cap (`MAX_POPULATION`) — stops and displays a message when total particles exceed the limit
  - Extinction (`STOP_ON_EXTINCTION`) — stops and displays a message when all particles have died
- **Full-screen display** — adapts to any monitor resolution automatically

---

## Requirements

- [Processing 4](https://processing.org/download) (free, cross-platform)
- No additional libraries needed

---

## How to Run

1. Open **Processing**
2. Go to **File → Open** and select the `sketch_260307b` folder (or the `.pde` file inside it)
3. Press the **Run** button (▶) or `Ctrl+R`

---

## Project Structure

```
Simulation1/
└── sketch_260307b/
    ├── sketch_260307b.pde   # Main sketch — setup, draw loop, graph rendering
    ├── Particle.pde         # Particle class — movement, collision, lifecycle, rendering
    └── Constants.pde        # All configurable parameters
```

Processing automatically compiles all `.pde` files in the same folder together, so no imports are needed.

---

## Configuration

All simulation parameters live in `Constants.pde`. Edit the values there to change behaviour without touching the logic files.

### Simulation Speed

| Constant | Default | Description |
|---|---|---|
| `TIME_SCALE` | `1.0` | Speed multiplier (`2.0` = twice as fast, `60.0` = 1 real-sec = 1 sim-min) |

### Particles

| Constant | Default | Description |
|---|---|---|
| `PARTICLE_RADIUS` | `5` | Radius in pixels |
| `MAX_SPEED` | `5.0` | Max initial velocity |
| `MAX_POPULATION` | `1000` | Simulation stops when total count reaches this |
| `STOP_ON_EXTINCTION` | `true` | Simulation stops when population reaches 0 |

### Group A — Red

| Constant | Default | Description |
|---|---|---|
| `GROUP_A_COUNT` | `2` | Starting number of red particles |
| `GROUP_A_R/G/B` | `220, 60, 60` | RGB color |
| `GROUP_A_OFFSPRING` | `2` | Offspring spawned per same-color collision |
| `GROUP_A_MIN_AGE` | `1.0` | Sim-seconds before a particle can reproduce |
| `GROUP_A_MAX_AGE` | `20.0` | Sim-seconds before a particle dies |

### Group B — Blue

| Constant | Default | Description |
|---|---|---|
| `GROUP_B_COUNT` | `10` | Starting number of blue particles |
| `GROUP_B_R/G/B` | `60, 130, 220` | RGB color |
| `GROUP_B_OFFSPRING` | `1` | Offspring spawned per same-color collision |
| `GROUP_B_MIN_AGE` | `1.0` | Sim-seconds before a particle can reproduce |
| `GROUP_B_MAX_AGE` | `20.0` | Sim-seconds before a particle dies |

### Graph Display Toggles

Set any of these to `true` or `false` to show/hide individual lines on the graph:

```processing
// Collision subplot (top)
final boolean SHOW_TOTAL_COLLISIONS = false;  // white — all collisions
final boolean SHOW_RED_COLLISIONS   = true;   // red   — red-only collisions
final boolean SHOW_BLUE_COLLISIONS  = true;   // blue  — blue-only collisions

// Population subplot (bottom)
final boolean SHOW_TOTAL_POPULATION = false;  // white — total count
final boolean SHOW_RED_POPULATION   = true;   // red   — red count
final boolean SHOW_BLUE_POPULATION  = true;   // blue  — blue count
```

### Graph Layout

| Constant | Default | Description |
|---|---|---|
| `GRAPH_RATIO` | `0.44` | Graph panel width as fraction of screen width |
| `GRAPH_MARGIN` | `50` | Inner padding for axis labels (px) |
| `GRAPH_Y_MAX_INITIAL` | `100` | Starting y-ceiling for collision subplot |
| `GRAPH_POP_Y_MAX_INITIAL` | `50` | Starting y-ceiling for population subplot |
| `GRAPH_Y_SCALE_AT` | `0.75` | Auto-scale when data reaches this fraction of ceiling |
| `GRAPH_Y_SCALE_FACTOR` | `2.0` | Ceiling multiplier when auto-scaling |
| `GRAPH_MIN_TICK_PX` | `60` | Min pixel gap between x-axis ticks before thinning |
| `GRAPH_MIN_Y_TICK_PX` | `40` | Min pixel gap between y-axis ticks before thinning |

---

## Collision Rules

| Collision type | Counted in totals | Per-group count | Spawns offspring |
|---|---|---|---|
| Red ↔ Red | ✅ | ✅ Red counter | ✅ Red offspring (if both mature) |
| Blue ↔ Blue | ✅ | ✅ Blue counter | ✅ Blue offspring (if both mature) |
| Red ↔ Blue | ✅ | ❌ | ❌ |

---

## Particle Lifecycle

```
Born (dim)  →  Mature (full brightness)  →  Aging (fade)  →  Dead (removed)
              ↑ can now reproduce                          ↑ at MAX_AGE
              at MIN_AGE
```

Particles that die without any offspring having survived may drive the population to extinction if reproduction rates are too low.

---

## Tips for Experimenting

- **Slow down time** — set `TIME_SCALE = 0.2` to watch individual collisions in detail
- **Speed up time** — set `TIME_SCALE = 60.0` to run a long-term population experiment in seconds
- **Increase starting population** — raise `GROUP_A_COUNT` / `GROUP_B_COUNT`
- **Boom-bust cycles** — try high `GROUP_A_OFFSPRING` with a low `GROUP_A_MAX_AGE`
- **Competition** — set one group's offspring rate to 0 and watch it go extinct
