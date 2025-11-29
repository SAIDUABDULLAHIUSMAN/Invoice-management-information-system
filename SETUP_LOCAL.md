# Local Supabase Setup with Docker

This guide will help you set up a local development environment using Docker.

## Prerequisites

1. **Docker Desktop** - Install from https://www.docker.com/products/docker-desktop
2. **Node.js** - Version 16+ (for running the React app)
3. **Git** - For version control

## Quick Start

### 1. Start Local Supabase

```bash
docker-compose up -d
```

This will start:
- PostgreSQL database on `localhost:5432`
- Supabase services on `localhost:8000`

Wait 30-60 seconds for services to be fully ready.

### 2. Verify Services

Check if services are running:
```bash
docker-compose ps
```

You should see two containers running:
- `supabase_postgres`
- `supabase_main`

### 3. Install Dependencies

```bash
npm install
```

### 4. Start the Development Server

```bash
npm run dev
```

The app will be available at `http://localhost:5173`

### 5. Access Supabase Admin

Open `http://localhost:3000` in your browser to access the Supabase dashboard.

## Database Setup

Your migrations will run automatically when the database initializes. The schema includes:
- Users table (via Supabase Auth)
- Sales transactions
- Products
- Audit logs
- Email notifications settings

## Environment Variables

The project uses `.env.local` for local development. Key variables:
- `VITE_SUPABASE_URL=http://localhost:8000`
- `VITE_SUPABASE_ANON_KEY` - Pre-configured for local testing

## Common Tasks

### View Database
```bash
# Connect to PostgreSQL
psql -h localhost -U postgres -d postgres

# Then use SQL commands to explore tables
\dt  # List tables
SELECT * FROM sales;  # View sales data
```

### Stop Services
```bash
docker-compose down
```

### Remove All Data (Reset Database)
```bash
docker-compose down -v
```

### View Logs
```bash
docker-compose logs -f supabase
```

## Testing Users

After setup, you can create test users by:
1. Going to `http://localhost:3000`
2. Using the Supabase Admin Panel
3. Creating new auth users with email/password

## Troubleshooting

**Services won't start:**
- Check if ports 5432, 8000, 3000 are available
- Run `docker-compose logs` to see error details

**Can't connect to database:**
- Ensure PostgreSQL container is healthy: `docker-compose ps`
- Wait a few moments for the database to fully initialize

**App won't load:**
- Check if Vite dev server is running on port 5173
- Verify environment variables are set in `.env.local`

## Notes

- Local database data persists in Docker volumes
- Use `.env.local` for local overrides (this file is git-ignored)
- In production, use cloud Supabase with appropriate credentials
