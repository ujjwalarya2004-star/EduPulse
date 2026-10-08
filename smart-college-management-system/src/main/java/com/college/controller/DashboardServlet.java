package com.college.controller;

import com.college.dao.AcademicRiskDAO;
import com.college.dao.DashboardDAO;
import com.college.model.AcademicRisk;
import com.college.model.DashboardStats;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {
    private final DashboardDAO dashboardDAO = new DashboardDAO();
    private final AcademicRiskDAO riskDAO = new AcademicRiskDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DashboardStats stats = dashboardDAO.getDashboardStatistics();
        List<AcademicRisk> highRiskStudents = riskDAO.getStudentsRequiringAttention();

        request.setAttribute("stats", stats);
        request.setAttribute("highRiskStudents", highRiskStudents);
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
