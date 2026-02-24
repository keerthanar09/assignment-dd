# Azure VM Deployment Guide

This guide provides step-by-step instructions for deploying the MEAN stack application on an Azure Ubuntu 22.04 VM.

## Prerequisites Checklist

- [ ] Azure VM running Ubuntu 22.04
- [ ] Docker installed on VM
- [ ] Docker Compose installed on VM
- [ ] Ports 22 (SSH) and 80 (HTTP) open in Azure Network Security Group
- [ ] GitHub repository with code pushed
- [ ] Docker Hub images built and pushed (via GitHub Actions)
- [ ] Your Docker Hub username

## Step 1: Verify VM Setup

```bash
# SSH into your Azure VM
ssh azureuser@<your-vm-public-ip>

# Verify Docker installation
docker --version
# Expected: Docker version 20.10.x or higher

# Verify Docker Compose installation
docker compose version
# Expected: Docker Compose version v2.x.x or higher

# Check if ports are accessible
sudo netstat -tulpn | grep :80
# Should be empty or show no conflicting service
```

## Step 2: Install Docker (If Not Installed)

```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to docker group (to run without sudo)
sudo usermod -aG docker $USER

# Log out and back in for group changes to take effect
exit
# SSH back in
ssh azureuser@<your-vm-public-ip>

# Verify installation
docker run hello-world
```

## Step 3: Deploy Application

### Method 1: Using Git (Recommended)

```bash
# Create application directory
mkdir -p ~/mean-app
cd ~/mean-app

# Clone your repository
git clone https://github.com/<your-username>/<your-repo>.git .

# Create .env file with your Docker Hub username
cat > .env << EOF
DOCKER_USERNAME=your-dockerhub-username
EOF

# Pull latest images from Docker Hub
docker compose pull

# Start all services
docker compose up -d

# View logs to verify startup
docker compose logs -f
```

### Method 2: Manual Deployment (Without Git)

```bash
# Create application directory
mkdir -p ~/mean-app
cd ~/mean-app

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
services:
  mongodb:
    image: mongo:6
    container_name: mean-mongodb
    restart: unless-stopped
    environment:
      MONGO_INITDB_DATABASE: dd_db
    volumes:
      - mongodb_data:/data/db
    networks:
      - mean-network
    healthcheck:
      test: echo 'db.runCommand("ping").ok' | mongosh localhost:27017/dd_db --quiet
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    image: ${DOCKER_USERNAME}/mean-backend:latest
    container_name: mean-backend
    restart: unless-stopped
    environment:
      - PORT=8080
      - MONGODB_URI=mongodb://mongodb:27017/dd_db
    depends_on:
      mongodb:
        condition: service_healthy
    networks:
      - mean-network
    healthcheck:
      test: ["CMD", "node", "-e", "require('http').get('http://localhost:8080', (r) => process.exit(r.statusCode === 200 ? 0 : 1))"]
      interval: 10s
      timeout: 5s
      retries: 5

  frontend:
    image: ${DOCKER_USERNAME}/mean-frontend:latest
    container_name: mean-frontend
    restart: unless-stopped
    depends_on:
      - backend
    networks:
      - mean-network

  nginx:
    image: nginx:alpine
    container_name: mean-nginx
    restart: unless-stopped
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - frontend
      - backend
    networks:
      - mean-network
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost/health"]
      interval: 10s
      timeout: 5s
      retries: 3

networks:
  mean-network:
    driver: bridge

volumes:
  mongodb_data:
    driver: local
EOF

# Create nginx directory and configuration
mkdir -p nginx
cat > nginx/nginx.conf << 'EOF'
upstream frontend {
    server frontend:80;
}

upstream backend {
    server backend:8080;
}

server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://frontend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /api {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
EOF

# Set your Docker Hub username
export DOCKER_USERNAME=your-dockerhub-username

# Pull and start services
docker compose pull
docker compose up -d
```

## Step 4: Verify Deployment

```bash
# Check all containers are running
docker compose ps

# Expected output:
# NAME            IMAGE                              STATUS
# mean-mongodb    mongo:6                            Up (healthy)
# mean-backend    username/mean-backend:latest       Up (healthy)
# mean-frontend   username/mean-frontend:latest      Up
# mean-nginx      nginx:alpine                       Up (healthy)

# Check logs
docker compose logs backend
docker compose logs frontend
docker compose logs nginx

# Test health endpoint
curl http://localhost/health
# Expected: healthy

# Test backend API
curl http://localhost/api
# Expected: JSON response

# Test frontend
curl http://localhost
# Expected: HTML content
```

## Step 5: Access Application

1. Open your web browser
2. Navigate to: `http://<your-vm-public-ip>`
3. You should see the Angular application

## Step 6: Update Deployment

When new images are pushed to Docker Hub:

