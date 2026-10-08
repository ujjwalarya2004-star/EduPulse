# Smart College Student Management System

A complete, production-ready, deployment-ready DBMS Mini-Project built with **Java Servlets (Jakarta EE 10)**, **JDBC**, **MySQL 8.x**, **Apache Tomcat 10.1.x**, and **Maven**.

---

## 📌 Project Overview
The **Smart College Student Management System** is an enterprise-grade academic administration web application designed to solve real-world college operational challenges. It complies with database normalization standards (**3NF**) and provides complete relational integrity, automated aggregations, and rule-based academic risk intelligence.

### Key Highlights
- **Architecture**: Model-View-Controller (MVC) with Data Access Object (DAO) pattern.
- **Jakarta EE 10**: Uses `jakarta.servlet.*` (fully compatible with modern **Apache Tomcat 10.1.x**).
- **Security**: SHA-256 salted password hashing, role-based session filtering (`ADMIN` vs `FACULTY`), and 100% parameterised SQL (`PreparedStatement`) to eliminate SQL injection.
- **Calculated Intelligence**: Dynamic attendance calculation, automatic fee balance deduction, weighted semester grades, and multi-factor **Academic Risk Analysis** (Attendance < 75%, Marks < 50%, or Pending Fees > 0).

---

## 🛠️ Technology Stack
| Layer | Technologies |
|---|---|
| **Frontend** | HTML5, CSS3, Vanilla JavaScript, Bootstrap 5.3.3, Bootstrap Icons |
| **Backend** | Java 17+, Jakarta Servlets 6.0, JDBC (Java Database Connectivity), HikariCP |
| **Server** | Apache Tomcat 10.1.x |
| **Build Tool** | Apache Maven 3.8+ |
| **Database** | MySQL 8.x (Workbench Compatible) |

---

## 🚀 Quick Setup & Execution Guide (Step-by-Step for Beginners)

