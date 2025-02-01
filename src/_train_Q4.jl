using Pkg
Pkg.add.(["Flux", "Images", "DataFrames", "CSV", "MLDataUtils", "CUDA", "ProgressMeter", "BSON", "cuDNN"])

using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN

include("train.jl")

classes = [Symbol("Class4.1"), Symbol("Class4.2")]

########################################################################################
# Q4. Is there a spiral pattern? 2 responses
########################################################################################

train_classif(classes, "models/class4_classif.bson")