package com.college.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private int userId;
    private String username;
    private String passwordHash;
    private String salt;
    private String role; // ADMIN or FACULTY
    private Integer facultyId;
    private Timestamp createdAt;

    // Additional display field
    private String displayName;

    public User() {}

    public User(int userId, String username, String role, Integer facultyId) {
        this.userId = userId;
        this.username = username;
        this.role = role;
        this.facultyId = facultyId;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getSalt() { return salt; }
    public void setSalt(String salt) { this.salt = salt; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Integer getFacultyId() { return facultyId; }
    public void setFacultyId(Integer facultyId) { this.facultyId = facultyId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getDisplayName() { return displayName; }
    public void setDisplayName(String displayName) { this.displayName = displayName; }

    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(this.role);
    }

    public boolean isFaculty() {
        return "FACULTY".equalsIgnoreCase(this.role);
    }
}
