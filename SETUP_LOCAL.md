# Complete Local Development Setup Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Installation Steps](#installation-steps)
3. [Verification](#verification)
4. [Running the Application](#running-the-application)
5. [Common Tasks](#common-tasks)
6. [Troubleshooting](#troubleshooting)
7. [Database Management](#database-management)
8. [Testing](#testing)

---

## Prerequisites

Before you start, ensure you have the following installed on your system:

### Required Software

1. **Docker Desktop**
   - **macOS**: Download from https://www.docker.com/products/docker-desktop
   - **Windows**: Download from https://www.docker.com/products/docker-desktop
   - **Linux**: Install via package manager or https://docs.docker.com/desktop/install/linux-install/

2. **Node.js** (v16 or higher)
   - Download from https://nodejs.org/
   - Verify installation: `node --version` and `npm --version`

3. **Git** (optional but recommended)
   - Download from https://git-scm.com/
   - Used for version control

### System Requirements

- **Minimum RAM**: 4GB (8GB recommended)
- **Available Disk Space**: 2GB minimum
- **Ports Available**: 5432, 8000, 3000, 5173
- **Internet Connection**: Required for first-time Docker image download (~2-3GB)

### Check Prerequisites

```bash
# Check if Docker is installed
docker --version

# Check if Node.js is installed
node --version
npm --version

# Check if Git is installed (optional)
git --version
```

All commands should return version numbers. If any fail, install the missing software.

---

## Installation Steps

### Step 1: Clone or Navigate to Project

```bash
# If you don't have the project yet
git clone <your-repo-url>
cd <project-directory>

# Or if you already have it
cd /path/to/project
```

### Step 2: Verify Project Structure

Ensure these files exist in your project root:
- `docker-compose.yml` - Docker configuration
- `.env.local` - Environment variables for local development
- `package.json` - Node.js dependencies
- `src/` - React source code

```bash
ls -la docker-compose.yml
ls -la .env.local
ls -la package.json
```

### Step 3: Check Environment Variables

Open `.env.local` and verify it contains:

```env
VITE_SUPABASE_URL=http://localhost:8000
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxvY2FsIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzgyNjAwNzUsImV4cCI6MTk5NDAwMDA3NX0.h-Br-q6mXA1D-VXGpFmj3WpVe3nFEeQ6V0W6qX7jXmQ
```

Do NOT modify these values - they're configured for local development.

### Step 4: Start Docker Containers

**Option A: Using the startup script (Recommended)**

macOS/Linux:
```bash
chmod +x start-local.sh
./start-local.sh
```

Windows (PowerShell):
```powershell
.\start-local.bat
```

Windows (Command Prompt):
```cmd
start-local.bat
```

**Option B: Using Docker Compose directly**

```bash
docker-compose up -d
```

The `-d` flag runs containers in the background.

### Step 5: Wait for Services to Initialize

After starting Docker, wait 30-60 seconds for all services to be fully ready.

**Monitor startup progress:**

```bash
# View all containers and their status
docker-compose ps

# View detailed logs (press Ctrl+C to stop)
docker-compose logs -f
```

You should see output indicating that PostgreSQL is ready and Supabase services are starting.

### Step 6: Install Node.js Dependencies

Open a new terminal window and run:

```bash
npm install
```

This installs all required packages listed in `package.json`. Should complete in 1-2 minutes.

### Step 7: Start the Development Server

```bash
npm run dev
```

You should see output like:
```
  VITE v5.4.2  ready in 123 ms

  ➜  Local:   http://localhost:5173/
  ➜  press h to show help
```

---

## Verification

### Check All Services Are Running

```bash
docker-compose ps
```

Expected output (all should say "running"):
```
NAME                  STATUS
supabase_postgres     running
supabase_main         running
```

### Check Each Service

**PostgreSQL Database:**
```bash
# Should return "pong" response
docker-compose exec postgres pg_isready
```

**Supabase Services:**
```bash
# Should return HTTP response
curl http://localhost:8000/health
```

### Test Network Connectivity

```bash
# Can you reach Supabase from your machine?
curl http://localhost:8000/rest/v1/

# Should return a response (JSON error is fine - means service is responding)
```

---

## Running the Application

### Access the Application

Once everything is running, open your browser and navigate to:

| Service | URL | Purpose |
|---------|-----|---------|
| **React App** | http://localhost:5173 | Main application |
| **Supabase Admin** | http://localhost:3000 | Database and auth management |
| **API (Direct)** | http://localhost:8000 | Supabase API endpoint |

### Application Workflow

1. **Open http://localhost:5173** in your browser
2. You'll see the login page
3. Click "Create account" or log in with test credentials
4. After login, you'll access the dashboard with full functionality

### Hot Module Replacement (HMR)

The development server has Hot Module Replacement enabled:
- Edit React components in `src/`
- Save the file
- Changes appear instantly in browser (without page reload)

This significantly speeds up development.

---

## Common Tasks

### 1. Create a Test User

**Via Supabase Admin Panel:**
1. Open http://localhost:3000
2. Click "Authentication" in the left sidebar
3. Click "Users" tab
4. Click "Generate mock user" or "Add user"
5. Enter email and password
6. Click "Create user"
7. Go to http://localhost:5173 and log in with these credentials

### 2. View Database Tables

**Option A: Using Supabase Admin**
1. Go to http://localhost:3000
2. Click "SQL Editor" to write queries
3. Or click "Table Editor" to browse data

**Option B: Using PostgreSQL CLI**
```bash
# Connect to database
psql -h localhost -U postgres -d postgres

# List tables
\dt

# View specific table
SELECT * FROM sales LIMIT 10;

# Exit
\q
```

Password: `postgres`

### 3. View Logs

```bash
# View all service logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f supabase
docker-compose logs -f postgres

# View last 100 lines
docker-compose logs --tail=100
```

### 4. Stop Services Temporarily

```bash
# Stop containers (data persists)
docker-compose stop

# Resume containers
docker-compose start
```

### 5. Reset Database (Delete All Data)

```bash
# Stop containers and remove volumes
docker-compose down -v

# Restart (fresh database)
docker-compose up -d

# Wait 30-60 seconds for initialization
```

### 6. View Application Build Size

```bash
npm run build
```

Shows the production build size and optimization suggestions.

### 7. Type Check

```bash
npm run typecheck
```

Checks for TypeScript errors without building.

### 8. Lint Code

```bash
npm run lint
```

Checks for code style issues.

---

## Troubleshooting

### Issue: "Port Already in Use"

**Error Message:**
```
Error: listen EADDRINUSE: address already in use :::5432
```

**Solutions:**

Find what's using the port:
```bash
# macOS/Linux
lsof -i :5432

# Windows PowerShell
Get-Process -Id (Get-NetTCPConnection -LocalPort 5432).OwningProcess
```

Either:
1. Stop the other application using the port
2. Change the port in `docker-compose.yml` (not recommended)

### Issue: Docker Won't Start

**Error Message:**
```
Cannot connect to Docker daemon
```

**Solutions:**
1. Ensure Docker Desktop is installed and running
2. macOS: Check that Docker.app is in Applications folder and running
3. Windows: Open Docker Desktop from Start Menu
4. Linux: Check Docker service is running: `sudo systemctl start docker`

### Issue: Containers Keep Restarting

**Check logs:**
```bash
docker-compose logs -f postgres
```

**Common causes:**
- Insufficient RAM (increase Docker memory allocation)
- Port conflicts
- Corrupted volume data - try: `docker-compose down -v && docker-compose up -d`

### Issue: App Won't Connect to Supabase

**Error:** "Cannot connect to Supabase"

**Check:**
1. Is Supabase container running? `docker-compose ps`
2. Is it healthy? `docker-compose logs supabase`
3. Verify `.env.local` has correct URLs
4. Wait longer for initialization (can take 60+ seconds)

**Restart services:**
```bash
docker-compose restart
```

### Issue: "Address Already in Use" for Port 5173 (Vite Dev Server)

```bash
# Find and kill the process
# macOS/Linux
lsof -i :5173 | grep LISTEN | awk '{print $2}' | xargs kill -9

# Windows PowerShell
Get-Process -Id (Get-NetTCPConnection -LocalPort 5173).OwningProcess | Stop-Process
```

Then restart: `npm run dev`

### Issue: Database Connection Timeout

**Error:** "Connection timeout"

**Solutions:**
```bash
# Restart PostgreSQL
docker-compose restart postgres

# Wait 30 seconds, then try again

# Or full reset
docker-compose down -v
docker-compose up -d
```

### Issue: Node Modules Issues

```bash
# Clear npm cache
npm cache clean --force

# Remove node_modules and package-lock.json
rm -rf node_modules package-lock.json

# Reinstall
npm install
```

### Issue: TypeScript Errors

```bash
# Check for type errors
npm run typecheck

# Fix common issues
npm run lint -- --fix
```

---

## Database Management

### Connection Details

| Property | Value |
|----------|-------|
| **Host** | localhost |
| **Port** | 5432 |
| **Database** | postgres |
| **User** | postgres |
| **Password** | postgres |

### Backup Database

```bash
# Create backup file
docker-compose exec postgres pg_dump -U postgres postgres > backup.sql

# File size should be a few MB
ls -lh backup.sql
```

### Restore Database

```bash
# Restore from backup
docker-compose exec -T postgres psql -U postgres postgres < backup.sql
```

### View Database Schema

```bash
# Connect and list tables
psql -h localhost -U postgres -d postgres

# In psql prompt
\dt              # Show tables
\d table_name    # Show table structure
\dn              # Show schemas
SELECT version();  # Check PostgreSQL version
```

### Run Raw SQL Queries

```bash
psql -h localhost -U postgres -d postgres -c "SELECT COUNT(*) FROM sales;"
```

### Monitor Active Connections

```bash
psql -h localhost -U postgres -d postgres -c \
"SELECT * FROM pg_stat_activity WHERE state = 'active';"
```

---

## Testing

### Manual Testing

1. **Create Test User:**
   - Go to http://localhost:3000
   - Create a new user with email/password

2. **Test Login:**
   - Go to http://localhost:5173
   - Enter test credentials
   - Verify you can log in

3. **Test Features:**
   - Create a sale transaction
   - View sales history
   - Generate reports
   - Check audit logs

4. **Test Admin Functions:**
   - Manage products
   - View all transactions
   - Monitor system audit log

### Automated Testing

```bash
# Run tests (if configured)
npm test

# Type check
npm run typecheck

# Lint
npm run lint
```

### Load Testing

For performance testing with multiple users, use tools like:
- Apache JMeter
- Locust
- Artillery

Example with Artillery:
```bash
npm install -g artillery
artillery quick --count 10 --num 100 http://localhost:5173
```

### Monitoring

View real-time application metrics:
```bash
# In separate terminal
docker-compose stats

# Or individual containers
docker stats supabase_postgres
docker stats supabase_main
```

---

## Environment Reference

### `.env.local` Variables

```env
# Supabase API endpoint (local)
VITE_SUPABASE_URL=http://localhost:8000

# Anonymous key for local development
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxvY2FsIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzgyNjAwNzUsImV4cCI6MTk5NDAwMDA3NX0.h-Br-q6mXA1D-VXGpFmj3WpVe3nFEeQ6V0W6qX7jXmQ
```

### Development Tools

- **Vite Dev Server**: http://localhost:5173 (with HMR)
- **React DevTools**: Install browser extension
- **PostgreSQL Client**: `psql` CLI tool
- **Supabase Studio**: http://localhost:3000

---

## Next Steps

1. ✅ Complete [Installation Steps](#installation-steps)
2. ✅ Verify services with [Verification](#verification)
3. ✅ Access application at http://localhost:5173
4. ✅ Create test user via http://localhost:3000
5. ✅ Test all features in the application
6. ✅ Check LOCAL_DEVELOPMENT.md for advanced workflows

---

## Quick Reference Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View status
docker-compose ps

# View logs
docker-compose logs -f

# Install dependencies
npm install

# Start dev server
npm run dev

# Build for production
npm run build

# Check for type errors
npm run typecheck

# Lint code
npm run lint

# Reset database (delete all data)
docker-compose down -v && docker-compose up -d
```

---

## Support & Resources

- **Supabase Docs**: https://supabase.com/docs
- **Docker Docs**: https://docs.docker.com/
- **React Docs**: https://react.dev
- **Vite Docs**: https://vitejs.dev
- **TypeScript Docs**: https://www.typescriptlang.org/docs/

---

## Checklist: Before You Start Developing

- [ ] Docker Desktop installed and running
- [ ] Node.js v16+ installed
- [ ] Project cloned/downloaded
- [ ] `.env.local` exists in project root
- [ ] `docker-compose.yml` exists in project root
- [ ] Docker containers started: `docker-compose up -d`
- [ ] Waited 30-60 seconds for initialization
- [ ] Verified all containers running: `docker-compose ps`
- [ ] npm dependencies installed: `npm install`
- [ ] Dev server started: `npm run dev`
- [ ] App loads at http://localhost:5173
- [ ] Test user created and logged in successfully

Once all checks pass, you're ready to develop!
