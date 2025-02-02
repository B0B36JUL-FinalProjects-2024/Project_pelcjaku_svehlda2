function question02(results)
	println("\nQ2: Could this be a disk viewed edge-on?")

	if results["Class2.1"] > results["Class2.2"]
		println("  ↳ yes, this could be a disk viewed edge-on")
		return question09(results)
	else
		println("  ↳ no, this could not be a disk viewed edge-on")
		return question03(results)
	end
end

function question03(results)
	println("\nQ3: Is there a sign of a bar feature through the centre of the galaxy?")

	if results["Class3.1"] > results["Class3.2"]
		println("  ↳ yes, there is a sign of a bar feature")
		return question04(results)
	else
		println("  ↳ no, there is no sign of a bar feature")
		return question04(results)
	end
end

function question04(results)
	println("\nQ4: Is there any sign of a spiral arm pattern?")

	if results["Class4.1"] > results["Class4.2"]
		println("  ↳ yes, there is a sign of a spiral arm pattern")
		return question10(results)
	else
		println("  ↳ no, there is no sign of a spiral arm pattern")
		return question05(results)
	end
end

function question05(results)
	println("\nQ5: How prominent is the central bulge, compared with the rest of the galaxy?")

	max_prob, max_idx = findmax([results["Class5.1"], results["Class5.2"], results["Class5.3"], results["Class5.4"]])
	texts = ["no bulge", "just noticeable", "obvious", "dominant"]
	println("  ↳ $(texts[max_idx])")
	return question06(results)
end

function question06(results)
	println("\nQ6: Is there anything odd?")

	if results["Class6.1"] > results["Class6.2"]
		println("  ↳ yes, there is something odd")
		return question08(results)
	else
		println("  ↳ no, there is nothing odd")
		return "No odd feature"
	end
end

function question07(results)
	println("\nQ7: How rounded is it?")

	max_prob, max_idx = findmax([results["Class7.1"], results["Class7.2"], results["Class7.3"]])
	texts = ["completely round", "in between", "cigar-shaped"]
	println("  ↳ $(texts[max_idx])")
	return question06(results)
end

function question08(results)
	println("\nQ8: Is the odd feature a ring, or is the galaxy disturbed or irregular?")

	max_prob, max_idx = findmax([results["Class8.1"], results["Class8.2"], results["Class8.3"], results["Class8.4"], results["Class8.5"], results["Class8.6"], results["Class8.7"]])
	texts = ["ring", "lens or arc", "disturbed", "irregular", "other", "merger", "dust lane"]
	println("  ↳ $(texts[max_idx])")
	return texts[max_idx]
end

function question09(results)
	println("\nQ9: Does the galaxy have a bulge at its centre? If so, what shape?")

	max_prob, max_idx = findmax([results["Class9.1"], results["Class9.2"], results["Class9.3"]])
	texts = ["rounded", "boxy", "no bulge"]
	println("  ↳ $(texts[max_idx])")
	return question06(results)
end

function question10(results)
	println("\nQ10: How tightly wound do the spiral arms appear?")

	max_prob, max_idx = findmax([results["Class10.1"], results["Class10.2"], results["Class10.3"]])
	texts = ["tight", "medium", "loose"]
	println("  ↳ $(texts[max_idx])")
	return question11(results)
end

function question11(results)
	println("\nQ11: How many spiral arms are there?")

	max_prob, max_idx = findmax([results["Class11.1"], results["Class11.2"], results["Class11.3"], results["Class11.4"], results["Class11.5"], results["Class11.6"]])
	texts = ["1", "2", "3", "4", "more than four", "can't tell"]
	println("  ↳ $(texts[max_idx])")
	return question05(results)
end