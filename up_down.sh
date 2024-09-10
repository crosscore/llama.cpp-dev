#!/bin/bash

if docker compose ps | grep "llama"; then
    echo "docker compose down"
    docker compose down
else
    echo "Starting Docker containers..."
    docker compose up --build -d
fi