### Step 1: Prerequisites
Ensure you have the following installed on your machine:
1. **Java JDK 17 or higher** (`java -version`)
2. **Apache Maven 3.8+** (`mvn -version`)
3. **MySQL Server 8.0+** and **MySQL Workbench**
4. **Apache Tomcat 10.1.x** ([Download Tomcat 10.1](https://tomcat.apache.org/download-10.cgi))

---

### Step 2: Database Setup in MySQL Workbench
1. Open **MySQL Workbench** and connect to your local MySQL instance.
2. Click **File -> Open SQL Script...** and select the file:
   ```
   smart_college_db.sql
   ```
3. Click the **Lightning Bolt (Execute)** icon to run the complete script.
4. Verify that the database `smart_college_db` was created with all **12 tables**, **4 views**, and realistic seed data.

---

### Step 3: Configure Database Credentials
Open the file:
`src/main/resources/db.properties`

Update your MySQL username and password:
```properties
db.host=localhost
db.port=3306
db.name=smart_college_db
db.user=root
db.password=YOUR_MYSQL_PASSWORD_HERE
```
*(Default password in script is `root123`)*

---

### Step 4: Build the WAR File Using Maven
Open your terminal / command prompt inside the project folder:
```bash
cd smart-college-management-system
mvn clean package
```
Upon successful build, Maven will generate the deployment file:
```
target/smart-college-management-system.war
```

---

### Step 5: Deploy to Apache Tomcat 10.1.x

#### Option A: Automatic Deployment (Recommended)
1. Copy the generated file `target/smart-college-management-system.war`.
2. Paste it into the `webapps/` folder of your Apache Tomcat directory:
   - **Windows**: `C:\apache-tomcat-10.1.x\webapps\smart-college-management-system.war`
   - **Linux/Mac**: `/opt/tomcat/webapps/smart-college-management-system.war`
3. Start Tomcat:
   - **Windows**: Run `bin\startup.bat`
   - **Linux/Mac**: Run `bin/startup.sh`
4. Tomcat will automatically unpack the WAR archive into a folder of the same name.

#### Option B: Deploy via Tomcat Manager App
1. Open `http://localhost:8080/manager/html`
2. Under "WAR file to deploy", browse and choose `smart-college-management-system.war`.
3. Click **Deploy**.

---

### Step 6: Access the Application
Open your web browser and navigate to:
```
http://localhost:8080/smart-college-management-system/
```

---

## 🔑 Default Login Credentials

| Role | Username | Password | Notes |
|---|---|---|---|
| **Admin** | `admin` | `admin123` | Full access to all 12 modules, reports, students, faculty, departments & fees |
| **Faculty (HOD CSE)** | `faculty_sharma` | `faculty123` | Dr. Rajesh Sharma - Mark attendance, enter marks, approve leaves |
| **Faculty (IT)** | `faculty_priya` | `faculty123` | Prof. Priya Nair - Mark attendance, enter marks |
| **Faculty (ECE)** | `faculty_verma` | `faculty123` | Dr. Amit Verma - Mark attendance, enter marks |

---

## 📂 Project Directory Structure
```
smart-college-management-system/
├── pom.xml                               # Maven Project Descriptor (Tomcat 10.1 + Jakarta)
├── smart_college_db.sql                  # Complete MySQL Database Script (3NF + Seed Data)
├── README.md                             # Comprehensive Setup & Submission Guide
└── src/
    └── main/
        ├── java/
        │   └── com/college/
        │       ├── controller/          # Jakarta Servlets (Action Handlers)
        │       │   ├── AcademicRiskServlet.java
        │       │   ├── AttendanceServlet.java
        │       │   ├── DashboardServlet.java
        │       │   ├── DepartmentServlet.java
        │       │   ├── EnrollmentServlet.java
        │       │   ├── FacultyServlet.java
        │       │   ├── FeeServlet.java
        │       │   ├── LeaveServlet.java
        │       │   ├── LoginServlet.java
        │       │   ├── LogoutServlet.java
        │       │   ├── MarksServlet.java
        │       │   ├── ReportServlet.java
        │       │   ├── StudentServlet.java
        │       │   └── SubjectServlet.java
        │       ├── dao/                 # Data Access Objects (Raw SQL + PreparedStatement)
        │       │   ├── AcademicRiskDAO.java
        │       │   ├── AttendanceDAO.java
        │       │   ├── DashboardDAO.java
        │       │   ├── DepartmentDAO.java
        │       │   ├── EnrollmentDAO.java
        │       │   ├── FacultyDAO.java
        │       │   ├── FeeDAO.java
        │       │   ├── LeaveDAO.java
        │       │   ├── MarksDAO.java
        │       │   ├── ReportDAO.java
        │       │   ├── StudentDAO.java
        │       │   ├── SubjectDAO.java
        │       │   └── UserDAO.java
        │       ├── filter/              # Security Filters
        │       │   ├── AuthFilter.java
        │       │   └── EncodingFilter.java
        │       ├── model/               # Java Beans (POJOs)
        │       │   ├── AcademicRisk.java
        │       │   ├── Attendance.java
        │       │   ├── DashboardStats.java
        │       │   ├── Department.java
        │       │   ├── Enrollment.java
        │       │   ├── Faculty.java
        │       │   ├── FeePayment.java
        │       │   ├── LeaveRequest.java
        │       │   ├── Marks.java
        │       │   ├── Student.java
        │       │   ├── StudentFee.java
        │       │   ├── Subject.java
        │       │   └── User.java
        │       └── util/                # Database and Security Helpers
        │           ├── DBConnectionUtil.java
        │           ├── PasswordUtil.java
        │           └── ValidationUtil.java
        ├── resources/
        │   └── db.properties            # Centralized Database Configuration
        └── webapp/                      # Web Presentation Tier
            ├── WEB-INF/
            │   └── web.xml              # Deployment Descriptor (Servlet & Filter Mappings)
            ├── css/
            │   └── style.css            # Custom Styling & Modern Academic Theme
            ├── js/
            │   └── main.js              # Client Validations, Confirmations & Live Math
            ├── includes/
            │   ├── header.jsp           # Top Navigation Bar & User Profile Badge
            │   ├── sidebar.jsp          # Role-aware Sidebar Menu
            │   └── footer.jsp           # Standard Academic Footer & Script Imports
            ├── login.jsp                # Secure Authentication Portal
            ├── dashboard.jsp            # Executive Real-time Metric Dashboard
            ├── students.jsp             # Student Directory with Search & Filters
            ├── add-student.jsp          # Student Enrollment Form
            ├── edit-student.jsp         # Student Modification Form
            ├── student-profile.jsp      # 360-Degree Comprehensive Student Profile
            ├── departments.jsp          # Department Management
            ├── faculty.jsp              # Faculty Directory & Form
            ├── subjects.jsp             # Course / Subject Management
            ├── enrollments.jsp          # Subject Enrollment Junction Manager
            ├── attendance.jsp           # Faculty Attendance Marking Desk
            ├── view-attendance.jsp      # Subject-wise Attendance Percentage & History
            ├── marks.jsp                # Marks Entry Register
            ├── student-result.jsp       # Official Grade Card & Semester Transcript
            ├── fees.jsp                 # Student Accounts & Fee Ledger
            ├── add-payment.jsp          # Receipt Generation & Fee Collector
            ├── leaves.jsp               # Leave Application & Approval Desk
            ├── academic-risk.jsp        # Early Warning Center (Risk Detection System)
            └── reports.jsp              # Multi-faceted SQL Reporting Engine
```

---

## 🗄️ Database Design (Relational Schema & 3NF Proof)

### Normalization Justifications
- **1NF**: Every column contains atomic values; no repeating groups.
- **2NF**: Every non-key attribute is fully functionally dependent on the primary key. Junction tables (`enrollments`) have composite uniqueness to prevent partial dependencies.
- **3NF**: No transitive dependencies. Calculated values like attendance percentages and pending fee balances are computed dynamically in SQL views and DAO queries rather than stored statically.

### Schema Relationships Summary
1. `departments` (1) ── (N) `students`
2. `departments` (1) ── (N) `faculty`
3. `departments` (1) ── (N) `subjects`
4. `faculty` (1) ── (N) `subjects`
5. `students` (M) ── `enrollments` ── (N) `subjects` (Junction table)
6. `students` (1) ── (N) `attendance`
7. `subjects` (1) ── (N) `attendance`
8. `students` (1) ── (N) `marks`
9. `fee_structure` (1) ── (N) `student_fees`
10. `student_fees` (1) ── (N) `fee_payments`
11. `students` (1) ── (N) `leave_requests`

---

## ⚠️ Troubleshooting Common Errors

### 1. "HTTP Status 500 - Communications link failure"
- **Cause**: MySQL server is not running or password in `db.properties` is incorrect.
- **Fix**: Start MySQL service (`net start mysql` or via Services panel) and check `src/main/resources/db.properties`.

### 2. "java.lang.ClassNotFoundException: com.mysql.cj.jdbc.Driver"
- **Cause**: MySQL connector JAR was not packaged into the WAR.
- **Fix**: Ensure you ran `mvn clean package`. Maven automatically places `mysql-connector-j-8.3.0.jar` into `WEB-INF/lib/`.

### 3. "Tomcat 10.1 shows 404 or ClassCastException with javax.servlet"
- **Cause**: Using old Tomcat 9 or javax imports.
- **Fix**: This project strictly uses `jakarta.servlet.*` which requires **Apache Tomcat 10.0+ / 10.1+**. Do not deploy to Tomcat 9 or older.

---

## 🎓 Viva / Exam Defense Points
1. **Why use PreparedStatement instead of Statement?**
   PreparedStatement compiles the SQL query once and treats parameters as literals, preventing SQL injection and improving execution performance via query plan caching.
2. **How is Academic Risk calculated without machine learning?**
   It uses deterministic relational filtering based on academic regulations:
   `WHERE attendance_pct < 75.0 OR avg_marks < 50.0 OR pending_fees > 0`.
3. **How is the junction table implemented?**
   The `enrollments` table uses a composite unique constraint `UNIQUE KEY (student_id, subject_id)` with cascading foreign keys to represent the Many-to-Many relationship cleanly.
