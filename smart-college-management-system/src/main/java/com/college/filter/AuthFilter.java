package com.college.filter;

import com.college.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI().substring(request.getContextPath().length());

        // Allow public static resources and login actions
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/")
                || path.equals("/login") || path.equals("/login.jsp") || path.equals("/")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            // Unauthenticated user -> redirect to login
            response.sendRedirect(request.getContextPath() + "/login?error=Please+login+to+continue.");
            return;
        }

        // Role-based authorization for administrative routes
        boolean isAdminOnlyRoute = path.startsWith("/departments")
                || path.startsWith("/faculty")
                || path.startsWith("/fees")
                || (path.startsWith("/students") && "POST".equalsIgnoreCase(request.getMethod()) && "delete".equalsIgnoreCase(request.getParameter("action")));

        if (isAdminOnlyRoute && !currentUser.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Administrative privileges required.");
            return;
        }

        chain.doFilter(req, res);
    }
}
