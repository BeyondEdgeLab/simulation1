# sketch_3body

This sketch visualizes the classic three-body gravitational problem in Processing. Three masses pull on each other in real time, leaving trails behind them so the orbital structure and chaotic divergence are easy to see.

## What It Shows

The sketch starts with a chaotic binary-plus-intruder setup and can also switch to a figure-eight orbit or a Pythagorean three-body scatter. A second "twin" system can run alongside the main one with an almost invisible velocity perturbation, which makes the sensitivity to initial conditions visible over time.

## Controls

1. `SPACE` pauses or resumes the simulation
2. `R` resets the current preset
3. `1`, `2`, `3` switch between presets
4. `T` toggles trajectory trails
5. `V` toggles velocity vectors
6. `C` toggles the perturbed twin system
7. `[` and `]` slow down or speed up time

## Files

```text
sketch_3body/
├── sketch_3body.pde   # main loop, presets, camera, HUD
├── OrbitalBody.pde    # body state, drawing, trails
├── OrbitalSystem.pde  # gravity integration and system metrics
├── ThreeBodyConfig.pde # configurable constants
└── README.md
```

## Notes

- The integrator uses velocity Verlet, which is simple and stable enough for this kind of visual simulation.
- `SOFTENING` in `ThreeBodyConfig.pde` avoids infinite acceleration during very close encounters.
- The auto-fit camera keeps all active bodies in frame.