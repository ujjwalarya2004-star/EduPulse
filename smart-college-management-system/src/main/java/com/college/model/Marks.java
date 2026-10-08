package com.college.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Marks implements Serializable {
    private static final long serialVersionUID = 1L;

    private int markId;
    private int studentId;
    private int subjectId;
    private double assignmentMarks; // out of 20
    private double internalMarks;   // out of 30
    private double practicalMarks;  // out of 20
    private double endSemMarks;     // out of 50
    private double totalMarks;      // sum: max 120
    private String grade;
    private Integer enteredBy;
    private Timestamp updatedAt;

    // Display
    private String studentName;
    private String enrollmentNo;
    private String subjectName;
    private String subjectCode;
    private int credits;

    public Marks() {}

    public int getMarkId() { return markId; }
    public void setMarkId(int markId) { this.markId = markId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public double getAssignmentMarks() { return assignmentMarks; }
    public void setAssignmentMarks(double assignmentMarks) { this.assignmentMarks = assignmentMarks; }

    public double getInternalMarks() { return internalMarks; }
    public void setInternalMarks(double internalMarks) { this.internalMarks = internalMarks; }

    public double getPracticalMarks() { return practicalMarks; }
    public void setPracticalMarks(double practicalMarks) { this.practicalMarks = practicalMarks; }

    public double getEndSemMarks() { return endSemMarks; }
    public void setEndSemMarks(double endSemMarks) { this.endSemMarks = endSemMarks; }

    public double getTotalMarks() { return totalMarks; }
    public void setTotalMarks(double totalMarks) { this.totalMarks = totalMarks; }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }

    public Integer getEnteredBy() { return enteredBy; }
    public void setEnteredBy(Integer enteredBy) { this.enteredBy = enteredBy; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getEnrollmentNo() { return enrollmentNo; }
    public void setEnrollmentNo(String enrollmentNo) { this.enrollmentNo = enrollmentNo; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public int getCredits() { return credits; }
    public void setCredits(int credits) { this.credits = credits; }

    public double getPercentage() {
        return Math.round((totalMarks / 120.0 * 100.0) * 10.0) / 10.0;
    }
}
