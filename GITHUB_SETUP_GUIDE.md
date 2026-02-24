# GitHub Setup Guide

## Step 1: Configure GitHub Secrets (5 minutes)

### Navigate to Secrets Page
1. Go to your GitHub repository
2. Click on **Settings** tab
3. In the left sidebar, click **Secrets and variables** → **Actions**
4. You should see "Actions secrets and variables" page

### Add Secret 1: DOCKER_USERNAME
1. Click **New repository secret** button
2. Name: `DOCKER_USERNAME`
3. Secret: `keerthanaxd`
4. Click **Add secret**

### Add Secret 2: DOCKER_PASSWORD
1. Click **New repository secret** button again
2. Name: `DOCKER_PASSWORD`
3. Secret: Your Docker Hub access token (the password you used for docker login)
4. Click **Add secret**

### Verify Secrets
You should now see two secrets listed:
- DOCKER_USERNAME
- DOCKER_PASSWORD

**Important**: Take a screenshot of this page (blur the values) for your assignment submission.

## Step 2: Push Code to GitHub (2 minutes)

### Check Git Status
```bash
git status
```

### Add All Changes
```bash
git add .
```

### Commit Changes
```bash
git commit -m "Complete DevOps setup with CI/CD pipeline"
```

### Push to Main Branch
```bash
git push origin main
```

This will automatically trigger the GitHub Actions workflow!

## Step 3: Monitor GitHub Actions (5 minutes)

### View Workflow Run
1. Go to your repository on GitHub
2. Click the **Actions** tab
3. You should see a workflow run starting
4. Click on the workflow run to see details

### Workflow Steps
The workflow will execute these steps:
1. Checkout code
2. Verify Docker Hub credentials
3. Set up Docker Buildx
4. Login to Docker Hub
5. Build and push backend image
6. Build and push frontend image

### Success Indicators
- All steps show green checkmarks ✓
- Build logs show "Image pushed successfully"
- No red X marks

### Take Screenshots
Capture these for your assignment:
1. Workflow overview showing success
2. Detailed logs showing image push

## Step 4: Verify Images on Docker Hub (2 minutes)

### Check Backend Image
1. Go to: https://hub.docker.com/r/keerthanaxd/mean-backend
2. Verify you see:
   - `latest` tag
   - Recent push timestamp
   - Two tags: `latest` and `main-<commit-sha>`

### Check Frontend Image
1. Go to: https://hub.docker.com/r/keerthanaxd/mean-frontend
2. Verify you see:
   - `latest` tag
   - Recent push timestamp
   - Two tags: `latest` and `main-<commit-sha>`

### Take Screenshots
Capture both repository pages for your assignment.

## Troubleshooting

### Workflow Fails with "Secrets Missing"
- Verify secrets are named exactly: `DOCKER_USERNAME` and `DOCKER_PASSWORD`
- Check for typos in secret names
- Re-add secrets if needed

### Workflow Fails at Docker Login
- Verify DOCKER_PASSWORD is your access token, not your account password
- Generate new access token at: https://hub.docker.com/settings/security
- Update the DOCKER_PASSWORD secret

### Workflow Fails at Build Step
- Check the build logs for specific errors
- Verify Dockerfiles are correct
- Try building locally first: `docker compose build`

## Next Steps

After successful GitHub Actions run:
1. Deploy to Azure VM (see DEPLOYMENT.md)
2. Take remaining screenshots
3. Complete assignment submission

## Quick Reference

**GitHub Secrets Page:**
`https://github.com/<username>/<repo>/settings/secrets/actions`

**GitHub Actions Page:**
`https://github.com/<username>/<repo>/actions`

**Docker Hub:**
- Backend: `https://hub.docker.com/r/keerthanaxd/mean-backend`
- Frontend: `https://hub.docker.com/r/keerthanaxd/mean-frontend`
