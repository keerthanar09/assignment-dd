#!/bin/bash

# Script to push images to Docker Hub
# Make sure you're logged in first: docker login

set -e

DOCKER_USERNAME="keerthanaxd"

echo "=========================================="
echo "  Pushing Images to Docker Hub"
echo "=========================================="

echo -e "\nDocker Hub username: $DOCKER_USERNAME"

# Check if logged in
echo -e "\nChecking Docker Hub login..."
if ! docker info | grep -q "Username: $DOCKER_USERNAME"; then
    echo "Please login to Docker Hub first:"
    echo "  docker login --username $DOCKER_USERNAME"
    exit 1
fi

echo "✓ Logged in to Docker Hub"

# Push backend image
echo -e "\nPushing backend image..."
docker push $DOCKER_USERNAME/mean-backend:latest
echo "✓ Backend image pushed"

# Push frontend image
echo -e "\nPushing frontend image..."
docker push $DOCKER_USERNAME/mean-frontend:latest
echo "✓ Frontend image pushed"

echo -e "\n=========================================="
echo "  Images successfully pushed!"
echo "=========================================="
echo ""
echo "Images available at:"
echo "  https://hub.docker.com/r/$DOCKER_USERNAME/mean-backend"
echo "  https://hub.docker.com/r/$DOCKER_USERNAME/mean-frontend"
echo ""
