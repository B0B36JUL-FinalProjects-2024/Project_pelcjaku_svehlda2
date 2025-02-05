using Test
using Flux, Images, DataFrames, CSV
include("../src/GalaxyZoo.jl")
using .GalaxyZoo

@testset "GalaxyZoo Module" begin
	@testset "Image Preprocessing" begin
		img_path = "dataset/images_training_rev1/100023.jpg"
		img_array = GalaxyZoo.preprocess_image(img_path)
		@test size(img_array) == (52, 52, 3)  # check if the image is resized correctly
		@test eltype(img_array) == Float32      # check if the image is converted to Float32

		# Test with an invalid image (non-existent path)
		invalid_path = "dataset/nonexistent_image.jpg"
		@test_throws ArgumentError GalaxyZoo.preprocess_image(invalid_path)
	end

	@testset "Data Loading" begin
		ground_truth_path = "tests/data.csv"
		ground_truth_df = CSV.read(ground_truth_path, DataFrame)

		classes = [Symbol("Class1.1"), Symbol("Class1.2"), Symbol("Class1.3")]
		data = GalaxyZoo.load_data(classes, ground_truth_path, "tests/imgtrain")
		@test data isa DataFrame
		@test nrow(data) > 0
	end
end