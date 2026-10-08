package com.college.controller;

import com.college.dao.LeaveDAO;
import com.college.dao.StudentDAO;
import com.college.model.LeaveRequest;
import com.college.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "LeaveServlet", urlPatterns = {"/leaves"})
public class LeaveServlet extends HttpServlet {
    private final LeaveDAO leaveDAO = new LeaveDAO();
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String filter = request.getParameter("status");
        List<LeaveRequest> requests = leaveDAO.getAllLeaveRequests(filter);

        request.setAttribute("leaveRequests", requests);
        request.setAttribute("students", studentDAO.getAllStudents(null, null, null));
        request.getRequestDispatcher("/leaves.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if ("status".equalsIgnoreCase(action)) {
            // Approve / Reject
            int leaveId = Integer.parseInt(request.getParameter("leaveId"));
            String status = request.getParameter("status");
            String remarks = request.getParameter("remarks");
            Integer reviewerId = (user != null) ? user.getFacultyId() : null;

            leaveDAO.updateLeaveStatus(leaveId, status, reviewerId, remarks);
            response.sendRedirect(request.getContextPath() + "/leaves?msg=Leave+request+marked+as+" + status);
            return;
        }

        // Student applying for leave
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        Date fromDate = Date.valueOf(request.getParameter("fromDate"));
        Date toDate = Date.valueOf(request.getParameter("toDate"));
        String reason = request.getParameter("reason");

        LeaveRequest lr = new LeaveRequest();
        lr.setStudentId(studentId);
        lr.setFromDate(fromDate);
        lr.setToDate(toDate);
        lr.setReason(reason);
        lr.setAppliedDate(new Date(System.currentTimeMillis()));

        boolean ok = leaveDAO.applyLeave(lr);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/leaves?msg=Leave+application+submitted+successfully.");
        } else {
            response.sendRedirect(request.getContextPath() + "/leaves?error=Failed+to+submit+leave+application.");
        }
    }
}
