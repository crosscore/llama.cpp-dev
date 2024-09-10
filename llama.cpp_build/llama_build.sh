#!/bin/bash

# Set the directory for llama.cpp
LLAMA_CPP_DIR="../llama.cpp_build/llama.cpp_b3707"

# Create the parent directory if it doesn't exist
mkdir -p "$(dirname "$LLAMA_CPP_DIR")"

# Check if the directory already exists
if [ ! -d "$LLAMA_CPP_DIR" ]; then
    echo "Cloning llama.cpp repository..."
    git clone https://github.com/ggerganov/llama.cpp.git "$LLAMA_CPP_DIR"
    cd "$LLAMA_CPP_DIR"
    git checkout b3707
else
    echo "llama.cpp directory already exists. Changing to directory..."
    cd "$LLAMA_CPP_DIR"
    git pull
    git checkout b3707
fi

# Output gcc version
echo "GCC version:"
gcc --version

# Set log file name with modified path
LOG_FILE="../build_log_$(date +%Y%m%d_%H%M%S).txt"

echo "Building llama.cpp..."
# Redirect both stdout and stderr to the log file, and also display on console
make 2>&1 | tee "$LOG_FILE"

echo "Build process completed. Log saved to $LOG_FILE"

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Build successful."
else
    echo "Build failed. Please check the log file for details."
fi