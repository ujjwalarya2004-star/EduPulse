package com.college.controller;

import com.college.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "ReportServlet", urlPatterns = {"/reports"})
public class ReportServlet extends HttpServlet {
    private final ReportDAO reportDAO = new ReportDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final FeeDAO feeDAO = new FeeDAO();
    private final AcademicRiskDAO riskDAO = new AcademicRiskDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("deptReport", reportDAO.getDepartmentWiseSummary());
        request.setAttribute("students", studentDAO.getAllStudents(null, null, null));
        request.setAttribute("attendanceSummary", attendanceDAO.getAttendanceSummaries(null));
        request.setAttribute("feeRecords", feeDAO.getAllStudentFees("PENDING"));
        request.setAttribute("riskStudents", riskDAO.getStudentsRequiringAttention());

        request.getRequestDispatcher("/reports.jsp").forward(request, response);
    }
}
