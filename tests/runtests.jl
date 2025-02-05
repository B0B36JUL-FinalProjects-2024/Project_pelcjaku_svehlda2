include("../src/env.jl")

using Test

@testset verbose = true "Unit tests" begin
	include("test_basic.jl")
	include("test_galaxyzoo.jl")
	include("test_galaxytree.jl")
	include("test_cli.jl")
end

nothing