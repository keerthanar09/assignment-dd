# Quick Reference Card

## Essential Commands

### Local Development
```bash
# Start
docker compose up -d

# Stop
docker compose down

# Rebuild
docker compose up -d --build

# Logs
docker compose logs -f

# Status
docker compose ps
```

### VM Deployment
```bash
# Deploy
docker compose pull && docker compose up -d

# Update
docker compose pull && docker compose up -d

# Status
docker compose ps

# Logs
docker compose logs -f
```

## URLs

### Local
- Frontend: http://localhost
- Backend: http://localhost/api
- Health: http://localhost/health

### VM
- Frontend: http://VM-IP
- Backend: http://VM-IP/api
- Health: http://VM-IP/health

## GitHub Secrets

Required in: Settings → Secrets and variables → Actions

1. `DOCKER_USERNAME` - Your Docker Hub username
2. `DOCKER_PASSWORD` - Your Docker Hub access token

## Docker Hub Images

- `${DOCKER_USERNAME}/mean-backend:latest`
- `${DOCKER_USERNAME}/mean-frontend:latest`

## Container Names

- `mean-mongodb` - MongoDB database
- `mean-backend` - Node.js API
- `mean-frontend` - Angular app
- `mean-nginx` - Reverse proxy

## Ports

- 80 - Nginx (public)
- 8080 - Backend (internal)
- 27017 - MongoDB (internal)

## Files to Configure

1. `.env` - Set DOCKER_USERNAME
2. GitHub Secrets - Set DOCKER_USERNAME and DOCKER_PASSWORD

## Troubleshooting

### Containers not starting
```bash
docker compose logs
docker compose restart
```

### Port 80 in use
```bash
sudo lsof -i :80
sudo systemctl stop apache2
```

### Cannot pull images
```bash
export DOCKER_USERNAME=your-username
docker compose pull
```

### Backend can't connect to MongoDB
```bash
docker compose restart backend
docker compose logs mongodb
```

## Documentation

- `README.md` - Main documentation
- `QUICKSTART.md` - 5-minute guide
- `DEPLOYMENT.md` - VM deployment
- `ASSIGNMENT_CHECKLIST.md` - Submission guide
- `DEVOPS_DECISIONS.md` - Technical rationale

## Testing

```bash
# Health check
curl http://localhost/health

# Frontend
curl http://localhost

# Backend
curl http://localhost/api
```

## Workflow

1. Code → Push to GitHub
2. GitHub Actions → Build images
3. Images → Push to Docker Hub
4. VM → Pull and deploy

## Time Estimates

- Local setup: 5 min
- GitHub Actions: 5 min
- VM deployment: 10 min
- Testing: 5 min
- Screenshots: 10 min

Total: ~35 minutes
