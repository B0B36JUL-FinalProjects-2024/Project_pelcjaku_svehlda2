using Pkg
Pkg.add.(["Flux", "Images", "DataFrames", "CSV", "MLDataUtils", "CUDA", "ProgressMeter", "BSON", "cuDNN"])

using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN

include("train.jl")

classes = [Symbol("Class9.1"), Symbol("Class9.2"), Symbol("Class9.3")]

########################################################################################
# Q9. What shape is the bulge in the edge-on galaxy? 3 responses
########################################################################################

train_classif(classes, "class9_classif.bson")