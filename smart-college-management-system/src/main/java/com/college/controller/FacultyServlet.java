package com.college.controller;

import com.college.dao.DepartmentDAO;
import com.college.dao.FacultyDAO;
import com.college.model.Faculty;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "FacultyServlet", urlPatterns = {"/faculty"})
public class FacultyServlet extends HttpServlet {
    private final FacultyDAO facultyDAO = new FacultyDAO();
    private final DepartmentDAO deptDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("facultyList", facultyDAO.getAllFaculty());
        request.setAttribute("departments", deptDAO.getAllDepartments());
        request.getRequestDispatcher("/faculty.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean ok = facultyDAO.deleteFaculty(id);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/faculty?msg=Faculty+member+removed+successfully.");
            } else {
                response.sendRedirect(request.getContextPath() + "/faculty?error=Unable+to+delete+faculty+assigned+to+subjects+or+attendance.");
            }
            return;
        }

        Faculty f = new Faculty();
        f.setEmployeeId(request.getParameter("employeeId"));
        f.setName(request.getParameter("name"));
        f.setEmail(request.getParameter("email"));
        f.setPhone(request.getParameter("phone"));
        f.setDeptId(Integer.parseInt(request.getParameter("deptId")));
        f.setDesignation(request.getParameter("designation"));
        f.setQualification(request.getParameter("qualification"));
        f.setJoiningDate(Date.valueOf(request.getParameter("joiningDate")));

        if ("edit".equalsIgnoreCase(action)) {
            f.setFacultyId(Integer.parseInt(request.getParameter("id")));
            facultyDAO.updateFaculty(f);
            response.sendRedirect(request.getContextPath() + "/faculty?msg=Faculty+details+updated+successfully.");
        } else {
            facultyDAO.addFaculty(f);
            response.sendRedirect(request.getContextPath() + "/faculty?msg=Faculty+member+registered+successfully.");
        }
    }
}
