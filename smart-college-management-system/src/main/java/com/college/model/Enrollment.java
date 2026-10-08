package com.college.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Enrollment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int enrollmentId;
    private int studentId;
    private int subjectId;
    private String academicYear;
    private Timestamp enrolledAt;

    // Display fields
    private String studentName;
    private String enrollmentNo;
    private String subjectName;
    private String subjectCode;
    private String deptCode;

    public Enrollment() {}

    public int getEnrollmentId() { return enrollmentId; }
    public void setEnrollmentId(int enrollmentId) { this.enrollmentId = enrollmentId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public String getAcademicYear() { return academicYear; }
    public void setAcademicYear(String academicYear) { this.academicYear = academicYear; }

    public Timestamp getEnrolledAt() { return enrolledAt; }
    public void setEnrolledAt(Timestamp enrolledAt) { this.enrolledAt = enrolledAt; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getEnrollmentNo() { return enrollmentNo; }
    public void setEnrollmentNo(String enrollmentNo) { this.enrollmentNo = enrollmentNo; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public String getDeptCode() { return deptCode; }
    public void setDeptCode(String deptCode) { this.deptCode = deptCode; }
}
