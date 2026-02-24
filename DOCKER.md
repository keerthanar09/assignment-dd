# Docker Deployment Guide

## Overview

This MEAN stack application has been fully containerized with Docker. The setup includes three services:
- MongoDB (database)
- Backend (Node.js + Express API)
- Frontend (Angular + Nginx)

## Quick Start

```bash
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Stop and remove volumes (clears database)
docker-compose down -v
```

## Architecture

### Container Communication

- All services run on the `mean-network` Docker bridge network
- Services communicate using Docker service names (not localhost):
  - Backend connects to MongoDB at `mongodb://mongodb:27017/dd_db`
  - Frontend proxies API requests to `http://backend:8080`

### Port Mapping

- **Port 80**: Frontend (Nginx) - Main application entry point
- **Port 8080**: Backend API (exposed for direct access if needed)
- **Port 27017**: MongoDB (exposed for database tools/debugging)

### Data Persistence

- MongoDB data is persisted in the `mongodb_data` Docker volume
- Data survives container restarts
- Use `docker-compose down -v` to clear all data

## Service Details

### MongoDB
- Image: `mongo:6`
- Database: `dd_db`
- No authentication configured (add for production)

### Backend
- Built from `backend/Dockerfile`
- Node.js 18 Alpine (lightweight)
- Runs on port 8080
- Environment variables:
  - `PORT`: Server port (default: 8080)
  - `MONGODB_URI`: MongoDB connection string

### Frontend
- Multi-stage build from `frontend/Dockerfile`
- Stage 1: Builds Angular app with Node.js 18
- Stage 2: Serves with Nginx Alpine
- Nginx proxies `/api/*` requests to backend
- Serves Angular SPA on port 80

## Code Modifications

Two files were modified for Docker compatibility:

1. **backend/app/config/db.config.js**
   - Added environment variable support for MongoDB URI
   - Falls back to localhost for local development

2. **frontend/src/app/services/tutorial.service.ts**
   - Changed API URL from `http://localhost:8080/api/tutorials` to `/api/tutorials`
   - Allows Nginx to proxy requests to backend container

## Production Considerations

For production deployment, consider:

1. **Security**
   - Add MongoDB authentication (MONGO_INITDB_ROOT_USERNAME/PASSWORD)
   - Use secrets management for credentials
   - Enable HTTPS/TLS
   - Restrict exposed ports

2. **Performance**
   - Use production-grade MongoDB replica sets
   - Configure Nginx caching
   - Add health checks to docker-compose.yml

3. **Monitoring**
   - Add logging drivers
   - Implement health check endpoints
   - Use container orchestration (Kubernetes, Docker Swarm)

## Troubleshooting

```bash
# Check service status
docker-compose ps

# View specific service logs
docker-compose logs backend
docker-compose logs frontend
docker-compose logs mongodb

# Restart a specific service
docker-compose restart backend

# Rebuild after code changes
docker-compose up -d --build

# Access MongoDB shell
docker exec -it mean-mongodb mongosh dd_db
```

## Development Workflow

```bash
# Start services
docker-compose up -d

# Make code changes...

# Rebuild and restart affected service
docker-compose up -d --build backend

# View logs
docker-compose logs -f backend
```
