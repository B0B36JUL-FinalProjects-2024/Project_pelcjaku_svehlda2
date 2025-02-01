using Pkg
Pkg.add.(["Flux", "Images", "DataFrames", "CSV", "MLDataUtils", "CUDA", "ProgressMeter", "BSON", "cuDNN"])

using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN

include("train.jl")

classes = [Symbol("Class10.1"), Symbol("Class10.2"), Symbol("Class10.3")]

########################################################################################
# Q10. How tightly wound are the spiral arms? 3 responses
########################################################################################

train_classif(classes, "class10_classif.bson")