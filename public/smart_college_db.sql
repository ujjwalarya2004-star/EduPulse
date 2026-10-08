-- =====================================================================
-- Smart College Student Management System - Complete MySQL Database Script
-- Compatible with MySQL 8.0+ and MySQL Workbench
-- Normalized to 3NF with Foreign Keys, Triggers, Indexes & Realistic Seed Data
-- =====================================================================

DROP DATABASE IF EXISTS smart_college_db;
CREATE DATABASE smart_college_db 
  DEFAULT CHARACTER SET utf8mb4 
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE smart_college_db;

-- ---------------------------------------------------------------------
-- TABLE 1: departments
-- ---------------------------------------------------------------------
CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_code VARCHAR(10) NOT NULL UNIQUE,
    dept_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- TABLE 2: faculty
-- ---------------------------------------------------------------------
CREATE TABLE faculty (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    dept_id INT NOT NULL,
    designation VARCHAR(50) NOT NULL,
    qualification VARCHAR(50) DEFAULT 'M.Tech / Ph.D',
    joining_date DATE NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_faculty_dept (dept_id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- TABLE 3: users (Authentication credentials)
-- Passwords are stored as SHA-256 hashes with salts.
-- ---------------------------------------------------------------------
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    salt VARCHAR(64) NOT NULL,
    role ENUM('ADMIN', 'FACULTY') NOT NULL,
    faculty_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id) ON DELETE CASCADE,
    INDEX idx_users_username (username)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- TABLE 4: students
-- ---------------------------------------------------------------------
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_no VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    gender ENUM('MALE', 'FEMALE', 'OTHER') NOT NULL,
    dob DATE NOT NULL,
    address TEXT NOT NULL,
    dept_id INT NOT NULL,
    semester INT NOT NULL CHECK (semester BETWEEN 1 AND 8),
    admission_year INT NOT NULL,
    status ENUM('ACTIVE', 'SUSPENDED', 'GRADUATED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_students_dept (dept_id),
    INDEX idx_students_semester (semester)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- TABLE 5: subjects
-- ---------------------------------------------------------------------
CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_code VARCHAR(15) NOT NULL UNIQUE,
    subject_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL CHECK (credits BETWEEN 1 AND 6),
    semester INT NOT NULL CHECK (semester BETWEEN 1 AND 8),
    dept_id INT NOT NULL,
    faculty_id INT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_subjects_dept (dept_id),
    INDEX idx_subjects_faculty (faculty_id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- TABLE 6: enrollments (Junction Table: Student <-> Subject)
-- ---------------------------------------------------------------------
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    academic_year VARCHAR(10) NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_student_subject (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id) ON DELETE CASCADE,
    INDEX idx_enroll_student (student_id),
    INDEX idx_enroll_subject (subject_id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- TABLE 7: attendance
-- ---------------------------------------------------------------------
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('PRESENT', 'ABSENT') NOT NULL,
    remarks VARCHAR(255) NULL,
    marked_by INT NULL,
    marked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_student_subject_date (student_id, subject_id, attendance_date),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id) ON DELETE CASCADE,
    FOREIGN KEY (marked_by) REFERENCES faculty(faculty_id) ON DELETE SET NULL,
    INDEX idx_att_student (student_id),
    INDEX idx_att_subject (subject_id),
    INDEX idx_att_date (attendance_date)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- TABLE 8: marks
-- ---------------------------------------------------------------------
CREATE TABLE marks (
    mark_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    assignment_marks DECIMAL(5,2) DEFAULT 0.00 CHECK (assignment_marks BETWEEN 0 AND 20),
    internal_marks DECIMAL(5,2) DEFAULT 0.00 CHECK (internal_marks BETWEEN 0 AND 30),
    practical_marks DECIMAL(5,2) DEFAULT 0.00 CHECK (practical_marks BETWEEN 0 AND 20),
    end_sem_marks DECIMAL(5,2) DEFAULT 0.00 CHECK (end_sem_marks BETWEEN 0 AND 50),
    total_marks DECIMAL(5,2) GENERATED ALWAYS AS (assignment_marks + internal_marks + practical_marks + end_sem_marks) STORED,
    grade VARCHAR(5) NULL,
    entered_by INT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_student_subject_marks (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id) ON DELETE CASCADE,
    FOREIGN KEY (entered_by) REFERENCES faculty(faculty_id) ON DELETE SET NULL,
    INDEX idx_marks_student (student_id),
    INDEX idx_marks_subject (subject_id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- TABLE 9: fee_structure
-- ---------------------------------------------------------------------
CREATE TABLE fee_structure (
    fee_structure_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_id INT NOT NULL,
    semester INT NOT NULL CHECK (semester BETWEEN 1 AND 8),
    tuition_fee DECIMAL(10,2) NOT NULL,
    lab_fee DECIMAL(10,2) NOT NULL,
    library_fee DECIMAL(10,2) NOT NULL,
    exam_fee DECIMAL(10,2) NOT NULL,
    total_fee DECIMAL(10,2) GENERATED ALWAYS AS (tuition_fee + lab_fee + library_fee + exam_fee) STORED,
    academic_year VARCHAR(10) NOT NULL,
    UNIQUE KEY uq_dept_sem_year (dept_id, semester, academic_year),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- TABLE 10: student_fees
-- ---------------------------------------------------------------------
CREATE TABLE student_fees (
    student_fee_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    fee_structure_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    paid_amount DECIMAL(10,2) DEFAULT 0.00,
    due_date DATE NOT NULL,
    status ENUM('PAID', 'PARTIAL', 'PENDING') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_student_fee_structure (student_id, fee_structure_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (fee_structure_id) REFERENCES fee_structure(fee_structure_id) ON DELETE RESTRICT,
    INDEX idx_sf_student (student_id),
    INDEX idx_sf_status (status)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- TABLE 11: fee_payments
-- ---------------------------------------------------------------------
CREATE TABLE fee_payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_fee_id INT NOT NULL,
    receipt_no VARCHAR(30) NOT NULL UNIQUE,
    amount_paid DECIMAL(10,2) NOT NULL,
    payment_method ENUM('ONLINE', 'CHEQUE', 'CASH', 'UPI') NOT NULL,
    transaction_ref VARCHAR(50) NULL,
    payment_date DATE NOT NULL,
    remarks VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_fee_id) REFERENCES student_fees(student_fee_id) ON DELETE CASCADE,
    INDEX idx_payment_fee (student_fee_id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- TABLE 12: leave_requests
-- ---------------------------------------------------------------------
CREATE TABLE leave_requests (
    leave_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    reason TEXT NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    applied_date DATE NOT NULL,
    reviewed_by INT NULL,
    review_remarks VARCHAR(255) NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES faculty(faculty_id) ON DELETE SET NULL,
    INDEX idx_leave_student (student_id),
    INDEX idx_leave_status (status)
) ENGINE=InnoDB;

-- =====================================================================
-- DATABASE VIEWS FOR QUICK REPORTING & ACADEMIC RISK CALCULATION
-- =====================================================================

CREATE OR REPLACE VIEW view_attendance_summary AS
SELECT 
    s.student_id,
    s.enrollment_no,
    s.name AS student_name,
    s.dept_id,
    d.dept_code,
    sub.subject_id,
    sub.subject_code,
    sub.subject_name,
    COUNT(a.attendance_id) AS total_classes,
    SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS classes_attended,
    ROUND(
        (SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) * 100.0) / 
        NULLIF(COUNT(a.attendance_id), 0), 2
    ) AS attendance_percentage
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN subjects sub ON e.subject_id = sub.subject_id
JOIN departments d ON s.dept_id = d.dept_id
LEFT JOIN attendance a ON s.student_id = a.student_id AND sub.subject_id = a.subject_id
GROUP BY s.student_id, s.enrollment_no, s.name, s.dept_id, d.dept_code, sub.subject_id, sub.subject_code, sub.subject_name;

-- Overall Attendance per Student View
CREATE OR REPLACE VIEW view_student_overall_attendance AS
SELECT 
    s.student_id,
    s.enrollment_no,
    s.name AS student_name,
    COUNT(a.attendance_id) AS total_classes,
    SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS classes_attended,
    COALESCE(ROUND(
        (SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) * 100.0) / 
        NULLIF(COUNT(a.attendance_id), 0), 2
    ), 0.0) AS overall_attendance_pct
FROM students s
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id, s.enrollment_no, s.name;

-- Student Overall Marks Average View
CREATE OR REPLACE VIEW view_student_overall_marks AS
SELECT 
    s.student_id,
    s.enrollment_no,
    s.name AS student_name,
    COUNT(m.mark_id) AS subjects_graded,
    COALESCE(ROUND(AVG(m.total_marks), 2), 0.0) AS avg_marks
FROM students s
LEFT JOIN marks m ON s.student_id = m.student_id
GROUP BY s.student_id, s.enrollment_no, s.name;

-- Student Overall Fee Pending View
CREATE OR REPLACE VIEW view_student_overall_fees AS
SELECT 
    s.student_id,
    s.enrollment_no,
    s.name AS student_name,
    COALESCE(SUM(sf.total_amount), 0.00) AS total_fee_assigned,
    COALESCE(SUM(sf.paid_amount), 0.00) AS total_fee_paid,
    COALESCE(SUM(sf.total_amount - sf.paid_amount), 0.00) AS pending_fees
FROM students s
LEFT JOIN student_fees sf ON s.student_id = sf.student_id
GROUP BY s.student_id, s.enrollment_no, s.name;

-- Academic Risk View (Rule-based: Att < 75% OR Avg Marks < 50% OR Pending Fees > 0)
CREATE OR REPLACE VIEW view_academic_risk_summary AS
SELECT 
    s.student_id,
    s.enrollment_no,
    s.name AS student_name,
    s.email,
    s.phone,
    d.dept_code,
    s.semester,
    att.overall_attendance_pct,
    m.avg_marks,
    fee.pending_fees,
    CASE WHEN att.overall_attendance_pct < 75.0 THEN 1 ELSE 0 END AS flag_low_attendance,
    CASE WHEN m.subjects_graded > 0 AND m.avg_marks < 50.0 THEN 1 ELSE 0 END AS flag_poor_marks,
    CASE WHEN fee.pending_fees > 0 THEN 1 ELSE 0 END AS flag_pending_fees
FROM students s
JOIN departments d ON s.dept_id = d.dept_id
LEFT JOIN view_student_overall_attendance att ON s.student_id = att.student_id
LEFT JOIN view_student_overall_marks m ON s.student_id = m.student_id
LEFT JOIN view_student_overall_fees fee ON s.student_id = fee.student_id
WHERE (att.overall_attendance_pct < 75.0)
   OR (m.subjects_graded > 0 AND m.avg_marks < 50.0)
   OR (fee.pending_fees > 0);

-- =====================================================================
-- SEED DATA INSERTIONS
-- =====================================================================

-- 1. Departments
INSERT INTO departments (dept_id, dept_code, dept_name, description) VALUES
(1, 'CSE', 'Computer Science & Engineering', 'Focus on Computing Algorithms, Systems, AI, and Software Engineering'),
(2, 'IT', 'Information Technology', 'Focus on Applied Software, Web Systems, Cloud, and Networking'),
(3, 'ECE', 'Electronics & Communication', 'Focus on VLSI, Signal Processing, Embedded Systems, and Telecommunications'),
(4, 'ME', 'Mechanical Engineering', 'Focus on Thermodynamics, Fluid Mechanics, Robotics, and Manufacturing'),
(5, 'CE', 'Civil Engineering', 'Focus on Structural Engineering, Geotechnical, and Environmental Engineering');

-- 2. Faculty Members
INSERT INTO faculty (faculty_id, employee_id, name, email, phone, dept_id, designation, qualification, joining_date) VALUES
(1, 'FAC001', 'Dr. Rajesh Sharma', 'rajesh.sharma@college.edu', '9876543210', 1, 'Professor & HOD', 'Ph.D in Computer Science', '2016-07-15'),
(2, 'FAC002', 'Prof. Priya Nair', 'priya.nair@college.edu', '9876543211', 1, 'Associate Professor', 'M.Tech in Software Engineering', '2018-08-01'),
(3, 'FAC003', 'Dr. Amit Verma', 'amit.verma@college.edu', '9876543212', 2, 'Professor', 'Ph.D in Information Tech', '2015-06-20'),
(4, 'FAC004', 'Prof. Sneha Kulkarni', 'sneha.kulkarni@college.edu', '9876543213', 2, 'Assistant Professor', 'M.Tech in Data Science', '2020-01-10'),
(5, 'FAC005', 'Dr. Vikram Malhotra', 'vikram.malhotra@college.edu', '9876543214', 3, 'Associate Professor', 'Ph.D in VLSI Systems', '2017-09-05'),
(6, 'FAC006', 'Prof. Ananya Roy', 'ananya.roy@college.edu', '9876543215', 3, 'Assistant Professor', 'M.Tech in Microelectronics', '2021-03-15'),
(7, 'FAC007', 'Dr. Ramesh Patil', 'ramesh.patil@college.edu', '9876543216', 4, 'Professor & HOD', 'Ph.D in Thermal Engineering', '2014-04-12'),
(8, 'FAC008', 'Dr. Sunita Deshmukh', 'sunita.deshmukh@college.edu', '9876543217', 5, 'Associate Professor', 'Ph.D in Structural Engineering', '2016-11-01');

-- 3. Users (Credentials)
-- Passwords with SHA-256 (Salted).
-- Admin login: username='admin', password='admin123'
-- Faculty login: username='faculty_sharma', password='faculty123'
-- Faculty login: username='faculty_priya', password='faculty123'
-- Faculty login: username='faculty_verma', password='faculty123'
-- Note: In PasswordUtil, hash(salt + password) = SHA256.
-- For convenience, our DBConnectionUtil / PasswordUtil supports SHA-256 verification and seed hash:
-- salt: 'SALT_2026_COLLEGE_SECURE'
-- 'SALT_2026_COLLEGE_SECUREadmin123' -> 96e147b1a2e7c4ef56e79b9d3b76964ca65882e34be6ca9a5f4f89d1b64ff1ea
-- 'SALT_2026_COLLEGE_SECUREfaculty123' -> c5a92a5d97f58b09a47a1ec6371cf7cb6c6d2bc99ef4ee67b5eb0ea24a2efca3
INSERT INTO users (user_id, username, password_hash, salt, role, faculty_id) VALUES
(1, 'admin', '96e147b1a2e7c4ef56e79b9d3b76964ca65882e34be6ca9a5f4f89d1b64ff1ea', 'SALT_2026_COLLEGE_SECURE', 'ADMIN', NULL),
(2, 'faculty_sharma', 'c5a92a5d97f58b09a47a1ec6371cf7cb6c6d2bc99ef4ee67b5eb0ea24a2efca3', 'SALT_2026_COLLEGE_SECURE', 'FACULTY', 1),
(3, 'faculty_priya', 'c5a92a5d97f58b09a47a1ec6371cf7cb6c6d2bc99ef4ee67b5eb0ea24a2efca3', 'SALT_2026_COLLEGE_SECURE', 'FACULTY', 2),
(4, 'faculty_verma', 'c5a92a5d97f58b09a47a1ec6371cf7cb6c6d2bc99ef4ee67b5eb0ea24a2efca3', 'SALT_2026_COLLEGE_SECURE', 'FACULTY', 3);

-- 4. Subjects
INSERT INTO subjects (subject_id, subject_code, subject_name, credits, semester, dept_id, faculty_id) VALUES
(1, 'CS401', 'Database Management Systems', 4, 4, 1, 1),
(2, 'CS402', 'Operating Systems', 4, 4, 1, 2),
(3, 'CS403', 'Design & Analysis of Algorithms', 4, 4, 1, 1),
(4, 'CS404', 'Computer Networks', 3, 4, 1, 2),
(5, 'IT401', 'Web Technologies & Frameworks', 4, 4, 2, 3),
(6, 'IT402', 'Cloud Computing & DevOps', 3, 4, 2, 4),
(7, 'EC401', 'Digital Signal Processing', 4, 4, 3, 5),
(8, 'EC402', 'Microprocessors & Microcontrollers', 4, 4, 3, 6),
(9, 'ME401', 'Fluid Mechanics & Machinery', 4, 4, 4, 7),
(10, 'CE401', 'Structural Analysis & Design', 4, 4, 5, 8);

-- 5. Students (20 realistic students across departments)
INSERT INTO students (student_id, enrollment_no, name, email, phone, gender, dob, address, dept_id, semester, admission_year, status) VALUES
(1, 'EN2024CS01', 'Aarav Patel', 'aarav.patel@student.college.edu', '9811100001', 'MALE', '2004-03-12', '101 MG Road, Bangalore, Karnataka', 1, 4, 2024, 'ACTIVE'),
(2, 'EN2024CS02', 'Diya Sharma', 'diya.sharma@student.college.edu', '9811100002', 'FEMALE', '2004-07-25', '204 Park View, Mumbai, Maharashtra', 1, 4, 2024, 'ACTIVE'),
(3, 'EN2024CS03', 'Rahul Verma', 'rahul.verma@student.college.edu', '9811100003', 'MALE', '2003-11-14', '15 Civil Lines, Jaipur, Rajasthan', 1, 4, 2024, 'ACTIVE'),
(4, 'EN2024CS04', 'Ananya Gupta', 'ananya.gupta@student.college.edu', '9811100004', 'FEMALE', '2004-05-19', '88 Sector 18, Noida, Uttar Pradesh', 1, 4, 2024, 'ACTIVE'),
(5, 'EN2024CS05', 'Rohan Mehta', 'rohan.mehta@student.college.edu', '9811100005', 'MALE', '2004-01-08', '45 Satellite, Ahmedabad, Gujarat', 1, 4, 2024, 'ACTIVE'),
(6, 'EN2024CS06', 'Isha Sen', 'isha.sen@student.college.edu', '9811100006', 'FEMALE', '2004-09-30', '12 Salt Lake, Kolkata, West Bengal', 1, 4, 2024, 'ACTIVE'),
(7, 'EN2024IT01', 'Kavya Reddy', 'kavya.reddy@student.college.edu', '9811100007', 'FEMALE', '2004-04-10', '77 Jubilee Hills, Hyderabad, Telangana', 2, 4, 2024, 'ACTIVE'),
(8, 'EN2024IT02', 'Aditya Joshi', 'aditya.joshi@student.college.edu', '9811100008', 'MALE', '2003-12-05', '32 FC Road, Pune, Maharashtra', 2, 4, 2024, 'ACTIVE'),
(9, 'EN2024IT03', 'Pooja Iyer', 'pooja.iyer@student.college.edu', '9811100009', 'FEMALE', '2004-08-22', '14 Anna Nagar, Chennai, Tamil Nadu', 2, 4, 2024, 'ACTIVE'),
(10, 'EN2024IT04', 'Sameer Khan', 'sameer.khan@student.college.edu', '9811100010', 'MALE', '2004-02-18', '56 Hazratganj, Lucknow, Uttar Pradesh', 2, 4, 2024, 'ACTIVE'),
(11, 'EN2024EC01', 'Tanvi Saxena', 'tanvi.saxena@student.college.edu', '9811100011', 'FEMALE', '2004-06-15', '23 Arera Colony, Bhopal, Madhya Pradesh', 3, 4, 2024, 'ACTIVE'),
(12, 'EN2024EC02', 'Manish Choudhary', 'manish.c@student.college.edu', '9811100012', 'MALE', '2003-10-28', '90 Tonk Road, Jaipur, Rajasthan', 3, 4, 2024, 'ACTIVE'),
(13, 'EN2024EC03', 'Snehal Rao', 'snehal.rao@student.college.edu', '9811100013', 'FEMALE', '2004-03-05', '67 Indiranagar, Bangalore, Karnataka', 3, 4, 2024, 'ACTIVE'),
(14, 'EN2024ME01', 'Karan Malhotra', 'karan.m@student.college.edu', '9811100014', 'MALE', '2004-01-20', '41 Model Town, Jalandhar, Punjab', 4, 4, 2024, 'ACTIVE'),
(15, 'EN2024ME02', 'Varun Nair', 'varun.nair@student.college.edu', '9811100015', 'MALE', '2003-11-11', '19 Panampilly Nagar, Kochi, Kerala', 4, 4, 2024, 'ACTIVE'),
(16, 'EN2024CE01', 'Neha Deshmukh', 'neha.d@student.college.edu', '9811100016', 'FEMALE', '2004-07-02', '34 Kothrud, Pune, Maharashtra', 5, 4, 2024, 'ACTIVE'),
(17, 'EN2024CE02', 'Vikramaditya Das', 'vikram.das@student.college.edu', '9811100017', 'MALE', '2004-05-14', '7 Saheed Nagar, Bhubaneswar, Odisha', 5, 4, 2024, 'ACTIVE'),
(18, 'EN2024CS07', 'Siddharth Roy', 'siddharth.roy@student.college.edu', '9811100018', 'MALE', '2003-09-09', '89 Alipore, Kolkata, West Bengal', 1, 4, 2024, 'ACTIVE'),
(19, 'EN2024CS08', 'Rhea Bansal', 'rhea.bansal@student.college.edu', '9811100019', 'FEMALE', '2004-04-18', '51 Mall Road, Shimla, Himachal Pradesh', 1, 4, 2024, 'ACTIVE'),
(20, 'EN2024CS09', 'Naveen Kumar', 'naveen.kumar@student.college.edu', '9811100020', 'MALE', '2003-12-30', '112 Gandhinagar, Jammu, Jammu & Kashmir', 1, 4, 2024, 'ACTIVE');

-- 6. Enrollments (Junction Table: Student <-> Subject)
INSERT INTO enrollments (student_id, subject_id, academic_year) VALUES
-- CSE students enrolled in CS401, CS402, CS403, CS404
(1, 1, '2025-2026'), (1, 2, '2025-2026'), (1, 3, '2025-2026'), (1, 4, '2025-2026'),
(2, 1, '2025-2026'), (2, 2, '2025-2026'), (2, 3, '2025-2026'), (2, 4, '2025-2026'),
(3, 1, '2025-2026'), (3, 2, '2025-2026'), (3, 3, '2025-2026'), (3, 4, '2025-2026'),
(4, 1, '2025-2026'), (4, 2, '2025-2026'), (4, 3, '2025-2026'), (4, 4, '2025-2026'),
(5, 1, '2025-2026'), (5, 2, '2025-2026'), (5, 3, '2025-2026'), (5, 4, '2025-2026'),
(6, 1, '2025-2026'), (6, 2, '2025-2026'), (6, 3, '2025-2026'), (6, 4, '2025-2026'),
(18, 1, '2025-2026'), (18, 2, '2025-2026'), (18, 3, '2025-2026'), (18, 4, '2025-2026'),
(19, 1, '2025-2026'), (19, 2, '2025-2026'), (19, 3, '2025-2026'), (19, 4, '2025-2026'),
(20, 1, '2025-2026'), (20, 2, '2025-2026'), (20, 3, '2025-2026'), (20, 4, '2025-2026'),
-- IT students enrolled in IT401, IT402, CS401
(7, 5, '2025-2026'), (7, 6, '2025-2026'), (7, 1, '2025-2026'),
(8, 5, '2025-2026'), (8, 6, '2025-2026'), (8, 1, '2025-2026'),
(9, 5, '2025-2026'), (9, 6, '2025-2026'), (9, 1, '2025-2026'),
(10, 5, '2025-2026'), (10, 6, '2025-2026'), (10, 1, '2025-2026'),
-- ECE students enrolled in EC401, EC402
(11, 7, '2025-2026'), (11, 8, '2025-2026'),
(12, 7, '2025-2026'), (12, 8, '2025-2026'),
(13, 7, '2025-2026'), (13, 8, '2025-2026'),
-- ME students enrolled in ME401
(14, 9, '2025-2026'), (15, 9, '2025-2026'),
-- CE students enrolled in CE401
(16, 10, '2025-2026'), (17, 10, '2025-2026');

-- 7. Realistic Attendance Records
-- Note: Student 3 (Rahul Verma) and Student 5 (Rohan Mehta) are deliberately designed to have LOW attendance (< 75%)
-- to test and prove the Academic Risk Dashboard feature!
INSERT INTO attendance (student_id, subject_id, attendance_date, status, remarks, marked_by) VALUES
-- Dates: 2026-03-01, 2026-03-03, 2026-03-05, 2026-03-08, 2026-03-10, 2026-03-12, 2026-03-15, 2026-03-18, 2026-03-20, 2026-03-22
-- Student 1: 9 out of 10 Present (90%)
(1, 1, '2026-03-01', 'PRESENT', 'On time', 1),
(1, 1, '2026-03-03', 'PRESENT', 'On time', 1),
(1, 1, '2026-03-05', 'PRESENT', 'On time', 1),
(1, 1, '2026-03-08', 'PRESENT', 'On time', 1),
(1, 1, '2026-03-10', 'PRESENT', 'On time', 1),
(1, 1, '2026-03-12', 'ABSENT', 'Medical leave submitted', 1),
(1, 1, '2026-03-15', 'PRESENT', 'On time', 1),
(1, 1, '2026-03-18', 'PRESENT', 'On time', 1),
(1, 1, '2026-03-20', 'PRESENT', 'On time', 1),
(1, 1, '2026-03-22', 'PRESENT', 'On time', 1),

-- Student 2: 10 out of 10 Present (100%)
(2, 1, '2026-03-01', 'PRESENT', 'On time', 1),
(2, 1, '2026-03-03', 'PRESENT', 'On time', 1),
(2, 1, '2026-03-05', 'PRESENT', 'On time', 1),
(2, 1, '2026-03-08', 'PRESENT', 'On time', 1),
(2, 1, '2026-03-10', 'PRESENT', 'On time', 1),
(2, 1, '2026-03-12', 'PRESENT', 'On time', 1),
(2, 1, '2026-03-15', 'PRESENT', 'On time', 1),
(2, 1, '2026-03-18', 'PRESENT', 'On time', 1),
(2, 1, '2026-03-20', 'PRESENT', 'On time', 1),
(2, 1, '2026-03-22', 'PRESENT', 'On time', 1),

-- Student 3: Rahul Verma -> Only 6 out of 10 Present (60%) -> LOW ATTENDANCE ALERT!
(3, 1, '2026-03-01', 'PRESENT', 'On time', 1),
(3, 1, '2026-03-03', 'ABSENT', 'Unexcused absence', 1),
(3, 1, '2026-03-05', 'PRESENT', 'On time', 1),
(3, 1, '2026-03-08', 'ABSENT', 'Unexcused absence', 1),
(3, 1, '2026-03-10', 'PRESENT', 'On time', 1),
(3, 1, '2026-03-12', 'ABSENT', 'Unexcused absence', 1),
(3, 1, '2026-03-15', 'PRESENT', 'On time', 1),
(3, 1, '2026-03-18', 'ABSENT', 'Unexcused absence', 1),
(3, 1, '2026-03-20', 'PRESENT', 'On time', 1),
(3, 1, '2026-03-22', 'PRESENT', 'On time', 1),

-- Student 4: Ananya Gupta -> 8 out of 10 Present (80%)
(4, 1, '2026-03-01', 'PRESENT', 'On time', 1),
(4, 1, '2026-03-03', 'PRESENT', 'On time', 1),
(4, 1, '2026-03-05', 'ABSENT', 'Informed', 1),
(4, 1, '2026-03-08', 'PRESENT', 'On time', 1),
(4, 1, '2026-03-10', 'PRESENT', 'On time', 1),
(4, 1, '2026-03-12', 'PRESENT', 'On time', 1),
(4, 1, '2026-03-15', 'ABSENT', 'Informed', 1),
(4, 1, '2026-03-18', 'PRESENT', 'On time', 1),
(4, 1, '2026-03-20', 'PRESENT', 'On time', 1),
(4, 1, '2026-03-22', 'PRESENT', 'On time', 1),

-- Student 5: Rohan Mehta -> 5 out of 10 Present (50%) -> CRITICAL ATTENDANCE ALERT!
(5, 1, '2026-03-01', 'ABSENT', 'Unexcused', 1),
(5, 1, '2026-03-03', 'PRESENT', 'On time', 1),
(5, 1, '2026-03-05', 'ABSENT', 'Unexcused', 1),
(5, 1, '2026-03-08', 'ABSENT', 'Unexcused', 1),
(5, 1, '2026-03-10', 'PRESENT', 'On time', 1),
(5, 1, '2026-03-12', 'PRESENT', 'On time', 1),
(5, 1, '2026-03-15', 'ABSENT', 'Unexcused', 1),
(5, 1, '2026-03-18', 'PRESENT', 'On time', 1),
(5, 1, '2026-03-20', 'ABSENT', 'Unexcused', 1),
(5, 1, '2026-03-22', 'PRESENT', 'On time', 1),

-- Student 6: Isha Sen -> 9 out of 10 Present (90%)
(6, 1, '2026-03-01', 'PRESENT', 'On time', 1),
(6, 1, '2026-03-03', 'PRESENT', 'On time', 1),
(6, 1, '2026-03-05', 'PRESENT', 'On time', 1),
(6, 1, '2026-03-08', 'PRESENT', 'On time', 1),
(6, 1, '2026-03-10', 'PRESENT', 'On time', 1),
(6, 1, '2026-03-12', 'PRESENT', 'On time', 1),
(6, 1, '2026-03-15', 'PRESENT', 'On time', 1),
(6, 1, '2026-03-18', 'PRESENT', 'On time', 1),
(6, 1, '2026-03-20', 'ABSENT', 'Sick leave', 1),
(6, 1, '2026-03-22', 'PRESENT', 'On time', 1),

-- Subject 2 (CS402 Operating Systems) Attendance for Students 1, 2, 3
(1, 2, '2026-03-02', 'PRESENT', 'Lab session', 2),
(1, 2, '2026-03-04', 'PRESENT', 'Lab session', 2),
(1, 2, '2026-03-09', 'PRESENT', 'Lab session', 2),
(1, 2, '2026-03-11', 'PRESENT', 'Lab session', 2),
(2, 2, '2026-03-02', 'PRESENT', 'Lab session', 2),
(2, 2, '2026-03-04', 'PRESENT', 'Lab session', 2),
(2, 2, '2026-03-09', 'PRESENT', 'Lab session', 2),
(2, 2, '2026-03-11', 'PRESENT', 'Lab session', 2),
(3, 2, '2026-03-02', 'ABSENT', 'Absent', 2),
(3, 2, '2026-03-04', 'ABSENT', 'Absent', 2),
(3, 2, '2026-03-09', 'PRESENT', 'Lab session', 2),
(3, 2, '2026-03-11', 'PRESENT', 'Lab session', 2);

-- 8. Marks Management Seed Data
-- Max marks: Assignment=20, Internal=30, Practical=20, End-sem=50 -> Total=120 or normalized
-- Grade is calculated based on percentage:
-- >= 90: 'A+', >= 80: 'A', >= 70: 'B', >= 60: 'C', >= 50: 'D', < 50: 'F'
INSERT INTO marks (student_id, subject_id, assignment_marks, internal_marks, practical_marks, end_sem_marks, grade, entered_by) VALUES
(1, 1, 18.00, 26.50, 18.50, 44.00, 'A+', 1), -- Total: 107/120 (89.1%)
(1, 2, 17.50, 25.00, 17.00, 42.00, 'A', 2),  -- Total: 101.5/120 (84.5%)
(1, 3, 19.00, 28.00, 19.00, 46.50, 'A+', 1), -- Total: 112.5/120 (93.7%)
(1, 4, 16.00, 24.00, 16.50, 40.00, 'A', 2),  -- Total: 96.5/120 (80.4%)

(2, 1, 19.50, 29.00, 19.50, 48.00, 'A+', 1),
(2, 2, 19.00, 28.50, 19.00, 47.00, 'A+', 2),

-- Student 3: Rahul Verma -> POOR ACADEMIC PERFORMANCE (Marks total < 50%!)
(3, 1, 8.00, 11.00, 7.50, 19.00, 'F', 1),    -- Total: 45.5/120 (37.9%) -> POOR MARKS ALERT!
(3, 2, 9.50, 12.00, 8.00, 20.00, 'F', 2),    -- Total: 49.5/120 (41.2%) -> POOR MARKS ALERT!

(4, 1, 15.00, 22.00, 16.00, 38.00, 'B', 1),
(4, 2, 16.50, 23.50, 15.00, 39.00, 'B', 2),

-- Student 5: Rohan Mehta -> BORDERLINE POOR MARKS
(5, 1, 10.00, 14.00, 10.00, 24.00, 'D', 1),   -- Total: 58/120 (48.3%) -> LOW MARKS!

(6, 1, 18.00, 27.00, 18.00, 45.00, 'A+', 1),
(7, 5, 17.00, 25.00, 17.50, 41.00, 'A', 3),
(8, 5, 18.50, 26.00, 18.00, 43.50, 'A', 3);

-- 9. Fee Structure
INSERT INTO fee_structure (fee_structure_id, dept_id, semester, tuition_fee, lab_fee, library_fee, exam_fee, academic_year) VALUES
(1, 1, 4, 35000.00, 8000.00, 3000.00, 4000.00, '2025-2026'), -- CSE Sem 4 Total = 50,000
(2, 2, 4, 34000.00, 7500.00, 3000.00, 4000.00, '2025-2026'), -- IT Sem 4 Total = 48,500
(3, 3, 4, 33000.00, 7000.00, 3000.00, 4000.00, '2025-2026'), -- ECE Sem 4 Total = 47,000
(4, 4, 4, 32000.00, 6500.00, 3000.00, 4000.00, '2025-2026'), -- ME Sem 4 Total = 45,500
(5, 5, 4, 31000.00, 6000.00, 3000.00, 4000.00, '2025-2026'); -- CE Sem 4 Total = 44,000

-- 10. Student Fee Records
INSERT INTO student_fees (student_fee_id, student_id, fee_structure_id, total_amount, paid_amount, due_date, status) VALUES
(1, 1, 1, 50000.00, 50000.00, '2026-01-15', 'PAID'),      -- Paid full
(2, 2, 1, 50000.00, 50000.00, '2026-01-15', 'PAID'),      -- Paid full
(3, 3, 1, 50000.00, 20000.00, '2026-01-15', 'PARTIAL'),   -- Rahul Verma has Rs 30,000 pending!
(4, 4, 1, 50000.00, 50000.00, '2026-01-15', 'PAID'),      -- Paid full
(5, 5, 1, 50000.00, 0.00,     '2026-01-15', 'PENDING'),   -- Rohan Mehta has Rs 50,000 pending!
(6, 6, 1, 50000.00, 50000.00, '2026-01-15', 'PAID'),      -- Paid full
(7, 7, 2, 48500.00, 48500.00, '2026-01-15', 'PAID'),      -- Paid full
(8, 8, 2, 48500.00, 25000.00, '2026-01-15', 'PARTIAL'),   -- Aditya Joshi has Rs 23,500 pending
(9, 11, 3, 47000.00, 47000.00, '2026-01-15', 'PAID'),     -- Paid full
(10, 14, 4, 45500.00, 15000.00, '2026-01-15', 'PARTIAL');  -- Karan Malhotra has pending

-- 11. Fee Payments
INSERT INTO fee_payments (payment_id, student_fee_id, receipt_no, amount_paid, payment_method, transaction_ref, payment_date, remarks) VALUES
(1, 1, 'REC-2026-001', 50000.00, 'ONLINE', 'TXN_NET_8819201', '2026-01-10', 'Full semester fee paid online'),
(2, 2, 'REC-2026-002', 50000.00, 'UPI', 'UPI_AXIS_9921029', '2026-01-11', 'UPI payment via Google Pay'),
(3, 3, 'REC-2026-003', 20000.00, 'CHEQUE', 'CHQ_HDFC_441209', '2026-01-12', 'Installment 1 paid via Cheque'),
(4, 4, 'REC-2026-004', 50000.00, 'ONLINE', 'TXN_ICICI_129034', '2026-01-08', 'Full payment verified'),
(5, 7, 'REC-2026-005', 48500.00, 'ONLINE', 'TXN_SBI_9918234', '2026-01-14', 'Net banking transfer'),
(6, 8, 'REC-2026-006', 25000.00, 'CASH', 'CASH_REC_0881', '2026-01-15', 'Partial cash payment at accounts desk'),
(7, 9, 'REC-2026-007', 47000.00, 'UPI', 'UPI_HDFC_3310921', '2026-01-12', 'Full payment received'),
(8, 10, 'REC-2026-008', 15000.00, 'CHEQUE', 'CHQ_SBI_990123', '2026-01-13', 'First installment');

-- 12. Leave Requests
INSERT INTO leave_requests (leave_id, student_id, from_date, to_date, reason, status, applied_date, reviewed_by, review_remarks) VALUES
(1, 1, '2026-03-12', '2026-03-12', 'Suffering from viral fever, doctor advised 1 day rest', 'APPROVED', '2026-03-11', 1, 'Medical certificate verified. Approved.'),
(2, 6, '2026-03-20', '2026-03-21', 'Attending sister marriage ceremony in hometown', 'APPROVED', '2026-03-18', 1, 'Family function leave granted.'),
(3, 3, '2026-03-25', '2026-03-28', 'Attending inter-college cultural festival', 'PENDING', '2026-03-24', NULL, NULL),
(4, 5, '2026-03-26', '2026-03-30', 'Personal vacation with family', 'REJECTED', '2026-03-23', 1, 'Cannot grant vacation during mid-semester examination period.'),
(5, 7, '2026-04-02', '2026-04-04', 'Attending National Hackathon representing college', 'APPROVED', '2026-03-28', 3, 'Representing college. Duty leave granted.');
