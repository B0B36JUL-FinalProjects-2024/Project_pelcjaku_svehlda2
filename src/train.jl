using Pkg
Pkg.add.(["Flux", "Images", "DataFrames", "CSV", "MLDataUtils", "CUDA", "ProgressMeter", "BSON", "cuDNN", "ImageTransformations"])
using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN, ImageTransformations

include("GalaxyZoo.jl")
include("model.jl")
using .GalaxyZoo

const BATCH_SIZE = 32
const N_EPOCHS = 10
const LR = 0.001

function create_loader(df, class_columns::Vector{Symbol}; shuffle=true)
	indices = shuffle ? shuffleobs(1:nrow(df)) : 1:nrow(df)
	
	function getbatch(i)
		batch = indices[(i-1)*BATCH_SIZE+1 : min(i*BATCH_SIZE, end)]
		
		images = []
		valid_indices = []
		for i in batch
			img = GalaxyZoo.preprocess_image(df.image_path[i])
			if size(img) == (GalaxyZoo.IMG_SIZE..., 3)
				push!(images, img)
				push!(valid_indices, i)
			else
				@warn "Skipping invalid image: $(df.image_path[i])"
			end
		end
		
		labels = Matrix(df[valid_indices, class_columns])'
		
		X = length(images) > 0 ? cat(images..., dims=4) : zeros(Float32, GalaxyZoo.IMG_SIZE..., 3, 0)
		y = Float32.(labels)
		return (X, y)
	end
	
	n_batches = ceil(Int, nrow(df) / BATCH_SIZE)
	return (getbatch(i) for i in 1:n_batches), n_batches
end

"""
loss(x, y, model)

# The RMSE loss is calculated as:

`√(1/N * Σ(pᵢ - aᵢ)²)`

Where:
- `N` is the number of galaxies times the total number of responses
- `pᵢ` is the predicted value
- `aᵢ` is the actual value
"""
function loss(x, y, model)
	ŷ = model(x)
	return sqrt(Flux.Losses.mse(ŷ, y))
end

# training
function train_classif(classes::Vector{Symbol}, filename::String)
	#classes = [Symbol("Class1.1"), Symbol("Class1.2"), Symbol("Class1.3")]
	num_classes = length(classes)

	data = GalaxyZoo.load_data(classes)
	train, test = splitobs(data, at=0.8)

	println("Train size: $(nrow(train)), Test size: $(nrow(test))")

	train_loader, n_train = create_loader(train, classes)
	test_loader, n_test = create_loader(test, classes; shuffle=false)

	println("Train batches: $n_train, Test batches: $n_test")

	model = create_model(num_classes)
	
	opt = Adam(LR)
	state = Flux.setup(opt, model)
	
	# raining loop
	for epoch in 1:N_EPOCHS

		train_progress = Progress(n_train, desc="Training Epoch $epoch: ")

		for (x, y) in train_loader
			x, y = x |> gpu, y |> gpu
			grads = gradient(model) do m
				loss(x, y, m)
			end
			Flux.update!(state, model, grads[1])

			next!(train_progress)
		end
		
		#takes quite a long time

		# train_loss_progress = Progress(n_train, desc="Evaluating Train Loss: ")
		# test_loss_progress = Progress(n_test, desc="Evaluating Test Loss: ")

		# train_loss = eval_loss(model, train_loader, n_train, train_loss_progress)
		# test_loss = eval_loss(model, test_loader, n_test, test_loss_progress)
		# println("Epoch $epoch: Train RMSE=$(round(train_loss, digits=4)), Test RMSE=$(round(test_loss, digits=4))")
	end
	
	model_cpu = model |> cpu
	BSON.@save filename model_cpu
end

"""
eval_loss(model, loader, n_batches, progress_bar)

Evaluate the loss of the model on the given loader.
"""
function eval_loss(model, loader, n_batches, progress_bar)
	total_loss = 0.0f0

	for (x, y) in loader
		x, y = x |> gpu, y |> gpu
		total_loss += loss(x, y, model)
		next!(progress_bar)
	end
	return total_loss / n_batches
end