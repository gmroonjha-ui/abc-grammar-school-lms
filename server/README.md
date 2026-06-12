# Backend - Node.js/Express Server

## Folder Structure

```
server/
├── src/
│   ├── config/           # Configuration files
│   ├── controllers/       # Request handlers
│   ├── middleware/        # Custom middleware
│   ├── models/           # Database models
│   ├── routes/           # API routes
│   ├── services/         # Business logic
│   ├── utils/            # Utility functions
│   ├── types/            # TypeScript types
│   └── index.ts          # Server entry point
├── migrations/           # Database migrations
├── seeds/                # Database seeds
├── tests/                # Unit & integration tests
├── package.json
├── tsconfig.json
└── .env
```

## Core API Routes

### Authentication
- `POST /api/auth/register` - Register user
- `POST /api/auth/login` - Login
- `POST /api/auth/logout` - Logout
- `POST /api/auth/refresh-token` - Refresh JWT

### Students
- `GET /api/students` - List all students
- `GET /api/students/:id` - Get student details
- `POST /api/students` - Add student
- `PUT /api/students/:id` - Update student
- `DELETE /api/students/:id` - Delete student

### Attendance
- `POST /api/attendance/mark` - Mark attendance
- `GET /api/attendance/:studentId` - Get student attendance
- `GET /api/attendance/report/:studentId` - Attendance report
- `POST /api/attendance/qr-scan` - QR code scanning

### Fees
- `POST /api/fees/voucher` - Generate fee voucher
- `GET /api/fees/:studentId` - Get fee records
- `POST /api/fees/payment` - Record payment
- `GET /api/fees/outstanding` - Outstanding fees report

### Marks
- `POST /api/marks/entry` - Enter marks
- `GET /api/marks/:studentId` - Get student marks
- `PUT /api/marks/:id` - Update marks
- `GET /api/marks/sheet/:studentId` - Marks sheet

### Staff
- `GET /api/staff` - List staff
- `POST /api/staff` - Add staff
- `PUT /api/staff/:id` - Update staff
- `GET /api/staff/:id/salary` - Staff salary

### Homework
- `POST /api/homework/upload` - Upload homework
- `GET /api/homework` - List homework
- `GET /api/homework/:id` - Get homework details

## Installation

```bash
cd server
npm install
```

## Environment Setup

Create `.env` file in server directory with database credentials.

## Database Setup

```bash
npm run db:migrate
npm run db:seed
```

## Development

```bash
npm run dev
```

Server runs on `http://localhost:5000`

## Database Schema

See `migrations/` folder for complete schema.

### Key Tables
- users
- students
- attendance
- fees
- marks
- staff
- homework
- expenses
