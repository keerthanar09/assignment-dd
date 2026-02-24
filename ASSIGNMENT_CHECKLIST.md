# DevOps Assignment Submission Checklist

## Pre-Submission Checklist

### 1. GitHub Repository Setup
- [ ] Repository is public or accessible to evaluator
- [ ] All code is pushed to `main` branch
- [ ] `.github/workflows/ci-cd.yml` exists
- [ ] `docker-compose.yml` exists
- [ ] `nginx/nginx.conf` exists
- [ ] `README.md` is complete
- [ ] `.env.example` is included (no actual credentials)

### 2. GitHub Secrets Configuration
- [ ] Navigate to: Repository → Settings → Secrets and variables → Actions
- [ ] `DOCKER_USERNAME` secret is set
- [ ] `DOCKER_PASSWORD` secret is set (Docker Hub access token)
- [ ] Screenshot taken of secrets page (with values blurred)

### 3. Docker Hub Setup
- [ ] Docker Hub account created
- [ ] Access token generated (Settings → Security → New Access Token)
- [ ] Repositories visible:
  - [ ] `<username>/mean-backend`
  - [ ] `<username>/mean-frontend`
- [ ] Images have `latest` tag
- [ ] Screenshots taken of both repositories

### 4. GitHub Actions Pipeline
- [ ] Push code to `main` branch to trigger workflow
- [ ] Navigate to: Repository → Actions tab
- [ ] Verify workflow runs successfully
- [ ] All steps show green checkmarks
- [ ] Screenshots taken:
  - [ ] Workflow overview
  - [ ] Successful run details
  - [ ] Build and push logs

### 5. Azure VM Deployment
- [ ] VM is running Ubuntu 22.04
- [ ] Docker and Docker Compose installed
- [ ] Application deployed using `docker compose pull && docker compose up -d`
- [ ] All containers running: `docker compose ps`
- [ ] Application accessible at `http://<VM-IP>`
- [ ] Screenshots taken:
  - [ ] `docker compose ps` output
  - [ ] `docker compose logs` output
  - [ ] Browser showing application at VM IP

### 6. Application Functionality
- [ ] Frontend loads successfully
- [ ] Backend API responds at `/api`
- [ ] CRUD operations work
- [ ] Screenshots taken:
  - [ ] Homepage
  - [ ] API response
  - [ ] CRUD operations

## Required Screenshots

### Screenshot 1: GitHub Actions - Workflow Success
**File**: `01-github-actions-success.png`
- Navigate to: Repository → Actions
- Show: Successful workflow run with green checkmark
- Include: Workflow name, branch, commit message, timestamp

### Screenshot 2: GitHub Actions - Build Logs
**File**: `02-github-actions-logs.png`
- Click on successful workflow run
- Show: All steps completed (Build backend, Build frontend, Push to Docker Hub)
- Include: Step details showing image push confirmation

### Screenshot 3: Docker Hub - Backend Repository
**File**: `03-dockerhub-backend.png`
- Navigate to: https://hub.docker.com/r/<username>/mean-backend
- Show: Repository with `latest` tag
- Include: Image size, last pushed timestamp

### Screenshot 4: Docker Hub - Frontend Repository
**File**: `04-dockerhub-frontend.png`
- Navigate to: https://hub.docker.com/r/<username>/mean-frontend
- Show: Repository with `latest` tag
- Include: Image size, last pushed timestamp

### Screenshot 5: Azure VM - Docker Compose Status
**File**: `05-vm-docker-compose-ps.png`
- Command: `docker compose ps`
- Show: All 4 containers running (mongodb, backend, frontend, nginx)
- Include: Container names, status, ports

### Screenshot 6: Azure VM - Container Logs
**File**: `06-vm-docker-logs.png`
- Command: `docker compose logs --tail=50`
- Show: Successful startup messages
- Include: "Connected to database", "Server is running"

### Screenshot 7: Application - Frontend Homepage
**File**: `07-app-frontend.png`
- Navigate to: `http://<VM-IP>`
- Show: Angular application loaded
- Include: Browser address bar with VM IP

### Screenshot 8: Application - Backend API
**File**: `08-app-backend-api.png`
- Navigate to: `http://<VM-IP>/api` or use curl
- Show: JSON response from backend
- Include: Response data

### Screenshot 9: Application - CRUD Operations
**File**: `09-app-crud-operations.png`
- Show: Creating, reading, updating, or deleting a tutorial
- Include: Form submission and data display

### Screenshot 10: GitHub Secrets Configuration
**File**: `10-github-secrets.png`
- Navigate to: Repository → Settings → Secrets and variables → Actions
- Show: DOCKER_USERNAME and DOCKER_PASSWORD listed
- **IMPORTANT**: Blur or hide actual values

### Screenshot 11: Configuration Files
**File**: `11-config-files.png`
- Show: Repository structure with key files
- Include: `.github/workflows/ci-cd.yml`, `docker-compose.yml`, `nginx/nginx.conf`

### Screenshot 12: Nginx Reverse Proxy
**File**: `12-nginx-config.png`
- Show: `nginx/nginx.conf` file content
- Include: Upstream definitions and location blocks

## Testing Commands

### Local Testing
```bash
# Build and run locally
docker compose up -d --build

# Test frontend
curl http://localhost

# Test backend
curl http://localhost/api

# Test health check
curl http://localhost/health

# Check logs
docker compose logs

# Stop
docker compose down
```

### VM Testing
```bash
# SSH to VM
ssh azureuser@<VM-IP>

# Navigate to app directory
cd ~/mean-app

# Pull latest images
docker compose pull

# Start services
docker compose up -d

# Check status
docker compose ps

# Test locally on VM
curl http://localhost
curl http://localhost/api
curl http://localhost/health

# Check logs
docker compose logs -f
```

