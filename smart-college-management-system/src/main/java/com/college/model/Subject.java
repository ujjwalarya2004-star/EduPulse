package com.college.model;

import java.io.Serializable;

public class Subject implements Serializable {
    private static final long serialVersionUID = 1L;

    private int subjectId;
    private String subjectCode;
    private String subjectName;
    private int credits;
    private int semester;
    private int deptId;
    private Integer facultyId;

    // Joined fields
    private String deptName;
    private String deptCode;
    private String facultyName;
    private int enrolledStudentCount;

    public Subject() {}

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public int getCredits() { return credits; }
    public void setCredits(int credits) { this.credits = credits; }

    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }

    public int getDeptId() { return deptId; }
    public void setDeptId(int deptId) { this.deptId = deptId; }

    public Integer getFacultyId() { return facultyId; }
    public void setFacultyId(Integer facultyId) { this.facultyId = facultyId; }

    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }

    public String getDeptCode() { return deptCode; }
    public void setDeptCode(String deptCode) { this.deptCode = deptCode; }

    public String getFacultyName() { return facultyName; }
    public void setFacultyName(String facultyName) { this.facultyName = facultyName; }

    public int getEnrolledStudentCount() { return enrolledStudentCount; }
    public void setEnrolledStudentCount(int enrolledStudentCount) { this.enrolledStudentCount = enrolledStudentCount; }
}
