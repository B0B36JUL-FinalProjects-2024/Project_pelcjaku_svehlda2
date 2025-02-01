# tests/test_galaxytree.jl
using Test
using Flux, Images, BSON, DataFrames, CSV
include("../src/GalaxyZoo.jl")
include("../src/GalaxyTree.jl")
include("../src/multiclassifier.jl")
using .GalaxyZoo
using .GalaxyTree

@testset "GalaxyTree Module" begin
	# Test 1: Model Loading
	@testset "Model Loading" begin
		model_path = "models/class1_classif.bson"
		BSON.@load model_path model_cpu
		model = model_cpu |> cpu

		@test model isa Chain
	end

	# Test 2: Image Classification
	@testset "Image Classification" begin
		model_path = "models/class1_classif.bson"
		BSON.@load model_path model_cpu
		model = model_cpu |> cpu

		# valid image
		img_path = "tests/whirpool.jpg"
		img_array = GalaxyZoo.preprocess_image(img_path)
		img_batch = reshape(img_array, size(img_array)..., 1)
		probs = model(img_batch)
		@test size(probs) == (3, 1)
		@test sum(probs) ≈ 1.0		# check sum of pdf
	end

	# Test 3: Decision Tree Traversal
	@testset "Decision Tree Traversal" begin
		# define some arbitrary classification result
		results = Dict(
			"Class1.1" => 0.8, "Class1.2" => 0.1, "Class1.3" => 0.1,
			"Class2.1" => 0.6, "Class2.2" => 0.4,
			"Class3.1" => 0.7, "Class3.2" => 0.3,
			"Class4.1" => 0.5, "Class4.2" => 0.5,
			"Class5.1" => 0.4, "Class5.2" => 0.3, "Class5.3" => 0.2, "Class5.4" => 0.1,
			"Class6.1" => 0.6, "Class6.2" => 0.4,
			"Class7.1" => 0.7, "Class7.2" => 0.2, "Class7.3" => 0.1,
			"Class8.1" => 0.4, "Class8.2" => 0.3, "Class8.3" => 0.2, "Class8.4" => 0.1, "Class8.5" => 0.0, "Class8.6" => 0.0, "Class8.7" => 0.0,
			"Class9.1" => 0.5, "Class9.2" => 0.3, "Class9.3" => 0.2,
			"Class10.1" => 0.6, "Class10.2" => 0.3, "Class10.3" => 0.1,
			"Class11.1" => 0.4, "Class11.2" => 0.3, "Class11.3" => 0.2, "Class11.4" => 0.1, "Class11.5" => 0.0, "Class11.6" => 0.0
		)

		# test the tree classification
		final_classification = GalaxyTree.decision_tree(results)
		@test final_classification == "ring"
	end

	# Test 4: Ground Truth Lookup
	@testset "Ground Truth Lookup" begin
		ground_truth_path = "dataset/training_solutions_rev1.csv"
		ground_truth_df = CSV.read(ground_truth_path, DataFrame)

		# Valid GalaxyID
		galaxy_id = 100008
		ground_truth = get_ground_truth(galaxy_id, ground_truth_df)
		@test ground_truth isa Vector  # is g.t. a vector
		@test length(ground_truth) > 0 # is g.t. not empty

		# Invalid GalaxyID
		invalid_galaxy_id = 999999
		@test_throws ErrorException get_ground_truth(invalid_galaxy_id, ground_truth_df)
	end

	# Test 5: MSE Calculation
	@testset "MSE Calculation" begin
		predicted = [0.5, 0.5, 0.5]
		ground_truth = [0.5, 0.5, 0.5]
		@test calculate_mse(predicted, ground_truth) == 0.0  # MSE should be 0

		predicted = [0.5, 0.5, 0.5]
		ground_truth = [1.0, 1.0, 1.0]
		@test calculate_mse(predicted, ground_truth) ≈ 0.25  # MSE should be 0.25
	end
end