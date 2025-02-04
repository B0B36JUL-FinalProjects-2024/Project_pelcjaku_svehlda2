module GalaxyZoo
export preprocess_image, load_data, IMG_SIZE

using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN, ImageTransformations

# IMG_SIZE = (224, 224)

# function preprocess_image(path)
# 	try
# 		img = load(path)
		
# 		img = imresize(img, IMG_SIZE)
# 		img = RGB.(img)
		
# 		channels = channelview(img)
# 		if size(channels, 1) == 1  #grayscale
# 			channels = repeat(channels, 3, 1, 1)
# 		elseif size(channels, 1) == 4  # RGBA
# 			channels = channels[1:3,:,:]  # drop alpha
# 		end
		
# 		arr = permutedims(channels, (2, 3, 1))
# 		return Float32.(arr)
# 	catch e
# 		@error "Error processing image: $path" exception=e
# 		throw(ArgumentError("No file exists at given path: $path"))
# 	end
# end

const CROP_SIZE = (207, 207)  # The cropped image size before resizing.
const RESIZED   = (52, 52)    # Final image size after resizing.

IMG_SIZE = RESIZED

"""
	preprocess_image(path::String)

Preprocesses an image at the given path for use in the neural network. The image is cropped to the
CROP_SIZE, then resized to the RESIZED size. The image is then normalized to have values between 0 and 1.
"""
function preprocess_image(path)
	try
		img = load(path)
		
		orig_height, orig_width = size(img)[1:2]
		crop_height, crop_width = CROP_SIZE
		
		start_row = Int(floor((orig_height - crop_height) / 2)) + 1
		start_col = Int(floor((orig_width - crop_width) / 2)) + 1
		
		#if the image is not already the desired size, resize it
		if size(img) != (crop_height, crop_width)
			#println("Resizing image from $path")
			#println(size(img))
			#println(crop_height, crop_width)
			img = view(img, start_row:start_row+crop_height-1, start_col:start_col+crop_width-1)
		end

		# img = imadjustintensity(img)

		img = imresize(img, RESIZED)
		
		img = RGB.(img)
		
		channels = channelview(img)
		if size(channels, 1) == 1
			channels = repeat(channels, 3, 1, 1)
		elseif size(channels, 1) == 4
			channels = channels[1:3, :, :]
		end
		
		for i in 1:size(channels, 1)
			chan = channels[i, :, :]
			min_val = minimum(chan)
			max_val = maximum(chan)
			channels[i, :, :] .= (chan .- min_val) ./ (max_val - min_val + eps())
		end
		
		arr = permutedims(channels, (2, 3, 1))
		return Float32.(arr)
		
	catch e
		@error "Error processing image: $path" exception=e
		throw(ArgumentError("No file exists at given path: $path"))
	end
end

"""
load_data(class_columns::Vector{Symbol})

Loads the training data from the dataset and returns a DataFrame with the specified columns.
Only classes specified in class_columns are included in the DataFrame.

# Examples
```julia
julia> classes = [Symbol("Class1.1"), Symbol("Class1.2"), Symbol("Class1.3")]
julia> data = load_data(classes)
```
"""
function load_data(class_columns::Vector{Symbol})
	data = CSV.read("./dataset/training_solutions_rev1.csv", DataFrame)
	data.image_path = [joinpath("./dataset/images_training_rev1", "$(row.GalaxyID).jpg") for row in eachrow(data)]
	selected_columns = [:GalaxyID, :image_path]
	selected_columns = vcat(selected_columns, class_columns)
	data = data[:, selected_columns]
	return data
end

end # ------ end module GalaxyZoo.jl ------