package com.college.dao;

import com.college.model.FeePayment;
import com.college.model.StudentFee;
import com.college.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FeeDAO {
    private static final Logger LOGGER = Logger.getLogger(FeeDAO.class.getName());

    public List<StudentFee> getAllStudentFees(String statusFilter) {
        List<StudentFee> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT sf.*, s.name AS student_name, s.enrollment_no, s.semester, d.dept_code "
            + "FROM student_fees sf "
            + "JOIN students s ON sf.student_id = s.student_id "
            + "JOIN departments d ON s.dept_id = d.dept_id "
        );

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
            sql.append("WHERE sf.status = ? ");
        }
        sql.append("ORDER BY sf.due_date ASC, s.name ASC");

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
                stmt.setString(1, statusFilter.trim());
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    StudentFee sf = new StudentFee();
                    sf.setStudentFeeId(rs.getInt("student_fee_id"));
                    sf.setStudentId(rs.getInt("student_id"));
                    sf.setFeeStructureId(rs.getInt("fee_structure_id"));
                    sf.setTotalAmount(rs.getDouble("total_amount"));
                    sf.setPaidAmount(rs.getDouble("paid_amount"));
                    sf.setDueDate(rs.getDate("due_date"));
                    sf.setStatus(rs.getString("status"));
                    sf.setCreatedAt(rs.getTimestamp("created_at"));
                    sf.setStudentName(rs.getString("student_name"));
                    sf.setEnrollmentNo(rs.getString("enrollment_no"));
                    sf.setDeptCode(rs.getString("dept_code"));
                    sf.setSemester(rs.getInt("semester"));
                    list.add(sf);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching student fee records", e);
        }
        return list;
    }

    public List<FeePayment> getPaymentsByStudent(int studentId) {
        List<FeePayment> list = new ArrayList<>();
        String sql = "SELECT fp.*, s.name AS student_name, s.enrollment_no "
                   + "FROM fee_payments fp "
                   + "JOIN student_fees sf ON fp.student_fee_id = sf.student_fee_id "
                   + "JOIN students s ON sf.student_id = s.student_id "
                   + "WHERE sf.student_id = ? "
                   + "ORDER BY fp.payment_date DESC";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    FeePayment p = new FeePayment();
                    p.setPaymentId(rs.getInt("payment_id"));
                    p.setStudentFeeId(rs.getInt("student_fee_id"));
                    p.setReceiptNo(rs.getString("receipt_no"));
                    p.setAmountPaid(rs.getDouble("amount_paid"));
                    p.setPaymentMethod(rs.getString("payment_method"));
                    p.setTransactionRef(rs.getString("transaction_ref"));
                    p.setPaymentDate(rs.getDate("payment_date"));
                    p.setRemarks(rs.getString("remarks"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setStudentName(rs.getString("student_name"));
                    p.setEnrollmentNo(rs.getString("enrollment_no"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching payment history: " + studentId, e);
        }
        return list;
    }

    public boolean recordPayment(FeePayment payment) {
        String insertPaymentSql = "INSERT INTO fee_payments (student_fee_id, receipt_no, amount_paid, payment_method, transaction_ref, payment_date, remarks) "
                                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        String updateFeeSql = "UPDATE student_fees "
                            + "SET paid_amount = paid_amount + ?, "
                            + "    status = CASE "
                            + "        WHEN (paid_amount + ?) >= total_amount THEN 'PAID' "
                            + "        ELSE 'PARTIAL' "
                            + "    END "
                            + "WHERE student_fee_id = ?";

        try (Connection conn = DBConnectionUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Insert payment record
                try (PreparedStatement stmt1 = conn.prepareStatement(insertPaymentSql)) {
                    stmt1.setInt(1, payment.getStudentFeeId());
                    stmt1.setString(2, payment.getReceiptNo().trim());
                    stmt1.setDouble(3, payment.getAmountPaid());
                    stmt1.setString(4, payment.getPaymentMethod());
                    stmt1.setString(5, payment.getTransactionRef());
                    stmt1.setDate(6, payment.getPaymentDate());
                    stmt1.setString(7, payment.getRemarks());
                    stmt1.executeUpdate();
                }

                // 2. Automatically update student_fees paid_amount and status
                try (PreparedStatement stmt2 = conn.prepareStatement(updateFeeSql)) {
                    stmt2.setDouble(1, payment.getAmountPaid());
                    stmt2.setDouble(2, payment.getAmountPaid());
                    stmt2.setInt(3, payment.getStudentFeeId());
                    stmt2.executeUpdate();
                }

                conn.commit();
                return true;
            } catch (SQLException ex) {
                conn.rollback();
                LOGGER.log(Level.SEVERE, "Payment transaction failed and rolled back", ex);
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error recording fee payment", e);
            return false;
        }
    }
}
