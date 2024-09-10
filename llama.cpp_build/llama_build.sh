#!/bin/bash

LLAMA_CPP_DIR="/app/llama.cpp_build/llama.cpp_b3707"

if [ ! -d "$LLAMA_CPP_DIR" ]; then
    echo "Cloning llama.cpp repository..."
    git clone https://github.com/ggerganov/llama.cpp.git "$LLAMA_CPP_DIR"
    cd "$LLAMA_CPP_DIR"
    git checkout b3707
    echo "Building llama.cpp..."
    make
else
    echo "llama.cpp build artifacts already exist. Skipping build process."
fi

echo "Build process completed."
