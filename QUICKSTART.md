# Quick Start Guide

Get your MEAN stack application running in 5 minutes!

## Prerequisites

- Docker and Docker Compose installed
- Docker Hub account
- GitHub account

## Local Development (5 minutes)

### 1. Clone and Configure (1 minute)

```bash
# Clone repository
git clone <your-repo-url>
cd <repo-name>

# Create .env file
cp .env.example .env

# Edit .env and set your Docker Hub username
# DOCKER_USERNAME=your-dockerhub-username
```

### 2. Build and Run (3 minutes)

```bash
# Build and start all services
docker compose up -d --build

# Wait for services to start (about 30 seconds)
# Watch logs
docker compose logs -f
```

### 3. Test (1 minute)

```bash
# Check all containers are running
docker compose ps

# Test in browser
# Open: http://localhost
```

**Done!** Your application is running locally.

## GitHub Actions Setup (5 minutes)

### 1. Create Docker Hub Access Token (2 minutes)

1. Go to https://hub.docker.com
2. Click on your profile → Account Settings
3. Security → New Access Token
4. Name: "GitHub Actions"
5. Permissions: Read, Write, Delete
6. Copy the token (you won't see it again!)

### 2. Configure GitHub Secrets (2 minutes)

1. Go to your GitHub repository
2. Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add two secrets:
   - Name: `DOCKER_USERNAME`, Value: your Docker Hub username
   - Name: `DOCKER_PASSWORD`, Value: your Docker Hub access token

### 3. Trigger Pipeline (1 minute)

```bash
# Make any change and push
git add .
git commit -m "Trigger CI/CD pipeline"
git push origin main

# Watch the pipeline
# Go to: Repository → Actions tab
```

**Done!** Your images are building and pushing to Docker Hub.

## Azure VM Deployment (10 minutes)

### 1. Prepare VM (5 minutes)

```bash
# SSH to your VM
ssh azureuser@<your-vm-ip>

# Install Docker (if not installed)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose (if not installed)
sudo apt-get update
sudo apt-get install -y docker-compose-plugin

# Log out and back in
exit
ssh azureuser@<your-vm-ip>

# Verify
docker --version
docker compose version
```

### 2. Deploy Application (3 minutes)

```bash
# Create app directory
mkdir -p ~/mean-app
cd ~/mean-app

# Clone repository
git clone <your-repo-url> .

# Create .env file
echo "DOCKER_USERNAME=your-dockerhub-username" > .env

# Pull and start
docker compose pull
docker compose up -d
```

### 3. Verify (2 minutes)

```bash
# Check containers
docker compose ps

# Check logs
docker compose logs -f

# Test locally
curl http://localhost
curl http://localhost/api
curl http://localhost/health
```

**Done!** Open `http://<your-vm-ip>` in your browser.

## Common Commands

### Local Development

```bash
# Start services
docker compose up -d

# View logs
docker compose logs -f

# Stop services
docker compose down

# Rebuild after code changes
docker compose up -d --build

# Clean everything
docker compose down -v
```

### VM Deployment

```bash
# Update to latest images
docker compose pull
docker compose up -d

# View logs
docker compose logs -f

# Restart a service
docker compose restart backend

# Check status
docker compose ps
```

## Troubleshooting

### Issue: Containers not starting

```bash
# Check logs
docker compose logs

# Restart
docker compose restart
```

### Issue: Port 80 in use

```bash
# Check what's using port 80
sudo lsof -i :80

# Stop conflicting service
sudo systemctl stop apache2
```

### Issue: Cannot pull images

```bash
# Verify .env file
cat .env

# Set environment variable
export DOCKER_USERNAME=your-dockerhub-username

# Try manual pull
docker pull $DOCKER_USERNAME/mean-backend:latest
```

## Testing Checklist

- [ ] Local: http://localhost works
- [ ] Local: http://localhost/api works
- [ ] Local: http://localhost/health returns "healthy"
- [ ] GitHub Actions: Workflow runs successfully
- [ ] Docker Hub: Images are visible
- [ ] VM: All containers running
- [ ] VM: http://VM-IP works in browser
- [ ] CRUD operations work

## Next Steps

1. ✅ Application running locally
2. ✅ CI/CD pipeline working
3. ✅ Deployed to Azure VM
4. 📸 Take screenshots for submission
5. 📝 Review README.md
6. 🎓 Submit assignment

## Need Help?

- Check [README.md](README.md) for detailed documentation
- Check [DEPLOYMENT.md](DEPLOYMENT.md) for deployment guide
- Check [ASSIGNMENT_CHECKLIST.md](ASSIGNMENT_CHECKLIST.md) for submission requirements
- Review logs: `docker compose logs`

## Time Estimates

- Local setup: 5 minutes
- GitHub Actions: 5 minutes
- VM deployment: 10 minutes
- Testing: 5 minutes
- Screenshots: 10 minutes

**Total: ~35 minutes**

Good luck! 🚀
