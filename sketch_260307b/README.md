# sketch_260307b Experiment Guide

This sketch is useful because it turns a few simple rules into visible long-term behavior. By changing only population, minimum reproduction age, maximum age, and offspring count, you can test ideas about competition, stability, collapse, and randomness.

## Core Questions This Simulation Can Answer

These are the main questions already mentioned for the series and worth testing on camera:

1. Which species survives?
2. Does a bigger starting population always win?
3. Is it better to live longer or reproduce faster?
4. Can a species with delayed reproduction still survive?
5. Can two groups coexist for a long time, or does one eventually take over?
6. How much can randomness change the outcome when both groups start equal?
7. Can a weaker group recover if it has one strong advantage?
8. How small can a parameter change be before the whole system behaves differently?
9. What causes population explosion instead of stable growth?
10. What causes collapse or extinction even when a group looks strong at the start?

## Why This Simulation Is Helpful

This simulation is helpful because it makes abstract system behavior visible. Instead of talking about population growth and competition only in theory, you can watch the effects unfold in real time and compare them using the graphs.

What you learn from it:

1. How one advantage can offset another disadvantage.
2. Why systems with simple rules can still be hard to predict.
3. How timing matters, not just raw strength.
4. Why growth can become unstable when reproduction is too aggressive.
5. Why equal rules do not always produce equal outcomes.

Real-life parallels:

1. Animal populations that compete for territory and survival.
2. Bacteria colonies with different growth and survival strategies.
3. Invasive species entering an ecosystem with a reproductive advantage.
4. Businesses or technologies competing where timing and growth rate matter.
5. Social systems where small starting differences compound over time.

## Hypothesis Experiments

Use these as ready-made episode ideas. The tables keep the experiments controlled so each video has a clear question.

### 1. Which Species Survives?

**Hypothesis**

If one group has a better reproduction setup than the other, it should dominate over time.

| Parameter | Group A | Group B |
|---|---:|---:|
| Population | 40 | 40 |
| Min age | 1.0 | 1.0 |
| Max age | 10.0 | 10.0 |
| Offspring | 1 | 2 |

Why this matters:
This is the cleanest way to introduce competitive advantage. It isolates reproduction as the key difference.

What you learn:
You learn whether a simple reproduction edge is enough to overpower otherwise equal conditions.

Real-life example:
Species with faster breeding cycles often outcompete slower-reproducing species in the same environment.

### 2. Does Bigger Population Always Win?

**Hypothesis**

A group that starts larger may still lose if the smaller group reproduces more efficiently.

| Parameter | Group A | Group B |
|---|---:|---:|
| Population | 80 | 20 |
| Min age | 1.0 | 1.0 |
| Max age | 10.0 | 10.0 |
| Offspring | 1 | 3 |

Why this matters:
It tests whether early numerical advantage is more important than long-term growth rate.

What you learn:
You see whether initial conditions or growth dynamics matter more in the long run.

Real-life example:
A smaller startup or invasive population can still overtake a larger established group if it expands faster.

### 3. Is It Better To Live Longer Or Reproduce Faster?

**Hypothesis**

There is a tradeoff between lifespan and reproduction, and neither advantage guarantees victory by itself.

| Parameter | Group A | Group B |
|---|---:|---:|
| Population | 40 | 40 |
| Min age | 1.0 | 1.0 |
| Max age | 6.0 | 16.0 |
| Offspring | 3 | 1 |

Why this matters:
This is one of the most important system-level questions in the series because it compares two fundamentally different survival strategies.

What you learn:
You learn whether rapid turnover beats durability, or whether long survival creates more stable growth.

Real-life example:
Some species survive by producing many offspring quickly, while others survive by living longer and reproducing more slowly.

### 4. Can Delayed Reproduction Still Win?

**Hypothesis**

A group that matures later can still survive if its long-term payoff is strong enough.

| Parameter | Group A | Group B |
|---|---:|---:|
| Population | 40 | 40 |
| Min age | 0.5 | 5.0 |
| Max age | 8.0 | 18.0 |
| Offspring | 1 | 3 |

Why this matters:
This experiment makes timing visible. It is not just about how much a group can reproduce, but when it becomes able to do so.

What you learn:
You learn that delayed reward strategies can fail early or dominate later depending on survival and payoff.

Real-life example:
Some organisms or businesses invest heavily early, delay payoff, and then outperform faster but weaker competitors later.

### 5. Can Two Groups Coexist For A Long Time?

**Hypothesis**

Balanced parameters can produce long periods of coexistence, but chance may still break the symmetry.

