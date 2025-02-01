using Pkg
Pkg.add.(["Flux", "Images", "DataFrames", "CSV", "MLDataUtils", "CUDA", "ProgressMeter", "BSON", "cuDNN"])

using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN

include("train.jl")

classes = [Symbol("Class6.1"), Symbol("Class6.2")]

########################################################################################
# Q6. Is there anything "odd" about the galaxy? 2 responses
########################################################################################

train_classif(classes, "models/class6_classif.bson")