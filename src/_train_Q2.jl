using Pkg
Pkg.add.(["Flux", "Images", "DataFrames", "CSV", "MLDataUtils", "CUDA", "ProgressMeter", "BSON", "cuDNN"])

using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN

include("train.jl")

classes = [Symbol("Class2.1"), Symbol("Class2.2")]

########################################################################################
# Q2. Is it edge-on? 2 responses
########################################################################################

train_classif(classes, "models/class2_classif.bson")