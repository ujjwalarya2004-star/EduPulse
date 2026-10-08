package com.college.dao;

import com.college.model.Attendance;
import com.college.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AttendanceDAO {
    private static final Logger LOGGER = Logger.getLogger(AttendanceDAO.class.getName());

    public List<Attendance> getAttendanceSummaries(Integer subjectId) {
        List<Attendance> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT student_id, enrollment_no, student_name, subject_id, subject_code, subject_name, "
            + "total_classes, classes_attended, attendance_percentage "
            + "FROM view_attendance_summary "
        );

        if (subjectId != null && subjectId > 0) {
            sql.append("WHERE subject_id = ? ");
        }
        sql.append("ORDER BY subject_code ASC, student_name ASC");

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            if (subjectId != null && subjectId > 0) {
                stmt.setInt(1, subjectId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Attendance a = new Attendance();
                    a.setStudentId(rs.getInt("student_id"));
                    a.setEnrollmentNo(rs.getString("enrollment_no"));
                    a.setStudentName(rs.getString("student_name"));
                    a.setSubjectId(rs.getInt("subject_id"));
                    a.setSubjectCode(rs.getString("subject_code"));
                    a.setSubjectName(rs.getString("subject_name"));
                    a.setTotalClasses(rs.getInt("total_classes"));
                    a.setClassesAttended(rs.getInt("classes_attended"));
                    a.setAttendancePercentage(rs.getDouble("attendance_percentage"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching attendance summary", e);
        }
        return list;
    }

    public List<Attendance> getStudentAttendanceHistory(int studentId) {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT a.attendance_id, a.attendance_date, a.status, a.remarks, "
                   + "sub.subject_code, sub.subject_name "
                   + "FROM attendance a "
                   + "JOIN subjects sub ON a.subject_id = sub.subject_id "
                   + "WHERE a.student_id = ? "
                   + "ORDER BY a.attendance_date DESC";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Attendance a = new Attendance();
                    a.setAttendanceId(rs.getInt("attendance_id"));
                    a.setAttendanceDate(rs.getDate("attendance_date"));
                    a.setStatus(rs.getString("status"));
                    a.setRemarks(rs.getString("remarks"));
                    a.setSubjectCode(rs.getString("subject_code"));
                    a.setSubjectName(rs.getString("subject_name"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching student attendance history: " + studentId, e);
        }
        return list;
    }

    public boolean markBatchAttendance(int subjectId, Date date, List<Integer> presentStudentIds, List<Integer> absentStudentIds, Integer facultyId) {
        String sql = "INSERT INTO attendance (student_id, subject_id, attendance_date, status, marked_by) "
                   + "VALUES (?, ?, ?, ?, ?) "
                   + "ON DUPLICATE KEY UPDATE status = VALUES(status), marked_by = VALUES(marked_by), marked_at = CURRENT_TIMESTAMP";

        try (Connection conn = DBConnectionUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                // Present students
                for (int sid : presentStudentIds) {
                    stmt.setInt(1, sid);
                    stmt.setInt(2, subjectId);
                    stmt.setDate(3, date);
                    stmt.setString(4, "PRESENT");
                    if (facultyId != null) stmt.setInt(5, facultyId); else stmt.setNull(5, Types.INTEGER);
                    stmt.addBatch();
                }

                // Absent students
                for (int sid : absentStudentIds) {
                    stmt.setInt(1, sid);
                    stmt.setInt(2, subjectId);
                    stmt.setDate(3, date);
                    stmt.setString(4, "ABSENT");
                    if (facultyId != null) stmt.setInt(5, facultyId); else stmt.setNull(5, Types.INTEGER);
                    stmt.addBatch();
                }

                stmt.executeBatch();
                conn.commit();
                return true;
            } catch (SQLException ex) {
                conn.rollback();
                LOGGER.log(Level.SEVERE, "Batch attendance transaction rolled back", ex);
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error establishing connection for attendance batch", e);
            return false;
        }
    }
}
