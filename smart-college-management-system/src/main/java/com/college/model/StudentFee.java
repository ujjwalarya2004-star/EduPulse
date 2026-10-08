package com.college.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

public class StudentFee implements Serializable {
    private static final long serialVersionUID = 1L;

    private int studentFeeId;
    private int studentId;
    private int feeStructureId;
    private double totalAmount;
    private double paidAmount;
    private Date dueDate;
    private String status; // PAID, PARTIAL, PENDING
    private Timestamp createdAt;

    // Display
    private String studentName;
    private String enrollmentNo;
    private String deptCode;
    private int semester;

    public StudentFee() {}

    public int getStudentFeeId() { return studentFeeId; }
    public void setStudentFeeId(int studentFeeId) { this.studentFeeId = studentFeeId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getFeeStructureId() { return feeStructureId; }
    public void setFeeStructureId(int feeStructureId) { this.feeStructureId = feeStructureId; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public double getPaidAmount() { return paidAmount; }
    public void setPaidAmount(double paidAmount) { this.paidAmount = paidAmount; }

    public double getPendingAmount() {
        return Math.max(0.0, totalAmount - paidAmount);
    }

    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getEnrollmentNo() { return enrollmentNo; }
    public void setEnrollmentNo(String enrollmentNo) { this.enrollmentNo = enrollmentNo; }

    public String getDeptCode() { return deptCode; }
    public void setDeptCode(String deptCode) { this.deptCode = deptCode; }

    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }
}
