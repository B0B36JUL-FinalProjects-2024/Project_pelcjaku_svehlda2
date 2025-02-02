module GalaxyTree

# using Pkg
# Pkg.activate(".")
# Pkg.add.(["Flux", "Images", "BSON", "ImageView"])

using Flux, Images, BSON

include("GalaxyZoo.jl")
include("questions.jl")

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

function decision_tree(results)
	println("Q1: Is the object a smooth galaxy, a galaxy with features/disk, or a star?")

	if results["Class1.1"] > results["Class1.2"] && results["Class1.1"] > results["Class1.3"]
		println("  ↳ smooth")
		return question07(results)
	elseif results["Class1.2"] > results["Class1.1"] && results["Class1.2"] > results["Class1.3"]
		println("  ↳ features or disk")
		return question02(results)
	else
		println("  ↳ star or artifact")
		return "Star or Artifact"
	end
end


function classify(image_path)
	if isfile(image_path)
		# img = load(image_path)
		# println("\nDisplaying image: $image_path")
		# display(img)

		results = classify_image(image_path)

		println("\n=== Galaxy Zoo Decision Tree ===")
		println("Evaluating image: $image_path")
		println("-------------------------------")

		final_classification = decision_tree(results)
		println("\n=== end of classification ===")
		#println("  ↳ $final_classification")
	else
		@error "Image file not found: $image_path"
	end
end

# testing classification
# image_path = "./dataset/images_test_rev1/132523.jpg"
# image_path = "./dataset/whirpool.jpg"
# if isfile(image_path)
# 	img = load(image_path)
# 	println("\nDisplaying image: $image_path")
# 	display(img)

# 	results = classify_image(image_path)
# 	final_classification = decision_tree(results)
# 	println("\n=== end of classification ===")
# 	#println("  ↳ $final_classification")
# else
# 	@error "Image file not found: $image_path"
# end

end # -------- end of module GalaxyTree --------