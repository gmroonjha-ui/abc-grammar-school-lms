# Deployment Guide for ABC Grammar School LMS

## Deployment Options

### Option 1: Render (Recommended - Free Tier Available)

#### Prerequisites
- GitHub repository (✓ Done)
- Render account (free at https://render.com)

#### Steps

1. **Create PostgreSQL Database on Render**
   - Sign up at https://render.com
   - Click "New +" → "PostgreSQL"
   - Name: `abc-lms-db`
   - Region: Select closest to you
   - PostgreSQL Version: 15
   - Note the connection string

2. **Deploy Backend**
   - Click "New +" → "Web Service"
   - Connect GitHub repository
   - Name: `abc-lms-api`
   - Environment: `node`
   - Build Command: `npm install && npm run build`
   - Start Command: `npm start`
   - Add Environment Variables:
     ```
     DATABASE_URL=<postgres_connection_string>
     NODE_ENV=production
     JWT_SECRET=<generate_strong_secret>
     ```

3. **Deploy Frontend**
   - Click "New +" → "Static Site" (or Web Service for SSR)
   - Connect GitHub repository
   - Name: `abc-lms-frontend`
   - Build Command: `cd client && npm install && npm run build`
   - Publish Directory: `client/.next` or `client/out`
   - Add Environment Variables:
     ```
     REACT_APP_API_URL=<your-backend-url>
     ```

4. **Custom Domain (Optional)**
   - Go to Settings → Custom Domain
   - Add your domain once ready

### Option 2: Railway (Alternative)

1. Sign up at https://railway.app
2. Connect GitHub
3. Create PostgreSQL service
4. Deploy backend & frontend
5. Set environment variables

### Option 3: AWS (Production Scale)

Use **EC2 + RDS + CloudFront** for enterprise deployment.

## Environment Variables for Production

```
# Database
DATABASE_URL=postgresql://user:password@host:5432/abc_lms

# JWT
JWT_SECRET=<long_random_string_min_32_chars>
JWT_EXPIRE=7d

# API
NODE_ENV=production
API_URL=https://your-domain.com/api

# Frontend
REACT_APP_API_URL=https://your-domain.com/api

# Email (for notifications)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password

# Features
ENABLE_FACE_RECOGNITION=true
QR_CODE_ENABLED=true
```

## Database Setup

### Initial Migration

```bash
npm run db:migrate
npm run db:seed
```

### Backup Strategy

- Daily automated backups (configure in Render/Railway)
- Manual backup: `pg_dump -U user -d abc_lms > backup.sql`

## SSL/HTTPS

- Render provides free SSL by default ✓
- Custom domain: SSL automatically provisioned

## Monitoring & Logs

- **Render**: Dashboard → Logs
- **Database**: PgAdmin (admin panel)
- **Email Alerts**: Set up in your deployment platform

## Performance Optimization

1. **CDN**: Enable CDN for static assets
2. **Caching**: Redis caching for frequently accessed data
3. **Compression**: Gzip enabled in production
4. **Image Optimization**: Next.js Image component

## Security Checklist

- ✓ Environment variables not in code
- ✓ HTTPS enforced
- ✓ CORS properly configured
- ✓ Rate limiting on API
- ✓ Input validation on all endpoints
- ✓ SQL injection prevention (using ORMs)
- ✓ XSS protection enabled
- ✓ JWT tokens with expiration

## DNS Setup

Once you have a domain:

1. Add DNS records to your domain registrar
2. Point to your Render app
3. Enable HTTPS

## Rollback Procedure

If deployment has issues:

1. **Render**: Click "Previous Deploy" → Restart
2. **Database**: Restore from backup
3. **Code**: Revert to previous commit

## Support & Troubleshooting

- **502 Bad Gateway**: Check backend logs
- **Database Connection Error**: Verify DATABASE_URL
- **Missing Modules**: Run `npm install` in deployment
- **Frontend Blank**: Check API_URL configuration

---

## Quick Start Command

```bash
# Local Development
npm run dev

# Production Build
npm run build

# Deploy
git push heroku main  # if using Heroku
# or use Render dashboard for auto-deployment
```

## Next Steps After Deployment

1. ✓ Create admin account
2. ✓ Configure school settings
3. ✓ Set up payment gateway (optional)
4. ✓ Add staff members
5. ✓ Invite students
6. ✓ Configure email notifications

Need help? Contact: gmroonjha@gmail.com
