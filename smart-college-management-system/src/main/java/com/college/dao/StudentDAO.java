package com.college.dao;

import com.college.model.Student;
import com.college.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class StudentDAO {
    private static final Logger LOGGER = Logger.getLogger(StudentDAO.class.getName());

    public List<Student> getAllStudents(String searchQuery, Integer deptId, Integer semester) {
        List<Student> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT s.*, d.dept_name, d.dept_code, "
            + "COALESCE(att.overall_attendance_pct, 0.0) AS overall_attendance_pct, "
            + "COALESCE(m.avg_marks, 0.0) AS avg_marks, "
            + "COALESCE(f.pending_fees, 0.0) AS pending_fees "
            + "FROM students s "
            + "JOIN departments d ON s.dept_id = d.dept_id "
            + "LEFT JOIN view_student_overall_attendance att ON s.student_id = att.student_id "
            + "LEFT JOIN view_student_overall_marks m ON s.student_id = m.student_id "
            + "LEFT JOIN view_student_overall_fees f ON s.student_id = f.student_id "
            + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (s.name LIKE ? OR s.enrollment_no LIKE ? OR s.email LIKE ?) ");
            String q = "%" + searchQuery.trim() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
        }

        if (deptId != null && deptId > 0) {
            sql.append("AND s.dept_id = ? ");
            params.add(deptId);
        }

        if (semester != null && semester > 0) {
            sql.append("AND s.semester = ? ");
            params.add(semester);
        }

        sql.append("ORDER BY s.student_id DESC");

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapStudent(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error querying students", e);
        }
        return list;
    }

    public Student getStudentById(int id) {
        String sql = "SELECT s.*, d.dept_name, d.dept_code, "
                   + "COALESCE(att.overall_attendance_pct, 0.0) AS overall_attendance_pct, "
                   + "COALESCE(m.avg_marks, 0.0) AS avg_marks, "
                   + "COALESCE(f.pending_fees, 0.0) AS pending_fees "
                   + "FROM students s "
                   + "JOIN departments d ON s.dept_id = d.dept_id "
                   + "LEFT JOIN view_student_overall_attendance att ON s.student_id = att.student_id "
                   + "LEFT JOIN view_student_overall_marks m ON s.student_id = m.student_id "
                   + "LEFT JOIN view_student_overall_fees f ON s.student_id = f.student_id "
                   + "WHERE s.student_id = ?";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapStudent(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching student by ID: " + id, e);
        }
        return null;
    }

    public boolean addStudent(Student s) {
        String sql = "INSERT INTO students (enrollment_no, name, email, phone, gender, dob, address, dept_id, semester, admission_year, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, s.getEnrollmentNo().trim());
            stmt.setString(2, s.getName().trim());
            stmt.setString(3, s.getEmail().trim());
            stmt.setString(4, s.getPhone().trim());
            stmt.setString(5, s.getGender());
            stmt.setDate(6, s.getDob());
            stmt.setString(7, s.getAddress().trim());
            stmt.setInt(8, s.getDeptId());
            stmt.setInt(9, s.getSemester());
            stmt.setInt(10, s.getAdmissionYear());
            stmt.setString(11, s.getStatus() != null ? s.getStatus() : "ACTIVE");
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting student", e);
            return false;
        }
    }

    public boolean updateStudent(Student s) {
        String sql = "UPDATE students SET enrollment_no=?, name=?, email=?, phone=?, gender=?, dob=?, address=?, "
                   + "dept_id=?, semester=?, admission_year=?, status=? WHERE student_id=?";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, s.getEnrollmentNo().trim());
            stmt.setString(2, s.getName().trim());
            stmt.setString(3, s.getEmail().trim());
            stmt.setString(4, s.getPhone().trim());
            stmt.setString(5, s.getGender());
            stmt.setDate(6, s.getDob());
            stmt.setString(7, s.getAddress().trim());
            stmt.setInt(8, s.getDeptId());
            stmt.setInt(9, s.getSemester());
            stmt.setInt(10, s.getAdmissionYear());
            stmt.setString(11, s.getStatus());
            stmt.setInt(12, s.getStudentId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating student", e);
            return false;
        }
    }

    public boolean deleteStudent(int id) {
        String sql = "DELETE FROM students WHERE student_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting student: " + id, e);
            return false;
        }
    }

    private Student mapStudent(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setStudentId(rs.getInt("student_id"));
        s.setEnrollmentNo(rs.getString("enrollment_no"));
        s.setName(rs.getString("name"));
        s.setEmail(rs.getString("email"));
        s.setPhone(rs.getString("phone"));
        s.setGender(rs.getString("gender"));
        s.setDob(rs.getDate("dob"));
        s.setAddress(rs.getString("address"));
        s.setDeptId(rs.getInt("dept_id"));
        s.setSemester(rs.getInt("semester"));
        s.setAdmissionYear(rs.getInt("admission_year"));
        s.setStatus(rs.getString("status"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        s.setDeptName(rs.getString("dept_name"));
        s.setDeptCode(rs.getString("dept_code"));
        s.setOverallAttendancePct(rs.getDouble("overall_attendance_pct"));
        s.setAvgMarks(rs.getDouble("avg_marks"));
        s.setPendingFees(rs.getDouble("pending_fees"));
        s.setAcademicRisk(s.getOverallAttendancePct() < 75.0 || (s.getAvgMarks() > 0 && s.getAvgMarks() < 50.0) || s.getPendingFees() > 0);
        return s;
    }
}
