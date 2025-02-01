using Pkg
Pkg.add.(["Flux", "Images", "DataFrames", "CSV", "MLDataUtils", "CUDA", "ProgressMeter", "BSON", "cuDNN"])

using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN

include("train.jl")

classes = [Symbol("Class11.1"), Symbol("Class11.2"), Symbol("Class11.3"), Symbol("Class11.4"), Symbol("Class11.5"), Symbol("Class11.6")]

########################################################################################
# Q11. How many spiral arms are there? 6 responses
########################################################################################

train_classif(classes, "class11_classif.bson")