#!/bin/bash

# Deploy script for Suna on Railway
# This script helps configure and deploy the multi-service architecture

set -e

echo " Starting Suna deployment on Railway..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    print_error "Railway CLI not found. Please install it first:"
    echo "npm install -g @railway/cli"
    exit 1
fi

# Check if logged in to Railway
if ! railway whoami &> /dev/null; then
    print_warning "Not logged in to Railway. Logging in..."
    railway login
fi

print_status "Deploying Backend Service..."
cd backend
railway up --service backend
cd ..

print_status "Deploying Frontend Service..."
cd frontend
railway up --service frontend
cd ..

print_status "Setting up Redis database..."
railway add --service redis

print_status "Configuring environment variables..."

# Backend environment variables
railway variables set NODE_ENV=production --service backend
railway variables set PYTHONUNBUFFERED=1 --service backend
railway variables set PORT=8000 --service backend

# Frontend environment variables  
railway variables set NODE_ENV=production --service frontend
railway variables set PORT=3000 --service frontend
railway variables set NEXT_TELEMETRY_DISABLED=1 --service frontend

print_status "Deployment completed successfully!"
print_warning "Please configure the following environment variables manually in Railway dashboard:"
echo "Backend:"
echo "  - SUPABASE_URL"
echo "  - SUPABASE_SERVICE_ROLE_KEY"
echo "  - ANTHROPIC_API_KEY"
echo "  - DAYTONA_API_KEY"
echo "  - REDIS_URL (should auto-populate from Redis service)"

echo ""
echo "Frontend:"
echo "  - NEXT_PUBLIC_SUPABASE_URL"
echo "  - NEXT_PUBLIC_SUPABASE_ANON_KEY"
echo "  - NEXT_PUBLIC_BACKEND_URL (should be backend service URL + /api)"

echo ""
print_status " Suna is now deploying on Railway!"
print_warning "Don't forget to generate domains for your services in the Railway dashboard."