```bash
cd ~/mean-app

# Pull latest images
docker compose pull

# Recreate containers with new images
docker compose up -d

# View logs
docker compose logs -f

# Clean up old images (optional)
docker image prune -f
```

## Useful Commands

### View Logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f nginx
docker compose logs -f mongodb

# Last 100 lines
docker compose logs --tail=100
```

### Restart Services
```bash
# Restart all services
docker compose restart

# Restart specific service
docker compose restart backend
docker compose restart nginx
```

### Stop Services
```bash
# Stop all services
docker compose stop

# Stop specific service
docker compose stop backend
```

### Remove Everything
```bash
# Stop and remove containers
docker compose down

# Stop, remove containers, and delete volumes (WARNING: deletes database)
docker compose down -v
```

### Check Resource Usage
```bash
# Container stats
docker stats

# Disk usage
docker system df

# Clean up unused resources
docker system prune -a
```

## Troubleshooting

### Issue: Containers Not Starting

```bash
# Check container status
docker compose ps

# Check logs for errors
docker compose logs

# Restart problematic service
docker compose restart <service-name>
```

### Issue: Cannot Access Application

```bash
# Check if nginx is running
docker compose ps nginx

# Check nginx logs
docker compose logs nginx

# Verify port 80 is accessible
curl http://localhost

# Check Azure NSG rules
# Ensure port 80 is open in Azure Portal
```

### Issue: Backend Cannot Connect to MongoDB

```bash
# Check MongoDB is running
docker compose ps mongodb

# Check MongoDB logs
docker compose logs mongodb

# Verify network connectivity
docker compose exec backend ping mongodb

# Restart backend
docker compose restart backend
```

### Issue: Images Not Pulling

```bash
# Verify Docker Hub username is set
echo $DOCKER_USERNAME

# Try pulling manually
docker pull $DOCKER_USERNAME/mean-backend:latest
docker pull $DOCKER_USERNAME/mean-frontend:latest

# Check if images exist on Docker Hub
# Visit: https://hub.docker.com/r/<username>/mean-backend
```

### Issue: Port 80 Already in Use

```bash
# Check what's using port 80
sudo lsof -i :80

# If Apache is running
sudo systemctl stop apache2
sudo systemctl disable apache2

# If another Nginx is running
sudo systemctl stop nginx
sudo systemctl disable nginx

# Then restart your containers
docker compose up -d
```

## Security Considerations

### Firewall Configuration
```bash
# Check UFW status
sudo ufw status

# Allow SSH (if not already allowed)
sudo ufw allow 22/tcp

# Allow HTTP
sudo ufw allow 80/tcp

# Enable firewall
sudo ufw enable
```

### Docker Security
```bash
# Run Docker daemon in rootless mode (optional, advanced)
# See: https://docs.docker.com/engine/security/rootless/

# Limit container resources (add to docker-compose.yml)
# deploy:
#   resources:
#     limits:
#       cpus: '0.5'
#       memory: 512M
```

## Monitoring

### Basic Monitoring
```bash
# Watch container stats
watch docker stats

# Check container health
docker compose ps

# Monitor logs in real-time
docker compose logs -f
```

### Set Up Log Rotation
```bash
# Create Docker daemon config
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

# Restart Docker
sudo systemctl restart docker

# Restart your containers
cd ~/mean-app
docker compose down
docker compose up -d
```

## Backup and Restore

### Backup MongoDB Data
```bash
# Create backup directory
mkdir -p ~/backups

# Backup MongoDB
docker compose exec mongodb mongodump --out=/data/backup
docker cp mean-mongodb:/data/backup ~/backups/mongodb-$(date +%Y%m%d)

# Or backup the volume
docker run --rm -v crud-dd-task-mean-app_mongodb_data:/data -v ~/backups:/backup ubuntu tar czf /backup/mongodb-$(date +%Y%m%d).tar.gz /data
```

### Restore MongoDB Data
```bash
# Restore from backup
docker cp ~/backups/mongodb-20240224 mean-mongodb:/data/restore
docker compose exec mongodb mongorestore /data/restore
```

## Performance Optimization

### Enable Docker BuildKit
```bash
# Add to ~/.bashrc or ~/.profile
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
```

### Prune Regularly
```bash
# Create a cron job for weekly cleanup
crontab -e

# Add this line (runs every Sunday at 2 AM)
0 2 * * 0 docker system prune -af --volumes
```

## Next Steps

1. Set up automated deployments (webhook or GitHub Actions with SSH)
2. Configure HTTPS with Let's Encrypt
3. Set up monitoring with Prometheus/Grafana
4. Implement automated backups
5. Configure log aggregation
6. Set up alerts for container failures

## Support

If you encounter issues:
1. Check the logs: `docker compose logs`
2. Verify all prerequisites are met
3. Ensure GitHub Actions successfully pushed images
4. Check Azure NSG rules for port 80
5. Review this troubleshooting guide
