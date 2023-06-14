module Lorenz

using Plots
using OrdinaryDiffEq
using ReservoirComputing
using Random

export lorenz_simulation, plot_2d_comparison, plot_3d_comparison, animate_comparison

"""
    lorenz_simulation()

Runs the simulation of the lorenz system using Echo State Network (ESN) and 
returns the test data, output data and the time series for prediction.

"""
function lorenz_simulation()
    Random.seed!(4242)
    #define lorenz system
    function lorenz!(du,u,p,t)
        du[1] = 10.0*(u[2]-u[1])
        du[2] = u[1]*(28.0-u[3]) - u[2]
        du[3] = u[1]*u[2] - (8/3)*u[3]
    end
    #solve and take data
    prob = ODEProblem(lorenz!, [1.0,0.5,0.0], (0.0,200.0))

    data = solve(prob, ABM54(), dt=0.02)
    
    shift = 300 
    train_len = 5000
    predict_len = 1250
    input_data = data[:, shift:shift+train_len-1]
    target_data = data[:, shift+1:shift+train_len]
    test_data = data[:,shift+train_len+1:shift+train_len+predict_len]
    
    esn = ESN(input_data; 
        variation = Default(),
        reservoir = RandSparseReservoir(300, radius=1.2, sparsity=6/300),
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

end
