using Pkg
Pkg.activate(".")
Pkg.add.(["Flux", "Images", "BSON", "ImageView"])

using Flux, Images, BSON, ImageView

include("GalaxyTree.jl")
using .GalaxyTree

path = "dataset/images_test_rev1/100018.jpg"
path = "dataset/whirpool.jpg"

GalaxyTree.classify(path)

# select random image from the testing image directory

dir = "dataset/images_test_rev1"
files = readdir(dir)
path = joinpath(dir, files[rand(1:end)])

GalaxyTree.classify(path)