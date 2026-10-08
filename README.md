# 🎓 Smart College Student Management System

A production-ready, full-featured Academic Administration and Student Information System designed to solve real-world college operational workflows with 3NF-compliant relational integrity, rule-based academic risk intelligence, fee tracking, dynamic attendance analytics, and multi-mode deployment.

---

## 🌟 Highlights & Features

- **Relational DBMS (3NF Normalized)**: 12 relational tables with foreign keys, indexes, cascading updates, triggers, and automated views.
- **Academic Risk Intelligence**: Multi-factor risk radar detecting students at risk based on attendance (< 75%), marks (< 50%), or fee arrears.
- **Dual Deployment Options**:
  - 🚀 **Option 1: Modern Web App & REST API** (React + Node.js/Express + MySQL)
  - ☕ **Option 2: Enterprise Java EE Web Application** (Jakarta EE 10 + Servlets + JSP + Tomcat 10.1 + Maven)
- **Interactive Project Explorer**: Includes live interactive DBMS explorer, SQL query tester, viva voce exam preparation guide, and full-source code browser.
- **Single-Command Docker Deployment**: Ready to launch with `docker compose up -d` including automated MySQL 8.0 schema creation and data seeding.

---

## 🗄️ Database Architecture (MySQL)

### Schema & Tables (`smart_college_db.sql`)

The system manages the following normalized tables:

| # | Table Name | Description | Key Relationships |
|---|---|---|---|
| 1 | `departments` | Academic departments (CSE, ECE, ME, CE, IT) | Referenced by students, faculty, subjects |
| 2 | `faculty` | Faculty members, designations, qualifications | Linked to departments and user accounts |
| 3 | `users` | Auth credentials (SHA-256 salted hashes, roles: `ADMIN`, `FACULTY`) | Linked to faculty records |
| 4 | `students` | Core student demographic, admission, and semester details | Linked to departments |
| 5 | `subjects` | Course offerings, credit weights, and assigned instructors | Linked to departments and faculty |
| 6 | `enrollments` | Student semester course enrollments | Links students to subjects |
| 7 | `attendance` | Daily class attendance records (PRESENT / ABSENT / LATE) | Links enrollments with date stamps |
| 8 | `marks` | Internal assessments (IA1, IA2), assignments, and semester exams | Links enrollments with score calculations |
| 9 | `fee_structures` | Semester tuition and institutional fee schedules | Defined per department and semester |
| 10 | `student_fees` | Student fee ledger (total, paid, pending balance) | Linked to students & fee structures |
| 11 | `fee_payments` | Transaction receipts and payment audit history | Linked to student fee accounts |
| 12 | `leave_requests` | Faculty & student leave applications with approval workflow | Linked to applicants & approvers |

### Pre-Built Analytical Views
- `v_student_academic_summary`: Dynamic calculation of overall attendance percentage and GPA.
- `v_academic_risk`: Automated flag generation for attendance shortage, academic failure, and fee defaulters.
- `v_fee_collection_status`: Real-time ledger summary of collected vs outstanding balances.
- `v_faculty_workload`: Faculty course allocation and student enrollment count.

---

## 🚀 Quick Setup & Deployment

### 1. Database Setup (MySQL)

#### Method A: Automated Setup Script (Recommended)
Make sure your local MySQL service is running, configure your `.env` credentials, and execute:
```bash
# Windows
setup-db.bat

# Linux / macOS / Terminal
npm run setup:db
```

#### Method B: Manual Import (MySQL Workbench or CLI)
1. Open MySQL Workbench.
2. Open and run [`smart-college-management-system/smart_college_db.sql`](smart-college-management-system/smart_college_db.sql).
3. The database `smart_college_db` will be created with all tables, triggers, views, and seed data.

---

### 2. Run with Docker (Fastest, 1-Click Deployment)

Start MySQL 8.0 and the complete Web Application in containers with pre-seeded data:
```bash
docker compose up -d
```
- Web Application: `http://localhost:3000`
- MySQL Database: `localhost:3306` (User: `root`, Password: `root`, Database: `smart_college_db`)

To stop:
```bash
docker compose down
```

---

### 3. Run Web App Locally (Node / Vite)

```bash
# 1. Install dependencies
npm install

# 2. Build and Start Server
npm run build
npm start

# Or for development with hot reload:
npm run dev
```

Open `http://localhost:3000` in your browser.

---

### 4. Deploy Java EE Project to Apache Tomcat 10.1.x

If you prefer deploying the traditional Java/JSP Servlets WAR package:

1. **Configure Database**: Update credentials in `smart-college-management-system/src/main/resources/db.properties`.
2. **Build WAR File**:
   ```bash
   cd smart-college-management-system
   mvn clean package
   ```
3. **Deploy to Tomcat**:
   - Copy `target/smart-college-management-system.war` into Tomcat's `webapps/` folder.
   - Start Apache Tomcat (`bin/startup.bat` or `bin/startup.sh`).
   - Access the system at: `http://localhost:8080/smart-college-management-system/`

---

## 🔑 Default Login Credentials

| Role | Username | Password | Access Level |
|---|---|---|---|
| **Admin** | `admin` | `admin123` | Full administrative control (Students, Faculty, Fees, System Settings) |
| **Faculty (CSE)** | `faculty_cse` | `faculty123` | Attendance entry, marks grading, student reports |
| **Faculty (ECE)** | `faculty_ece` | `faculty123` | Department-specific academic operations |

---

## 📂 Project Structure

```
smart-college-student-management-system/
├── docker-compose.yml              # Multi-container orchestration (MySQL + App)
├── Dockerfile                      # Container build definition
├── package.json                    # Dependencies & automation scripts
├── server.js                       # Node/Express API server & static host
├── start.bat / start.sh            # 1-Click launch scripts
├── setup-db.bat / setup-db.sh      # 1-Click MySQL database initializer
├── .env.example                    # Environment template
│
├── scripts/
│   ├── setup_mysql.js              # Automated database migrator & verifier
│   └── generators/                 # Project code generator & bundling tools
│
├── src/                            # Modern UI & DBMS Explorer Application
│   ├── App.tsx                     # Core Dashboard, Risk Radar & Explorer
│   ├── data/                       # Relational mock datasets & code tree
│   └── main.tsx
│
└── smart-college-management-system/ # Java EE Jakarta 10 Web Application
    ├── pom.xml                     # Maven configuration (Tomcat 10.1 / Jakarta EE)
    ├── smart_college_db.sql        # 3NF MySQL Database Schema & Seed Data
    └── src/main/
        ├── java/com/college/       # Servlets, DAOs, Models, Filters, Utils
        ├── resources/              # db.properties database credentials
        └── webapp/                 # Responsive JSP Views & Styles
```

---

## 📜 License
This project is open-source and free for academic, learning, and production use.
