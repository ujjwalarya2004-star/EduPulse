package com.college.dao;

import com.college.model.LeaveRequest;
import com.college.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LeaveDAO {
    private static final Logger LOGGER = Logger.getLogger(LeaveDAO.class.getName());

    public List<LeaveRequest> getAllLeaveRequests(String statusFilter) {
        List<LeaveRequest> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT lr.*, s.name AS student_name, s.enrollment_no, d.dept_code, f.name AS reviewer_name "
            + "FROM leave_requests lr "
            + "JOIN students s ON lr.student_id = s.student_id "
            + "JOIN departments d ON s.dept_id = d.dept_id "
            + "LEFT JOIN faculty f ON lr.reviewed_by = f.faculty_id "
        );

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
            sql.append("WHERE lr.status = ? ");
        }
        sql.append("ORDER BY lr.applied_date DESC");

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
                stmt.setString(1, statusFilter.trim());
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    LeaveRequest lr = new LeaveRequest();
                    lr.setLeaveId(rs.getInt("leave_id"));
                    lr.setStudentId(rs.getInt("student_id"));
                    lr.setFromDate(rs.getDate("from_date"));
                    lr.setToDate(rs.getDate("to_date"));
                    lr.setReason(rs.getString("reason"));
                    lr.setStatus(rs.getString("status"));
                    lr.setAppliedDate(rs.getDate("applied_date"));
                    int rb = rs.getInt("reviewed_by");
                    lr.setReviewedBy(rs.wasNull() ? null : rb);
                    lr.setReviewRemarks(rs.getString("review_remarks"));
                    lr.setUpdatedAt(rs.getTimestamp("updated_at"));
                    lr.setStudentName(rs.getString("student_name"));
                    lr.setEnrollmentNo(rs.getString("enrollment_no"));
                    lr.setDeptCode(rs.getString("dept_code"));
                    lr.setReviewerName(rs.getString("reviewer_name"));
                    list.add(lr);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching leave requests", e);
        }
        return list;
    }

    public boolean applyLeave(LeaveRequest lr) {
        String sql = "INSERT INTO leave_requests (student_id, from_date, to_date, reason, status, applied_date) "
                   + "VALUES (?, ?, ?, ?, 'PENDING', ?)";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, lr.getStudentId());
            stmt.setDate(2, lr.getFromDate());
            stmt.setDate(3, lr.getToDate());
            stmt.setString(4, lr.getReason().trim());
            stmt.setDate(5, lr.getAppliedDate() != null ? lr.getAppliedDate() : new Date(System.currentTimeMillis()));
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error applying for leave", e);
            return false;
        }
    }

    public boolean updateLeaveStatus(int leaveId, String status, Integer reviewerId, String remarks) {
        String sql = "UPDATE leave_requests SET status = ?, reviewed_by = ?, review_remarks = ? WHERE leave_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            if (reviewerId != null) stmt.setInt(2, reviewerId); else stmt.setNull(2, Types.INTEGER);
            stmt.setString(3, remarks);
            stmt.setInt(4, leaveId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating leave status: " + leaveId, e);
            return false;
        }
    }
}
