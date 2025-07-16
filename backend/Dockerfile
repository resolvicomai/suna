# Backend Dockerfile for Railway Deployment
FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1     PYTHONDONTWRITEBYTECODE=1     PIP_NO_CACHE_DIR=off     PIP_DISABLE_PIP_VERSION_CHECK=on     PORT=8000

# Create app directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y     gcc     g++     make     curl     && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE $PORT

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3     CMD curl -f http://localhost:$PORT/api/health || exit 1

# Start command for Railway
CMD gunicorn api:app --bind 0.0.0.0:$PORT --workers 2 --worker-class uvicorn.workers.UvicornWorker --access-logfile - --error-logfile -