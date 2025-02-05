using Pkg
Pkg.activate(".")
Pkg.add.(["Flux", "Images", "BSON", "Downloads", "ImageView", "Crayons", "URIs"])

using Flux, Images, BSON, Downloads, ImageView, Random, URIs

include("GalaxyTree.jl")
include("GalaxyZoo.jl")
using .GalaxyTree
using .GalaxyZoo

const TRAINING_FOLDER = "dataset/images_training_rev1"
const TESTING_FOLDER = "dataset/images_test_rev1"

function load_image_from_url(url)
	temp_file = "temp.jpg"

	Downloads.download(String(url), temp_file)
	
	return temp_file
end

function get_random_image(folder)
	files = readdir(folder, join=true)
	filter!(f -> isfile(f) && occursin(r"\.(jpg|jpeg|png|bmp|gif)$", lowercase(f)), files)
	
	if isempty(files)
		error("No valid image files found in the folder: $folder")
	end
	rand(files)
end

function show_image(🖼️_path)
	name = split(🖼️_path, "/")[end]
	🖼️ = load(🖼️_path)
	ImageView.imshow(🖼️, title="$name")

	🌌 = GalaxyZoo.preprocess_image(🖼️_path)
	ImageView.imshow(🌌, title="$name")
end

function resize_external(img_path)
	#resize the image to 424x424 as in the galaxyzoo dataset

	if size(load(img_path)) == (424, 424)
		return img_path
	end

	img = load(img_path)
	resized = Images.imresize(img, (424, 424))
	
	path = split(img_path, ".")
	resized_path = joinpath(path[1] * "_resized." * path[2])
	save(resized_path, resized)

	return resized_path
end

#TODO: add feature of displaying the input image to the neural network
#TODO: add feature to display the kernels of the neural network

function display_help()
	println("----------------------------------------")
	println("Available commands:\n")
	println("  <file path> - Classify the image at the given path.")
	println("  <URL> - Classify the image from the given URL.")
	println("  test? - Classify a random image from the testing folder.")
	println("  train? - Classify a random image from the training folder.")
	println("  help - Display this help message.")
	println("  exit - Exit the CLI.")
	println("----------------------------------------")
end

function run_cli(; cmd = nothing)
	println("Galaxy Image Classification CLI")
	println("Type 'help' for a list of commands or 'exit' to quit.")

	
	while true
		print("Enter a command: ")

		user_input = ""

		if cmd !== nothing
			user_input = cmd
		else
			user_input = chomp(readline())
		end

		if lowercase(user_input) == "exit"
			println("Exiting...")
			ImageView.closeall()
			break


		elseif lowercase(user_input) == "help"
			display_help()


		elseif lowercase(user_input) == "test?"
			println("Selecting a random image from the testing folder...")
			try
				img_path = get_random_image(TESTING_FOLDER)
				println("Classifying image: ", img_path)
				
				show_image(img_path)

				result = GalaxyTree.classify(img_path)
				#println("Classification result: ", result)
			catch e
				println("An error occurred: ", e)
			end


		elseif lowercase(user_input) == "train?"
			println("Selecting a random image from the training folder...")
			try
				img_path = get_random_image(TRAINING_FOLDER)
				println("Classifying image: ", img_path)
				
				show_image(img_path)

				result = GalaxyTree.classify(img_path)
				#println("Classification result: ", result)
			catch e
				println("An error occurred: ", e)
			end


		else
			try
				if startswith(user_input, "http://") || startswith(user_input, "https://")
					println("Loading image from URL: ", user_input)
					
					temp_file = load_image_from_url(user_input)

					resized = resize_external(temp_file)
					
					show_image(resized)

					result = GalaxyTree.classify(resized)
					# println("Classification result: ", result)
				elseif isfile(user_input)
					println("Classifying image: ", user_input)

					resized = resize_external(user_input)
					
					show_image(resized)

					println("Resized image path: ", resized)
					result = GalaxyTree.classify(resized)
					#println("Classification result: ", result)
				else
					println("Invalid input. Please provide a valid file path, URL, or command.")
				end
			catch e
				println("An error occurred: ", e)
			end
		end

		if cmd !== nothing
			break
		end
	end
end

function run_cli(commands::Vector{String})
	map(cmd -> run_cli(cmd=cmd), commands)
end