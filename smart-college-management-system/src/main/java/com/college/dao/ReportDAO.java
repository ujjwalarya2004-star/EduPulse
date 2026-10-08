package com.college.dao;

import com.college.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReportDAO {
    private static final Logger LOGGER = Logger.getLogger(ReportDAO.class.getName());

    public List<Map<String, Object>> getDepartmentWiseSummary() {
        List<Map<String, Object>> rows = new ArrayList<>();
        String sql = "SELECT d.dept_name, d.dept_code, "
                   + "COUNT(DISTINCT s.student_id) AS total_students, "
                   + "COUNT(DISTINCT f.faculty_id) AS total_faculty, "
                   + "COUNT(DISTINCT sub.subject_id) AS total_subjects, "
                   + "COALESCE(ROUND(AVG(att.overall_attendance_pct), 1), 0.0) AS avg_dept_attendance, "
                   + "COALESCE(SUM(sf.total_amount - sf.paid_amount), 0.0) AS dept_pending_fees "
                   + "FROM departments d "
                   + "LEFT JOIN students s ON d.dept_id = s.dept_id "
                   + "LEFT JOIN faculty f ON d.dept_id = f.dept_id "
                   + "LEFT JOIN subjects sub ON d.dept_id = sub.dept_id "
                   + "LEFT JOIN view_student_overall_attendance att ON s.student_id = att.student_id "
                   + "LEFT JOIN student_fees sf ON s.student_id = sf.student_id "
                   + "GROUP BY d.dept_id, d.dept_name, d.dept_code "
                   + "ORDER BY d.dept_code ASC";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("deptName", rs.getString("dept_name"));
                map.put("deptCode", rs.getString("dept_code"));
                map.put("totalStudents", rs.getInt("total_students"));
                map.put("totalFaculty", rs.getInt("total_faculty"));
                map.put("totalSubjects", rs.getInt("total_subjects"));
                map.put("avgDeptAttendance", rs.getDouble("avg_dept_attendance"));
                map.put("deptPendingFees", rs.getDouble("dept_pending_fees"));
                rows.add(map);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error building department-wise report", e);
        }
        return rows;
    }
}
