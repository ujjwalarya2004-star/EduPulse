package com.college.dao;

import com.college.model.Marks;
import com.college.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MarksDAO {
    private static final Logger LOGGER = Logger.getLogger(MarksDAO.class.getName());

    public List<Marks> getMarksBySubject(int subjectId) {
        List<Marks> list = new ArrayList<>();
        String sql = "SELECT m.*, s.name AS student_name, s.enrollment_no, sub.subject_name, sub.subject_code, sub.credits "
                   + "FROM marks m "
                   + "JOIN students s ON m.student_id = s.student_id "
                   + "JOIN subjects sub ON m.subject_id = sub.subject_id "
                   + "WHERE m.subject_id = ? "
                   + "ORDER BY s.enrollment_no ASC";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, subjectId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMarks(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching marks for subject: " + subjectId, e);
        }
        return list;
    }

    public List<Marks> getStudentTranscript(int studentId) {
        List<Marks> list = new ArrayList<>();
        String sql = "SELECT m.*, s.name AS student_name, s.enrollment_no, sub.subject_name, sub.subject_code, sub.credits "
                   + "FROM marks m "
                   + "JOIN students s ON m.student_id = s.student_id "
                   + "JOIN subjects sub ON m.subject_id = sub.subject_id "
                   + "WHERE m.student_id = ? "
                   + "ORDER BY sub.subject_code ASC";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMarks(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching transcript for student: " + studentId, e);
        }
        return list;
    }

    public boolean saveOrUpdateMarks(Marks m) {
        // Calculate grade dynamically based on total out of 120
        double total = m.getAssignmentMarks() + m.getInternalMarks() + m.getPracticalMarks() + m.getEndSemMarks();
        double pct = (total / 120.0) * 100.0;
        String grade = "F";
        if (pct >= 90) grade = "A+";
        else if (pct >= 80) grade = "A";
        else if (pct >= 70) grade = "B";
        else if (pct >= 60) grade = "C";
        else if (pct >= 50) grade = "D";

        String sql = "INSERT INTO marks (student_id, subject_id, assignment_marks, internal_marks, practical_marks, end_sem_marks, grade, entered_by) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?) "
                   + "ON DUPLICATE KEY UPDATE "
                   + "assignment_marks = VALUES(assignment_marks), "
                   + "internal_marks = VALUES(internal_marks), "
                   + "practical_marks = VALUES(practical_marks), "
                   + "end_sem_marks = VALUES(end_sem_marks), "
                   + "grade = VALUES(grade), "
                   + "entered_by = VALUES(entered_by), "
                   + "updated_at = CURRENT_TIMESTAMP";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, m.getStudentId());
            stmt.setInt(2, m.getSubjectId());
            stmt.setDouble(3, m.getAssignmentMarks());
            stmt.setDouble(4, m.getInternalMarks());
            stmt.setDouble(5, m.getPracticalMarks());
            stmt.setDouble(6, m.getEndSemMarks());
            stmt.setString(7, grade);
            if (m.getEnteredBy() != null) stmt.setInt(8, m.getEnteredBy()); else stmt.setNull(8, Types.INTEGER);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving marks", e);
            return false;
        }
    }

    private Marks mapMarks(ResultSet rs) throws SQLException {
        Marks m = new Marks();
        m.setMarkId(rs.getInt("mark_id"));
        m.setStudentId(rs.getInt("student_id"));
        m.setSubjectId(rs.getInt("subject_id"));
        m.setAssignmentMarks(rs.getDouble("assignment_marks"));
        m.setInternalMarks(rs.getDouble("internal_marks"));
        m.setPracticalMarks(rs.getDouble("practical_marks"));
        m.setEndSemMarks(rs.getDouble("end_sem_marks"));
        m.setTotalMarks(rs.getDouble("total_marks"));
        m.setGrade(rs.getString("grade"));
        int eb = rs.getInt("entered_by");
        m.setEnteredBy(rs.wasNull() ? null : eb);
        m.setUpdatedAt(rs.getTimestamp("updated_at"));
        m.setStudentName(rs.getString("student_name"));
        m.setEnrollmentNo(rs.getString("enrollment_no"));
        m.setSubjectName(rs.getString("subject_name"));
        m.setSubjectCode(rs.getString("subject_code"));
        m.setCredits(rs.getInt("credits"));
        return m;
    }
}
