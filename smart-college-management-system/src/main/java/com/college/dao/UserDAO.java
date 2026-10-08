package com.college.dao;

import com.college.model.User;
import com.college.util.DBConnectionUtil;
import com.college.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    public User authenticate(String username, String password) {
        String sql = "SELECT u.user_id, u.username, u.password_hash, u.salt, u.role, u.faculty_id, "
                   + "COALESCE(f.name, u.username) AS display_name "
                   + "FROM users u "
                   + "LEFT JOIN faculty f ON u.faculty_id = f.faculty_id "
                   + "WHERE u.username = ?";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username.trim());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");
                    String salt = rs.getString("salt");

                    if (PasswordUtil.verifyPassword(password, storedHash, salt)) {
                        User user = new User();
                        user.setUserId(rs.getInt("user_id"));
                        user.setUsername(rs.getString("username"));
                        user.setRole(rs.getString("role"));
                        int fid = rs.getInt("faculty_id");
                        user.setFacultyId(rs.wasNull() ? null : fid);
                        user.setDisplayName(rs.getString("display_name"));
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error authenticating user: " + username, e);
        }
        return null;
    }

    public boolean createUser(String username, String rawPassword, String role, Integer facultyId) {
        String salt = PasswordUtil.generateSalt();
        String hash = PasswordUtil.hashPassword(rawPassword, salt);
        String sql = "INSERT INTO users (username, password_hash, salt, role, faculty_id) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            stmt.setString(2, hash);
            stmt.setString(3, salt);
            stmt.setString(4, role);
            if (facultyId != null) {
                stmt.setInt(5, facultyId);
            } else {
                stmt.setNull(5, java.sql.Types.INTEGER);
            }
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating user: " + username, e);
            return false;
        }
    }
}
