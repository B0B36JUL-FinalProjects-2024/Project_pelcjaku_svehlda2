# function create_model(n_classes::Int)
# 	Chain(
# 		Conv((3, 3), 3 => 32, relu; pad=1),
# 		MaxPool((2, 2)),
# 		Conv((3, 3), 32 => 64, relu; pad=1),
# 		MaxPool((2, 2)),
# 		Conv((3, 3), 64 => 128, relu; pad=1),
# 		MaxPool((2, 2)),
# 		Flux.flatten,
# 		Dense(128 * 28 * 28, 512, relu),  # 224/8 = 28
# 		Dropout(0.5),
# 		Dense(512, n_classes),
# 		softmax
# 	) |> gpu
# end

# function create_model(n_classes::Int)
# 	cnn = Chain(
# 		x -> imresize(x, (52, 52)),
# 		Conv((3, 3), 3 => 16, relu; pad=1),
# 		MaxPool((2, 2)),
# 		Conv((3, 3), 16 => 32, relu; pad=1),
# 		MaxPool((2, 2)),
# 		flatten,
# 		Dense(32 * 13 * 13, 512, relu)
# 	)
	
# 	fc = Chain(
# 		Dense(513, 256, relu),
# 		Dropout(0.5),
# 		Dense(256, 128, relu),
# 		Dropout(0.5),
# 		Dense(128, n_classes),
# 		softmax
# 	)
	
# 	return (img, ext) -> begin
# 		cnn_features = cnn(img)
# 		combined = vcat(cnn_features, ext)
# 		fc(combined)
# 	end |> gpu
# end

# function create_model(n_classes::Int)
# 	model = Chain(
# 		# The model now assumes the image is already resized to 52×52.
# 		# Step 1: First convolution + max-pooling.
# 		# Convolve with a 3×3 kernel, 3 input channels → 16 output channels.
# 		# Padding is set so that the 52×52 size is maintained.
# 		Conv((3, 3), 3 => 16, relu; pad = 1),
# 		MaxPool((2, 2)),  # 52×52 becomes 26×26.
		
# 		# Step 2: Second convolution + max-pooling.
# 		# Convolve with a 3×3 kernel, 16 input channels → 32 output channels.
# 		Conv((3, 3), 16 => 32, relu; pad = 1),
# 		MaxPool((2, 2)),  # 26×26 becomes 13×13.
		
# 		# Step 3: Flatten the output and reduce to 512 features.
# 		Flux.flatten,
# 		Dense(32 * 13 * 13, 512, relu),
# 		Dropout(0.5),
		
# 		# Step 4: Fully connected layers.
# 		Dense(512, 256, relu),
# 		Dropout(0.5),
# 		Dense(256, 128, relu),
# 		Dropout(0.5),
# 		Dense(128, n_classes),
# 		Flux.softmax
# 	) |> gpu
# 	return model
# end

function create_model(n_classes::Int)
	model = Chain(
		
		Conv((7, 7), 3 => 16, relu; pad = 3),
		MaxPool((2, 2)),
		
		Conv((3, 3), 16 => 16, relu; pad = 1),
		MaxPool((2, 2)),
		
		Conv((3, 3), 16 => 32, relu; pad = 1),
		MaxPool((2, 2)),
		
		Flux.flatten,
		Dense(32 * 6 * 6, 512, relu),
		Dropout(0.5),
		
		Dense(512, 256, relu),
		Dropout(0.5),
		Dense(256, 128, relu),
		Dropout(0.5),
		Dense(128, n_classes),
		Flux.softmax
	) |> gpu
	return model
end