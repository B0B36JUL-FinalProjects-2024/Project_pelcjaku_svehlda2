using Flux, Images, BSON, CSV, DataFrames, Statistics


include("GalaxyZoo.jl")
using .GalaxyZoo

models = []
for i in 1:11
	model_path = "models/class$(i)_classif.bson"
	BSON.@load model_path model_cpu
	model = model_cpu |> cpu
	push!(models, model)
end

function classify_image(image_path)
	img_array = GalaxyZoo.preprocess_image(image_path)
	img_batch = reshape(img_array, size(img_array)..., 1)
	
	results = Dict()
	
	for (i, model) in enumerate(models)
		probs = model(img_batch)
		if i == 1
			results["Class1.1"] = round(probs[1]; digits=4)
			results["Class1.2"] = round(probs[2]; digits=4)
			results["Class1.3"] = round(probs[3]; digits=4)
		elseif i == 2
			results["Class2.1"] = round(probs[1]; digits=4)
			results["Class2.2"] = round(probs[2]; digits=4)
		elseif i == 3
			results["Class3.1"] = round(probs[1]; digits=4)
			results["Class3.2"] = round(probs[2]; digits=4)
		elseif i == 4
			results["Class4.1"] = round(probs[1]; digits=4)
			results["Class4.2"] = round(probs[2]; digits=4)
		elseif i == 5
			results["Class5.1"] = round(probs[1]; digits=4)
			results["Class5.2"] = round(probs[2]; digits=4)
			results["Class5.3"] = round(probs[3]; digits=4)
			results["Class5.4"] = round(probs[4]; digits=4)
		elseif i == 6
			results["Class6.1"] = round(probs[1]; digits=4)
			results["Class6.2"] = round(probs[2]; digits=4)
		elseif i == 7
			results["Class7.1"] = round(probs[1]; digits=4)
			results["Class7.2"] = round(probs[2]; digits=4)
			results["Class7.3"] = round(probs[3]; digits=4)
		elseif i == 8
			results["Class8.1"] = round(probs[1]; digits=4)
			results["Class8.2"] = round(probs[2]; digits=4)
			results["Class8.3"] = round(probs[3]; digits=4)
			results["Class8.4"] = round(probs[4]; digits=4)
			results["Class8.5"] = round(probs[5]; digits=4)
			results["Class8.6"] = round(probs[6]; digits=4)
			results["Class8.7"] = round(probs[7]; digits=4)
		elseif i == 9
			results["Class9.1"] = round(probs[1]; digits=4)
			results["Class9.2"] = round(probs[2]; digits=4)
			results["Class9.3"] = round(probs[3]; digits=4)
		elseif i == 10
			results["Class10.1"] = round(probs[1]; digits=4)
			results["Class10.2"] = round(probs[2]; digits=4)
			results["Class10.3"] = round(probs[3]; digits=4)
		elseif i == 11
			results["Class11.1"] = round(probs[1]; digits=4)
			results["Class11.2"] = round(probs[2]; digits=4)
			results["Class11.3"] = round(probs[3]; digits=4)
			results["Class11.4"] = round(probs[4]; digits=4)
			results["Class11.5"] = round(probs[5]; digits=4)
			results["Class11.6"] = round(probs[6]; digits=4)
		end
	end
	
	return results
end

ground_truth_path = "./dataset/training_solutions_rev1.csv"
ground_truth_df = CSV.read(ground_truth_path, DataFrame)

# calculate MSE
function calculate_mse(predicted, ground_truth)
	return mean((predicted .- ground_truth) .^ 2)
end

function get_ground_truth(galaxy_id, ground_truth_df)
	row = ground_truth_df[ground_truth_df.GalaxyID .== galaxy_id, :]
	if nrow(row) == 0
		@error "GalaxyID $galaxy_id not found in ground truth data."
		return nothing
	end
	return Vector(row[1, 2:end])  # Exclude the GalaxyID column
end

image_path = "./dataset/images_training_rev1/105081.jpg"
if isfile(image_path)
	galaxy_id = parse(Int, split(basename(image_path), ".")[1])
	
	ground_truth = get_ground_truth(galaxy_id, ground_truth_df)
	if ground_truth === nothing
		exit()
	end
	
	results = classify_image(image_path)
	
	sorted_keys = sort(collect(keys(results)), by=x -> (parse(Int, split(x, '.')[1][6:end]), parse(Int, split(x, '.')[2])))
	predicted_probs = [results[key] for key in sorted_keys]
	
	mse = calculate_mse(predicted_probs, ground_truth)
	println("Mean Squared Error for GalaxyID $galaxy_id: $mse")
else
	@error "Image file not found: $image_path"
end