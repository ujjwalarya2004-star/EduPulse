package com.college.dao;

import com.college.model.Faculty;
import com.college.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FacultyDAO {
    private static final Logger LOGGER = Logger.getLogger(FacultyDAO.class.getName());

    public List<Faculty> getAllFaculty() {
        List<Faculty> list = new ArrayList<>();
        String sql = "SELECT f.*, d.dept_name, d.dept_code FROM faculty f "
                   + "JOIN departments d ON f.dept_id = d.dept_id "
                   + "ORDER BY f.name ASC";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Faculty f = mapResultSet(rs);
                list.add(f);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching faculty members", e);
        }
        return list;
    }

    public Faculty getFacultyById(int id) {
        String sql = "SELECT f.*, d.dept_name, d.dept_code FROM faculty f "
                   + "JOIN departments d ON f.dept_id = d.dept_id "
                   + "WHERE f.faculty_id = ?";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching faculty: " + id, e);
        }
        return null;
    }

    public boolean addFaculty(Faculty f) {
        String sql = "INSERT INTO faculty (employee_id, name, email, phone, dept_id, designation, qualification, joining_date) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, f.getEmployeeId().trim());
            stmt.setString(2, f.getName().trim());
            stmt.setString(3, f.getEmail().trim());
            stmt.setString(4, f.getPhone().trim());
            stmt.setInt(5, f.getDeptId());
            stmt.setString(6, f.getDesignation().trim());
            stmt.setString(7, f.getQualification());
            stmt.setDate(8, f.getJoiningDate());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding faculty member", e);
            return false;
        }
    }

    public boolean updateFaculty(Faculty f) {
        String sql = "UPDATE faculty SET employee_id=?, name=?, email=?, phone=?, dept_id=?, designation=?, qualification=?, joining_date=? "
                   + "WHERE faculty_id=?";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, f.getEmployeeId().trim());
            stmt.setString(2, f.getName().trim());
            stmt.setString(3, f.getEmail().trim());
            stmt.setString(4, f.getPhone().trim());
            stmt.setInt(5, f.getDeptId());
            stmt.setString(6, f.getDesignation().trim());
            stmt.setString(7, f.getQualification());
            stmt.setDate(8, f.getJoiningDate());
            stmt.setInt(9, f.getFacultyId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating faculty member", e);
            return false;
        }
    }

    public boolean deleteFaculty(int id) {
        String sql = "DELETE FROM faculty WHERE faculty_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting faculty member: " + id, e);
            return false;
        }
    }

    private Faculty mapResultSet(ResultSet rs) throws SQLException {
        Faculty f = new Faculty();
        f.setFacultyId(rs.getInt("faculty_id"));
        f.setEmployeeId(rs.getString("employee_id"));
        f.setName(rs.getString("name"));
        f.setEmail(rs.getString("email"));
        f.setPhone(rs.getString("phone"));
        f.setDeptId(rs.getInt("dept_id"));
        f.setDesignation(rs.getString("designation"));
        f.setQualification(rs.getString("qualification"));
        f.setJoiningDate(rs.getDate("joining_date"));
        f.setDeptName(rs.getString("dept_name"));
        f.setDeptCode(rs.getString("dept_code"));
        return f;
    }
}
