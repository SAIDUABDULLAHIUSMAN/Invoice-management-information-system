# Local Development Guide

## One-Command Setup (Recommended)

### macOS/Linux:
```bash
chmod +x start-local.sh
./start-local.sh
```

### Windows (PowerShell):
```powershell
.\start-local.bat
```

Or just run:
```bash
docker-compose up -d
```

## Full Setup Steps

### 1. Start Docker Services
```bash
docker-compose up -d
```

Wait 30-60 seconds for everything to initialize.

### 2. Install Dependencies
```bash
npm install
```

### 3. Start Development Server
```bash
npm run dev
```

### 4. Open Applications

- **React App**: http://localhost:5173
- **Supabase Admin**: http://localhost:3000
- **API**: http://localhost:8000

## Environment Configuration

The app automatically uses `.env.local` for local development with these settings:
- Supabase URL: `http://localhost:8000`
- Database: PostgreSQL on `localhost:5432`
- Auth: Local Supabase authentication

No additional configuration needed - just run the app!

## Database Management

### Connect to PostgreSQL
```bash
psql -h localhost -U postgres -d postgres
```

Password: `postgres`

### Useful PostgreSQL Commands
```sql
-- List all tables
\dt

-- View table structure
\d table_name

-- List all schemas
\dn

-- View auth users
SELECT id, email, created_at FROM auth.users;

-- View sales
SELECT * FROM sales LIMIT 10;

-- View products
SELECT * FROM products;
```

### Reset Database (Delete all data)
```bash
docker-compose down -v
docker-compose up -d
```

## Testing the Application

### Test User Account
1. Go to http://localhost:3000 (Supabase Admin)
2. Click "Authentication" → "Users"
3. Click "Generate mock user" or add a new user
4. Use email/password to log in to http://localhost:5173

### Sample Data
The database migrations automatically create:
- Sample products
- RLS policies for security
- Audit logging tables

## Troubleshooting

### Services Won't Start
```bash
# Check if ports are available
lsof -i :5432  # PostgreSQL
lsof -i :8000  # Supabase API
lsof -i :3000  # Supabase Admin

# View logs
docker-compose logs -f
```

### Database Connection Issues
```bash
# Check container health
docker-compose ps

# Restart containers
docker-compose restart

# Full reset
docker-compose down -v
docker-compose up -d
```

### App Won't Load
1. Verify Vite is running on port 5173
2. Check browser console for errors
3. Ensure `.env.local` exists and has correct URLs
4. Clear browser cache and reload

## Development Workflow

### 1. Make Code Changes
Edit React components, styles, and logic normally.

### 2. Hot Module Replacement
Changes automatically reload in the browser (Vite HMR).

### 3. Database Changes
To add database tables/columns:
1. Create migration file: `supabase/migrations/TIMESTAMP_description.sql`
2. Run migrations via Supabase Admin dashboard or SQL editor
3. Changes apply immediately

### 4. Test Changes
Use the Supabase Admin at http://localhost:3000 to:
- Manage users
- View/edit database data
- Test authentication
- View edge function logs

## Production vs Local

| Feature | Local | Production |
|---------|-------|-----------|
| Database | Local PostgreSQL | Supabase Cloud |
| Auth | Local Supabase | Supabase Cloud |
| Environment File | `.env.local` | `.env` (via secrets) |
| Development | Full speed HMR | N/A |
| Persistence | Docker volumes | Cloud backup |

## Stopping and Cleaning Up

### Stop Services (Keep Data)
```bash
docker-compose down
```

### Stop Services (Delete Everything)
```bash
docker-compose down -v
```

### Remove Docker Images
```bash
docker-compose down -v --rmi all
```

## Next Steps

1. Log in with test user at http://localhost:5173
2. Test the sales form and transactions
3. View audit logs and reports
4. Manage products and staff

Everything works offline - no internet connection needed for local development!
