using Pkg
Pkg.add.(["Flux", "Images", "DataFrames", "CSV", "MLDataUtils", "CUDA", "ProgressMeter", "BSON", "cuDNN"])

using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN

include("train.jl")

classes = [Symbol("Class7.1"), Symbol("Class7.2"), Symbol("Class7.3")]

########################################################################################
# Q7. How round is the smooth galaxy? 3 responses
########################################################################################

train_classif(classes, "models/class7_classif.bson")