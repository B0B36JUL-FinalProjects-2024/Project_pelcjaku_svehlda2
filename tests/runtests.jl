using Pkg
Pkg.activate(".")
Pkg.add("ImageView")

using Test

@testset verbose = true "Unit tests" begin
	include("test_basic.jl")
	include("test_galaxyzoo.jl")
	include("test_galaxytree.jl")
end

nothing