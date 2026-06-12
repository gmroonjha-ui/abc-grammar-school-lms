# Frontend - React/Next.js Application

## Folder Structure

```
client/
├── src/
│   ├── components/
│   │   ├── common/          # Reusable components
│   │   ├── layout/          # Layout components
│   │   ├── forms/           # Form components
│   │   └── dashboard/       # Dashboard components
│   ├── pages/               # Next.js pages
│   ├── styles/              # CSS & Tailwind config
│   ├── hooks/               # Custom React hooks
│   ├── services/            # API service calls
│   ├── store/               # Redux/State management
│   ├── types/               # TypeScript interfaces
│   ├── utils/               # Utility functions
│   └── app.tsx              # Root component
├── public/                  # Static assets
├── package.json
├── next.config.js
├── tsconfig.json
└── .env.local
```

## Key Pages

### Admin Dashboard
- `/admin/dashboard` - Main dashboard
- `/admin/students` - Student management
- `/admin/attendance` - Attendance tracking
- `/admin/fees` - Fees management
- `/admin/marks` - Marks entry & management
- `/admin/staff` - Staff management
- `/admin/homework` - Homework management
- `/admin/expenses` - Expense tracking
- `/admin/reports` - Reports & analytics

### Student Portal
- `/student/dashboard` - Student dashboard
- `/student/attendance` - View own attendance
- `/student/fees` - Fee records & receipts
- `/student/marks` - Marks & results
- `/student/homework` - Homework assignments

### Staff Portal
- `/staff/dashboard` - Staff dashboard
- `/staff/attendance` - Attendance tracking
- `/staff/salary` - Salary information
- `/staff/homework` - Upload homework

### Public Pages
- `/` - Landing page
- `/login` - Login page
- `/register` - Registration page

## Components

### Authentication
- `LoginForm` - Login component
- `RegisterForm` - Registration component
- `ProtectedRoute` - Route protection

### Student Management
- `StudentList` - Display students
- `StudentForm` - Add/Edit student
- `StudentIDCard` - Generate ID with QR code

### Attendance
- `AttendanceMarker` - Mark attendance
- `QRScanner` - Scan QR code
- `AttendanceReport` - View reports

### Fees
- `FeeVoucherGenerator` - Generate vouchers with QR codes
- `FeePaymentForm` - Record payment
- `OutstandingReport` - Outstanding fees tracking

### Marks
- `MarksEntry` - Enter marks for subjects
- `MarksSheet` - View marks sheet
- `QRMarkCorrection` - Correct marks via QR

### Homework
- `HomeworkUploader` - Upload homework
- `HomeworkList` - List assignments

## Installation

```bash
cd client
npm install
```

## Development

```bash
npm run dev
```

App runs on `http://localhost:3000`

## Build

```bash
npm run build
npm run start
```

## Technologies Used

- **React 18** - UI framework
- **Next.js 14** - React framework
- **TypeScript** - Type safety
- **Tailwind CSS** - Styling
- **Redux Toolkit** - State management
- **Axios** - HTTP client
- **React Query** - Data fetching
- **qrcode.react** - QR code generation
- **jsQR** - QR code scanning
- **face-api.js** - Face recognition
