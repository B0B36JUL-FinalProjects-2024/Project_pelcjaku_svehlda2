using Flux, Images, BSON

include("GalaxyZoo.jl")
using .GalaxyZoo

models = []
for i in 1:11
	model_path = "models/class$(i)_classif.bson"
	BSON.@load model_path model_cpu
	model = model_cpu |> cpu
	push!(models, model)
end

# Define the decision tree
function decision_tree(results)
	println("Q1: Is the object a smooth galaxy, a galaxy with features/disk or a star?")

	# Task 01
	if results["Class1.1"] > results["Class1.2"] && results["Class1.1"] > results["Class1.3"]
		# smooth
		println("Smooth")
		return task07(results)
	elseif results["Class1.2"] > results["Class1.1"] && results["Class1.2"] > results["Class1.3"]
		# features or disk
		println("Features or Disk")
		return task02(results)
	else
		# star or artifact
		return "Star or Artifact"
	end
end

function task02(results)
	println("Q2: Is it edge-on?")

	# Task 02
	if results["Class2.1"] > results["Class2.2"]
		# yes, edge-on
		println("Edge-on")
		return task09(results)
	else
		# no
		println("Not edge-on")
		return task03(results)
	end
end

function task03(results)
	println("Q3: Is there a bar?")

	# Task 03
	if results["Class3.1"] > results["Class3.2"]
		# yes, bar feature
		println("Bar feature")
		return task04(results)
	else
		# no
		println("No bar feature")
		return task04(results)
	end
end

function task04(results)
	println("Q4: Is there a spiral pattern?")

	# Task 04
	if results["Class4.1"] > results["Class4.2"]
		# yes, spiral arm pattern
		println("Spiral arm pattern")
		return task10(results)
	else
		# no
		println("No spiral arm pattern")
		return task05(results)
	end
end

function task05(results)
	println("Q5: How prominent is the central bulge?")

	# Task 05
	# Assuming Class5.1: no bulge, Class5.2: just noticeable, Class5.3: obvious, Class5.4: dominant
	max_prob, max_idx = findmax([results["Class5.1"], results["Class5.2"], results["Class5.3"], results["Class5.4"]])
	
	texts = ["No bulge", "Just noticeable", "Obvious", "Dominant"]

	println(texts[max_idx])

	return task06(results)
end

function task06(results)
	println("Q6: Is there anything 'odd' about the galaxy?")

	# Task 06
	if results["Class6.1"] > results["Class6.2"]
		# yes, odd feature
		println("Odd feature")
		return task08(results)
	else
		# no
		println("No odd feature")

		return "No odd feature"
	end
end

function task07(results)
	println("Q7: How round is the smooth galaxy?")

	# Task 07
	# Assuming Class7.1: completely round, Class7.2: in between, Class7.3: cigar-shaped
	max_prob, max_idx = findmax([results["Class7.1"], results["Class7.2"], results["Class7.3"]])
	
	texts = ["Completely round", "In between", "Cigar-shaped"]

	println(texts[max_idx])
	
	return task06(results)
end

function task08(results)
	println("Q8: What is the odd feature?")

	# Task 08
	# Assuming Class8.1: ring, Class8.2: lens or arc, Class8.3: disturbed, Class8.4: irregular, Class8.5: other, Class8.6: merger, Class8.7: dust lane
	max_prob, max_idx = findmax([results["Class8.1"], results["Class8.2"], results["Class8.3"], results["Class8.4"], results["Class8.5"], results["Class8.6"], results["Class8.7"]])
	if max_idx == 1
		println("Ring")
		return "Ring"
	elseif max_idx == 2
		println("Lens or Arc")
		return "Lens or Arc"
	elseif max_idx == 3
		println("Disturbed")
		return "Disturbed"
	elseif max_idx == 4
		println("Irregular")
		return "Irregular"
	elseif max_idx == 5
		println("Other")
		return "Other"
	elseif max_idx == 6
		println("Merger")
		return "Merger"
	elseif max_idx == 7
		println("Dust Lane")
		return "Dust Lane"
	end
end

function task09(results)
	println("Q9: What shape is the bulge in the edge-on galaxy?")

	# Task 09
	# Assuming Class9.1: rounded, Class9.2: boxy, Class9.3: no bulge
	max_prob, max_idx = findmax([results["Class9.1"], results["Class9.2"], results["Class9.3"]])
	
	texts = ["Rounded", "Boxy", "No bulge"]

	println(texts[max_idx])

	return task06(results)
end

function task10(results)
	println("Q10: How tightly wound are the spiral arms?")

	# Task 10
	# Assuming Class10.1: tight, Class10.2: medium, Class10.3: loose
	max_prob, max_idx = findmax([results["Class10.1"], results["Class10.2"], results["Class10.3"]])

	texts = ["Tight", "Medium", "Loose"]

	println(texts[max_idx])

	return task11(results)
end

function task11(results)
	println("Q11: How many spiral arms are there?")

	# Task 11
	# Assuming Class11.1: 1, Class11.2: 2, Class11.3: 3, Class11.4: 4, Class11.5: more than four, Class11.6: can't tell
	max_prob, max_idx = findmax([results["Class11.1"], results["Class11.2"], results["Class11.3"], results["Class11.4"], results["Class11.5"], results["Class11.6"]])
	
	texts = ["1", "2", "3", "4", "More than four", "Can't tell"]

	println(texts[max_idx])

	return task05(results)
end

image_path = "./dataset/images_test_rev1/127277.jpg"
if isfile(image_path)

	final_classification = decision_tree(results)
	println("Final Classification: $final_classification")

else
	@error "Image file not found: $image_path"
end