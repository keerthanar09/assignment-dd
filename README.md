# MEAN Stack Application - DevOps Assignment

A full-stack MEAN (MongoDB, Express, Angular, Node.js) application with complete CI/CD pipeline and Docker containerization.

## Table of Contents
- [Architecture Overview](#architecture-overview)
- [Prerequisites](#prerequisites)
- [Local Development](#local-development)
- [CI/CD Pipeline](#cicd-pipeline)
- [Deployment on Azure VM](#deployment-on-azure-vm)
- [Docker Hub Integration](#docker-hub-integration)
- [Nginx Reverse Proxy](#nginx-reverse-proxy)
- [Required Screenshots](#required-screenshots)
- [Troubleshooting](#troubleshooting)

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Azure VM (Ubuntu 22.04)              │
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │              Nginx Reverse Proxy                 │  │
│  │                  (Port 80)                       │  │
│  └────────┬─────────────────────────┬────────────────┘  │
│           │                         │                   │
│           │ /                       │ /api              │
│           ▼                         ▼                   │
│  ┌─────────────────┐      ┌─────────────────┐          │
│  │    Frontend     │      │     Backend     │          │
│  │  (Angular +     │      │  (Node.js +     │          │
│  │    Nginx)       │      │    Express)     │          │
│  │   Port 80       │      │   Port 8080     │          │
│  └─────────────────┘      └────────┬────────┘          │
│                                    │                   │
│                                    ▼                   │
│                          ┌─────────────────┐           │
│                          │    MongoDB      │           │
│                          │   Port 27017    │           │
│                          │  (with volume)  │           │
│                          └─────────────────┘           │
│                                                         │
│              Docker Network: mean-network               │
└─────────────────────────────────────────────────────────┘
```

## Prerequisites

### Local Development
- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- Docker Compose v2.0+
- Git

### Azure VM
- Ubuntu 22.04 LTS
- Docker and Docker Compose installed
- Ports 22 (SSH) and 80 (HTTP) open

### GitHub Repository
- GitHub account with repository
- Docker Hub account
- GitHub Secrets configured:
  - `DOCKER_USERNAME` - Your Docker Hub username
  - `DOCKER_PASSWORD` - Your Docker Hub access token

## Local Development

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd <repo-name>
```

### 2. Configure Environment Variables

```bash
# Copy the example environment file
cp .env.example .env

# Edit .env and replace with your Docker Hub username
# DOCKER_USERNAME=your-dockerhub-username
```

### 3. Build and Run Locally

```bash
# Build and start all services
docker compose up -d --build

# View logs
docker compose logs -f

# Check service status
docker compose ps
```

### 4. Access the Application

- Frontend: http://localhost
- Backend API: http://localhost/api
- MongoDB: localhost:27017

### 5. Stop Services

```bash
# Stop all services
docker compose down

# Stop and remove volumes (clears database)
docker compose down -v
```

## CI/CD Pipeline

### GitHub Actions Workflow

The CI/CD pipeline is defined in `.github/workflows/ci-cd.yml` and automatically:

1. **Triggers** on every push to the `main` branch
2. **Validates** GitHub Secrets (DOCKER_USERNAME, DOCKER_PASSWORD)
3. **Builds** Docker images for backend and frontend
4. **Tags** images with `latest` and commit SHA
5. **Pushes** images to Docker Hub
6. **Caches** layers for faster subsequent builds

### Workflow Steps

```yaml
Checkout Code → Verify Secrets → Setup Docker Buildx → 
Login to Docker Hub → Build Backend → Push Backend → 
Build Frontend → Push Frontend → Success
```

### Why GitHub Actions?

- **Native Integration**: Built into GitHub, no external CI/CD tool needed
- **Free for Public Repos**: Generous free tier for private repos
- **Docker Support**: Excellent Docker and container registry support
- **Secrets Management**: Secure credential storage
- **Simple Configuration**: YAML-based, easy to understand and maintain

### Viewing Pipeline Status

1. Go to your GitHub repository
2. Click on the "Actions" tab
3. View workflow runs and logs
4. Check for successful builds and pushes

## Docker Hub Integration

### Image Naming Convention

Images are pushed to Docker Hub with the following naming:

```
<DOCKER_USERNAME>/mean-backend:latest
<DOCKER_USERNAME>/mean-backend:main-<commit-sha>

<DOCKER_USERNAME>/mean-frontend:latest
<DOCKER_USERNAME>/mean-frontend:main-<commit-sha>
```

### Why Docker Hub?

- **Public Registry**: Free for public images
- **Reliable**: Industry-standard container registry
- **Fast Pulls**: Optimized for quick image downloads
- **Version Control**: Multiple tags for different versions
- **CI/CD Integration**: Easy integration with GitHub Actions

### Manual Push (Optional)

```bash
# Set your Docker Hub username
export DOCKER_USERNAME=your-dockerhub-username

# Build images
docker compose build

# Tag images
docker tag crud-dd-task-mean-app-backend:latest $DOCKER_USERNAME/mean-backend:latest
docker tag crud-dd-task-mean-app-frontend:latest $DOCKER_USERNAME/mean-frontend:latest

# Login to Docker Hub
docker login

# Push images
docker push $DOCKER_USERNAME/mean-backend:latest
docker push $DOCKER_USERNAME/mean-frontend:latest
```

## Deployment on Azure VM

### Initial VM Setup

```bash
# SSH into your Azure VM
ssh azureuser@<your-vm-ip>

# Verify Docker is installed
docker --version
docker compose version

# Create application directory
mkdir -p ~/mean-app
cd ~/mean-app
```

### Deploy Application

#### Option 1: Clone Repository (Recommended)

```bash
# Clone the repository
git clone <your-repo-url> .

# Create .env file with your Docker Hub username
echo "DOCKER_USERNAME=your-dockerhub-username" > .env

# Pull latest images from Docker Hub
docker compose pull

# Start services
docker compose up -d

# View logs
docker compose logs -f
```

#### Option 2: Manual Deployment (Without Git)

```bash
# Create docker-compose.yml and nginx/nginx.conf manually
# Or copy from local machine using scp

# Set environment variable
export DOCKER_USERNAME=your-dockerhub-username

# Pull and start
docker compose pull
docker compose up -d
```

### Verify Deployment

```bash
# Check running containers
docker compose ps

# Check logs
docker compose logs backend
docker compose logs frontend
docker compose logs nginx

# Test the application
curl http://localhost
curl http://localhost/api
```

### Update Deployment

```bash
# Pull latest images
docker compose pull

# Restart services with new images
docker compose up -d

# Remove old images (optional)
docker image prune -f
```

## Nginx Reverse Proxy

### Architecture Decision

A dedicated Nginx reverse proxy container sits in front of the application for several reasons:

#### Why Separate Reverse Proxy?

1. **Single Entry Point**: All traffic enters through port 80
2. **Routing Logic**: Centralized routing configuration
3. **Security**: Backend and frontend not directly exposed
4. **Scalability**: Easy to add load balancing or SSL termination
5. **Separation of Concerns**: Frontend Nginx serves static files, reverse proxy handles routing

### Routing Configuration

```nginx
/ → frontend:80 (Angular SPA)
/api → backend:8080 (Express API)
/health → Health check endpoint
```

### Configuration File

Located at `nginx/nginx.conf`:

- **Upstream Definitions**: Define backend and frontend services
- **Proxy Headers**: Forward client information (IP, protocol)
- **Health Checks**: Simple endpoint for monitoring
- **HTTP/1.1**: WebSocket support if needed

### Why This Approach?

- **Production-Ready**: Standard pattern for microservices
- **Flexible**: Easy to add new services or routes
- **Maintainable**: Clear separation between routing and application logic
- **Portable**: Same configuration works locally and in production

## Required Screenshots

For your DevOps assignment submission, capture the following screenshots:

### 1. GitHub Actions Pipeline
- [ ] Screenshot of successful workflow run in GitHub Actions tab
- [ ] Screenshot showing all steps completed successfully
- [ ] Screenshot of workflow logs showing image push to Docker Hub

### 2. Docker Hub
- [ ] Screenshot of Docker Hub repository showing `mean-backend` image
- [ ] Screenshot of Docker Hub repository showing `mean-frontend` image
- [ ] Screenshot showing image tags (latest and commit SHA)

### 3. Azure VM Deployment
- [ ] Screenshot of `docker compose ps` showing all containers running
- [ ] Screenshot of `docker compose logs` showing successful startup
- [ ] Screenshot of application running in browser (http://VM-IP)

### 4. Application Functionality
- [ ] Screenshot of frontend homepage
- [ ] Screenshot of API response (http://VM-IP/api)
- [ ] Screenshot showing CRUD operations working

### 5. Configuration Files
- [ ] Screenshot of `.github/workflows/ci-cd.yml`
- [ ] Screenshot of `docker-compose.yml`
- [ ] Screenshot of `nginx/nginx.conf`

### 6. GitHub Repository
- [ ] Screenshot of repository structure
- [ ] Screenshot of GitHub Secrets configuration page (blur sensitive values)

## Troubleshooting

### GitHub Actions Fails

**Problem**: Workflow fails with authentication error

**Solution**:
```bash
# Verify secrets are set in GitHub
# Go to: Settings → Secrets and variables → Actions
# Ensure DOCKER_USERNAME and DOCKER_PASSWORD are set
```

### Images Not Pulling on VM

**Problem**: `docker compose pull` fails

**Solution**:
```bash
# Ensure .env file has correct username
cat .env

# Or set environment variable
export DOCKER_USERNAME=your-dockerhub-username

# Try pulling manually
docker pull $DOCKER_USERNAME/mean-backend:latest
docker pull $DOCKER_USERNAME/mean-frontend:latest
```

### Backend Cannot Connect to MongoDB

**Problem**: Backend logs show "Cannot connect to database"

**Solution**:
```bash
# Check MongoDB is running
docker compose ps mongodb

# Check MongoDB logs
docker compose logs mongodb

# Restart services
docker compose restart backend
```

### Port 80 Already in Use

**Problem**: Cannot bind to port 80

**Solution**:
```bash
# Check what's using port 80
sudo lsof -i :80

# Stop conflicting service
sudo systemctl stop apache2  # or nginx

# Or change port in docker-compose.yml
ports:
  - "8080:80"  # Access via port 8080
```

### Frontend Shows 502 Bad Gateway

**Problem**: Nginx cannot reach backend/frontend

**Solution**:
```bash
# Check all services are running
docker compose ps

# Check network connectivity
docker compose exec nginx ping backend
docker compose exec nginx ping frontend

# Restart nginx
docker compose restart nginx
```

## DevOps Best Practices Implemented

### 1. Infrastructure as Code
- All infrastructure defined in `docker-compose.yml`
- Reproducible across environments
- Version controlled

### 2. CI/CD Automation
- Automated builds on every commit
- Automated testing and deployment
- Fast feedback loop

### 3. Container Orchestration
- Multi-container application
- Service dependencies managed
- Health checks for reliability

### 4. Security
- No hardcoded credentials
- Secrets managed via GitHub Secrets
- Minimal container images (Alpine Linux)

### 5. Monitoring
- Health check endpoints
- Container health checks
- Centralized logging via Docker

### 6. Scalability
- Microservices architecture
- Stateless application containers
- Persistent data in volumes

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── ci-cd.yml           # GitHub Actions CI/CD pipeline
├── backend/
│   ├── app/
│   ├── Dockerfile              # Backend container definition
│   ├── package.json
│   └── server.js
├── frontend/
│   ├── src/
│   ├── Dockerfile              # Frontend multi-stage build
│   ├── nginx.conf              # Frontend Nginx config
│   ├── package.json
│   └── angular.json
├── nginx/
│   └── nginx.conf              # Reverse proxy configuration
├── docker-compose.yml          # Multi-container orchestration
├── .env.example                # Environment variables template
├── .dockerignore               # Docker build exclusions
├── DOCKER.md                   # Docker documentation
└── README.md                   # This file
```

## Technology Stack

- **Frontend**: Angular 15, Bootstrap 4, Nginx
- **Backend**: Node.js 18, Express.js, Mongoose
- **Database**: MongoDB 6
- **Containerization**: Docker, Docker Compose
- **CI/CD**: GitHub Actions
- **Registry**: Docker Hub
- **Reverse Proxy**: Nginx
- **Cloud**: Azure VM (Ubuntu 22.04)

## License

This project is for educational purposes as part of a DevOps assignment.

## Support

For issues or questions:
1. Check the [Troubleshooting](#troubleshooting) section
2. Review Docker and container logs
3. Verify all prerequisites are met
4. Check GitHub Actions workflow logs
