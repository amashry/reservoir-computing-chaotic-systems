# Reservoir Computing for Chaotic Systems Prediction

This repository contains an implementation of reservoir computing, with a focus on Echo State Networks (ESN), for predicting chaotic systems. The project includes two primary examples: the Lorenz Attractor and the Rossler Attractor, which are sets of differential equations whose solutions exhibit chaotic behavior. The code is developed using the Julia language, leveraging packages such as Plots, OrdinaryDiffEq, and ReservoirComputing.

<p align="center">
  <img src= "https://github.com/amashry/reservoir-computing-chaotic-systems/assets/98168605/60780e55-0807-427d-a16a-fed194768911)" alt="Sample Lorenz System Animation">
</p>

_Sample animated GIF showing a comparison between actual data (blue) and predicted data (red) for the Lorenz system using Reservoir Computing Echo State Network._


## Project Structure

The project consists of modular scripts implementing ESNs on the Lorenz and Rossler systems and a comprehensive report detailing the theoretical foundations, mathematical models, and key findings.

### 1. Code

The project code is divided into separate modules for the Lorenz (`lorenz.jl`) and Rossler (`rossler.jl`) attractors. Each module:

- Defines the respective system and its parameters.
- Generates system data by solving the differential equations.
- Implements an Echo State Network (ESN) using the `ReservoirComputing.jl` package.
- Trains the ESN to predict the system's behavior.
- Calculates and plots error metrics between the predicted and actual data.
- Creates 2D and 3D visualizations of the predicted vs. actual behavior of the system.

The `main.jl` script serves as the entry point for executing these modules. User can choose which chaotic system to train the ESN on, and predict its next state over time. 

### 2. Report

The report is a thorough examination of Reservoir Computing and its application to chaotic systems prediction. It provides an extensive explanation of Reservoir Computing, Echo State Networks, and their parameters' influence on system prediction. 

Key sections include:

- An introduction detailing the challenge of predicting chaotic systems and the role of ESNs in Reservoir Computing.
- A comprehensive mathematical description of Reservoir Computing. 
- An in-depth analysis of Echo State Networks and their parameters.
- A discussion on the relationship between ESNs and chaos theory, including practical examples.
- An examination of the Lorenz and Rossler attractors.

## Getting Started

To run the project, clone this repository, navigate to its directory, and execute the `main.jl` script with a Julia environment:

```bash
git clone <https://github.com/amashry/reservoir-computing-chaotic-systems>
cd <reservoir-computing-chaotic-systems>
julia main.jl
```

Ensure you have Julia installed, along with the necessary packages (`Plots`, `OrdinaryDiffEq`, `ReservoirComputing`, and `Random`). These can be installed via Julia's package manager:

```julia
import Pkg
Pkg.add("Plots")
Pkg.add("OrdinaryDiffEq")
Pkg.add("ReservoirComputing")
Pkg.add("Random")
```

The report can be found in the repository as a `.pdf` file under docs directory.

## Dependencies

- [Julia](https://julialang.org/downloads/)
- [Plots.jl](https://github.com/JuliaPlots/Plots.jl)
- [OrdinaryDiffEq.jl](https://github.com/SciML/OrdinaryDiffEq.jl)
- [ReservoirComputing.jl](https://github.com/SciML/ReservoirComputing.jl)
- [Random.jl](https://docs.julialang.org/en/v1/stdlib/Random/)

## Acknowledgments

- [Julia](https://julialang.org/) 
- [ReservoirComputing.jl](https://github.com/SciML/ReservoirComputing.jl)
