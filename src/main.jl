using Pkg
Pkg.activate(pwd())
Pkg.add("CSV")
Pkg.add("Images")
Pkg.add("DataFrames")
Pkg.add("MLUtils")
Pkg.add("ProgressMeter")
Pkg.add("CUDA")
Pkg.add("Flux")
Pkg.add("ColorTypes")

include("GalaxyZoo.jl")

using .GalaxyZoo
GalaxyZoo.run()