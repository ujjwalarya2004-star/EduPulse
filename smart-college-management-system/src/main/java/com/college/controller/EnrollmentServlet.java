package com.college.controller;

import com.college.dao.EnrollmentDAO;
import com.college.dao.StudentDAO;
import com.college.dao.SubjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "EnrollmentServlet", urlPatterns = {"/enrollments"})
public class EnrollmentServlet extends HttpServlet {
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("enrollments", enrollmentDAO.getAllEnrollments());
        request.setAttribute("students", studentDAO.getAllStudents(null, null, null));
        request.setAttribute("subjects", subjectDAO.getAllSubjects());
        request.getRequestDispatcher("/enrollments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String action = request.getParameter("action");
        if ("remove".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            enrollmentDAO.removeEnrollment(id);
            response.sendRedirect(request.getContextPath() + "/enrollments?msg=Enrollment+removed.");
            return;
        }

        int studentId = Integer.parseInt(request.getParameter("studentId"));
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        String academicYear = request.getParameter("academicYear");

        boolean ok = enrollmentDAO.enrollStudent(studentId, subjectId, academicYear);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/enrollments?msg=Student+enrolled+into+subject+successfully.");
        } else {
            response.sendRedirect(request.getContextPath() + "/enrollments?error=Student+is+already+enrolled+in+this+subject.");
        }
    }
}
