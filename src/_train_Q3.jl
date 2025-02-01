using Pkg
Pkg.add.(["Flux", "Images", "DataFrames", "CSV", "MLDataUtils", "CUDA", "ProgressMeter", "BSON", "cuDNN"])

using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN

include("train.jl")

classes = [Symbol("Class3.1"), Symbol("Class3.2")]

########################################################################################
# Q3. Is there a bar? 2 responses
########################################################################################

train_classif(classes, "models/class3_classif.bson")