package com.college.dao;

import com.college.model.DashboardStats;
import com.college.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DashboardDAO {
    private static final Logger LOGGER = Logger.getLogger(DashboardDAO.class.getName());

    public DashboardStats getDashboardStatistics() {
        DashboardStats stats = new DashboardStats();

        String sql = "SELECT "
                   + "(SELECT COUNT(*) FROM students WHERE status='ACTIVE') AS total_students, "
                   + "(SELECT COUNT(*) FROM faculty) AS total_faculty, "
                   + "(SELECT COUNT(*) FROM subjects) AS total_subjects, "
                   + "(SELECT COUNT(*) FROM departments) AS total_departments, "
                   + "(SELECT COUNT(*) FROM view_student_overall_attendance WHERE overall_attendance_pct < 75.0) AS low_att_students, "
                   + "(SELECT COUNT(DISTINCT student_id) FROM student_fees WHERE status IN ('PENDING', 'PARTIAL')) AS pending_fee_students, "
                   + "(SELECT COUNT(*) FROM view_academic_risk_summary) AS risk_students, "
                   + "(SELECT COUNT(*) FROM leave_requests WHERE status='PENDING') AS pending_leaves, "
                   + "(SELECT COALESCE(SUM(amount_paid), 0.0) FROM fee_payments) AS total_collected, "
                   + "(SELECT COALESCE(SUM(total_amount - paid_amount), 0.0) FROM student_fees) AS total_pending";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                stats.setTotalStudents(rs.getInt("total_students"));
                stats.setTotalFaculty(rs.getInt("total_faculty"));
                stats.setTotalSubjects(rs.getInt("total_subjects"));
                stats.setTotalDepartments(rs.getInt("total_departments"));
                stats.setLowAttendanceStudentsCount(rs.getInt("low_att_students"));
                stats.setPendingFeeStudentsCount(rs.getInt("pending_fee_students"));
                stats.setRiskStudentsCount(rs.getInt("risk_students"));
                stats.setPendingLeaveRequestsCount(rs.getInt("pending_leaves"));
                stats.setTotalFeesCollected(rs.getDouble("total_collected"));
                stats.setTotalFeesPending(rs.getDouble("total_pending"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving dashboard statistics", e);
        }
        return stats;
    }
}
