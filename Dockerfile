# Use Python 3.11 slim image as the base
FROM python:3.11-slim-bullseye

# Avoid prompts from apt and set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV OMP_NUM_THREADS=1
ENV OPENBLAS_NUM_THREADS=1

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    make \
    git \
    libopenblas-dev \
    ninja-build \
    pkg-config \
    procps \
    && rm -rf /var/lib/apt/lists/*

RUN echo "alias ls='ls --color=auto'" >> ~/.bashrc && \
    echo "alias ll='ls -alF'" >> ~/.bashrc && \
    echo "export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> ~/.bashrc

# Set working directory
WORKDIR /app

COPY ./requirements.txt /app

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Use CMD instead of ENTRYPOINT
CMD ["/bin/bash", "-c", "tail -f /dev/null"]
