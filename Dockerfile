# Use Python 3.11 slim image as the base
FROM python:3.11-slim-bookworm

# Avoid prompts from apt and set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV OMP_NUM_THREADS=0
ENV OPENBLAS_NUM_THREADS=0

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    git-lfs \
    libopenblas-dev \
    libopenmpi-dev \
    ninja-build \
    pkg-config \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up some useful aliases and prompt
RUN echo "alias ls='ls --color=auto'" >> ~/.bashrc && \
    echo "alias ll='ls -alF'" >> ~/.bashrc && \
    echo "export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> ~/.bashrc

# Set working directory
WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

CMD ["/bin/bash", "-c", "tail -f /dev/null"]