include("rossler.jl")
include("lorenz.jl")

# Access the exported functions from the modules
using .Rossler
using .Lorenz

# User configurable parameters
simulation_type = "rossler" # or "lorenz"
output_dir = "results/"

# Run the correct simulation and save results
if simulation_type == "rossler"
    println("Running Rossler simulation...")
    test_data, output, predict_ts = rossler_simulation()

    println("Plotting 2D comparison...")
    plot_2d_comparison(test_data, output, predict_ts, output_dir * "rossler_2d.png")

    println("Plotting 3D comparison...")
    plot_3d_comparison(test_data, output, output_dir * "rossler_3d.png")

    println("Generating animation...")
    animate_comparison(test_data, output, output_dir * "rossler_animation.gif")

    println("Completed Rossler simulation.")
elseif simulation_type == "lorenz"
    println("Running Lorenz simulation...")
    test_data, output, predict_ts = lorenz_simulation()

    println("Plotting 2D comparison...")
    plot_2d_comparison(test_data, output, predict_ts, output_dir * "lorenz_2d.png")

    println("Plotting 3D comparison...")
    plot_3d_comparison(test_data, output, output_dir * "lorenz_3d.png")

    println("Generating animation...")
    animate_comparison(test_data, output, output_dir * "lorenz_animation.gif")

    println("Completed lorenz simulation.")
end

println("Finished.")
