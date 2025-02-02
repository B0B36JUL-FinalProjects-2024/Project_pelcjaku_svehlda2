using Pkg
Pkg.add.(["Flux", "Images", "DataFrames", "CSV", "MLDataUtils", "CUDA", "ProgressMeter", "BSON", "cuDNN"])

using Flux, Images, DataFrames, CSV, MLDataUtils, CUDA, ProgressMeter, BSON, cuDNN

include("train.jl")

classes = [Symbol("Class1.1"), Symbol("Class1.2"), Symbol("Class1.3")]

########################################################################################
# Q1. Is the object a smooth galaxy, a galaxy with features/disk or a star? 3 responses
########################################################################################

train_classif(classes, "models/class1_classif.bson")

classes = [Symbol("Class2.1"), Symbol("Class2.2")]

########################################################################################
# Q2. Is it edge-on? 2 responses
########################################################################################

train_classif(classes, "models/class2_classif.bson")

classes = [Symbol("Class3.1"), Symbol("Class3.2")]

########################################################################################
# Q3. Is there a bar? 2 responses
########################################################################################

train_classif(classes, "models/class3_classif.bson")

classes = [Symbol("Class4.1"), Symbol("Class4.2")]

########################################################################################
# Q4. Is there a spiral pattern? 2 responses
########################################################################################

train_classif(classes, "models/class4_classif.bson")

classes = [Symbol("Class5.1"), Symbol("Class5.2"), Symbol("Class5.3"), Symbol("Class5.4")]

########################################################################################
# Q5. How prominent is the central bulge? 4 responses
########################################################################################

train_classif(classes, "models/class5_classif.bson")

classes = [Symbol("Class6.1"), Symbol("Class6.2")]

########################################################################################
# Q6. Is there anything "odd" about the galaxy? 2 responses
########################################################################################

train_classif(classes, "models/class6_classif.bson")

classes = [Symbol("Class7.1"), Symbol("Class7.2"), Symbol("Class7.3")]

########################################################################################
# Q7. How round is the smooth galaxy? 3 responses
########################################################################################

train_classif(classes, "models/class7_classif.bson")

classes = [Symbol("Class8.1"), Symbol("Class8.2"), Symbol("Class8.3"), Symbol("Class8.4"), Symbol("Class8.5"), Symbol("Class8.6"), Symbol("Class8.7")]

########################################################################################
# Q8. What is the odd feature? 7 responses
########################################################################################

train_classif(classes, "models/class8_classif.bson")

classes = [Symbol("Class9.1"), Symbol("Class9.2"), Symbol("Class9.3")]

########################################################################################
# Q9. What shape is the bulge in the edge-on galaxy? 3 responses
########################################################################################

train_classif(classes, "models/class9_classif.bson")

classes = [Symbol("Class10.1"), Symbol("Class10.2"), Symbol("Class10.3")]

########################################################################################
# Q10. How tightly wound are the spiral arms? 3 responses
########################################################################################

train_classif(classes, "models/class10_classif.bson")

classes = [Symbol("Class11.1"), Symbol("Class11.2"), Symbol("Class11.3"), Symbol("Class11.4"), Symbol("Class11.5"), Symbol("Class11.6")]

########################################################################################
# Q11. How many spiral arms are there? 6 responses
########################################################################################

train_classif(classes, "models/class11_classif.bson")