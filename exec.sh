#!/bin/bash

if docker compose ps | grep "llama"; then
    echo "docker compose exec llama bash"
    docker compose exec llama bash
fi
