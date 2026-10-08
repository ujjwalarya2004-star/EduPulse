package com.college.controller;

import com.college.dao.UserDAO;
import com.college.model.User;
import com.college.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (!ValidationUtil.isNotEmpty(username) || !ValidationUtil.isNotEmpty(password)) {
            request.setAttribute("errorMessage", "Username and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.authenticate(username, password);

        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("errorMessage", "Invalid username or password. Please try again.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
