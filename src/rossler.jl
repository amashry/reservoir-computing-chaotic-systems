module Rossler

using Plots
using OrdinaryDiffEq
using ReservoirComputing
using Random

export rossler_simulation, plot_2d_comparison, plot_3d_comparison, animate_comparison

"""
    rossler_simulation()

Runs the simulation of the Rossler system using Echo State Network (ESN) and 
returns the test data, output data and the time series for prediction.

"""
function rossler_simulation()
    Random.seed!(4242)

    # Define Rössler system
    function rossler!(du, u, p, t)
        a, b, c = 0.2, 0.2, 5.7
        du[1] = -u[2] - u[3]
        du[2] = u[1] + a*u[2]
        du[3] = b + u[3]*(u[1] - c)
    end

    # Solve and collect data 
    prob = ODEProblem(rossler!, [0.0, 1.0, 0.0], (0.0, 200.0))
    data = solve(prob, ABM54(), dt=0.02)

    # Echo State Network (ESN) setup
    shift = 300 
    train_len = 5000
    predict_len = 2000
    input_data = data[:, shift:shift+train_len-1]
    target_data = data[:, shift+1:shift+train_len]
    test_data = data[:,shift+train_len+1:shift+train_len+predict_len]

    esn = ESN(input_data; 
        variation = Default(),
        reservoir = RandSparseReservoir(100, radius=1.07, sparsity=6/300),
        input_layer = WeightedLayer(),
        reservoir_driver = RNN(),
        nla_type = NLADefault(),
        states_type = StandardStates())

    training_method = StandardRidge(0.0) 
    output_layer = train(esn, target_data, training_method)

    output = esn(Generative(predict_len), output_layer)

    ts = 0.0:0.02:200.0
    predict_ts = ts[shift+train_len+1:shift+train_len+predict_len]

    return test_data, output, predict_ts
end

"""
    plot_2d_comparison(test_data, output, predict_ts, filename)

Generates a 2D comparison plot between the test data and the output data, and saves it as a file.

"""
function plot_2d_comparison(test_data, output, predict_ts, filename)
    ############ Calculate error ################
    error_x = abs.(test_data[1,:] - output[1,:])
    error_y = abs.(test_data[2,:] - output[2,:])
    error_z = abs.(test_data[3,:] - output[3,:])
    combined_error = sqrt.(error_x.^2 + error_y.^2 + error_z.^2) #L2 error
    # to plot MSE over time
    mse_x = (error_x .^ 2) ./ length(error_x)
    mse_y = (error_y .^ 2) ./ length(error_y)
    mse_z = (error_z .^ 2) ./ length(error_z)
    combined_mse = mse_x + mse_y + mse_z

    ########## Plotting 2D ###################
    p1 = plot(predict_ts, [test_data[1,:] output[1,:]], label = ["actual" "predicted"], 
        ylabel = "x(t)", linewidth=2.5, xticks=false, yticks = -10:10:10)
    p2 = plot(predict_ts, [test_data[2,:] output[2,:]], label = false, 
        ylabel = "y(t)", linewidth=2.5, xticks=false, yticks = -10:10:10)
    p3 = plot(predict_ts, [test_data[3,:] output[3,:]], label = false, 
        ylabel = "z(t)", linewidth=2.5, xticks=false, yticks = 0:15:40)
    p4 = plot(predict_ts, combined_mse, label = false, 
        ylabel = "MSE", xlabel = "t", linewidth=2.5, yticks = 0:0.005:0.01)

    two_d_plot = plot(p1, p2, p3, p4, size=(1080, 720), plot_title = "Attractor Coordinates", 
    layout=(4,1), xtickfontsize = 12, ytickfontsize = 12, xguidefontsize=15, yguidefontsize=15,
    legendfontsize=12, titlefontsize=20, left_margin=10Plots.px)

    savefig(two_d_plot, filename)
end

"""
    plot_3d_comparison(test_data, output, filename)

Generates a 3D comparison plot between the test data and the output data, and saves it as a file.

"""
function plot_3d_comparison(test_data, output, filename)
    ######################### Plot 3D ########################
    actual_xyz = test_data
    predicted_xyz = output

    p = plot3d(actual_xyz[1,:], actual_xyz[2,:], actual_xyz[3,:], label ="Actual", linewidth = 2, color = :blue)
    #p4 = plot3d(predicted_xyz[1,:], predicted_xyz[2,:], predicted_xyz[3,:], label = "Predicted", linewidth = 2, color = :red)

    plot3d!(p, predicted_xyz[1,:], predicted_xyz[2,:], predicted_xyz[3,:], label = "Predicted", linewidth = 2, color = :red)
    title!("3D System")
    xlabel!("x(t)")
    ylabel!("y(t)")
    zlabel!("z(t)")

    savefig(filename)
end

"""
    animate_comparison(test_data, output, filename)

Generates an animation comparing the actual and predicted data, and saves it as a gif.

"""
function animate_comparison(test_data, output, filename)
    
    predict_len = 1250
    actual_xyz = test_data
    predicted_xyz = output
    # Animation
    animation = @animate for i in 1:5:predict_len
        p = plot3d(actual_xyz[1,1:i], actual_xyz[2,1:i], actual_xyz[3,1:i], label="Actual", linewidth=2, color=:blue)
        plot3d!(p, predicted_xyz[1,1:i], predicted_xyz[2,1:i], predicted_xyz[3,1:i], label="Predicted", linewidth=2, color=:red)
        xlims!(p, extrema(actual_xyz[1,:])...)
        ylims!(p, extrema(actual_xyz[2,:])...)
        zlims!(p, extrema(actual_xyz[3,:])...)
        title!(p, "3D System")
        xlabel!(p, "x(t)")
        ylabel!(p, "y(t)")
        zlabel!(p, "z(t)")
    end
    
    # Save the animation as a gif
    gif(animation, filename, fps = 30)
end

end
