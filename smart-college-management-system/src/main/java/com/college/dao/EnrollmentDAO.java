package com.college.dao;

import com.college.model.Enrollment;
import com.college.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EnrollmentDAO {
    private static final Logger LOGGER = Logger.getLogger(EnrollmentDAO.class.getName());

    public List<Enrollment> getAllEnrollments() {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT e.*, s.name AS student_name, s.enrollment_no, sub.subject_name, sub.subject_code, d.dept_code "
                   + "FROM enrollments e "
                   + "JOIN students s ON e.student_id = s.student_id "
                   + "JOIN subjects sub ON e.subject_id = sub.subject_id "
                   + "JOIN departments d ON s.dept_id = d.dept_id "
                   + "ORDER BY s.enrollment_no ASC, sub.subject_code ASC";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Enrollment en = new Enrollment();
                en.setEnrollmentId(rs.getInt("enrollment_id"));
                en.setStudentId(rs.getInt("student_id"));
                en.setSubjectId(rs.getInt("subject_id"));
                en.setAcademicYear(rs.getString("academic_year"));
                en.setEnrolledAt(rs.getTimestamp("enrolled_at"));
                en.setStudentName(rs.getString("student_name"));
                en.setEnrollmentNo(rs.getString("enrollment_no"));
                en.setSubjectName(rs.getString("subject_name"));
                en.setSubjectCode(rs.getString("subject_code"));
                en.setDeptCode(rs.getString("dept_code"));
                list.add(en);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching enrollments", e);
        }
        return list;
    }

    public List<Enrollment> getEnrollmentsByStudent(int studentId) {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT e.*, s.name AS student_name, s.enrollment_no, sub.subject_name, sub.subject_code, d.dept_code "
                   + "FROM enrollments e "
                   + "JOIN students s ON e.student_id = s.student_id "
                   + "JOIN subjects sub ON e.subject_id = sub.subject_id "
                   + "JOIN departments d ON s.dept_id = d.dept_id "
                   + "WHERE e.student_id = ? "
                   + "ORDER BY sub.subject_code ASC";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Enrollment en = new Enrollment();
                    en.setEnrollmentId(rs.getInt("enrollment_id"));
                    en.setStudentId(rs.getInt("student_id"));
                    en.setSubjectId(rs.getInt("subject_id"));
                    en.setAcademicYear(rs.getString("academic_year"));
                    en.setEnrolledAt(rs.getTimestamp("enrolled_at"));
                    en.setStudentName(rs.getString("student_name"));
                    en.setEnrollmentNo(rs.getString("enrollment_no"));
                    en.setSubjectName(rs.getString("subject_name"));
                    en.setSubjectCode(rs.getString("subject_code"));
                    en.setDeptCode(rs.getString("dept_code"));
                    list.add(en);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching student enrollments: " + studentId, e);
        }
        return list;
    }

    public boolean enrollStudent(int studentId, int subjectId, String academicYear) {
        String sql = "INSERT INTO enrollments (student_id, subject_id, academic_year) VALUES (?, ?, ?)";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            stmt.setInt(2, subjectId);
            stmt.setString(3, academicYear != null ? academicYear : "2025-2026");
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error enrolling student", e);
            return false;
        }
    }

    public boolean removeEnrollment(int enrollmentId) {
        String sql = "DELETE FROM enrollments WHERE enrollment_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, enrollmentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting enrollment: " + enrollmentId, e);
            return false;
        }
    }
}
