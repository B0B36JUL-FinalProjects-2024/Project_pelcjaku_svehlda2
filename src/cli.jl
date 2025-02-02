using Pkg
Pkg.activate(".")
Pkg.add.(["Flux", "Images", "BSON", "Downloads", "ImageView"])

using Flux, Images, BSON, Downloads, ImageView
using Random

include("GalaxyTree.jl")
using .GalaxyTree

const TRAINING_FOLDER = "dataset/images_training_rev1"
const TESTING_FOLDER = "dataset/images_test_rev1"

function load_image_from_url(url)
	Downloads.download(url, "temp")
	nothing
end

function get_random_image(folder)
	files = readdir(folder, join=true)
	filter!(f -> isfile(f) && occursin(r"\.(jpg|jpeg|png|bmp|gif)$", lowercase(f)), files)
	
	if isempty(files)
		error("No valid image files found in the folder: $folder")
	end
	
	rand(files)
end

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
			break
		elseif lowercase(user_input) == "help"
			display_help()
		elseif lowercase(user_input) == "test?"
			println("Selecting a random image from the testing folder...")
			try
				img_path = get_random_image(TESTING_FOLDER)
				println("Classifying image: ", img_path)
				img = load(img_path)
				ImageView.imshow(img)
				result = GalaxyTree.classify(img_path)
				println("Classification result: ", result)
			catch e
				println("An error occurred: ", e)
			end
		elseif lowercase(user_input) == "train?"
			println("Selecting a random image from the training folder...")
			try
				img_path = get_random_image(TRAINING_FOLDER)
				println("Classifying image: ", img_path)
				img = load(img_path)
				ImageView.imshow(img)
				result = GalaxyTree.classify(img_path)
				println("Classification result: ", result)
			catch e
				println("An error occurred: ", e)
			end
		else
			try
				if startswith(user_input, "http://") || startswith(user_input, "https://")
					println("Loading image from URL: ", user_input)
					load_image_from_url(user_input)
					img = load("temp")
					ImageView.imshow(img)
					result = GalaxyTree.classify("temp")
					println("Classification result: ", result)
				elseif isfile(user_input)
					println("Classifying image: ", user_input)
					img = load(user_input)
					ImageView.imshow(img)
					result = GalaxyTree.classify(user_input)
					println("Classification result: ", result)
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