### Browser Testing
1. Open browser
2. Navigate to `http://<VM-IP>`
3. Verify frontend loads
4. Test CRUD operations
5. Check network tab for API calls

## Common Issues and Solutions

### Issue: GitHub Actions Fails
**Solution**:
```bash
# Check secrets are set
# Go to: Settings → Secrets and variables → Actions
# Verify DOCKER_USERNAME and DOCKER_PASSWORD exist

# Check workflow file syntax
# Validate YAML at: https://www.yamllint.com/
```

### Issue: Images Not on Docker Hub
**Solution**:
```bash
# Check GitHub Actions logs
# Verify login step succeeded
# Check push step completed
# Verify Docker Hub credentials are correct
```

### Issue: VM Cannot Pull Images
**Solution**:
```bash
# Set environment variable
export DOCKER_USERNAME=your-dockerhub-username

# Or create .env file
echo "DOCKER_USERNAME=your-dockerhub-username" > .env

# Try manual pull
docker pull $DOCKER_USERNAME/mean-backend:latest
```

### Issue: Application Not Accessible
**Solution**:
```bash
# Check Azure NSG rules
# Ensure port 80 is open

# Check containers are running
docker compose ps

# Check nginx logs
docker compose logs nginx

# Test locally on VM
curl http://localhost
```

## Submission Package

### Required Files
1. GitHub repository URL
2. Docker Hub username
3. Azure VM public IP address
4. All 12 screenshots (properly named)
5. Brief report (optional, if required by instructor)

### Report Structure (if required)
```
1. Introduction
   - Project overview
   - Technologies used

2. Architecture
   - System architecture diagram
   - Component descriptions

3. Implementation
   - Docker containerization
   - CI/CD pipeline
   - Nginx reverse proxy
   - Deployment process

4. Screenshots
   - All 12 screenshots with captions

5. Challenges and Solutions
   - Issues encountered
   - How they were resolved

6. Conclusion
   - What was learned
   - Future improvements

7. References
   - Documentation used
   - Resources consulted
```

## Evaluation Criteria

### Docker Containerization (25%)
- [ ] Backend Dockerfile is production-ready
- [ ] Frontend Dockerfile uses multi-stage build
- [ ] docker-compose.yml properly configured
- [ ] Images use appropriate base images
- [ ] .dockerignore files present

### CI/CD Pipeline (25%)
- [ ] GitHub Actions workflow exists
- [ ] Workflow triggers on push to main
- [ ] Images build successfully
- [ ] Images push to Docker Hub
- [ ] Proper error handling

### Nginx Reverse Proxy (20%)
- [ ] Dedicated nginx container
- [ ] Proper routing (/ and /api)
- [ ] Configuration file well-structured
- [ ] Health check endpoint

### Deployment (20%)
- [ ] Application runs on Azure VM
- [ ] All containers running
- [ ] Application accessible via browser
- [ ] Proper use of Docker volumes

### Documentation (10%)
- [ ] README.md is comprehensive
- [ ] Clear deployment instructions
- [ ] Architecture explained
- [ ] Screenshots included

## Final Checklist Before Submission

- [ ] All code pushed to GitHub
- [ ] GitHub Actions workflow successful
- [ ] Images on Docker Hub
- [ ] Application running on Azure VM
- [ ] All 12 screenshots captured
- [ ] Screenshots properly named
- [ ] README.md complete
- [ ] No credentials hardcoded
- [ ] .env.example provided
- [ ] Repository is accessible
- [ ] VM IP address noted
- [ ] Docker Hub username noted

## Quick Test Script

Save this as `test-deployment.sh` and run on VM:

```bash
#!/bin/bash

echo "=== Testing MEAN Stack Deployment ==="

echo -e "\n1. Checking Docker..."
docker --version || { echo "Docker not installed!"; exit 1; }

echo -e "\n2. Checking Docker Compose..."
docker compose version || { echo "Docker Compose not installed!"; exit 1; }

echo -e "\n3. Checking containers..."
docker compose ps

echo -e "\n4. Testing health endpoint..."
curl -f http://localhost/health || { echo "Health check failed!"; exit 1; }

echo -e "\n5. Testing frontend..."
curl -f http://localhost > /dev/null || { echo "Frontend not accessible!"; exit 1; }

echo -e "\n6. Testing backend API..."
curl -f http://localhost/api > /dev/null || { echo "Backend API not accessible!"; exit 1; }

echo -e "\n7. Checking logs for errors..."
docker compose logs --tail=20 | grep -i error && echo "Errors found in logs!" || echo "No errors in recent logs"

echo -e "\n=== All tests passed! ==="
```

## Time Estimate

- GitHub setup: 15 minutes
- Docker Hub setup: 10 minutes
- Code implementation: 30 minutes
- GitHub Actions testing: 15 minutes
- Azure VM deployment: 20 minutes
- Testing and screenshots: 30 minutes
- Documentation review: 10 minutes

**Total**: ~2 hours

## Support Resources

- Docker Documentation: https://docs.docker.com/
- Docker Compose: https://docs.docker.com/compose/
- GitHub Actions: https://docs.github.com/en/actions
- Nginx Documentation: https://nginx.org/en/docs/
- Azure VM: https://docs.microsoft.com/en-us/azure/virtual-machines/

## Good Luck!

Remember:
- Test everything before submission
- Take clear, readable screenshots
- Document any issues you encountered
- Explain your DevOps decisions
- Keep credentials secure
