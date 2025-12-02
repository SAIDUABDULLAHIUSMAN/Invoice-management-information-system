# Quick Start - Local Development with Docker

Get your development environment running in minutes!

## 5-Minute Setup

### 1. Prerequisites Check (30 seconds)

```bash
# Make sure you have these installed
docker --version  # Should show Docker version
node --version    # Should show v16+
```

**Missing something?** Download:
- Docker Desktop: https://www.docker.com/products/docker-desktop
- Node.js: https://nodejs.org/

### 2. Start Docker (30 seconds)

```bash
# Navigate to project directory
cd /path/to/project

# Start services in background
docker-compose up -d

# Verify they're running
docker-compose ps
```

**Wait 30-60 seconds** for services to fully initialize.

### 3. Install Dependencies (2 minutes)

```bash
npm install
```

### 4. Start Development Server (30 seconds)

Open a new terminal and run:

```bash
npm run dev
```

### 5. Open in Browser (30 seconds)

**Main App**: http://localhost:5173
**Admin Panel**: http://localhost:3000

---

## Your First Test Run

### Step 1: Create Test User
1. Go to http://localhost:3000
2. Click "Authentication" → "Users"
3. Click "Generate mock user"
4. Note the email and password

### Step 2: Log In
1. Go to http://localhost:5173
2. Sign up or log in with test credentials
3. You're in!

### Step 3: Test Features
- Create a sale transaction
- View sales history
- Check reports
- Explore the admin panel

---

## Essential Commands

```bash
# Start services (run once)
docker-compose up -d

# Start dev server (in new terminal)
npm run dev

# View logs
docker-compose logs -f

# Stop services (keeps data)
docker-compose down

# Reset database (delete all data)
docker-compose down -v && docker-compose up -d

# Check for errors
npm run typecheck

# Build for production
npm run build
```

---

## Ports

| Port | Service | URL |
|------|---------|-----|
| 5173 | React App | http://localhost:5173 |
| 3000 | Supabase Admin | http://localhost:3000 |
| 8000 | Supabase API | http://localhost:8000 |
| 5432 | PostgreSQL | localhost:5432 |

---

## Database Access

```bash
# Connect to database
psql -h localhost -U postgres -d postgres

# Password: postgres

# Useful commands in psql:
\dt              # List tables
SELECT * FROM sales LIMIT 10;  # View data
\q               # Exit
```

---

## Common Issues

**Port already in use?**
```bash
# macOS/Linux: Kill process using port 5173
lsof -i :5173 | grep LISTEN | awk '{print $2}' | xargs kill -9

# Windows PowerShell: Kill port 5173
Get-Process -Id (Get-NetTCPConnection -LocalPort 5173).OwningProcess | Stop-Process
```

**Services won't start?**
```bash
# Check Docker is running
docker info

# View detailed logs
docker-compose logs
```

**App won't connect to database?**
```bash
# Restart services
docker-compose restart

# Wait 60 seconds and try again
```

---

## Hot Module Replacement (HMR)

The app automatically reloads when you save changes!

1. Edit a React component in `src/`
2. Save the file
3. Change appears instantly in browser

No page refresh needed.

---

## Next Steps

- **Full Setup Guide**: See `SETUP_LOCAL.md` for detailed instructions
- **Advanced Workflows**: See `LOCAL_DEVELOPMENT.md` for database management, testing, and troubleshooting
- **Need Help?**: Check the troubleshooting section in `SETUP_LOCAL.md`

---

## All Set!

You now have a complete local development environment with:
- ✅ React app with hot reload
- ✅ PostgreSQL database
- ✅ Supabase authentication
- ✅ Admin dashboard
- ✅ Full offline development

Happy coding!
