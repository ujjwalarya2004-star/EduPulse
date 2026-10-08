package com.college.controller;

import com.college.dao.AcademicRiskDAO;
import com.college.model.AcademicRisk;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AcademicRiskServlet", urlPatterns = {"/academic-risk"})
public class AcademicRiskServlet extends HttpServlet {
    private final AcademicRiskDAO riskDAO = new AcademicRiskDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<AcademicRisk> riskList = riskDAO.getStudentsRequiringAttention();
        request.setAttribute("riskStudents", riskList);
        request.getRequestDispatcher("/academic-risk.jsp").forward(request, response);
    }
}
