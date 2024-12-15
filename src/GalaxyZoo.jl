module GalaxyZoo

using Flux
using Images
using DataFrames
using CSV
using MLUtils
using ProgressMeter
using CUDA

include("loader.jl")
include("model.jl")
include("train.jl")
include("utils.jl")

function run()
	println("Loading data...")
	train_images, train_labels = load_data("dataset/images_training_rev1", "dataset/training_solutions_rev1.csv")

	println("Building model...")
	model = build_model()

	println("Starting training...")
	train(model, train_images, train_labels)

	println("Training complete!")
end

end
