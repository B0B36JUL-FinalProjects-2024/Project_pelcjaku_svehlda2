module GalaxyZoo

using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN

const IMG_SIZE = (224, 224)

function preprocess_image(path)
	try
		img = load(path)
		
		img = imresize(img, IMG_SIZE)
		img = RGB.(img)
		
		channels = channelview(img)
		if size(channels, 1) == 1  #grayscale
			channels = repeat(channels, 3, 1, 1)
		elseif size(channels, 1) == 4  # RGBA
			channels = channels[1:3,:,:]  # drop alpha
		end
		
		arr = permutedims(channels, (2, 3, 1))
		return Float32.(arr)
	catch e
		@error "Error processing image: $path" exception=e
		return zeros(Float32, IMG_SIZE..., 3)  #ret blank image on error
	end
end

function load_data(class_columns::Vector{Symbol})
	data = CSV.read("./dataset/training_solutions_rev1.csv", DataFrame)
	data.image_path = [joinpath("./dataset/images_training_rev1", "$(row.GalaxyID).jpg") for row in eachrow(data)]
	selected_columns = [:GalaxyID, :image_path]
	selected_columns = vcat(selected_columns, class_columns)
	data = data[:, selected_columns]
	return data
end

end # ------ end module GalaxyZoo.jl ------