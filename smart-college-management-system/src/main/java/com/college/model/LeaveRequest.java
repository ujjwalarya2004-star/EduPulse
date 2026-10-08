package com.college.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

public class LeaveRequest implements Serializable {
    private static final long serialVersionUID = 1L;

    private int leaveId;
    private int studentId;
    private Date fromDate;
    private Date toDate;
    private String reason;
    private String status; // PENDING, APPROVED, REJECTED
    private Date appliedDate;
    private Integer reviewedBy;
    private String reviewRemarks;
    private Timestamp updatedAt;

    // Display
    private String studentName;
    private String enrollmentNo;
    private String deptCode;
    private String reviewerName;

    public LeaveRequest() {}

    public int getLeaveId() { return leaveId; }
    public void setLeaveId(int leaveId) { this.leaveId = leaveId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public Date getFromDate() { return fromDate; }
    public void setFromDate(Date fromDate) { this.fromDate = fromDate; }

    public Date getToDate() { return toDate; }
    public void setToDate(Date toDate) { this.toDate = toDate; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getAppliedDate() { return appliedDate; }
    public void setAppliedDate(Date appliedDate) { this.appliedDate = appliedDate; }

    public Integer getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(Integer reviewedBy) { this.reviewedBy = reviewedBy; }

    public String getReviewRemarks() { return reviewRemarks; }
    public void setReviewRemarks(String reviewRemarks) { this.reviewRemarks = reviewRemarks; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getEnrollmentNo() { return enrollmentNo; }
    public void setEnrollmentNo(String enrollmentNo) { this.enrollmentNo = enrollmentNo; }

    public String getDeptCode() { return deptCode; }
    public void setDeptCode(String deptCode) { this.deptCode = deptCode; }

    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }
}
