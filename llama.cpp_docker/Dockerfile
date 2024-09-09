# Use Python 3.11 slim image as the base
FROM python:3.11-slim-bullseye AS builder

# Avoid prompts from apt and set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV OMP_NUM_THREADS=1
ENV OPENBLAS_NUM_THREADS=1

# Install necessary packages
RUN apt-get update && apt-get install -y bash \
    build-essential \
    cmake \
    git \
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

# Create a new stage for the final image
FROM python:3.11-slim-bullseye

# Copy the built artifacts from the builder stage
COPY --from=builder /app/llama.cpp /app/llama.cpp

# Set working directory
WORKDIR /app/llama.cpp

# Use CMD instead of ENTRYPOINT
CMD ["/bin/bash", "-c", "tail -f /dev/null"]
