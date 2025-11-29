#!/bin/bash

echo "Starting Local Supabase Setup..."
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker Desktop from https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo "Error: Docker daemon is not running. Please start Docker Desktop."
    exit 1
fi

echo "✓ Docker is installed and running"
echo ""

# Start containers
echo "Starting Supabase containers..."
docker-compose up -d

# Wait for services to be ready
echo ""
echo "Waiting for services to initialize (this may take 30-60 seconds)..."
sleep 5

# Check container status
echo ""
echo "Container status:"
docker-compose ps

echo ""
echo "✓ Local Supabase is starting!"
echo ""
echo "Next steps:"
echo "1. Wait for all containers to show 'running' status"
echo "2. In another terminal, run: npm install && npm run dev"
echo "3. Open http://localhost:5173 in your browser"
echo "4. To access Supabase admin: http://localhost:3000"
echo ""
echo "To stop services: docker-compose down"
