package com.college.controller;

import com.college.dao.DepartmentDAO;
import com.college.model.Department;
import com.college.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "DepartmentServlet", urlPatterns = {"/departments"})
public class DepartmentServlet extends HttpServlet {
    private final DepartmentDAO deptDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("departments", deptDAO.getAllDepartments());
        request.getRequestDispatcher("/departments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean ok = deptDAO.deleteDepartment(id);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/departments?msg=Department+deleted+successfully.");
            } else {
                response.sendRedirect(request.getContextPath() + "/departments?error=Cannot+delete+department+with+associated+students+or+faculty.");
            }
            return;
        }

        String deptCode = request.getParameter("deptCode");
        String deptName = request.getParameter("deptName");
        String desc = request.getParameter("description");

        if (!ValidationUtil.isNotEmpty(deptCode) || !ValidationUtil.isNotEmpty(deptName)) {
            response.sendRedirect(request.getContextPath() + "/departments?error=Department+code+and+name+are+required.");
            return;
        }

        Department d = new Department();
        d.setDeptCode(deptCode);
        d.setDeptName(deptName);
        d.setDescription(desc);

        if ("edit".equalsIgnoreCase(action)) {
            d.setDeptId(Integer.parseInt(request.getParameter("id")));
            deptDAO.updateDepartment(d);
            response.sendRedirect(request.getContextPath() + "/departments?msg=Department+updated+successfully.");
        } else {
            deptDAO.addDepartment(d);
            response.sendRedirect(request.getContextPath() + "/departments?msg=Department+added+successfully.");
        }
    }
}
