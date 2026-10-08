package com.college.controller;

import com.college.dao.DepartmentDAO;
import com.college.dao.FacultyDAO;
import com.college.dao.SubjectDAO;
import com.college.model.Subject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "SubjectServlet", urlPatterns = {"/subjects"})
public class SubjectServlet extends HttpServlet {
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final DepartmentDAO deptDAO = new DepartmentDAO();
    private final FacultyDAO facultyDAO = new FacultyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("subjects", subjectDAO.getAllSubjects());
        request.setAttribute("departments", deptDAO.getAllDepartments());
        request.setAttribute("facultyList", facultyDAO.getAllFaculty());
        request.getRequestDispatcher("/subjects.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            subjectDAO.deleteSubject(id);
            response.sendRedirect(request.getContextPath() + "/subjects?msg=Subject+deleted+successfully.");
            return;
        }

        Subject s = new Subject();
        s.setSubjectCode(request.getParameter("subjectCode"));
        s.setSubjectName(request.getParameter("subjectName"));
        s.setCredits(Integer.parseInt(request.getParameter("credits")));
        s.setSemester(Integer.parseInt(request.getParameter("semester")));
        s.setDeptId(Integer.parseInt(request.getParameter("deptId")));

        String facStr = request.getParameter("facultyId");
        if (facStr != null && !facStr.isEmpty()) {
            s.setFacultyId(Integer.parseInt(facStr));
        }

        if ("edit".equalsIgnoreCase(action)) {
            s.setSubjectId(Integer.parseInt(request.getParameter("id")));
            subjectDAO.updateSubject(s);
            response.sendRedirect(request.getContextPath() + "/subjects?msg=Subject+updated+successfully.");
        } else {
            subjectDAO.addSubject(s);
            response.sendRedirect(request.getContextPath() + "/subjects?msg=Subject+added+successfully.");
        }
    }
}
