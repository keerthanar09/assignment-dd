# Commands Cheatsheet

## 🚀 Quick Start Commands

### Local Development
```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# View logs
docker compose logs -f

# Check status
docker compose ps

# Restart a service
docker compose restart backend
```

### Testing
```bash
# Health check
curl http://localhost/health

# Frontend
curl http://localhost

# Backend API
curl http://localhost/api
```

## 📦 Docker Hub Commands

### Login
```bash
docker login --username keerthanaxd
```

### Push Images
```bash
docker push keerthanaxd/mean-backend:latest
docker push keerthanaxd/mean-frontend:latest
```

### Pull Images
```bash
docker compose pull
```

## 🔄 Git Commands

### Add and Commit
```bash
git add .
git commit -m "Complete DevOps setup with CI/CD"
```

### Push to GitHub (Triggers CI/CD)
```bash
git push origin main
```

### Check Status
```bash
git status
git log --oneline -5
```

## ☁️ Azure VM Deployment

### SSH to VM
```bash
ssh azureuser@<your-vm-ip>
```

### Initial Setup
```bash
# Create directory
mkdir -p ~/mean-app
cd ~/mean-app

# Clone repository
git clone <your-repo-url> .

# Create .env file
echo "DOCKER_USERNAME=keerthanaxd" > .env
```

### Deploy Application
```bash
# Pull images from Docker Hub
docker compose pull

# Start services
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f
```

### Update Deployment
```bash
# Pull latest images
docker compose pull

# Restart with new images
docker compose up -d

# Check status
docker compose ps
```

### Troubleshooting on VM
```bash
# Check logs
docker compose logs backend
docker compose logs frontend
docker compose logs nginx

# Restart service
docker compose restart backend

# Check health locally
curl http://localhost/health
curl http://localhost
```

## 🧹 Cleanup Commands

### Stop and Remove Containers
```bash
docker compose down
```

### Remove Containers and Volumes
```bash
docker compose down -v
```

### Remove Old Images
```bash
docker image prune -f
```

### Full Cleanup
```bash
docker system prune -a --volumes
```

## 🔍 Debugging Commands

### Check Container Logs
```bash
# All services
docker compose logs

# Specific service
docker compose logs backend

# Follow logs
docker compose logs -f

# Last 50 lines
docker compose logs --tail=50
```

### Inspect Container
```bash
# Get container details
docker inspect mean-backend

# Check environment variables
docker inspect mean-backend | grep -A 10 Env
```

### Network Debugging
```bash
# List networks
docker network ls

# Inspect network
docker network inspect crud-dd-task-mean-app_mean-network

# Test connectivity
docker compose exec backend ping mongodb
docker compose exec nginx ping backend
```

### Volume Management
```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect crud-dd-task-mean-app_mongodb_data

# Backup volume
docker run --rm -v crud-dd-task-mean-app_mongodb_data:/data -v $(pwd):/backup ubuntu tar czf /backup/mongodb-backup.tar.gz /data
```

## 📊 Monitoring Commands

### Resource Usage
```bash
# Container stats
docker stats

# Disk usage
docker system df

# Detailed disk usage
docker system df -v
```

### Health Checks
```bash
# Check container health
docker compose ps

# Manual health check
curl http://localhost/health
curl http://localhost/api
```

## 🔐 Security Commands

### Check for Vulnerabilities
```bash
# Scan image
docker scan keerthanaxd/mean-backend:latest
```

### View Secrets (GitHub)
```bash
# Cannot view via CLI - use GitHub web interface
# Go to: Settings → Secrets and variables → Actions
```

## 📝 Documentation Commands

### View Documentation
```bash
# Main README
cat README.md

# Quick start
cat QUICKSTART.md

# Deployment guide
cat DEPLOYMENT.md

# Current status
cat COMPLETION_STATUS.md
```

## 🎯 Assignment Submission Commands

### Take Screenshots
```bash
# On Windows (PowerShell)
# Use Snipping Tool or Win+Shift+S

# On Linux
gnome-screenshot -a

# On Mac
# Use Cmd+Shift+4
```

### Verify Everything
```bash
# Local
docker compose ps
curl http://localhost/health

# Docker Hub
# Visit: https://hub.docker.com/r/keerthanaxd/mean-backend
# Visit: https://hub.docker.com/r/keerthanaxd/mean-frontend

# GitHub Actions
# Visit: https://github.com/<username>/<repo>/actions
```

## 🆘 Emergency Commands

### If Port 80 is Busy
```bash
# Check what's using port 80
sudo lsof -i :80

# Stop Apache (if running)
sudo systemctl stop apache2

# Stop Nginx (if running)
sudo systemctl stop nginx
```

### If Containers Won't Start
```bash
# Remove everything and start fresh
docker compose down -v
docker compose up -d

# Check logs for errors
docker compose logs
```

### If Images Won't Pull
```bash
# Check Docker Hub login
docker login --username keerthanaxd

# Try pulling manually
docker pull keerthanaxd/mean-backend:latest
docker pull keerthanaxd/mean-frontend:latest

# Check .env file
cat .env
```

## 📱 Quick Reference URLs

### Docker Hub
- Backend: https://hub.docker.com/r/keerthanaxd/mean-backend
- Frontend: https://hub.docker.com/r/keerthanaxd/mean-frontend

### GitHub (Replace with your repo)
- Repository: https://github.com/<username>/<repo>
- Actions: https://github.com/<username>/<repo>/actions
- Secrets: https://github.com/<username>/<repo>/settings/secrets/actions

### Local Application
- Frontend: http://localhost
- Backend: http://localhost/api
- Health: http://localhost/health

### VM Application (Replace with your VM IP)
- Frontend: http://<vm-ip>
- Backend: http://<vm-ip>/api
- Health: http://<vm-ip>/health
