using Pkg
Pkg.add.(["Flux", "Images", "DataFrames", "CSV", "MLDataUtils", "CUDA", "ProgressMeter", "BSON", "cuDNN"])

using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN

include("train.jl")

classes = [Symbol("Class8.1"), Symbol("Class8.2"), Symbol("Class8.3"), Symbol("Class8.4"), Symbol("Class8.5"), Symbol("Class8.6"), Symbol("Class8.7")]

########################################################################################
# Q8. What is the odd feature? 7 responses
########################################################################################

train_classif(classes, "models/class8_classif.bson")