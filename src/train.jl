using Flux, ProgressMeter

function train(model, X, y; epochs=10, lr=0.001, batch_size=32)
	train_loader = Flux.DataLoader((X, y), batchsize=batch_size, shuffle=true)

	loss(x, y) = Flux.crossentropy(model(x), y) #TODO: this should be changed to RMSE
	opt = Flux.setup(Adam(lr), model)

	for epoch in 1:epochs
		@showprogress "Epoch $epoch/$epochs" for (x_batch, y_batch) in train_loader
			x_batch, y_batch = gpu(x_batch), gpu(y_batch)
			Flux.train!(loss, model, [(x_batch, y_batch)], opt)
		end
		println("Epoch $epoch completed.")
	end
end
