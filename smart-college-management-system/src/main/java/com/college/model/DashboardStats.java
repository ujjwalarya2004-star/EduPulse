package com.college.model;

import java.io.Serializable;

public class DashboardStats implements Serializable {
    private static final long serialVersionUID = 1L;

    private int totalStudents;
    private int totalFaculty;
    private int totalSubjects;
    private int totalDepartments;
    private int lowAttendanceStudentsCount;
    private int pendingFeeStudentsCount;
    private int riskStudentsCount;
    private int pendingLeaveRequestsCount;
    private double totalFeesCollected;
    private double totalFeesPending;

    public DashboardStats() {}

    public int getTotalStudents() { return totalStudents; }
    public void setTotalStudents(int totalStudents) { this.totalStudents = totalStudents; }

    public int getTotalFaculty() { return totalFaculty; }
    public void setTotalFaculty(int totalFaculty) { this.totalFaculty = totalFaculty; }

    public int getTotalSubjects() { return totalSubjects; }
    public void setTotalSubjects(int totalSubjects) { this.totalSubjects = totalSubjects; }

    public int getTotalDepartments() { return totalDepartments; }
    public void setTotalDepartments(int totalDepartments) { this.totalDepartments = totalDepartments; }

    public int getLowAttendanceStudentsCount() { return lowAttendanceStudentsCount; }
    public void setLowAttendanceStudentsCount(int lowAttendanceStudentsCount) { this.lowAttendanceStudentsCount = lowAttendanceStudentsCount; }

    public int getPendingFeeStudentsCount() { return pendingFeeStudentsCount; }
    public void setPendingFeeStudentsCount(int pendingFeeStudentsCount) { this.pendingFeeStudentsCount = pendingFeeStudentsCount; }

    public int getRiskStudentsCount() { return riskStudentsCount; }
    public void setRiskStudentsCount(int riskStudentsCount) { this.riskStudentsCount = riskStudentsCount; }

    public int getPendingLeaveRequestsCount() { return pendingLeaveRequestsCount; }
    public void setPendingLeaveRequestsCount(int pendingLeaveRequestsCount) { this.pendingLeaveRequestsCount = pendingLeaveRequestsCount; }

    public double getTotalFeesCollected() { return totalFeesCollected; }
    public void setTotalFeesCollected(double totalFeesCollected) { this.totalFeesCollected = totalFeesCollected; }

    public double getTotalFeesPending() { return totalFeesPending; }
    public void setTotalFeesPending(double totalFeesPending) { this.totalFeesPending = totalFeesPending; }
}
