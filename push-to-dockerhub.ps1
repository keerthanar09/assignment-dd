# PowerShell script to push images to Docker Hub
# Make sure you're logged in first: docker login

$DOCKER_USERNAME = "keerthanaxd"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Pushing Images to Docker Hub" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host "`nDocker Hub username: $DOCKER_USERNAME"

# Check if images exist
Write-Host "`nChecking if images exist..."
$backendImage = docker images -q "$DOCKER_USERNAME/mean-backend:latest"
$frontendImage = docker images -q "$DOCKER_USERNAME/mean-frontend:latest"

if (-not $backendImage) {
    Write-Host "Error: Backend image not found" -ForegroundColor Red
    Write-Host "Please build the images first: docker compose build"
    exit 1
}

if (-not $frontendImage) {
    Write-Host "Error: Frontend image not found" -ForegroundColor Red
    Write-Host "Please build the images first: docker compose build"
    exit 1
}

Write-Host "✓ Images found" -ForegroundColor Green

# Push backend image
Write-Host "`nPushing backend image..." -ForegroundColor Cyan
docker push "$DOCKER_USERNAME/mean-backend:latest"
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Backend image pushed" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to push backend image" -ForegroundColor Red
    Write-Host "Make sure you're logged in: docker login --username $DOCKER_USERNAME"
    exit 1
}

# Push frontend image
Write-Host "`nPushing frontend image..." -ForegroundColor Cyan
docker push "$DOCKER_USERNAME/mean-frontend:latest"
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Frontend image pushed" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to push frontend image" -ForegroundColor Red
    exit 1
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "  Images successfully pushed!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Images available at:"
Write-Host "  https://hub.docker.com/r/$DOCKER_USERNAME/mean-backend"
Write-Host "  https://hub.docker.com/r/$DOCKER_USERNAME/mean-frontend"
Write-Host ""
