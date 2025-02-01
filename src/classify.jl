using Flux, Images, BSON

include("GalaxyZoo.jl")
using .GalaxyZoo

BSON.@load "models/class1_classif.bson" model_cpu
model = model_cpu |> cpu

function classify_image(image_path)
	img_array = GalaxyZoo.preprocess_image(image_path)
	img_batch = reshape(img_array, size(img_array)..., 1)
	
	probs = model(img_batch)
	
	class1_1 = probs[1]
	class1_2 = probs[2]
	class1_3 = probs[3]
	
	return (class1_1, class1_2, class1_3)
end

image_path = "./dataset/images_training_rev1/100023.jpg"
if isfile(image_path)
	c1_1, c1_2, c1_3 = classify_image(image_path)
	println("Classification results for $(basename(image_path)):")
	println("Class1.1: ", round(c1_1; digits=4))
	println("Class1.2: ", round(c1_2; digits=4))
	println("Class1.3: ", round(c1_3; digits=4))
else
	@error "Image file not found: $image_path"
end