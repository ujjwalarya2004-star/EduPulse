package com.college.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Department implements Serializable {
    private static final long serialVersionUID = 1L;

    private int deptId;
    private String deptCode;
    private String deptName;
    private String description;
    private Timestamp createdAt;

    // Analytical counts
    private int studentCount;
    private int facultyCount;
    private int subjectCount;

    public Department() {}

    public Department(int deptId, String deptCode, String deptName, String description) {
        this.deptId = deptId;
        this.deptCode = deptCode;
        this.deptName = deptName;
        this.description = description;
    }

    public int getDeptId() { return deptId; }
    public void setDeptId(int deptId) { this.deptId = deptId; }

    public String getDeptCode() { return deptCode; }
    public void setDeptCode(String deptCode) { this.deptCode = deptCode; }

    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public int getStudentCount() { return studentCount; }
    public void setStudentCount(int studentCount) { this.studentCount = studentCount; }

    public int getFacultyCount() { return facultyCount; }
    public void setFacultyCount(int facultyCount) { this.facultyCount = facultyCount; }

    public int getSubjectCount() { return subjectCount; }
    public void setSubjectCount(int subjectCount) { this.subjectCount = subjectCount; }
}
