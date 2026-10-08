package com.college.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

public class Attendance implements Serializable {
    private static final long serialVersionUID = 1L;

    private int attendanceId;
    private int studentId;
    private int subjectId;
    private Date attendanceDate;
    private String status; // PRESENT or ABSENT
    private String remarks;
    private Integer markedBy;
    private Timestamp markedAt;

    // Summary fields
    private String studentName;
    private String enrollmentNo;
    private String subjectName;
    private String subjectCode;
    private int totalClasses;
    private int classesAttended;
    private double attendancePercentage;

    public Attendance() {}

    public int getAttendanceId() { return attendanceId; }
    public void setAttendanceId(int attendanceId) { this.attendanceId = attendanceId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public Date getAttendanceDate() { return attendanceDate; }
    public void setAttendanceDate(Date attendanceDate) { this.attendanceDate = attendanceDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public Integer getMarkedBy() { return markedBy; }
    public void setMarkedBy(Integer markedBy) { this.markedBy = markedBy; }

    public Timestamp getMarkedAt() { return markedAt; }
    public void setMarkedAt(Timestamp markedAt) { this.markedAt = markedAt; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getEnrollmentNo() { return enrollmentNo; }
    public void setEnrollmentNo(String enrollmentNo) { this.enrollmentNo = enrollmentNo; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public int getTotalClasses() { return totalClasses; }
    public void setTotalClasses(int totalClasses) { this.totalClasses = totalClasses; }

    public int getClassesAttended() { return classesAttended; }
    public void setClassesAttended(int classesAttended) { this.classesAttended = classesAttended; }

    public double getAttendancePercentage() { return attendancePercentage; }
    public void setAttendancePercentage(double attendancePercentage) { this.attendancePercentage = attendancePercentage; }

    public boolean isLowAttendance() {
        return this.attendancePercentage < 75.0;
    }
}
