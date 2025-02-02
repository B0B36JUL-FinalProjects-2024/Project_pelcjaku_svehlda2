#!/bin/bash

MODEL_DIR="modelst"

if [ ! -d $MODEL_DIR ]; then
mkdir $MODEL_DIR
fi

cd $MODEL_DIR

BASE_URL="https://github.com/B0B36JUL-FinalProjects-2024/Project_pelcjaku_svehlda2/releases/download/release/class"
EXT=".bson"

for i in {1..11}
do
	wget "${BASE_URL}${i}_classif${EXT}"
done