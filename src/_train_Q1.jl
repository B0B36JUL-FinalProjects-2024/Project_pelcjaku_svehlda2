using Pkg
Pkg.add.(["Flux", "Images", "DataFrames", "CSV", "MLDataUtils", "CUDA", "ProgressMeter", "BSON", "cuDNN"])

using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN

include("train.jl")

classes = [Symbol("Class1.1"), Symbol("Class1.2"), Symbol("Class1.3")]

########################################################################################
# Q1. Is the object a smooth galaxy, a galaxy with features/disk or a star? 3 responses
########################################################################################

train_classif(classes, "models/class1_classif.bson")