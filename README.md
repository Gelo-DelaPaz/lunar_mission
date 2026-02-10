# Lunar Mission

**Using PDDL to develop an automated planning solution for the deployment and task execution of rovers for lunar operations**

This repository contains a set of PDDL (Planning Domain Definition Language) files that model planning domains and missions for lunar rover operations. The goal is to use automated planning techniques (e.g., Fast Downward, Metric‑FF, or other planners) to generate executable plans for rover deployment and task execution on a lunar surface mission.

## Project Structure

| File | Description |
|------|-------------|
| `domain.pddl` | Base planning domain describing rover, terrain, tasks, and actions. |
| `domain-ext.pddl` | Extended planning domain with additional actions or constraints. |
| `mission1.pddl` | Problem instance #1 representing a specific lunar mission scenario. |
| `mission2.pddl` | Problem instance #2 with a different set of goals or initial conditions. |
| `mission3.pddl` | Problem instance #3 with more complex tasks. |

Each mission file defines:
- The initial world state
- The desired goals to achieve
- A set of mission‑specific objects

## About PDDL

PDDL (Planning Domain Definition Language) is used in AI planning research to describe:
- **Domains:** actions, predicates, objects, and constraints
- **Problems:** initial states and goals

This repository models lunar rover missions that could be solved using classical planners.

## How to Use

### 1. Choose a planner
Examples include:
- **Fast Downward**: https://www.fast-downward.org
- **Metric‑FF**
- **POP‑F**

### 2. Run a planning task

```bash
fast-downward.py domain.pddl mission1.pddl --search "eager(ff())"
