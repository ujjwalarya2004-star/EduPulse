package com.college.dao;

import com.college.model.Department;
import com.college.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DepartmentDAO {
    private static final Logger LOGGER = Logger.getLogger(DepartmentDAO.class.getName());

    public List<Department> getAllDepartments() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT d.dept_id, d.dept_code, d.dept_name, d.description, d.created_at, "
                   + "(SELECT COUNT(*) FROM students s WHERE s.dept_id = d.dept_id) AS student_count, "
                   + "(SELECT COUNT(*) FROM faculty f WHERE f.dept_id = d.dept_id) AS faculty_count, "
                   + "(SELECT COUNT(*) FROM subjects sub WHERE sub.dept_id = d.dept_id) AS subject_count "
                   + "FROM departments d ORDER BY d.dept_code ASC";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Department d = new Department();
                d.setDeptId(rs.getInt("dept_id"));
                d.setDeptCode(rs.getString("dept_code"));
                d.setDeptName(rs.getString("dept_name"));
                d.setDescription(rs.getString("description"));
                d.setCreatedAt(rs.getTimestamp("created_at"));
                d.setStudentCount(rs.getInt("student_count"));
                d.setFacultyCount(rs.getInt("faculty_count"));
                d.setSubjectCount(rs.getInt("subject_count"));
                list.add(d);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching departments", e);
        }
        return list;
    }

    public Department getDepartmentById(int id) {
        String sql = "SELECT * FROM departments WHERE dept_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Department d = new Department();
                    d.setDeptId(rs.getInt("dept_id"));
                    d.setDeptCode(rs.getString("dept_code"));
                    d.setDeptName(rs.getString("dept_name"));
                    d.setDescription(rs.getString("description"));
                    d.setCreatedAt(rs.getTimestamp("created_at"));
                    return d;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching department: " + id, e);
        }
        return null;
    }

    public boolean addDepartment(Department d) {
        String sql = "INSERT INTO departments (dept_code, dept_name, description) VALUES (?, ?, ?)";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, d.getDeptCode().trim().toUpperCase());
            stmt.setString(2, d.getDeptName().trim());
            stmt.setString(3, d.getDescription());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding department", e);
            return false;
        }
    }

    public boolean updateDepartment(Department d) {
        String sql = "UPDATE departments SET dept_code = ?, dept_name = ?, description = ? WHERE dept_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, d.getDeptCode().trim().toUpperCase());
            stmt.setString(2, d.getDeptName().trim());
            stmt.setString(3, d.getDescription());
            stmt.setInt(4, d.getDeptId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating department", e);
            return false;
        }
    }

    public boolean deleteDepartment(int id) {
        String sql = "DELETE FROM departments WHERE dept_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting department: " + id, e);
            return false;
        }
    }
}
