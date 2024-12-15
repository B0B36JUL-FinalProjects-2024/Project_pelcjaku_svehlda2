using Flux

function build_model()
	model = Chain(
		Conv((3, 3), 1=>16, relu, pad=1),
		MaxPool((2, 2)),
		Conv((3, 3), 16=>32, relu, pad=1),
		MaxPool((2, 2)),
		Flux.flatten,
		Dense(32 * 16 * 16, 128, relu),
		Dense(128, 37),  #37 classes
		softmax
	) |> gpu  #move to gpu
	return model
end
