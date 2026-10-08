package com.college.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class AcademicRisk implements Serializable {
    private static final long serialVersionUID = 1L;

    private int studentId;
    private String enrollmentNo;
    private String studentName;
    private String email;
    private String phone;
    private String deptCode;
    private int semester;
    private double overallAttendancePct;
    private double avgMarks;
    private double pendingFees;
    private boolean lowAttendanceFlag;
    private boolean poorMarksFlag;
    private boolean pendingFeesFlag;

    public AcademicRisk() {}

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getEnrollmentNo() { return enrollmentNo; }
    public void setEnrollmentNo(String enrollmentNo) { this.enrollmentNo = enrollmentNo; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getDeptCode() { return deptCode; }
    public void setDeptCode(String deptCode) { this.deptCode = deptCode; }

    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }

    public double getOverallAttendancePct() { return overallAttendancePct; }
    public void setOverallAttendancePct(double overallAttendancePct) { this.overallAttendancePct = overallAttendancePct; }

    public double getAvgMarks() { return avgMarks; }
    public void setAvgMarks(double avgMarks) { this.avgMarks = avgMarks; }

    public double getPendingFees() { return pendingFees; }
    public void setPendingFees(double pendingFees) { this.pendingFees = pendingFees; }

    public boolean isLowAttendanceFlag() { return lowAttendanceFlag; }
    public void setLowAttendanceFlag(boolean lowAttendanceFlag) { this.lowAttendanceFlag = lowAttendanceFlag; }

    public boolean isPoorMarksFlag() { return poorMarksFlag; }
    public void setPoorMarksFlag(boolean poorMarksFlag) { this.poorMarksFlag = poorMarksFlag; }

    public boolean isPendingFeesFlag() { return pendingFeesFlag; }
    public void setPendingFeesFlag(boolean pendingFeesFlag) { this.pendingFeesFlag = pendingFeesFlag; }

    public List<String> getRiskReasons() {
        List<String> reasons = new ArrayList<>();
        if (lowAttendanceFlag) {
            reasons.add("Attendance: " + overallAttendancePct + "% (< 75% threshold)");
        }
        if (poorMarksFlag) {
            reasons.add("Average Marks: " + avgMarks + " / 120 (< 50% passing)");
        }
        if (pendingFeesFlag) {
            reasons.add("Pending Fees: ₹" + String.format("%,.2f", pendingFees));
        }
        return reasons;
    }
}
