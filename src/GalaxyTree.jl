module GalaxyTree

using Flux, Images, BSON, Crayons

include("GalaxyZoo.jl")
include("questions.jl")

using .GalaxyZoo

classnames = [
	["Class1.1", "Class1.2", "Class1.3"],
	["Class2.1", "Class2.2"],
	["Class3.1", "Class3.2"],
	["Class4.1", "Class4.2"],
	["Class5.1", "Class5.2", "Class5.3", "Class5.4"],
	["Class6.1", "Class6.2"],
	["Class7.1", "Class7.2", "Class7.3"],
	["Class8.1", "Class8.2", "Class8.3", "Class8.4", "Class8.5", "Class8.6", "Class8.7"],
	["Class9.1", "Class9.2", "Class9.3"],
	["Class10.1", "Class10.2", "Class10.3"],
	["Class11.1", "Class11.2", "Class11.3", "Class11.4", "Class11.5", "Class11.6"]
]

models = []
for i in 1:11
	model_path = "models/class$(i)_classif.bson"
	BSON.@load model_path model_cpu
	model = model_cpu |> cpu
	push!(models, model)
end

"""
set_results!(results, probs, class_names)

Set the results dictionary with the probabilities of each class.
"""
function set_results!(results, probs, class_names)
	for (i, class_name) in enumerate(class_names)
		results[class_name] = round(probs[i]; digits=4)
	end
end

"""
classify_image(image_path)

Classifies an image with the set of models as defined in Galaxy Zoo. Those classification results are saved as a dictionary.

Returns: results (Dict)
"""
function classify_image(image_path)
	img_array = GalaxyZoo.preprocess_image(image_path)
	img_batch = reshape(img_array, size(img_array)..., 1)
	
	results = Dict()

	for (i, model) in enumerate(models)
		probs = model(img_batch)

		set_results!(results, probs, classnames[i])
	end
	
	return results
end

"""
decision_tree(results)

Runs the decision tree classification with the given results, given by the classifier set.
"""
function decision_tree(results)
	println("Q1: Is the object a smooth galaxy, a galaxy with features/disk, or a star?")

	if results["Class1.1"] > results["Class1.2"] && results["Class1.1"] > results["Class1.3"]
		println(crayon"blue"("  ↳ smooth"))
		return question07(results)
	elseif results["Class1.2"] > results["Class1.1"] && results["Class1.2"] > results["Class1.3"]
		println(crayon"blue"("  ↳ features or disk"))
		return question02(results)
	else
		println(crayon"blue"("  ↳ star or artifact"))
		return "Star or Artifact"
	end
end

"""
classify(image_path)

Sets up the classification process for the desicion tree. It first evaluates the image (runs classification on each model),
then runs the decision tree classification.
"""
function classify(image_path)
	if isfile(image_path)
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

end # -------- end of module GalaxyTree --------