package com.college.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

public class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    private int studentId;
    private String enrollmentNo;
    private String name;
    private String email;
    private String phone;
    private String gender; // MALE, FEMALE, OTHER
    private Date dob;
    private String address;
    private int deptId;
    private int semester;
    private int admissionYear;
    private String status; // ACTIVE, SUSPENDED, GRADUATED
    private Timestamp createdAt;

    // Relational display fields
    private String deptName;
    private String deptCode;

    // Calculated profile fields
    private double overallAttendancePct;
    private double avgMarks;
    private double pendingFees;
    private boolean academicRisk;

    public Student() {}

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getEnrollmentNo() { return enrollmentNo; }
    public void setEnrollmentNo(String enrollmentNo) { this.enrollmentNo = enrollmentNo; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public int getDeptId() { return deptId; }
    public void setDeptId(int deptId) { this.deptId = deptId; }

    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }

    public int getAdmissionYear() { return admissionYear; }
    public void setAdmissionYear(int admissionYear) { this.admissionYear = admissionYear; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }

    public String getDeptCode() { return deptCode; }
    public void setDeptCode(String deptCode) { this.deptCode = deptCode; }

    public double getOverallAttendancePct() { return overallAttendancePct; }
    public void setOverallAttendancePct(double overallAttendancePct) { this.overallAttendancePct = overallAttendancePct; }

    public double getAvgMarks() { return avgMarks; }
    public void setAvgMarks(double avgMarks) { this.avgMarks = avgMarks; }

    public double getPendingFees() { return pendingFees; }
    public void setPendingFees(double pendingFees) { this.pendingFees = pendingFees; }

    public boolean isAcademicRisk() { return academicRisk; }
    public void setAcademicRisk(boolean academicRisk) { this.academicRisk = academicRisk; }
}