| Parameter | Group A | Group B |
|---|---:|---:|
| Population | 50 | 50 |
| Min age | 1.5 | 1.5 |
| Max age | 12.0 | 12.0 |
| Offspring | 2 | 2 |

Why this matters:
This is the best setup for showing balance, noise, and how fragile apparent equilibrium can be.

What you learn:
You learn whether the system tends toward stability or whether random collisions and timing differences gradually break balance.

Real-life example:
Competing species, companies, or ideas can coexist for long periods before one gains an edge through small cumulative effects.

### 6. How Powerful Is Randomness?

**Hypothesis**

Even identical parameters can lead to different outcomes across repeated runs.

| Parameter | Group A | Group B |
|---|---:|---:|
| Population | 60 | 60 |
| Min age | 1.0 | 1.0 |
| Max age | 10.0 | 10.0 |
| Offspring | 2 | 2 |

Why this matters:
This is the simplest way to show viewers that the system is not scripted. The same setup can still evolve differently.

What you learn:
You learn how sensitive the simulation is to random collisions and early momentum.

Real-life example:
Weather, market behavior, and ecological spread often diverge even when initial conditions appear nearly identical.

### 7. Can A Weaker Group Make A Comeback?

**Hypothesis**

A group that starts smaller can recover if it has a strong enough strategic advantage.

| Parameter | Group A | Group B |
|---|---:|---:|
| Population | 20 | 70 |
| Min age | 1.0 | 2.0 |
| Max age | 14.0 | 8.0 |
| Offspring | 2 | 1 |

Why this matters:
This creates a strong story for video because viewers can immediately see an underdog situation.

What you learn:
You learn that initial weakness does not always decide the final outcome.

Real-life example:
Smaller populations, younger companies, or late entrants can recover if they scale better or survive longer.

### 8. How Small Can A Change Be Before The System Flips?

**Hypothesis**

A tiny parameter change can move the system from balance to dominance or collapse.

| Parameter | Baseline | Modified |
|---|---:|---:|
| Group A population | 50 | 50 |
| Group B population | 50 | 50 |
| Group A min age | 1.0 | 1.0 |
| Group B min age | 1.0 | 1.0 |
| Group A max age | 10.0 | 10.0 |
| Group B max age | 10.0 | 10.0 |
| Group A offspring | 1 | 1 |
| Group B offspring | 1 | 2 |

Why this matters:
This is the best experiment for showing nonlinear behavior. One small rule change can produce a very large difference later.

What you learn:
You learn how thresholds work in dynamic systems and why intuition often fails.

Real-life example:
Tiny differences in growth rate, cost, infection rate, or reproduction can completely change long-term outcomes.

### 9. What Causes Population Explosion?

**Hypothesis**

High offspring count combined with low maturity delay creates runaway growth.

| Parameter | Group A | Group B |
|---|---:|---:|
| Population | 30 | 30 |
| Min age | 0.5 | 0.5 |
| Max age | 14.0 | 14.0 |
| Offspring | 4 | 4 |

Why this matters:
This shows viewers the difference between healthy growth and unstable growth.

What you learn:
You learn why systems often need balancing constraints to avoid overshoot.

Real-life example:
Unchecked reproduction, viral spread, or demand spikes can cause sudden expansion that stresses the whole system.

### 10. What Causes Collapse Even When A Group Looks Strong?

**Hypothesis**

A group can look dominant early and still collapse if its strategy is too fragile.

| Parameter | Group A | Group B |
|---|---:|---:|
| Population | 70 | 30 |
| Min age | 0.5 | 1.5 |
| Max age | 4.0 | 14.0 |
| Offspring | 3 | 1 |

Why this matters:
This is good for storytelling because the early winner may not be the final winner.

What you learn:
You learn that fast early growth can hide long-term weakness.

Real-life example:
Systems built on short-term aggressive expansion can collapse if they lack resilience.

## How To Analyze Each Hypothesis

For each run, look at the same checkpoints so the videos stay consistent:

1. Which group grows fastest in the first phase?
2. Which group maintains population longer?
3. Does one group crash after early success?
4. Does the collision graph match the population story?
5. Is the result repeatable across multiple runs?

## Suggested Episode Format

1. State the question.
2. Show the parameter table.
3. Predict the result before running the simulation.
4. Run the test and watch the graphs.
5. Explain what happened and whether the hypothesis was correct.
6. Compare it with a real-life analogy.

## Future Directions

This sketch already works well for competition and population dynamics. It becomes even more powerful if you later add:

1. Predator-prey rules.
2. Food zones or resource scarcity.
3. Mutation across generations.
4. Disease spread.
5. Environmental change over time.

Those additions would let you move from simple competition to broader ecosystem storytelling.