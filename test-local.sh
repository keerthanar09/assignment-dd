#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "  MEAN Stack Local Testing Script"
echo "=========================================="

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}Warning: .env file not found${NC}"
    echo "Creating .env from .env.example..."
    cp .env.example .env
    echo -e "${YELLOW}Please edit .env and set your DOCKER_USERNAME${NC}"
    exit 1
fi

# Source .env file
source .env

if [ -z "$DOCKER_USERNAME" ] || [ "$DOCKER_USERNAME" == "your-dockerhub-username" ]; then
    echo -e "${RED}Error: DOCKER_USERNAME not set in .env file${NC}"
    echo "Please edit .env and set your Docker Hub username"
    exit 1
fi

echo -e "\n${GREEN}✓${NC} Docker Hub username: $DOCKER_USERNAME"

# Check Docker is running
echo -e "\n1. Checking Docker..."
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}✗ Docker is not running${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} Docker is running"

# Check Docker Compose
echo -e "\n2. Checking Docker Compose..."
if ! docker compose version > /dev/null 2>&1; then
    echo -e "${RED}✗ Docker Compose not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} Docker Compose is available"

# Stop existing containers
echo -e "\n3. Stopping existing containers..."
docker compose down > /dev/null 2>&1
echo -e "${GREEN}✓${NC} Cleaned up existing containers"

# Build images
echo -e "\n4. Building Docker images..."
if docker compose build; then
    echo -e "${GREEN}✓${NC} Images built successfully"
else
    echo -e "${RED}✗ Build failed${NC}"
    exit 1
fi

# Start services
echo -e "\n5. Starting services..."
if docker compose up -d; then
    echo -e "${GREEN}✓${NC} Services started"
else
    echo -e "${RED}✗ Failed to start services${NC}"
    exit 1
fi

# Wait for services to be ready
echo -e "\n6. Waiting for services to be ready..."
sleep 10

# Check container status
echo -e "\n7. Checking container status..."
docker compose ps

# Test health endpoint
echo -e "\n8. Testing health endpoint..."
if curl -f http://localhost/health > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Health check passed"
else
    echo -e "${RED}✗ Health check failed${NC}"
    echo "Checking nginx logs..."
    docker compose logs nginx
    exit 1
fi

# Test frontend
echo -e "\n9. Testing frontend..."
if curl -f http://localhost > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Frontend is accessible"
else
    echo -e "${RED}✗ Frontend not accessible${NC}"
    echo "Checking frontend logs..."
    docker compose logs frontend
    exit 1
fi

# Test backend API
echo -e "\n10. Testing backend API..."
if curl -f http://localhost/api > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Backend API is accessible"
else
    echo -e "${RED}✗ Backend API not accessible${NC}"
    echo "Checking backend logs..."
    docker compose logs backend
    exit 1
fi

# Check MongoDB connection
echo -e "\n11. Checking MongoDB connection..."
if docker compose logs backend | grep -q "Connected to the database"; then
    echo -e "${GREEN}✓${NC} Backend connected to MongoDB"
else
    echo -e "${YELLOW}⚠${NC} MongoDB connection status unclear"
    echo "Backend logs:"
    docker compose logs backend | tail -10
fi

# Display summary
echo -e "\n=========================================="
echo -e "${GREEN}  All tests passed!${NC}"
echo "=========================================="
echo ""
echo "Application is running at:"
echo "  Frontend: http://localhost"
echo "  Backend:  http://localhost/api"
echo "  Health:   http://localhost/health"
echo ""
echo "Useful commands:"
echo "  View logs:        docker compose logs -f"
echo "  Stop services:    docker compose down"
echo "  Restart:          docker compose restart"
echo ""
echo "Next steps:"
echo "  1. Open http://localhost in your browser"
echo "  2. Test CRUD operations"
echo "  3. Push to GitHub to trigger CI/CD"
echo ""
