# CMOABC

**Consensus-guided Multi-Party Multi-Objective Artificial Bee Colony**

CMOABC is a consensus-guided multi-party multi-objective artificial bee colony algorithm for cooperative decision-making problems. It combines concession-aware scoring, cooperation-guided search, and an external archive to balance party-specific and global multi-objective optimization.

## File Structure

| File | Description |
|------|-------------|
| `CMOABC.m` | Main algorithm entry point |
| `BuildStartPopulation.m` | Initial population construction |
| `GetConcessionWeights.m` | Concession-aware weight computation |
| `ComputeAlpha0.m` | Initial mixing coefficient |
| `ComputeAlpha.m` | Generation-dependent mixing coefficient |
| `ComputeMixedScore.m` | Mixed multi-party / multi-objective score |
| `CalculateCrowdingDistance.m` | Crowding distance for archive scoring |
| `GenerateNewSolution.m` | Neighborhood search and reference selection |
| `DirectionalScout.m` | Scout bee operator |
| `GreedySelection.m` | Mixed-score greedy selection |
| `CalculateProbability.m` | Onlooker bee selection probability |
| `RouletteWheelSelection.m` | Roulette-wheel selection |
| `UpdateArchive.m` | External archive maintenance |

## Usage

Add the algorithm folder to your MATLAB path, then invoke the main entry function through your optimization framework:

```matlab
addpath('path/to/CMOABC-Algorithm');
main('-algorithm', @CMOABC, '-problem', @YourProblem, ...
     '-N', 200, '-evaluation', 80000, '-D', 2);
```

## Algorithm Overview

CMOABC extends the artificial bee colony framework with three key components:

1. **Concession-aware scoring** — assigns weights to decision makers based on their concession levels and blends party-specific ranks with global multi-objective ranks.
2. **Consensus-guided search** — selects reference solutions from the archive using mixed scores to guide employed and onlooker bees.
3. **Dual External archive** — stores high-quality solutions and supports directional scout reinitialization.

## License

For academic research use only.
