using Test
using Downloads
using Random
include("../src/cli.jl")

SOMBRERO_URL = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/M104_ngc4594_sombrero_galaxy_hi-res.jpg/640px-M104_ngc4594_sombrero_galaxy_hi-res.jpg"

@testset "CLI" begin
	@testset "load_image_from_url" begin
		url = SOMBRERO_URL
		load_image_from_url(url)
		@test isfile("temp")
		rm("temp")
	end

	# Test get_random_image function
	@testset "get_random_image" begin
		#create a temporary directory with some image files
		temp_dir = mktempdir()
		touch(joinpath(temp_dir, "image1.jpg"))
		touch(joinpath(temp_dir, "image2.png"))
		touch(joinpath(temp_dir, "not_an_image.txt"))

		random_image = get_random_image(temp_dir)
		@test occursin(r"\.(jpg|jpeg|png|bmp|gif)$", lowercase(random_image))

		rm(temp_dir, force=true, recursive=true)
	end

	@testset "run_cli_help" begin
		cmd = "help"
		std_file = "stdout.txt"

		open(std_file, "w") do io
			redirect_stdout(io) do
				run_cli(cmd=cmd)
			end
		end

		@test isfile(std_file)
		@test filesize(std_file) > 0
		rm(std_file)
	end

	@testset "run_cli_url" begin
		cmd = SOMBRERO_URL

		#test if temp file is created
		run_cli(cmd=cmd)
		@test isfile("temp")
	end

	#test local file gets classified
	@testset "run_cli_classification" begin
		cmd = "tests/test.jpg"
		std_file = "stdout.txt"

		open(std_file, "w") do io
			redirect_stdout(io) do
				run_cli(cmd=cmd)
			end
		end

		@test isfile(std_file)
		@test filesize(std_file) > 0

		output = read(std_file, String)
		normalized_output = replace(output, "\r\n" => "\n")
		@test occursin(r"medium", normalized_output)
		rm(std_file)
	end
end