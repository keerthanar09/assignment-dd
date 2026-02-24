# PowerShell script for Windows users

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  MEAN Stack Local Testing Script" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Check if .env file exists
if (-not (Test-Path .env)) {
    Write-Host "Warning: .env file not found" -ForegroundColor Yellow
    Write-Host "Creating .env from .env.example..."
    Copy-Item .env.example .env
    Write-Host "Please edit .env and set your DOCKER_USERNAME" -ForegroundColor Yellow
    exit 1
}

# Read .env file
Get-Content .env | ForEach-Object {
    if ($_ -match '^([^=]+)=(.*)$') {
        Set-Variable -Name $matches[1] -Value $matches[2]
    }
}

if (-not $DOCKER_USERNAME -or $DOCKER_USERNAME -eq "your-dockerhub-username") {
    Write-Host "Error: DOCKER_USERNAME not set in .env file" -ForegroundColor Red
    Write-Host "Please edit .env and set your Docker Hub username"
    exit 1
}

Write-Host "`n✓ Docker Hub username: $DOCKER_USERNAME" -ForegroundColor Green

# Check Docker is running
Write-Host "`n1. Checking Docker..." -ForegroundColor Cyan
try {
    docker info | Out-Null
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker is not running" -ForegroundColor Red
    exit 1
}

# Check Docker Compose
Write-Host "`n2. Checking Docker Compose..." -ForegroundColor Cyan
try {
    docker compose version | Out-Null
    Write-Host "✓ Docker Compose is available" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker Compose not found" -ForegroundColor Red
    exit 1
}

# Stop existing containers
Write-Host "`n3. Stopping existing containers..." -ForegroundColor Cyan
docker compose down 2>&1 | Out-Null
Write-Host "✓ Cleaned up existing containers" -ForegroundColor Green

# Build images
Write-Host "`n4. Building Docker images..." -ForegroundColor Cyan
$buildResult = docker compose build 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Images built successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Build failed" -ForegroundColor Red
    Write-Host $buildResult
    exit 1
}

# Start services
Write-Host "`n5. Starting services..." -ForegroundColor Cyan
$startResult = docker compose up -d 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Services started" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to start services" -ForegroundColor Red
    Write-Host $startResult
    exit 1
}

# Wait for services to be ready
Write-Host "`n6. Waiting for services to be ready..." -ForegroundColor Cyan
Start-Sleep -Seconds 10

# Check container status
Write-Host "`n7. Checking container status..." -ForegroundColor Cyan
docker compose ps

# Test health endpoint
Write-Host "`n8. Testing health endpoint..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost/health" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Health check passed" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Health check failed" -ForegroundColor Red
    Write-Host "Checking nginx logs..."
    docker compose logs nginx
    exit 1
}

# Test frontend
Write-Host "`n9. Testing frontend..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Frontend is accessible" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Frontend not accessible" -ForegroundColor Red
    Write-Host "Checking frontend logs..."
    docker compose logs frontend
    exit 1
}

# Test backend API
Write-Host "`n10. Testing backend API..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost/api" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Backend API is accessible" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Backend API not accessible" -ForegroundColor Red
    Write-Host "Checking backend logs..."
    docker compose logs backend
    exit 1
}

# Check MongoDB connection
Write-Host "`n11. Checking MongoDB connection..." -ForegroundColor Cyan
$logs = docker compose logs backend
if ($logs -match "Connected to the database") {
    Write-Host "✓ Backend connected to MongoDB" -ForegroundColor Green
} else {
    Write-Host "⚠ MongoDB connection status unclear" -ForegroundColor Yellow
    Write-Host "Backend logs:"
    docker compose logs backend --tail 10
}

# Display summary
Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "  All tests passed!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Application is running at:"
Write-Host "  Frontend: http://localhost"
Write-Host "  Backend:  http://localhost/api"
Write-Host "  Health:   http://localhost/health"
Write-Host ""
Write-Host "Useful commands:"
Write-Host "  View logs:        docker compose logs -f"
Write-Host "  Stop services:    docker compose down"
Write-Host "  Restart:          docker compose restart"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Open http://localhost in your browser"
Write-Host "  2. Test CRUD operations"
Write-Host "  3. Push to GitHub to trigger CI/CD"
Write-Host ""
