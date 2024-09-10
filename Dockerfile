# Use Python 3.11 slim image as the base
FROM python:3.11-slim-bullseye

# Avoid prompts from apt and set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV OMP_NUM_THREADS=1
ENV OPENBLAS_NUM_THREADS=1

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libopenblas-dev \
    ninja-build \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app/llama.cpp

# Use CMD instead of ENTRYPOINT
CMD ["/bin/bash", "-c", "tail -f /dev/null"]
