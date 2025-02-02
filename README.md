# Galaxy Zoo Classifier

The aim of this project is to implement a classifier for the Galaxy Zoo dataset as described in the Kaggle competition [Galaxy Zoo - The Galaxy Challenge](https://www.kaggle.com/c/galaxy-zoo-the-galaxy-challenge).

The classifier should be able to predict the type of galaxy based on this decision tree:

![Galaxy Zoo Decision Tree](img/decision_tree.png)

which corresponds to the following classes:

- Class1.1,Class1.2,Class1.3
- Class2.1,Class2.2
- Class3.1,Class3.2
- Class4.1,Class4.2
- Class5.1,Class5.2,Class5.3,Class5.4
- Class6.1,Class6.2
- Class7.1,Class7.2,Class7.3
- Class8.1,Class8.2,Class8.3,Class8.4,Class8.5,Class8.6,Class8.7
- Class9.1,Class9.2,Class9.3
- Class10.1,Class10.2,Class10.3
- Class11.1,Class11.2,Class11.3,Class11.4,Class11.5,Class11.6

The decision tree can also be represented by the following table:

![Galaxy Zoo Decision Table](img/questions.png)

## Training

To train the CNNs run the training scripts in `src`:

```bash
julia src/_train_Q[num].jl
```
or you can download the pretrained models by running

```bash
chmod +x getmodels.sh
./getmodels.sh
```

the models are saved in the `models/` directory in a `.bson` format.

## Classification

To classify an image, run the `GalaxyTree` classifier (or run `src/main.jl`):

```julia
include("GalaxyTree.jl")

using .GalaxyTree

GalaxyTree.classify("dataset/whirpool.jpg")
```
and the following classification will be printed:

```txt
=== Galaxy Zoo Decision Tree ===
Evaluating image: dataset/whirpool.jpg
-------------------------------
Q1: Is the object a smooth galaxy, a galaxy with features/disk, or a star?
  ↳ features or disk

Q2: Could this be a disk viewed edge-on?
  ↳ no

Q3: Is there a sign of a bar feature through the centre of the galaxy?
  ↳ no

Q4: Is there any sign of a spiral arm pattern?
  ↳ yes

Q10: How tightly wound do the spiral arms appear?
  ↳ medium

Q11: How many spiral arms are there?
  ↳ can't tell

Q5: How prominent is the central bulge, compared with the rest of the galaxy?
  ↳ no bulge

Q6: Is there anything odd?
  ↳ no

=== end of classification ===
```

Jakub Pelc, Daniel Švehla for [B0B36JUL](https://juliateachingctu.github.io/Julia-for-Optimization-and-Learning/stable/), 2024