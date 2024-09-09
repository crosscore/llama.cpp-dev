# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    python3 \
    python3-pip \
    libopenblas-dev \
    ninja-build \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone llama.cpp repository and checkout specific version
RUN git clone https://github.com/ggerganov/llama.cpp.git && \
    cd llama.cpp && \
    git checkout b3707

# Build llama.cpp
WORKDIR /app/llama.cpp
RUN make

# Set environment variables for consistent behavior
ENV OMP_NUM_THREADS=1
ENV OPENBLAS_NUM_THREADS=1

# Set the entrypoint to bash
ENTRYPOINT ["/bin/bash"]
