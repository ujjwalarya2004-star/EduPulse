package com.college.model;

import java.io.Serializable;
import java.sql.Date;

public class Faculty implements Serializable {
    private static final long serialVersionUID = 1L;

    private int facultyId;
    private String employeeId;
    private String name;
    private String email;
    private String phone;
    private int deptId;
    private String designation;
    private String qualification;
    private Date joiningDate;

    // Joined fields
    private String deptName;
    private String deptCode;

    public Faculty() {}

    public int getFacultyId() { return facultyId; }
    public void setFacultyId(int facultyId) { this.facultyId = facultyId; }

    public String getEmployeeId() { return employeeId; }
    public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public int getDeptId() { return deptId; }
    public void setDeptId(int deptId) { this.deptId = deptId; }

    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }

    public String getQualification() { return qualification; }
    public void setQualification(String qualification) { this.qualification = qualification; }

    public Date getJoiningDate() { return joiningDate; }
    public void setJoiningDate(Date joiningDate) { this.joiningDate = joiningDate; }

    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }

    public String getDeptCode() { return deptCode; }
    public void setDeptCode(String deptCode) { this.deptCode = deptCode; }
}
