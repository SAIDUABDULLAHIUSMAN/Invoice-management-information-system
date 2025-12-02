# Local Development Architecture

## System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                  Your Computer (Local)                   │
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │         Browser (http://localhost:5173)          │   │
│  │  ┌─────────────────────────────────────────────┐ │   │
│  │  │    React App (Your Sales Dashboard)         │ │   │
│  │  │  - Login/Registration                       │ │   │
│  │  │  - Sales Management                         │ │   │
│  │  │  - Reports & Analytics                      │ │   │
│  │  │  - Admin Panel                              │ │   │
│  │  └─────────────────────────────────────────────┘ │   │
│  │                      ↓                             │   │
│  │              (Vite Dev Server)                    │   │
│  │           HMR (Hot Reload)                        │   │
│  └──────────────────────────────────────────────────┘   │
│                       ↓                                  │
│            HTTP Requests (JSON)                         │
│                       ↓                                  │
│  ┌──────────────────────────────────────────────────┐   │
│  │           Docker Container Network               │   │
│  │                                                   │   │
│  │  ┌────────────────────────────────────────────┐  │   │
│  │  │  Supabase Container (localhost:8000)      │  │   │
│  │  │  ┌──────────────────────────────────────┐ │  │   │
│  │  │  │  Supabase API Server                │ │  │   │
│  │  │  │  - Authentication                   │ │  │   │
│  │  │  │  - Authorization (RLS)              │ │  │   │
│  │  │  │  - Real-time Subscriptions          │ │  │   │
│  │  │  │  - REST API                         │ │  │   │
│  │  │  └──────────────────────────────────────┘ │  │   │
│  │  │               ↓                            │  │   │
│  │  │  ┌──────────────────────────────────────┐ │  │   │
│  │  │  │  PostgreSQL Database                │ │  │   │
│  │  │  │  (localhost:5432)                    │ │  │   │
│  │  │  │                                      │ │  │   │
│  │  │  │  Tables:                             │ │  │   │
│  │  │  │  - auth.users (Authentication)       │ │  │   │
│  │  │  │  - sales (Transaction Data)          │ │  │   │
│  │  │  │  - products (Product Catalog)        │ │  │   │
│  │  │  │  - audit_log (Audit Trail)           │ │  │   │
│  │  │  │  - email_notifications (Settings)    │ │  │   │
│  │  │  │  - staff_sales (Staff Transactions)  │ │  │   │
│  │  │  │                                      │ │  │   │
│  │  │  │  Security:                           │ │  │   │
│  │  │  │  - Row Level Security (RLS)          │ │  │   │
│  │  │  │  - Data Encryption                   │ │  │   │
│  │  │  └──────────────────────────────────────┘ │  │   │
│  │  └────────────────────────────────────────────┘  │   │
│  │                                                   │   │
│  │  ┌────────────────────────────────────────────┐  │   │
│  │  │  Supabase Admin (localhost:3000)          │  │   │
│  │  │  - Database Editor                        │  │   │
│  │  │  - User Management                        │  │   │
│  │  │  - Real-time Logs                         │  │   │
│  │  └────────────────────────────────────────────┘  │   │
│  │                                                   │   │
│  └──────────────────────────────────────────────────┘   │
│                                                           │
└─────────────────────────────────────────────────────────┘
```

## Data Flow Example: Creating a Sale

```
1. User fills out sales form
   ↓
2. React app validates data
   ↓
3. App sends POST request to Supabase API
   (http://localhost:8000/rest/v1/sales)
   ↓
4. Supabase authenticates request
   (Checks JWT token)
   ↓
5. Supabase applies Row Level Security (RLS)
   (Checks if user can create sales)
   ↓
6. Data is saved to PostgreSQL database
   ↓
7. Audit log entry created automatically
   ↓
8. Response sent back to React app
   ↓
9. UI updates to show success
   ↓
10. Real-time subscriptions notify other users
```

## File Structure

```
project-root/
├── src/
│   ├── components/          # React components
│   │   ├── Auth/           # Login/Registration
│   │   ├── Sales/          # Sales forms & history
│   │   ├── Admin/          # Admin features
│   │   ├── Dashboard/      # Dashboard views
│   │   ├── Reports/        # Reporting
│   │   ├── Layout/         # Layout components
│   │   └── Settings/       # Settings
│   ├── pages/              # Page components
│   ├── contexts/           # React Context (State Management)
│   ├── hooks/              # Custom React Hooks
│   ├── lib/                # Utilities & Supabase client
│   ├── utils/              # Helper functions
│   ├── App.tsx             # Main app component
│   ├── main.tsx            # Entry point
│   └── index.css            # Global styles
│
├── supabase/
│   └── migrations/         # Database schema changes
│       ├── 20251011125559_create_sales_management_schema.sql
│       ├── 20251011130051_add_sample_products.sql
│       ├── 20251014040105_enhance_schema_for_rbac_and_audit.sql
│       └── 20251015050502_add_email_notification_settings.sql
│
├── docker-compose.yml      # Docker services config
├── .env.local             # Local environment variables
├── package.json           # Node.js dependencies
├── vite.config.ts         # Vite bundler config
├── tsconfig.json          # TypeScript config
├── tailwind.config.js     # Tailwind CSS config
│
├── SETUP_LOCAL.md         # Complete setup guide
├── QUICK_START.md         # Quick start guide
├── LOCAL_DEVELOPMENT.md   # Development workflow
└── ARCHITECTURE.md        # This file
```

## Environment Setup

```
Local Machine
    ↓
Docker Desktop (Installed)
    ↓
Docker Compose
    ├── PostgreSQL Container
    │   └── Port: 5432
    │       User: postgres
    │       Password: postgres
    │       Database: postgres
    │
    ├── Supabase Container
    │   ├── Port: 8000 (API)
    │   ├── Port: 3000 (Admin)
    │   └── Services:
    │       ├── Authentication
    │       ├── REST API
    │       ├── Real-time
    │       ├── Storage
    │       └── Vector Database
    │
    └── Node.js Application
        ├── Port: 5173 (Dev Server)
        ├── npm run dev
        ├── Vite bundler
        └── React app with HMR
```

## Technology Stack

### Frontend
- **React 18.3** - UI framework
- **TypeScript** - Type safety
- **Vite** - Fast build tool with HMR
- **Tailwind CSS** - Utility-first CSS
- **Lucide React** - Icons
- **Recharts** - Charts & graphs
- **jsPDF** - PDF generation

### Backend
- **Supabase** - Backend-as-a-Service
  - PostgreSQL - Database
  - Supabase Auth - Authentication
  - RLS - Row Level Security
  - Real-time subscriptions
  - Edge Functions (for notifications)

### Development Tools
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **PostgreSQL 15** - Database
- **Node.js** - JavaScript runtime
- **npm** - Package manager

## Authentication Flow

```
1. User goes to http://localhost:5173
   ↓
2. React checks if user is logged in
   (Checks localStorage for JWT)
   ↓
3. If no JWT → Show login page
   ↓
4. User enters email/password
   ↓
5. Request sent to: http://localhost:8000/auth/v1/token
   ↓
6. Supabase validates credentials against auth.users table
   ↓
7. JWT token returned (valid for 1 hour by default)
   ↓
8. Token stored in localStorage
   ↓
9. Token attached to all API requests
   (Authorization: Bearer <token>)
   ↓
10. Supabase verifies token on each request
    ↓
11. RLS policies check if user can access data
    ↓
12. Data returned (or denied if unauthorized)
```

## Security Architecture

```
┌─────────────────────────────────────────┐
│         React App (Untrusted)            │
│                                          │
│  User Input → Validation → API Request   │
└──────────────────┬──────────────────────┘
                   │
                   ↓ HTTPS (localhost)
        ┌──────────────────────┐
        │  Supabase API        │
        │  (Trusted Server)    │
        │                      │
        │  1. Check JWT Token  │ ← Authentication
        │  2. Apply RLS        │ ← Authorization
        │  3. Audit Log        │ ← Logging
        │  4. Validation       │ ← Data Integrity
        └──────────┬───────────┘
                   │
                   ↓
        ┌──────────────────────┐
        │  PostgreSQL DB       │
        │                      │
        │  Encrypted Data      │
        │  RLS Enforced        │
        │  Transaction Safe    │
        └──────────────────────┘
```

## Local Development Advantages

| Feature | Local | Cloud |
|---------|-------|-------|
| Speed | Instant (no network) | ~50-200ms latency |
| Cost | Free | Pay per request |
| Data Privacy | No internet transfer | External servers |
| Offline Dev | Can work offline | Need internet |
| Debugging | Full access to logs | Limited visibility |
| Database Access | Direct connection | Via admin panel |
| Schema Changes | Instant apply | May be delayed |

## Performance Characteristics

```
Database Query
    ↓
Local: ~1-5ms (same computer)
vs
Cloud: ~50-200ms (network + server)

Development Speed
    ↓
HMR Reload: <1 second (file changes)
vs
Production Build: ~15-20 seconds

Cold Start (Docker up)
    ↓
First time: ~30-60 seconds (initialization)
Subsequent: <5 seconds (containers cached)
```

## Scaling Considerations

When moving to production, the same code works with:
- **Cloud Supabase**: Just change environment variables
- **PostgreSQL Self-Hosted**: Configure connection string
- **Multiple Instances**: Load balancing (no changes needed)

The architecture automatically scales without code changes!

## Getting Help

- **Docker Issues**: Check `docker-compose logs`
- **Database Issues**: Connect via `psql` and inspect tables
- **App Issues**: Check browser console and network tab
- **Auth Issues**: Check Supabase admin panel at http://localhost:3000

## Next Steps

1. Complete setup from `SETUP_LOCAL.md`
2. Create a test user
3. Explore the admin panel at http://localhost:3000
4. Test features in the app
5. Review code in `src/` directory
6. Check database schema in `supabase/migrations/`
