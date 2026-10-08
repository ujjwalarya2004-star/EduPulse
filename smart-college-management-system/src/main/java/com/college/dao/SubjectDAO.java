package com.college.dao;

import com.college.model.Subject;
import com.college.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SubjectDAO {
    private static final Logger LOGGER = Logger.getLogger(SubjectDAO.class.getName());

    public List<Subject> getAllSubjects() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT s.*, d.dept_name, d.dept_code, f.name AS faculty_name, "
                   + "(SELECT COUNT(*) FROM enrollments e WHERE e.subject_id = s.subject_id) AS enrolled_count "
                   + "FROM subjects s "
                   + "JOIN departments d ON s.dept_id = d.dept_id "
                   + "LEFT JOIN faculty f ON s.faculty_id = f.faculty_id "
                   + "ORDER BY s.semester ASC, s.subject_code ASC";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Subject sub = new Subject();
                sub.setSubjectId(rs.getInt("subject_id"));
                sub.setSubjectCode(rs.getString("subject_code"));
                sub.setSubjectName(rs.getString("subject_name"));
                sub.setCredits(rs.getInt("credits"));
                sub.setSemester(rs.getInt("semester"));
                sub.setDeptId(rs.getInt("dept_id"));
                int fid = rs.getInt("faculty_id");
                sub.setFacultyId(rs.wasNull() ? null : fid);
                sub.setDeptName(rs.getString("dept_name"));
                sub.setDeptCode(rs.getString("dept_code"));
                sub.setFacultyName(rs.getString("faculty_name"));
                sub.setEnrolledStudentCount(rs.getInt("enrolled_count"));
                list.add(sub);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching subjects", e);
        }
        return list;
    }

    public List<Subject> getSubjectsByFaculty(int facultyId) {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT s.*, d.dept_name, d.dept_code, f.name AS faculty_name, "
                   + "(SELECT COUNT(*) FROM enrollments e WHERE e.subject_id = s.subject_id) AS enrolled_count "
                   + "FROM subjects s "
                   + "JOIN departments d ON s.dept_id = d.dept_id "
                   + "LEFT JOIN faculty f ON s.faculty_id = f.faculty_id "
                   + "WHERE s.faculty_id = ? "
                   + "ORDER BY s.subject_code ASC";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, facultyId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Subject sub = new Subject();
                    sub.setSubjectId(rs.getInt("subject_id"));
                    sub.setSubjectCode(rs.getString("subject_code"));
                    sub.setSubjectName(rs.getString("subject_name"));
                    sub.setCredits(rs.getInt("credits"));
                    sub.setSemester(rs.getInt("semester"));
                    sub.setDeptId(rs.getInt("dept_id"));
                    sub.setFacultyId(facultyId);
                    sub.setDeptName(rs.getString("dept_name"));
                    sub.setDeptCode(rs.getString("dept_code"));
                    sub.setFacultyName(rs.getString("faculty_name"));
                    sub.setEnrolledStudentCount(rs.getInt("enrolled_count"));
                    list.add(sub);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching subjects for faculty: " + facultyId, e);
        }
        return list;
    }

    public boolean addSubject(Subject s) {
        String sql = "INSERT INTO subjects (subject_code, subject_name, credits, semester, dept_id, faculty_id) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, s.getSubjectCode().trim().toUpperCase());
            stmt.setString(2, s.getSubjectName().trim());
            stmt.setInt(3, s.getCredits());
            stmt.setInt(4, s.getSemester());
            stmt.setInt(5, s.getDeptId());
            if (s.getFacultyId() != null && s.getFacultyId() > 0) {
                stmt.setInt(6, s.getFacultyId());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting subject", e);
            return false;
        }
    }

    public boolean updateSubject(Subject s) {
        String sql = "UPDATE subjects SET subject_code=?, subject_name=?, credits=?, semester=?, dept_id=?, faculty_id=? "
                   + "WHERE subject_id=?";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, s.getSubjectCode().trim().toUpperCase());
            stmt.setString(2, s.getSubjectName().trim());
            stmt.setInt(3, s.getCredits());
            stmt.setInt(4, s.getSemester());
            stmt.setInt(5, s.getDeptId());
            if (s.getFacultyId() != null && s.getFacultyId() > 0) {
                stmt.setInt(6, s.getFacultyId());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }
            stmt.setInt(7, s.getSubjectId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating subject", e);
            return false;
        }
    }

    public boolean deleteSubject(int id) {
        String sql = "DELETE FROM subjects WHERE subject_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting subject: " + id, e);
            return false;
        }
    }
}
