using Pkg
Pkg.add.(["Flux", "Images", "DataFrames", "CSV", "MLDataUtils", "CUDA", "ProgressMeter", "BSON", "cuDNN"])
using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN

include("GalaxyZoo.jl")
using .GalaxyZoo

const BATCH_SIZE = 32
const N_EPOCHS = 10

function create_loader(df, class_columns::Vector{Symbol}; shuffle=true)
	indices = shuffle ? shuffleobs(1:nrow(df)) : 1:nrow(df)
	
	function getbatch(i)
		batch = indices[(i-1)*BATCH_SIZE+1 : min(i*BATCH_SIZE, end)]
		
		images = []
		valid_indices = []
		for i in batch
			img = GalaxyZoo.preprocess_image(df.image_path[i])
			if size(img) == (IMG_SIZE..., 3)
				push!(images, img)
				push!(valid_indices, i)
			else
				@warn "Skipping invalid image: $(df.image_path[i])"
			end
		end
		
		labels = Matrix(df[valid_indices, class_columns])'
		
		X = length(images) > 0 ? cat(images..., dims=4) : zeros(Float32, IMG_SIZE..., 3, 0)
		y = Float32.(labels)
		return (X, y)
	end
	
	n_batches = ceil(Int, nrow(df) / BATCH_SIZE)
	return (getbatch(i) for i in 1:n_batches), n_batches
end

function create_model(n_classes::Int)
	Chain(
		Conv((3, 3), 3 => 32, relu; pad=1),
		MaxPool((2, 2)),
		Conv((3, 3), 32 => 64, relu; pad=1),
		MaxPool((2, 2)),
		Conv((3, 3), 64 => 128, relu; pad=1),
		MaxPool((2, 2)),
		Flux.flatten,
		Dense(128 * 28 * 28, 512, relu),  # 224/8 = 28
		Dropout(0.5),
		Dense(512, n_classes),
		softmax
	) |> gpu
end

# RMSE loss
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
	
	opt = Adam(0.001) #LR: 0.001
	state = Flux.setup(opt, model)
	
	# raining loop
	@showprogress for epoch in 1:N_EPOCHS
		for (x, y) in train_loader
			x, y = x |> gpu, y |> gpu
			grads = gradient(model) do m
				loss(x, y, m)
			end
			Flux.update!(state, model, grads[1])
		end
		
		train_loss = eval_loss(model, train_loader, n_train)
		test_loss = eval_loss(model, test_loader, n_test)
		println("Epoch $epoch: Train RMSE=$(round(train_loss, digits=4)), Test RMSE=$(round(test_loss, digits=4))")
	end
	
	model_cpu = model |> cpu
	BSON.@save filename model_cpu
end

# Evaluation function using RMSE
function eval_loss(model, loader, n_batches)
	total_loss = 0.0f0
	for (x, y) in loader
		x, y = x |> gpu, y |> gpu
		total_loss += loss(x, y, model)
	end
	return total_loss / n_batches
end

#main()