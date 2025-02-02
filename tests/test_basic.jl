using Test

#to test if Julia is working today
@testset "Basic Julia Tests" begin
	# Test 1: Arithmetic Operations
	@testset "Arithmetic Operations" begin
		@test 1 + 1 == 2
		@test 2 * 3 == 6
		@test 5 - 3 == 2
		@test 10 / 2 == 5
	end

	# Test 2: Array Operations
	@testset "Array Operations" begin
		arr = [1, 2, 3, 4, 5]
		@test length(arr) == 5
		@test sum(arr) == 15
		@test arr[1] == 1
		@test arr[end] == 5
	end

	# Test 3: String Operations
	@testset "String Operations" begin
		str = "Hello, Julia!"
		@test length(str) == 13
		@test str[1:5] == "Hello"
		@test uppercase(str) == "HELLO, JULIA!"
		@test lowercase(str) == "hello, julia!"
	end
end