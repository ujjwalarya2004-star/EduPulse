package com.college.dao;

import com.college.model.AcademicRisk;
import com.college.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AcademicRiskDAO {
    private static final Logger LOGGER = Logger.getLogger(AcademicRiskDAO.class.getName());

    public List<AcademicRisk> getStudentsRequiringAttention() {
        List<AcademicRisk> list = new ArrayList<>();
        String sql = "SELECT * FROM view_academic_risk_summary ORDER BY overall_attendance_pct ASC, pending_fees DESC";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                AcademicRisk r = new AcademicRisk();
                r.setStudentId(rs.getInt("student_id"));
                r.setEnrollmentNo(rs.getString("enrollment_no"));
                r.setStudentName(rs.getString("student_name"));
                r.setEmail(rs.getString("email"));
                r.setPhone(rs.getString("phone"));
                r.setDeptCode(rs.getString("dept_code"));
                r.setSemester(rs.getInt("semester"));
                r.setOverallAttendancePct(rs.getDouble("overall_attendance_pct"));
                r.setAvgMarks(rs.getDouble("avg_marks"));
                r.setPendingFees(rs.getDouble("pending_fees"));
                r.setLowAttendanceFlag(rs.getInt("flag_low_attendance") == 1);
                r.setPoorMarksFlag(rs.getInt("flag_poor_marks") == 1);
                r.setPendingFeesFlag(rs.getInt("flag_pending_fees") == 1);
                list.add(r);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error querying academic risk summary view", e);
        }
        return list;
    }
}
