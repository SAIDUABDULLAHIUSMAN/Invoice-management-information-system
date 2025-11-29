@echo off
echo Starting Local Supabase Setup...
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo Error: Docker is not installed. Please install Docker Desktop from https://www.docker.com/products/docker-desktop
    exit /b 1
)

echo Docker is installed
echo.

REM Start containers
echo Starting Supabase containers...
docker-compose up -d

REM Wait for services
echo.
echo Waiting for services to initialize (this may take 30-60 seconds)...
timeout /t 5 /nobreak

REM Check status
echo.
echo Container status:
docker-compose ps

echo.
echo Local Supabase is starting!
echo.
echo Next steps:
echo 1. Wait for all containers to show 'running' status
echo 2. In another terminal, run: npm install ^&^& npm run dev
echo 3. Open http://localhost:5173 in your browser
echo 4. To access Supabase admin: http://localhost:3000
echo.
echo To stop services: docker-compose down
