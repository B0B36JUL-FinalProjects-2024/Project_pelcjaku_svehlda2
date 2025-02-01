using Pkg
Pkg.add.(["Flux", "Images", "DataFrames", "CSV", "MLDataUtils", "CUDA", "ProgressMeter", "BSON", "cuDNN"])

using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN

include("train.jl")

classes = [Symbol("Class5.1"), Symbol("Class5.2"), Symbol("Class5.3"), Symbol("Class5.4")]

########################################################################################
# Q5. How prominent is the central bulge? 4 responses
########################################################################################

train_classif(classes, "models/class5_classif.bson")